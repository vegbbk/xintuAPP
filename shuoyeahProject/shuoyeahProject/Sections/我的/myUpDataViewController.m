//
//  myUpDataViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/29.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "myUpDataViewController.h"
#import "myDataCell.h"
#import "KKDatePickerView.h"
#import "writeViewController.h"
#import "oneTableViewController.h"
#import "changePhoneNumViewController.h"
#import "ZXUploadImage.h"
@interface myUpDataViewController ()<UITableViewDelegate,UITableViewDataSource,dataSelectDelegate,sendInfoDelegate,selectHZdelegate,changePhoneNumDelegate,ZXUploadImageDelegate>{

    UIImageView * avtarImg;//头像
    NSArray * imgArr;
    UIButton * _girlBtn;
    UIButton * _boyBtn;
    NSString * _sexStr;
    NSString * isBoy ;
    NSString * _birthDayStr;//生日
    NSString * _signatureStr;//个性签名
    NSString * _industryStr;//行业
    NSString * _industryID;//行业id
    NSString * _profStr;//职业
    NSString * _phoneStr;
    NSString * _headImgUrl;
    
    UITextField * _realNameText;//真实姓名
    NSString * _realNameString;
    
    KKDatePickerView *PickerView;
}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation myUpDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善个人资料";
    [self loadData];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)loadData{

    if([GVUserDefaults standardUserDefaults].userBirthDay){
        _birthDayStr =unKnowToStr([GVUserDefaults standardUserDefaults].userBirthDay);
    }else{
        _birthDayStr = @"";
    }
    if([GVUserDefaults standardUserDefaults].userPhone){
        _phoneStr = [GVUserDefaults standardUserDefaults].userPhone;
    }else{
       _phoneStr = @"";
    }
        imgArr = @[@[@"登录",@"性别",@"muffin",@"考试_1"],@[@"Planet",@"Wallet"]];
    if([GVUserDefaults standardUserDefaults].userSignature){
        _signatureStr = [GVUserDefaults standardUserDefaults].userSignature;
    }else{
        _signatureStr = @"";
    }
    if ([GVUserDefaults standardUserDefaults].userIndustry){
        _industryStr = [GVUserDefaults standardUserDefaults].userIndustry;
    }else{
        _industryStr = @"";
    }
    if ([GVUserDefaults standardUserDefaults].userJob) {
        _profStr = [GVUserDefaults standardUserDefaults].userJob;
    }else{
        _profStr = @"";
    }
    if([[GVUserDefaults standardUserDefaults].userSex isEqualToString:@"0"]){
        _sexStr = @"女";
        isBoy = @"0";
    }else{
       _sexStr = @"男";
        isBoy = @"1";
    }
    if([GVUserDefaults standardUserDefaults].userName){
        _realNameString = [GVUserDefaults standardUserDefaults].userName;
    }
    
    if(!IsStrEmpty([GVUserDefaults standardUserDefaults].userHeadImg)){
        _headImgUrl = [GVUserDefaults standardUserDefaults].userHeadImg;
    }else{
        _headImgUrl = @"";
    }
    
}

