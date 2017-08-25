//
//  companyAuthViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/29.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "companyAuthViewController.h"
#import "companyAuthTableViewCell.h"
#import "ZXUploadImage.h"
#import "picPreviewViewController.h"
@interface companyAuthViewController ()<UITableViewDelegate,UITableViewDataSource,ZXUploadImageDelegate,changePicPreViewDelegate>{

    UIImageView * _YYZZImgView;//营业执照
    NSString * _YYZZUrlString;
    UILabel * _YYZZLabel;
    UIImageView * _SFZZImgView;//身份证正面
    NSString * _SFZZUrlString;
    UILabel * _SFZZLabel;
    UIImageView * _SFZFImgView;//身份证反面
    NSString * _SFZFUrlString;
    UILabel * _SFZFLabel;
    NSInteger  selectNum;//1选中营业执照2,身份证正3,身份证反
    UITextField * _companyNameText;//企业名
    UITextField * _companyOwnerText;//法人姓名
    UITextField * _companyPhoneText;//联系方式
    UITextField * _companyWhereText;//公司地址
}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation companyAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业认证";
    [self createTabel];
    if([GVUserDefaults standardUserDefaults].isAdmin.integerValue!=1&&[GVUserDefaults standardUserDefaults].companyId.integerValue!=0){
        self.view.userInteractionEnabled = NO;
    }
    // Do any additional setup after loading the view.
}
#pragma mark ----------------------------tableView----------------------------------
-(void)createTabel{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==4){
        
        NSString *ID = @"myDataViewController1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selected = NO;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];

            UILabel * userNameLabel=[[UILabel alloc]init];
            [userNameLabel setBackgroundColor:[UIColor clearColor]];
            [userNameLabel setTextColor:textMainColor];
            [userNameLabel setFont:[UIFont systemFontOfSize:fontSizeLJJ]];
            userNameLabel.textAlignment=NSTextAlignmentLeft;
            userNameLabel.text = @"营业执照";
            userNameLabel.frame = CGRectMake(widSize(15), heiSize(18) ,SCREEN_WIDTH-widSize(15), heiSize(15));
            [cell addSubview:userNameLabel];
            
            _YYZZImgView = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(15), CGRectGetMaxY(userNameLabel.frame)+heiSize(18), SCREEN_WIDTH-2*widSize(15), heiSize(106)) andImage:nil andBgColor:rgb(247, 247, 247)];
            _YYZZImgView.contentMode = UIViewContentModeScaleAspectFit;
            [cell addSubview:_YYZZImgView];
            
            _YYZZLabel = [myLjjTools createLabelWithFrame:CGRectMake(0, 20, _YYZZImgView.frame.size.width, _YYZZImgView.frame.size.height-40) andTitle:@"点击上传营业执照的正面照" andTitleFont:MAINtextFont(15) andTitleColor:rgb(85, 85, 85) andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
            [_YYZZImgView addSubview:_YYZZLabel];
            
            if(_model.companyLisenceImg){
                [_YYZZImgView sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(_model.companyLisenceImg)] placeholderImage:nil];
                _YYZZLabel.hidden = YES;
            }
    }
        return cell;
        
    }else if(indexPath.row==5){
    
        NSString *ID = @"myDataViewController2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selected = NO;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            
            UILabel * userNameLabel=[[UILabel alloc]init];
            [userNameLabel setBackgroundColor:[UIColor clearColor]];
            [userNameLabel setTextColor:textMainColor];
            [userNameLabel setFont:[UIFont systemFontOfSize:fontSizeLJJ]];
            userNameLabel.textAlignment=NSTextAlignmentLeft;
            userNameLabel.text = @"法人身份证";
            userNameLabel.frame = CGRectMake(widSize(15), heiSize(18) ,SCREEN_WIDTH-widSize(15), heiSize(15));
            [cell addSubview:userNameLabel];
            
            _SFZZImgView = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(15), CGRectGetMaxY(userNameLabel.frame)+heiSize(18), (SCREEN_WIDTH-2*widSize(15)-widSize(9))/2.0, heiSize(106)) andImage:nil andBgColor:rgb(247, 247, 247)];
            _SFZZImgView.userInteractionEnabled = YES;
            _SFZZImgView.contentMode = UIViewContentModeScaleAspectFit;
            [cell addSubview:_SFZZImgView];
            _SFZZLabel = [myLjjTools createLabelWithFrame:CGRectMake(0, 20, _SFZZImgView.frame.size.width, _SFZZImgView.frame.size.height-40) andTitle:@"点击上传身份证正面照" andTitleFont:MAINtextFont(14) andTitleColor:rgb(85, 85, 85) andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
            [_SFZZImgView addSubview:_SFZZLabel];

            if(_model.legalPersonIDAImg){
             [_SFZZImgView sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(_model.legalPersonIDAImg)] placeholderImage:nil];
                _SFZZLabel.hidden = YES;
            }
            
            UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UPZImageClick)];
            [_SFZZImgView addGestureRecognizer:tap1];
            
            _SFZFImgView = [myLjjTools createImageViewWithFrame:CGRectMake(CGRectGetMaxX(_SFZZImgView.frame)+widSize(9), CGRectGetMaxY(userNameLabel.frame)+heiSize(18), (SCREEN_WIDTH-2*widSize(15)-widSize(9))/2.0, heiSize(106)) andImage:nil andBgColor:rgb(247, 247, 247)];
            _SFZFImgView.contentMode = UIViewContentModeScaleAspectFit;
            _SFZFImgView.userInteractionEnabled = YES;
            [cell addSubview:_SFZFImgView];
            _SFZFLabel = [myLjjTools createLabelWithFrame:CGRectMake(0, 20, _SFZFImgView.frame.size.width, _SFZFImgView.frame.size.height-40) andTitle:@"点击上传身份证反面照" andTitleFont:MAINtextFont(14) andTitleColor:rgb(85, 85, 85) andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
            [_SFZFImgView addSubview:_SFZFLabel];
            
            if(_model.legalPersonIDBImg){
                [_SFZFImgView sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(_model.legalPersonIDBImg)] placeholderImage:nil];
                _SFZFLabel.hidden = YES;
            }

            
            UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UPFImageClick)];
            [_SFZFImgView addGestureRecognizer:tap2];

        }
        return cell;

    }else{
        
        NSString *ID = @"myDataViewController";
        companyAuthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selected = NO;
        if (cell == nil) {
            cell = [[companyAuthTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
            cell.detailTextLabel.textColor=[UIColor lightGrayColor];
            //cell.detailTextLabel.numberOfLines=2;
        }
       // cell.imageName = imgArr[indexPath.row-1];
        switch (indexPath.row) {
            case 0:
                 cell.titleName = @"企业名";
                 _companyNameText = cell.infoStr;
                if(_model.companyName){
                    _companyNameText.text = _model.companyName;
                }
                 break;
            case 1:
                cell.titleName = @"法人姓名";
                _companyOwnerText = cell.infoStr;
                if(_model.legalPersonName){
                    _companyOwnerText.text = _model.legalPersonName;
                }
                break;
            case 2:
                cell.titleName = @"联系方式";
                _companyPhoneText = cell.infoStr;
                if(_model.legalPersonPhone){
                    _companyPhoneText.text = _model.legalPersonPhone;
                }
                break;
            case 3:
                cell.titleName = @"公司地址";
                _companyWhereText = cell.infoStr;
                if(_model.companyAddress){
                    _companyWhereText.text = _model.companyAddress;
                }
                break;
    
            default:
                break;
        }
    
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==4||indexPath.row==5){
        
        return heiSize(156.0);
        
    }else{
        
        return heiSize(52.0);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return heiSize(110);

}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * view = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, heiSize(110)) andBgColor:WHITEColor];

    UIButton * button = [myLjjTools createButtonWithFrame:CGRectMake(widSize(77), heiSize(25), SCREEN_WIDTH-widSize(77)*2, heiSize(35)) andTitle:@"完成" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(doneAction) andTarget:self];
    if([GVUserDefaults standardUserDefaults].companyId.integerValue!=0){
        [button setTitle:@"修改" forState:UIControlStateNormal];
    }
    button.layer.cornerRadius = 3.0;
    button.clipsToBounds = YES;
    [view addSubview:button];
    
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, CGRectGetMaxY(button.frame)+heiSize(10), SCREEN_WIDTH-20, heiSize(14));
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = rgb(170, 170, 170);
    label.text = @"点击\"完成\"表示同意《法律条款及隐私政策》";
    label = [myLjjTools createLabelTextWithView:label andwithChangeColorTxt:@"《法律条款及隐私政策》" withColor:MAINThemeOrgColor];
    [view addSubview:label];
    
    if([GVUserDefaults standardUserDefaults].isAdmin.integerValue!=1&&[GVUserDefaults standardUserDefaults].companyId.integerValue!=0){
        button.hidden = YES;
        label.hidden = YES;
    }
     return view;
    
}

