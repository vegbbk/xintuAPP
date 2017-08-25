//
//  addDressLJJViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "addDressLJJViewController.h"
#import "selectMapDressViewController.h"
#import "picHeadSelectView.h"
#import "addDressStrLJJTableViewCell.h"
@interface addDressLJJViewController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate,AMapLocationManagerDelegate,picHeadSelectDelegate>{

    UIImageView * _headImageView;
    NSString * _headImgStr;
    UITextField * dressText;
    NSString * dressPoint;
    UITextField * _nameText;
    UILabel * _tishiLabel;
    
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)AMapSearchAPI*search;
@property (nonatomic, strong) NSMutableArray *tips;
@property (nonatomic, strong)AMapLocationManager*locationManager;
@end

@implementation addDressLJJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tips = [NSMutableArray array];
    if(_typeNum==1){
    self.navigationItem.title = @"添加常用地址";
    }else{
    self.navigationItem.title = @"编辑常用地址";
    }
    [self createUI];
    [self createRightNav];
    [self location];
    // Do any additional setup after loading the view. addDressStrID
}

#pragma mark --------------确认----------------------
-(void)createRightNav{

    UIBarButtonItem * item = [myLjjTools createRightNavItem:@"确定" andFont:FontSize(17) andSelecter:@selector(sureAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = item;

}

-(void)sureAction{
    
    if(_nameText.text.length==0){
        ToastWithTitle(@"地址名称不能为空哦");
        return;
    }
    
    if(_nameText.text.length>6){
        ToastWithTitle(@"地址名称不能多于6个字");
        return;
    }
    
    if(!dressPoint){
        ToastWithTitle(@"详细地址不能为空哦");
        return;
    }
    
    if(!_headImgStr){
        ToastWithTitle(@"你还没选地址图标哦");
        return;
    }
    NSLog(@"%@",dressPoint);
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    if(_typeNum==2){
    [parameters setObject:self.dataModel.dressID forKey:@"addId"];
    [parameters setObject:@"update" forKey:@"act"];
    }else{
    [parameters setObject:@"add" forKey:@"act"];
    }
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [parameters setObject:_headImgStr forKey:@"addIcon"];
    [parameters setObject:_nameText.text forKey:@"addName"];
    [parameters setObject:dressText.text forKey:@"address"];
    [parameters setObject:dressPoint forKey:@"lnglat"];
    [HttpRequest postWithURL:HTTP_URLIP(saveOrUpdate_Address) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        if(_typeNum==1){
        ToastWithTitle(@"添加成功!");
        }else{
         ToastWithTitle(@"修改成功!");
        }
        [self.delegate addDressSucFreshData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dressLJJfreshID" object:self userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark --------------界面----------------------
-(void)createUI{

    UIView * backView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 184) andBgColor:WHITEColor];
    [self.view addSubview:backView];
    
    _headImageView = [myLjjTools createImageViewWithFrame:CGRectMake((SCREEN_WIDTH-28)/2.0, 20, 28, 28) andImageName:@"首页_添加地址_选择图标" andBgColor:nil];
    if(_dataModel.addIcon){
        _headImageView.image = [UIImage imageNamed:PicHeadLifeArr[_dataModel.addIcon.intValue]];
        _headImgStr = _dataModel.addIcon;
    }
    _headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [_headImageView addGestureRecognizer:tap];
    [backView addSubview:_headImageView];
    
    _tishiLabel = [myLjjTools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(_headImageView.frame)+8, SCREEN_WIDTH, 15) andTitle:@"请选择图标" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [backView addSubview:_tishiLabel];
    
    UIView * lineView = [myLjjTools createViewWithFrame:CGRectMake(0, CGRectGetMaxY(_tishiLabel.frame)+14, SCREEN_WIDTH, 1) andBgColor:LINECOLOR];
    [backView addSubview:lineView];
    
    _nameText = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView.frame), SCREEN_WIDTH-30, 49)];
    _nameText.placeholder = @"起个名字吧";
    _nameText.font = FontSize(15);
    UIView * view = [myLjjTools createViewWithFrame:CGRectMake(0, 0, 33, 49) andBgColor:CLEARCOLOR];
    UIImageView * image = [myLjjTools createImageViewWithFrame:CGRectMake(0,15, 20, 20) andImageName:@"首页_添加地址_名字" andBgColor:nil];
    [view addSubview:image];
    _nameText.leftViewMode = UITextFieldViewModeAlways;
    _nameText.leftView = view;
    [backView addSubview:_nameText];
    if(_dataModel.addName){
        _nameText.text = _dataModel.addName;
    }
    
    UIView * lineView2 = [myLjjTools createViewWithFrame:CGRectMake(0, CGRectGetMaxY(_nameText.frame), SCREEN_WIDTH, 1) andBgColor:LINECOLOR];
    [backView addSubview:lineView2];
    
    dressText = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView2.frame), SCREEN_WIDTH-30, 49)];
    dressText.placeholder = @"请选择地址";
    dressText.font = FontSize(15);
    [dressText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView * view1 = [myLjjTools createViewWithFrame:CGRectMake(0, 0, 33, 49) andBgColor:CLEARCOLOR];
    UIImageView * image1 = [myLjjTools createImageViewWithFrame:CGRectMake(0,15, 20, 20) andImageName:@"首页_添加地址_地址" andBgColor:nil];
    image1.contentMode = UIViewContentModeScaleAspectFit;
    [view1 addSubview:image1];
    dressText.leftViewMode = UITextFieldViewModeAlways;
    dressText.leftView = view1;
    [backView addSubview:dressText];
    if(_dataModel.address){
        dressText.text = _dataModel.address;
    }
    if(_dataModel.lnglat){
        dressPoint = _dataModel.lnglat;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame)+1, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(backView.frame)-1-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = CLEARCOLOR;
    [_tableView setSeparatorColor:LINECOLOR];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"addDressStrLJJTableViewCell" bundle:nil] forCellReuseIdentifier:@"addDressStrID"];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _tips.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    addDressStrLJJTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"addDressStrID" forIndexPath:indexPath];
    cell.backgroundColor = CLEARCOLOR;
    AMapTip *tip = self.tips[indexPath.row];
    cell.placeNameLabel.text = tip.name;
    cell.placeInfoNameLabel.text = tip.address;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapTip *tip = self.tips[indexPath.row];
    dressText.text = tip.name;
    dressPoint = [NSString stringWithFormat:@"%lf,%lf",tip.location.longitude,tip.location.latitude];
    [self.tips removeAllObjects];
    [self.tableView reloadData];
    
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    
    [self searchLocation:theTextField.text];
}

-(void)searchLocation:(NSString*)string{
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.city =  [GVUserDefaults standardUserDefaults].cityNameLocation;
    request.keywords            = string;
    request.requireExtension    = YES;
    request.cityLimit = NO;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    
    
}
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    if (response.pois.count == 0)
    {
        return;
    }
    [self.tips setArray:response.pois];
    [self.tableView reloadData];
    //解析response获取POI信息，具体解析见 Demo
}

-(void)location{
    
    self.locationManager = [[AMapLocationManager alloc] init]; 
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为10s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    self.locationManager.reGeocodeTimeout = 2;

    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            dressText.text = @"定位失败";
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            if(_dataModel.address){
               
            }else{
            dressText.text = regeocode.formattedAddress;
            dressPoint = [NSString stringWithFormat:@"%lf,%lf",location.coordinate.longitude,location.coordinate.latitude];
            }
        }
    }];
}

-(void)selectTap{
    picHeadSelectView * head = [[picHeadSelectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    head.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:head];
}

-(void)picHeadSelectName:(NSString *)nameStr{

    _headImgStr = nameStr;
    _headImageView.image = [UIImage imageNamed:PicHeadLifeArr[nameStr.integerValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