-(void)createUI{

    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(0, 0, 60, 30);
    [releaseButton setTitle:@"确定" forState:normal];
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    releaseButton.layer.cornerRadius = 3;
    // [releaseButton setBackgroundColor:MAINThemeColor];
    [releaseButton addTarget:self action:@selector(releaseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = BACKLJJcolor;
    [_tableView  setSeparatorColor:LINECOLOR];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
    
        return 1;
    }else if(section==1){
    
        return 4;
    }else{
    
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        
        NSString *ID = @"myDataViewController1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            avtarImg=[[UIImageView alloc] init];
            avtarImg.frame=CGRectMake((SCREEN_WIDTH-widSize(87))/2.0,(heiSize(160.0)-heiSize(87))/2.0, widSize(87), widSize(87));
            avtarImg.layer.masksToBounds=YES;
            avtarImg.layer.cornerRadius=heiSize(87)/2.0;
            avtarImg.layer.borderColor = WHITEColor.CGColor;
            avtarImg.layer.borderWidth = 3;
            avtarImg.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upHeadImgClick)];
            [avtarImg addGestureRecognizer:tap];
            [cell addSubview:avtarImg];
            [avtarImg sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(_headImgUrl)] placeholderImage:[UIImage imageNamed:@"user"]];
            
            _realNameText = [[UITextField alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(avtarImg.frame)+((heiSize(160.0)-heiSize(87))/2.0-20)/2.0, SCREEN_WIDTH-60, 20)];
            _realNameText.placeholder = @"请输入真实姓名";
            _realNameText.font = FontSize(15);
            if(_realNameString){
                _realNameText.text = _realNameString;
            }
            _realNameText.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:_realNameText];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = rgb(224, 251, 255);
        return cell;
        
    }else if(indexPath.section==1){
        
        NSString *ID = @"myDataViewController";
        myDataCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[myDataCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
            cell.detailTextLabel.textColor=[UIColor lightGrayColor];
           // cell.backgroundColor = rgb(247, 247, 247);
        }
        if(indexPath.row==1){
        
            cell.titleStr = _sexStr;
        
        }else if(indexPath.row==2){
        
            if(!IsStrEmpty(_birthDayStr)){
            cell.titleStr = _birthDayStr;
            }else{
            cell.titleStr = @"生日";
            }
        }else if(indexPath.row==3){
            
            if(!IsStrEmpty(_signatureStr)){
            cell.titleStr = _signatureStr;
            }else{
            cell.titleStr = @"个性签名";
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if(indexPath.row==0){
            if(IsStrEmpty(_phoneStr)){
             cell.titleStr = @"手机号码";
            }else{
            cell.titleStr = _phoneStr;
            }
        }
        
        cell.imageName = imgArr[0][indexPath.row];
        return cell;
    }else {
    
        NSString *ID = @"myDataViewController1";
        myDataCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[myDataCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
            cell.detailTextLabel.textColor=[UIColor lightGrayColor];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
          //  cell.backgroundColor = rgb(247, 247, 247);
        }
        cell.imageName = imgArr[1][indexPath.row];
        
        if(indexPath.row==0){
            if(IsStrEmpty(_industryStr)){
             cell.titleStr = @"选择行业";
            }else{
            cell.titleStr = _industryStr;
            }
        }else if(indexPath.row==1){
            if(IsStrEmpty(_profStr)){
            cell.titleStr = @"选择职业";
            }else{
            cell.titleStr = _profStr;
            }
        }
        
        return cell;
    
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0&&indexPath.row==0){
        
        return heiSize(160.0);
        
    }else{
        
        return heiSize(50.0);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return heiSize(15.0);

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==1&&indexPath.row==2){//选择生日
    
        if(!PickerView){
        PickerView = [[KKDatePickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180)];
        PickerView.delegate = self;
        [self.view addSubview:PickerView];
    
        [UIView animateWithDuration:0.5 animations:^{
            
            PickerView.frame = CGRectMake(0, SCREEN_HEIGHT-180, SCREEN_WIDTH, 180);
            
        } completion:^(BOOL finished) {
            

        }];
        }
    }else if(indexPath.section==1&&indexPath.row==1){//性别
        
        [self selectSxe];
        
    }else if(indexPath.section==1&&indexPath.row==0){//修改手机号
    
        changePhoneNumViewController * change = [[changePhoneNumViewController alloc]init];
        change.delegate = self;
        [self.navigationController pushViewController:change animated:YES];
        
    }else if(indexPath.section==1&&indexPath.row==3){//个性签名
    
        writeViewController * write = [[writeViewController alloc]init];
        write.delegate = self;
        write.signatureStr = _signatureStr;
        [self.navigationController pushViewController:write animated:YES];
    }else if (indexPath.section==2){//行业职业
    
        if(indexPath.row==0){
        oneTableViewController * write = [[oneTableViewController alloc]init];
        write.title = @"选择行业";
        write.delegate = self;
        write.number = 1;
        [self.navigationController pushViewController:write animated:YES];
    }else{
        if(_industryID){
        oneTableViewController * write = [[oneTableViewController alloc]init];
        write.title = @"选择职业";
        write.delegate = self;
        write.number = 2;
        write.industryId = _industryID;
        [self.navigationController pushViewController:write animated:YES];
        }else{
            ToastWithTitle(@"请先选择行业");
        }
    }
    }
    
}

#pragma mark ------------确认---------------
-(void)releaseInfo{
    
     NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
     [parameters setObject:_birthDayStr forKey:@"birthDay"];
     [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
     [parameters setObject:_industryStr forKey:@"userIndustry"];
     [parameters setObject:_profStr forKey:@"userJob"];
     [parameters setObject:isBoy forKey:@"userSex"];
     [parameters setObject:_signatureStr forKey:@"userSignature"];
     [parameters setObject:_headImgUrl forKey:@"userHeadImg"];
     [parameters setObject:_realNameText.text forKey:@"userName"];
     [HttpRequest postWithURL:HTTP_URLIP(save_UserProfile) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject){
        ToastWithTitle(@"保存成功!");
        [GVUserDefaults standardUserDefaults].userJob = _profStr;
        [GVUserDefaults standardUserDefaults].userIndustry = _industryStr;
        [GVUserDefaults standardUserDefaults].userBirthDay = _birthDayStr;
        [GVUserDefaults standardUserDefaults].userSex = isBoy;
        [GVUserDefaults standardUserDefaults].userSignature = _signatureStr;
        [GVUserDefaults standardUserDefaults].userName = _realNameText.text;
        [GVUserDefaults standardUserDefaults].userHeadImg = _headImgUrl;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark -------性别----------
-(void)selectSxe{

  UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择您的性别"preferredStyle:UIAlertControllerStyleActionSheet];
  UIAlertAction *boylAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
      _sexStr = @"男";
      isBoy = @"1";
      [self.tableView reloadData];
  }];
  [alert addAction:boylAction];
    //了解更多:style:UIAlertActionStyleDestructive
  UIAlertAction *girlAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      _sexStr = @"女";
      isBoy = @"0";
     [self.tableView reloadData];
  }];
  [alert addAction:girlAction];
  [self.navigationController presentViewController:alert animated:YES completion:nil];
}
#pragma mark --------生日----------
-(void)dataSelectClick:(NSString *)timeStr{

    PickerView = nil;
    _birthDayStr = timeStr;
    [self.tableView reloadData];

}
#pragma mark --------修改个性签名----------
-(void)sendInfowith:(NSString *)string{

    _signatureStr = string;
    [self.tableView reloadData];
}
#pragma mark ------------修改职业行业-------------