#pragma mark --------完成--------------
-(void)doneAction{
    NSLog(@"%@",_companyNameText.text);
    //if()
    if(!_SFZFUrlString){
        ToastWithTitle(@"必须传身份证正面照哦");
        return;
    }
    if(!_SFZZUrlString){
        ToastWithTitle(@"必须传身份证反面照哦");
         return;
    }
    if(!_YYZZUrlString){
        ToastWithTitle(@"必须传营业执照哦");
         return;
    }
    if(_companyWhereText.text.length==0){
        ToastWithTitle(@"公司地址不能为空");
         return;
    }
    if(_companyNameText.text.length==0){
        ToastWithTitle(@"公司名称不能为空");
         return;
    }
    if(_companyOwnerText.text.length==0){
        ToastWithTitle(@"法人姓名不能为空");
         return;
    }
    if(_companyPhoneText.text.length==0){
        ToastWithTitle(@"法人电话不能为空");
         return;
    }
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:_SFZZUrlString forKey:@"LDimgA"];
    [parameters setObject:_SFZFUrlString forKey:@"LDimgB"];
    [parameters setObject:_companyWhereText.text forKey:@"companyAddress"];
    [parameters setObject:_YYZZUrlString forKey:@"companyLisence"];
    [parameters setObject:_companyNameText.text forKey:@"companyName"];
    [parameters setObject:_companyOwnerText.text forKey:@"legalPersonName"];
    [parameters setObject:_companyPhoneText.text forKey:@"legalPersonPhone"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    if([GVUserDefaults standardUserDefaults].companyId.integerValue!=0){
    [parameters setObject:[GVUserDefaults standardUserDefaults].companyId forKey:@"companyId"];
    }
    [HttpRequest postWithURL:HTTP_URLIP(cert_Enterprise) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        ToastWithTitle(@"提交成功,等待审核...");
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row==4){//营业执照
        selectNum = 1;
        if(_YYZZLabel.hidden){
            picPreviewViewController * pic = [picPreviewViewController new];
            pic.typeNum = 1;
            pic.ImgUrlStr = HTTP_URLIP(_model.companyLisenceImg);
            pic.delegate = self;
            [self.navigationController presentViewController:pic animated:YES completion:nil];
        }else{
        [[ZXUploadImage shareUploadImage] showActionSheetInFatherViewController:self isTailoring:YES delegate:self];
        }
    }
    
}

-(void)UPZImageClick{//身份证正面
    selectNum=2;
    if(_SFZZLabel.hidden){
        picPreviewViewController * pic = [picPreviewViewController new];
        pic.typeNum = 2;
        pic.delegate = self;
        pic.ImgUrlStr = HTTP_URLIP(_model.legalPersonIDAImg);
        [self.navigationController presentViewController:pic animated:YES completion:nil];
    }else{
        [[ZXUploadImage shareUploadImage] showActionSheetInFatherViewController:self isTailoring:YES delegate:self];
    }
}
-(void)UPFImageClick{//省份证反面
    selectNum=3;
    if(_SFZFLabel.hidden){
        picPreviewViewController * pic = [picPreviewViewController new];
        pic.typeNum = 3;
        pic.ImgUrlStr = HTTP_URLIP(_model.legalPersonIDBImg);
        pic.delegate = self;
        [self.navigationController presentViewController:pic animated:YES completion:nil];
    }else{
        [[ZXUploadImage shareUploadImage] showActionSheetInFatherViewController:self isTailoring:YES delegate:self];
    }
}

-(void)uploadImageToServerWithImage:(UIImage *)image{

     [self upImgToNet:image with:selectNum];

}

-(void)changePicPreViewClick:(UIImage *)preImage withType:(NSInteger)typeStr{

    [self upImgToNet:preImage with:selectNum];

}

-(void)upImgToNet:(UIImage*)image with:(NSInteger)type//1.身份证正面2.身份证面反面3.营业执照
{
    NSString * urlString;
    NSArray * PathArr;
    if(type==1){
        urlString = HTTP_URLIP(uploadompany_Lisence);
         PathArr = @[@"companyLisence"];
    }else{
        urlString = HTTP_URLIP(uploadLegal_PersonIDBImg);
        PathArr = @[@"LDimg"];
    }
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:@"" forKey:@""];
    [HttpRequest postImageWithURL:urlString params:nil path:PathArr photos:@[image] success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        if(type==1){
            _SFZZUrlString = [NSString stringWithFormat:@"%@/%@",responseObject[@"data"][@"imgPath"],responseObject[@"data"][@"imgName"]];
        }else if(type==2){
            _SFZFUrlString = [NSString stringWithFormat:@"%@/%@",responseObject[@"data"][@"imgPath"],responseObject[@"data"][@"imgName"]];
        }else{
          _YYZZUrlString = [NSString stringWithFormat:@"%@/%@",responseObject[@"data"][@"imgPath"],responseObject[@"data"][@"imgName"]];
        }
        switch (selectNum) {
            case 1:
                _YYZZImgView.image = image;
                _YYZZLabel.hidden = YES;
                break;
            case 2:
                _SFZZImgView.image = image;
                _SFZZLabel.hidden = YES;
                break;
            case 3:
                _SFZFImgView.image = image;
                _SFZFLabel.hidden = YES;
                break;
            default:
                break;
        }

    } failure:^(NSError *error) {
        
    }];
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