-(void)selectHZClick:(jobAndIndustModel *)model with:(NSInteger)number{

    if(number==1){
    
        _industryStr = model.industryName;
        _industryID = model.thinkID;
    }else if(number==2){
    
        _profStr = model.jobName;
        
    }
   [self.tableView reloadData];
    
}
#pragma mark ----------修改手机号-----------------

-(void)changePhoneNumber:(NSString *)str{

    _phoneStr = str;
    [self.tableView reloadData];

}
#pragma mark ----------上传头像-----------------
-(void)upHeadImgClick{
     [[ZXUploadImage shareUploadImage] showActionSheetInFatherViewController:self isTailoring:NO delegate:self];
}
-(void)uploadImageToServerWithImage:(UIImage *)image{

    [HttpRequest postImageWithURL:HTTP_URLIP(upload_UserHeadImg) params:nil path:@[@"userHeadImg"] photos:@[image] success:^(NSDictionary *responseObject) {
        NSLog(@"上传成功%@",responseObject);
        avtarImg.image = image;
        _headImgUrl = [NSString stringWithFormat:@"%@/%@",responseObject[@"data"][@"imgPath"],responseObject[@"data"][@"imgName"]];
    } failure:^(NSError *error) {
        ToastWithTitle(@"上传失败");
    }];

}

-(void)cancelViewData{

    PickerView = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
