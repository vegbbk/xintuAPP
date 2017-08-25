//
//  businessLJJViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/6.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "businessLJJViewController.h"
#import "headCateButton.h"
#import "MHDatePicker.h"
#import "carStyleSelectView.h"
#import "selectWhereViewController.h"
#import "chargeSelectInfoView.h"
#import "WKFRadarView.h"
#import "ReGeocodeAnnotation.h"
#import "GeocodeAnnotation.h"
#import "callCarSucLJJViewController.h"
#import "collectDriverViewController.h"
#import "MANaviAnnotation.h"
#import "MANaviRoute.h"
#import "CommonUtility.h"
#import "carStyleModel.h"
#import "routeListLJJModel.h"
#import "payMoneyOrderViewController.h"
#import "jifenCZViewController.h"
#import "mapViewLJJTools.h"
#import "moneyNoEnoughView.h"
#import "routeInfoViewController.h"
#import "ljjUrlWebViewController.h"
static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;
@interface businessLJJViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MAMapViewDelegate,AMapSearchDelegate,selectWhereSureDelegate,AMapNaviDriveManagerDelegate,AMapLocationManagerDelegate,styleSelectchooseDelegate,selectDriverNameDelegate,gotoChargeMoneyDelegate>{

    NSMutableArray * buttonsArr;
    UIView * lineView;
    UILabel * _startTextField;
    AMapGeoPoint*_startPoint;//起点
    NSString * _startStrName;
    AMapGeoPoint*_startRNMPoint;//起点日你妈
    UILabel * _endTextField;
    AMapGeoPoint* _endPoint;//终点
    AMapGeoPoint*_endRNMPoint;//终点日你妈
    NSString * _endStrName;
    UILabel * startTimeLabel;
    NSString *_startTimeString;//出发时间
    UIButton * bottomBtn;//确认用车
    headCateButton * singleBtn;//单程
    headCateButton * doubleBtn;//往返
    UILabel * _startLabel;
    UILabel * _returnLabel;
    UIImageView * returnImg;
    UILabel * returnTimeLabel;
    NSString * _returnTimeString;//返程时间
    BOOL isSingle;//是否是单程
    BOOL isUnfold;//是否展开
    BOOL isSendFly;//是否送机
    
    UILabel * _freeMoneyLabel;//估价
    UILabel * _conpuneLabel;//优惠券
    NSString * _moneyNumStr;//价格
    NSString * _freeMoneyStr;//优惠券
    
    UILabel * _driverLabel;//司机
    NSString * _driverID;//司机id
    UITextField * otherText;
    
    NSString * _carStyleStr;//车型名称
    UIButton * _selectCarBtn;
    NSString * _carNameLJJ;
    
    
    UITextField * _flightText;//航班信息
    UIImageView * _plainImageView;
    
    UITextField * selectField;
    
    UIView * topView;

    NSString * cityName;//当前城市
    CGFloat heighFloat;
    CGFloat titleHIGHT;
    
    NSString * _distanceStr;//距离
    NSString * _estimatedTimeStr;//估计时间
    
    NSString * _strokeFee;//预计费用
    
    carStyleModel * selectCarModel;
    
    BOOL isFreshDataLJJ;//刷新数据
    
    MAPointAnnotation * _locationAnnota;
    
    routeListLJJModel * routDataModel;
    
    WKFRadarView*  radarView ;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic, strong)AMapSearchAPI *search;
@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic) MANaviRoute * naviRoute;
@end

@implementation businessLJJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self loadCarStyle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.search = [[AMapSearchAPI alloc] init];
    [self initDriveManager];
    self.search.delegate = self;
    [self setMap];
    if(self.indexNum==1){
    [self createSegment];
    }
    [self createListView];
    [self location];
    [self loadRightBtn];
    // Do any additional setup after loading the view.106.654584,29.719350
}

-(void)loadRightBtn{
    
    UIButton *newsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newsButton.frame = CGRectMake(0, 0, 22, 22);
    [newsButton setBackgroundImage:[UIImage imageNamed:@"产品说明"] forState:normal];
    [newsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newsButton addTarget:self action:@selector(newsClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newsButton];
    self.navigationItem.rightBarButtonItem = ButtonItem;
}

-(void)newsClick{

    ljjUrlWebViewController * url = [[ljjUrlWebViewController alloc]init];
    url.title = @"产品说明";
    [self.navigationController pushViewController:url animated:YES];

}

-(void)loadCarStyle{

    NSMutableArray * carStyleArr = [NSMutableArray array];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [HttpRequest postWithURL:HTTP_URLIP(cars_Type) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        for(NSDictionary * dict in responseObject[@"data"]){
            carStyleModel * model = [[carStyleModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [carStyleArr addObject:model];
        }
        if(carStyleArr.count>0){
            carStyleModel * model = carStyleArr[0];
            _carNameLJJ = model.typeName;
            _carStyleStr = model.typeCarID;
            selectCarModel = model;
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)initData{
    
    if(self.indexNum==1){self.navigationItem.title = @"接送机";heighFloat=440;titleHIGHT=51;}
    else if(self.indexNum==2){heighFloat=400;titleHIGHT=0;}
    buttonsArr = [NSMutableArray new];
    isSingle = YES;//默认单程
    isUnfold = NO;//默认收起
    isSendFly = NO;//默认接机
    isFreshDataLJJ = YES;
}

-(void)dealloc{
    
    self.search.delegate = nil;
    [self.driveManager setDelegate:nil];
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.mapView.delegate = nil;
    
}

-(void)location{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.locatingWithReGeocode = YES;
    [self.locationManager startUpdatingLocation];
}

-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
        cityName = reGeocode.province;
        [GVUserDefaults standardUserDefaults].cityNameLocation = cityName;
        [self.locationManager stopUpdatingLocation];
        _mapView.centerCoordinate = location.coordinate;
    }
    
}



- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [mapViewLJJTools sharedAMapNaviDriveManager];
        [self.driveManager setDelegate:self];
    }
}
#pragma mark -----------接送机选择--------------------
-(void)createSegment{

    NSArray * titleArr = @[@"接机",@"送机"];
    topView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, titleHIGHT) andBgColor:WHITEColor];
    [self.view addSubview:topView];
    
    for(int i = 0;i<2;i++){
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH/2.0*i, 0, SCREEN_WIDTH/2.0, 50);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setBackgroundColor:CLEARCOLOR];
        button.titleLabel.font = FontSize(17);
        button.tag = 222+i;
        if(i==0){
            [button setTitleColor:MAINThemeColor forState:UIControlStateNormal];
        }else{
            [button setTitleColor:BlackColor forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:button];
        [buttonsArr addObject:button];
        if(i==0){
            lineView = [myLjjTools createViewWithFrame:CGRectMake(SCREEN_WIDTH/2.0*i+20, 50, SCREEN_WIDTH/2.0-40, 1) andBgColor:MAINThemeColor];
            [topView addSubview:lineView];
        }
    }
}
// 选中按钮
- (void)btnClick:(UIButton *)btn
{
    NSUInteger i = btn.tag-222;
    isFreshDataLJJ = YES;
    if(i==0){
        isSendFly = NO;
        heighFloat=440;
        if(!isSingle){
        heighFloat=480;
        }
    }else{
        isSendFly = YES;
        _flightText.text = @"";
        heighFloat=400;
        if(!isSingle){
            heighFloat=440;
        }
    }
    for(UIButton * butt in buttonsArr){
        [butt setTitleColor:BlackColor forState:UIControlStateNormal];
    }
    [btn setTitleColor:MAINThemeColor forState:UIControlStateNormal];
    if (isUnfold) {
     _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, heighFloat);
    }else{
        if (self.indexNum==1) {
            if(isSendFly){
            _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, 80);
            bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
            }else{
            _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, 120);
            bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
            }
        }
    }
    lineView.frame = CGRectMake(SCREEN_WIDTH/2.0*i+20, 50, SCREEN_WIDTH/2.0-40, 1);
    [self.tableView reloadData];
    if(isUnfold){
    bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, heighFloat+titleHIGHT-12, 25, 25);
    }
}
#pragma mark -----------地点时间选择通用--------------------

-(void)createListView{
    if (self.indexNum==1&&!isSendFly) {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, titleHIGHT, SCREEN_WIDTH, 120) style:UITableViewStylePlain];
    }else{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, titleHIGHT, SCREEN_WIDTH, 80) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    self.tableView.bounces = NO;
    _tableView.backgroundColor = CLEARCOLOR;
    [self.view addSubview:_tableView];
    [_tableView  setSeparatorColor:LINECOLOR];
    bottomBtn = [myLjjTools createButtonWithFrame:CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25) andImage:[UIImage imageNamed:@"首页_下拉"] andSelecter:@selector(chooseClick:) andTarget:self];
    bottomBtn.touchAreaInsets = UIEdgeInsetsMake(10, 10, 0, 10);
    [self.view addSubview:bottomBtn];
}

-(void)chooseClick:(UIButton*)btn{
    isFreshDataLJJ = NO;
    btn.selected = !btn.selected;
    [UIView animateWithDuration:0.5 animations:^{
    
        if(btn.selected){
            _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, heighFloat);
             _tableView.scrollEnabled = YES;
            [bottomBtn setImage:[UIImage imageNamed:@"首页_上拉"] forState:UIControlStateNormal];
            bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
            isUnfold = YES;
        }else{
            if (self.indexNum==1&&!isSendFly) {
            _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, 120);
            }else{
            _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, 80);
            }
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            _tableView.scrollEnabled = NO;
            [bottomBtn setImage:[UIImage imageNamed:@"首页_下拉"] forState:UIControlStateNormal];
            bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
            isUnfold = NO;
        }

    } completion:^(BOOL finished) {
         [self.tableView reloadData];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * strID = [NSString stringWithFormat:@"mybussCellID%ld",indexPath.row];
    NSString *ID = strID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        if(indexPath.row==1){
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 9, 13) andImageName:@"首页_地址" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            _startTextField = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+11, 10, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-20, 20) andTitle:@"你在哪儿?" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
            [cell.contentView addSubview:_startTextField];
            
        }else if(indexPath.row==2){
            
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 9, 13) andImageName:@"首页_地址" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            
            _endTextField = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+11, 10, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-20, 20) andTitle:@"你要去在哪儿?" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
            [cell.contentView addSubview:_endTextField];
        }else if(indexPath.row==3){
        
            singleBtn = [[headCateButton alloc]initWithFrame:CGRectMake(15, 0, 70, 40)];
            singleBtn.btnLab.text = @"单程";
            singleBtn.btnImageView.image = [UIImage imageNamed:@"首页_往返"];
            [cell.contentView addSubview:singleBtn];
            [singleBtn addTarget:self action:@selector(selectSinDou:) forControlEvents:UIControlEventTouchUpInside];
            doubleBtn = [[headCateButton alloc]initWithFrame:CGRectMake(15+CGRectGetMaxX(singleBtn.frame)+5, 0, 70, 40)];
            doubleBtn.btnLab.text = @"往返";
            doubleBtn.btnLab.textColor = RGB170;
            doubleBtn.btnImageView.image = [UIImage imageNamed:@"首页_单程"];
            [cell.contentView addSubview:doubleBtn];
            [doubleBtn addTarget:self action:@selector(selectSinDou:) forControlEvents:UIControlEventTouchUpInside];
        }else if(indexPath.row==4){
            
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 12, 13) andImageName:@"首页_时间" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            
            UILabel * label = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, 10, 80, 20) andTitle:@"出发时间:" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
            [cell.contentView addSubview:label];

            _startLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 10, SCREEN_WIDTH-CGRectGetMaxX(label.frame), 20) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
            _startLabel.userInteractionEnabled = YES;
            [cell.contentView addSubview:_startLabel];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startClick)];
            [_startLabel addGestureRecognizer:tap];

        }else if(indexPath.row==5){
            
            returnImg = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 12, 13) andImageName:@"首页_时间" andBgColor:nil];
            returnImg.hidden = YES;
            [cell.contentView addSubview:returnImg];
            
            returnTimeLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(returnImg.frame)+5, 10, 80, 20) andTitle:@"返回时间:" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
            returnTimeLabel.hidden = YES;
            [cell.contentView addSubview:returnTimeLabel];
            
            _returnLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(returnTimeLabel.frame), 10, SCREEN_WIDTH-CGRectGetMaxX(returnTimeLabel.frame), 20) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
             _returnLabel.userInteractionEnabled = YES;
            [cell.contentView addSubview:_returnLabel];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnClick)];
            _returnLabel.hidden = YES;
            [_returnLabel addGestureRecognizer:tap];
            
        }else if(indexPath.row==6){
            
            _selectCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _selectCarBtn.frame = CGRectMake(widSize(56), heiSize(15), 60, 50);
            [_selectCarBtn setImage:[UIImage imageNamed:@"首页_选择车型_奢华车型"] forState:UIControlStateNormal];
            if(_carNameLJJ){
             [_selectCarBtn setTitle:_carNameLJJ forState:UIControlStateNormal];
            }else{
            [_selectCarBtn setTitle:@"选择车型" forState:UIControlStateNormal];
            }
            _selectCarBtn.titleLabel.font = FontSize(14);
            [_selectCarBtn setTitleColor:RGB170 forState:UIControlStateNormal];
            _selectCarBtn.imageRect = CGRectMake(0, 0, 60, 25);
            _selectCarBtn.titleRect = CGRectMake(0, 34, 60, 15);
            [_selectCarBtn addTarget:self action:@selector(selectCarStyle) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_selectCarBtn];
            
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(CGRectGetMaxX(_selectCarBtn.frame)+widSize(42), 30, 11, 21) andImageName:@"iconfont-fanhui-拷贝-7" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            
            _freeMoneyLabel = [[UILabel alloc]init];
            if(_moneyNumStr){
            [self changeLabelWithText:_moneyNumStr];
            }else{
            _freeMoneyLabel.text = @"暂无估价";
            }
            _freeMoneyLabel.numberOfLines = 0;
            _freeMoneyLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame), 12, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-26, 28);
            _freeMoneyLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:_freeMoneyLabel];
            WEAKSELF
            [_freeMoneyLabel addTapGuester:YES with:^{
                [weakSelf jumpToFreeInfo];
            }];
            
            _conpuneLabel = [[UILabel alloc]init];
            if(_freeMoneyStr){
            _conpuneLabel.text = [NSString stringWithFormat:@"优惠券已抵扣%@元",_freeMoneyStr];
            }else{
            _conpuneLabel.text = @"暂无优惠券信息";
            }
            _conpuneLabel.numberOfLines = 0;
            _conpuneLabel.font = FontSize(12);
            _conpuneLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame), 40, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-26, 28);
            _conpuneLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:_conpuneLabel];
            [_conpuneLabel addTapGuester:YES with:^{
                [weakSelf jumpToFreeInfo];
            }];
            UIImageView * imageViewOne = [myLjjTools createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-26, 30, 11, 21) andImageName:@"iconfont-fanhui-拷贝-7" andBgColor:nil];
            [cell.contentView addSubview:imageViewOne];

        }else if(indexPath.row==7){
            
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 9, 13) andImageName:@"首页_司机" andBgColor:nil];
             imageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:imageView];
            
            _driverLabel = [[UILabel alloc]init];
            _driverLabel.text = @"挑选司机";
            _driverLabel.numberOfLines = 0;
            _driverLabel.font = FontSize(15);
            _driverLabel.textColor = MAINThemeOrgColor;
            _driverLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame)+3, 10, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-10, 20);
            [cell.contentView addSubview:_driverLabel];
            WEAKSELF
            [_driverLabel addTapGuester:YES with:^{
                
                [weakSelf selectDriver];
                
            }];

        }else if(indexPath.row==8){
  
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 9, 13) andImageName:@"首页_编辑" andBgColor:nil];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:imageView];
            
            otherText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+3, 10, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-10, 20)];
            otherText.placeholder = @"是否有其他要求?";
            otherText.font = FontSize(15);
            [cell.contentView addSubview:otherText];

        }else if(indexPath.row==9){
            
            UIButton * sureCarBtn = [myLjjTools createButtonWithFrame:CGRectMake(67, 22, SCREEN_WIDTH-67*2, 36) andTitle:@"确认用车" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(sureCarClick) andTarget:self];
            sureCarBtn.layer.cornerRadius = 4.0;
            [cell.contentView addSubview:sureCarBtn];
            
        }else if(indexPath.row==0){
        
            _plainImageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 16, 12) andImageName:@"首页_航班号" andBgColor:nil];
            _plainImageView.contentMode = UIViewContentModeScaleAspectFit;
            _plainImageView.hidden = YES;
            [cell.contentView addSubview:_plainImageView];
            
            _flightText = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(_plainImageView.frame)+11, 10, SCREEN_WIDTH-CGRectGetMaxX(_plainImageView.frame)-20, 20) andPlaceholder:@"请输入航班号" andTextColor:BlackColor andTextFont:FontSize(15) andReturnType:UIReturnKeyDone];
            _flightText.delegate = self;
            _flightText.hidden = YES;
            [cell.contentView addSubview:_flightText];
        }
    
    }
    if(indexPath.row==1&&isFreshDataLJJ){
        WEAKSELF
        if(self.indexNum!=1||isSendFly){
            [_startTextField addTapGuester:YES with:^{
                [weakSelf selectStartPlace];
            }];
            if(_endStrName){
            _startTextField.text = _endStrName;
            _startStrName = _endStrName;
            _startPoint = _endRNMPoint;
            _startRNMPoint = _startPoint;
            }else{
            _startTextField.text = @"你在哪儿?";
            _startPoint = nil;
            }
        }else{
             _startTextField.userInteractionEnabled = NO;
            _startTextField.text = @"重庆江北国际机场";
            _startPoint = [AMapGeoPoint locationWithLatitude:29.719350 longitude:106.654584];
        }

    }else if(indexPath.row==2&&isFreshDataLJJ){
        WEAKSELF
        if(self.indexNum!=1||!isSendFly){
            [_endTextField addTapGuester:YES with:^{
                [weakSelf selectEndPlace];
            }];
            if(_startStrName){
            _endTextField.text =_startStrName;
            _endStrName = _startStrName;
            _endPoint = _startRNMPoint;
            _endRNMPoint = _endPoint;
            }else{
            _endTextField.text = @"你要去哪儿?";
            _endPoint = nil;
            }
        }else{
            _endTextField.userInteractionEnabled = NO;
            _endTextField.text = @"重庆江北国际机场";
            _endPoint = [AMapGeoPoint locationWithLatitude:29.719350 longitude:106.654584];
        }
    
    }else if(indexPath.row==6&&isFreshDataLJJ){
        if(_carNameLJJ){
            [_selectCarBtn setTitle:_carNameLJJ forState:UIControlStateNormal];
        }else{
            [_selectCarBtn setTitle:@"选择车型" forState:UIControlStateNormal];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];

    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==6){
    return 80;
    }else if(indexPath.row==9){
    return 80;
    }else if(indexPath.row==5){
    
        if(isSingle){
            return 0.0;
        }else{
            return 40.0;
        }
        
    }else if(indexPath.row==0){
    
        if(!isUnfold||isSendFly){
            
            if (!isSendFly&&self.indexNum==1) {
                _plainImageView.hidden = NO;
                _flightText.hidden = NO;
                return 40.0;
            }else{
            _plainImageView.hidden = YES;
            _flightText.hidden = YES;
            return 0.0;
            }
        }else{
            if(self.indexNum==2){
            
                _plainImageView.hidden = YES;
                _flightText.hidden = YES;
                return 0.0;
            }else{
            _plainImageView.hidden = NO;
            _flightText.hidden = NO;

            return 40.0;
            }
        }
        
    }else{
    return 40.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark --------------------时间-----------------
- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}
#pragma mark --------------------确认用车-----------------
-(void)sureCarClick{
    
//    if([GVUserDefaults standardUserDefaults].loginType.integerValue==2){
//    
//        moneyNoEnoughView * no = [[moneyNoEnoughView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        no.delegate = self;
//        [self.view addSubview:no];
//        return;
//    }
    //-------------------------接机------------------------------
    NSLog(@"航班%@",_flightText.text);
    NSLog(@"在哪%@",_startTextField.text);
    NSLog(@"去哪%@",_endTextField);
    NSLog(@"单往%d",isSingle);
    NSLog(@"车型%@",_carStyleStr);
    NSLog(@"估价%@",_moneyNumStr);
    NSLog(@"挑选司机%@",_driverLabel.text);
    NSLog(@"出发时间%@",_startLabel.text);
    NSLog(@"回来时间%@", _returnLabel.text);
    NSLog(@"是否其他要求%@",otherText.text);
    NSLog(@"是否接机%d",isSendFly);
    if(_flightText.text.length==0&&_indexNum==1&&!isSendFly){
        ToastWithTitle(@"航班号不能为空");
        return;
    }
    
    if(![JudgeSummaryLJJ isFlightNumber:_flightText.text]&&!isSendFly&&_indexNum==1){
        ToastWithTitle(@"航班号格式不对哦");
        return;
    }

    if(!_endPoint){
        ToastWithTitle(@"请选择终点哦");
        return;
    }
    if(!_startPoint){
        ToastWithTitle(@"请选择起点哦");
        return;
    }
    
    if (!_startTimeString) {
        ToastWithTitle(@"请选择出发时间");
        return;
    }
    
    if(!_returnTimeString&&isSingle==NO){
    
        ToastWithTitle(@"请选择返程时间");
        return;
    }
    
    if([_returnTimeString isEqualToString:_startTimeString]){
        ToastWithTitle(@"出发时间返程时间不能一样哦");
        return;
    }
    
    if(!isSingle){
    if(_returnTimeString.integerValue<_startTimeString.integerValue){
    
        ToastWithTitle(@"返回时间不能早于出发时间");
        return;
    }
    }
    if(IsStrEmpty(_strokeFee)){
    
        ToastWithTitle(@"预计费用没有计算出来哦");
        return;
    }
   //余额不足
   // moneyNoEnoughView * view = [[moneyNoEnoughView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
   //  [[UIApplication sharedApplication].keyWindow addSubview:view];
   //匹配司机
   
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    SET_OBJRCT(@"accountType", [GVUserDefaults standardUserDefaults].loginType);
    [parameters setObject:self.typeItemNum forKey:@"busType"];
    if(_flightText.text.length>0){
    [parameters setObject:_flightText.text forKey:@"airplaneNum"];
    }
    if(_carStyleStr){
    [parameters setObject:_carStyleStr forKey:@"carType"];
    }
    if(_driverID){
    [parameters setObject:_driverID forKey:@"driverId"];
    }
    [parameters setObject:_endTextField.text forKey:@"endAddress"];
    NSString * endStr = [NSString stringWithFormat:@"%lf,%lf",_endPoint.longitude,_endPoint.latitude];
    [parameters setObject:endStr forKey:@"endLngLat"];
    if(isSingle){
    [parameters setObject:@"0" forKey:@"isRound"];
    }else{
    [parameters setObject:@"1" forKey:@"isRound"];
    }
    if(!IsStrEmpty(_distanceStr)){
    [parameters setObject:_distanceStr forKey:@"milage"];
    }
    if(!IsStrEmpty(_returnTimeString)){
    [parameters setObject:_returnTimeString forKey:@"roundTime"];
    }
    if(!IsStrEmpty(_strokeFee)){
      [parameters setObject:_strokeFee forKey:@"strokeFee"];
    }
    [parameters setObject:_startTextField.text forKey:@"startAddress"];
    NSString * startStr = [NSString stringWithFormat:@"%lf,%lf",_startPoint.longitude,_startPoint.latitude];
    [parameters setObject:startStr forKey:@"startLngLat"];
    [parameters setObject:_startTimeString forKey:@"startTime"];
    if(otherText.text.length>0){
    [parameters setObject:otherText.text forKey:@"strokeNote"];
    }
    if(!IsStrEmpty(_estimatedTimeStr)){
    [parameters setObject:intToStr(_startTimeString.integerValue+_estimatedTimeStr.integerValue) forKey:@"preEndTime"];
    }
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    NSLog(@"%@",parameters);
    WEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确认用车?"message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        radarView = [[WKFRadarView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH) andThumbnail:@"首页_系统匹配"];
        // if([GVUserDefaults standardUserDefaults].loginType.integerValue==1){
        [self.view addSubview:radarView];
        // }
        weakSelf.tableView.hidden = YES;
        topView.hidden = YES;

        [HttpRequest postWithURL:HTTP_URLIP(add_Stroke) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject){
            routDataModel = [[routeListLJJModel alloc]init];
            [routDataModel setValuesForKeysWithDictionary:responseObject[@"data"]];
            if([unKnowToStr(responseObject[@"status"]) isEqualToString:@"balance"]){
                [self balanceOnlyClick];
            }else{
                ToastWithTitle(@"您预约的订单已下单成功!");
                routeInfoViewController * route = [[routeInfoViewController alloc]init];
                route.routeModel = routDataModel;
                [self.navigationController pushViewController:route animated:YES];
            }
            weakSelf.tableView.hidden = NO;
            topView.hidden = NO;
            [radarView removeFromSuperview];
            
        } failure:^(NSError *error) {
            weakSelf.tableView.hidden = NO;
            topView.hidden = NO;
            [radarView removeFromSuperview];
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];

 }

#pragma mark ---------余额支付----------------
-(void)balanceOnlyClick{
    
    moneyNoEnoughView * no = [[moneyNoEnoughView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    no.delegate = self;
    [self.view addSubview:no];
    
}
#pragma mark -----------去充值-----------
-(void)gotoChargeAction{
    
    jifenCZViewController * czjf = [[jifenCZViewController alloc]init];
    czjf.typeFrom = 2;
    czjf.routDataModel = routDataModel;
    [self.navigationController pushViewController:czjf animated:YES];
    
}

-(void)continueTakeOrder{

    [self sureCarClick];

}

-(void)delayMethodcccc:(routeListLJJModel*)model{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    SET_OBJRCT(@"orderSn", model.orderSn);
    [parameters setObject:@"3" forKey:@"channel"];
    SET_OBJRCT(@"accountType", [GVUserDefaults standardUserDefaults].loginType)
    SET_OBJRCT(@"companyId", [GVUserDefaults standardUserDefaults].companyId)
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    NSLog(@"%@",parameters);
    [HttpRequest postWithURL:HTTP_URLIP(@"pay/payment") params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
         } failure:^(NSError *error){
        
    }];

//    if([GVUserDefaults standardUserDefaults].loginType.integerValue==1){
//    callCarSucLJJViewController * call = [[callCarSucLJJViewController alloc]init];
//    call.dataModel = model;
//    [self.navigationController pushViewController:call animated:YES];
//    }else{
//    payMoneyOrderViewController * pay = [[payMoneyOrderViewController alloc]init];
//    pay.typeCate = 1;
//    pay.orderSn = model.orderSn;
//    pay.moneyStr = _moneyNumStr;
//    [self.navigationController pushViewController:pay animated:YES];
//    }
}

#pragma mark --------------------选择往返单程-----------------
-(void)selectSinDou:(headCateButton*)btn{

    doubleBtn.btnLab.textColor = RGB170;
    doubleBtn.btnImageView.image = [UIImage imageNamed:@"首页_单程"];
    singleBtn.btnLab.textColor = RGB170;
    singleBtn.btnImageView.image = [UIImage imageNamed:@"首页_单程"];
    isFreshDataLJJ = NO;
    btn.btnLab.textColor = BlackColor;
    btn.btnImageView.image = [UIImage imageNamed:@"首页_往返"];

    if(btn==singleBtn){
        if (!isSingle) {
         heighFloat = heighFloat-40;
        }
        isSingle = YES;
        returnImg.hidden = YES;
        returnTimeLabel.hidden = YES;
        _returnLabel.hidden = YES;
        [self.tableView reloadData];
        _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, heighFloat);
        bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
    }else{
        if (isSingle) {
         heighFloat = heighFloat+40;
        }
        isSingle = NO;
        returnImg.hidden = NO;
        returnTimeLabel.hidden = NO;
        _returnLabel.hidden = NO;
        _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, heighFloat);
        bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
        [self.tableView reloadData];
    }
    if(_returnTimeString){
    [self loadMoney];
    }
}
#pragma mark --------------------选择地图起点终点路径规划-----------------
-(void)selectWhereSureClick:(NSString *)placeStr with:(AMapGeoPoint *)location with:(NSInteger)typeStr{
    
    NSLog(@"-----------------------%lf,%lf",location.longitude,location.latitude);
    
    if(typeStr==1){
        _startTextField.text = placeStr;
        _startPoint = location;
        _startStrName = placeStr;
        _startRNMPoint = location;
    }else{
        _endTextField.text = placeStr;
        _endPoint = location;
        _endStrName = placeStr;
        _endRNMPoint = location;
    }
    if(_startPoint&&_endPoint&&_startTimeString){
        [self clear];
        [self createDriverRoute];
    }
    
    if(!isUnfold&&_startPoint&&_endPoint){
    isFreshDataLJJ = NO;
    [UIView animateWithDuration:0.5 animations:^{
        
        _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, heighFloat);
        _tableView.scrollEnabled = YES;
        [bottomBtn setImage:[UIImage imageNamed:@"首页_上拉"] forState:UIControlStateNormal];
        bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
        isUnfold = YES;
        
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
    }
    
}

/* 清空地图上已有的路线. */
- (void)clear
{   //[_mapView removeAnnotation:_locationAnnota];
    [self.naviRoute removeFromMapView];
}

-(void)createDriverRoute{
    NSLog(@"起点%@",_startPoint);
    NSLog(@"终点%@",_endPoint);
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.strategy = 11;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:_startPoint.latitude
                                           longitude:_startPoint.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:_endPoint.latitude
                                                longitude:_endPoint.longitude];
    [self.search AMapDrivingRouteSearch:navi];
    
}
/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    self.route = response.route;
    if (response.count > 0)
    {
       // [self presentCurrentCourse];
        AMapPath * path = response.route.paths[0];
        _distanceStr = [NSString stringWithFormat:@"%.1lf",path.distance/1000.0];
        _estimatedTimeStr = intToStr(path.duration);
        if(_carStyleStr&&_startTimeString){
            [self loadMoney];
        }
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{

    ToastWithTitle(@"路径规划出错,麻烦重新选择");
    _startTextField.text = @"";
    _startPoint = nil;
    _endTextField.text = @"";
    _endPoint = nil;
}

/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[0] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:_startPoint.latitude longitude:_startPoint.longitude] endPoint:[AMapGeoPoint locationWithLatitude:_endPoint.latitude longitude:_endPoint.longitude]];
    [self.naviRoute addToMapView:_mapView];
   /* 缩放地图使其适应polylines的展示. */
//    [_mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
//                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
//                           animated:YES];
    
}
#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
  
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 6;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = MAINThemeColor;
        
        return polylineRenderer;
    }

    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.lineWidth   = 6;
        polylineRenderer.lineDash = NO;
        polylineRenderer.strokeColor = MAINThemeColor;
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 6;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = MAINThemeColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = MAINThemeColor;
        }
        else
        {
            polylineRenderer.strokeColor = MAINThemeColor;
        }
     
        return polylineRenderer;
    }

    return nil;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
            annotationView.image = [UIImage imageNamed:@"坐标"];
            annotationView.canShowCallout            = YES;
            annotationView.animatesDrop              = YES;
            annotationView.draggable                 = YES;
        }
        return annotationView;
    }
    
    return nil;
}

#pragma mark --------------------地图-----------------

-(void)setMap{
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mapView.delegate = self;
    [self.mapView setZoomLevel:17.5 animated:YES];
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    //自定义定位蓝点----------------------------
    _locationAnnota = [[MAPointAnnotation alloc] init];
    _locationAnnota.lockedToScreen = YES;
    _locationAnnota.lockedScreenPoint = CGPointMake(SCREEN_WIDTH/2.0, (131+SCREEN_HEIGHT-131)/2.0);
    [_mapView addAnnotation:_locationAnnota];

}
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{

    //if(wasUserAction&&!_distanceStr){
    CLLocationCoordinate2D dddd = [mapView convertPoint:CGPointMake(SCREEN_WIDTH/2.0, 131+(SCREEN_HEIGHT-131)/2.0) toCoordinateFromView:self.view];
     NSLog(@"------%lf---%lf--",dddd.longitude,dddd.latitude);
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location  = [AMapGeoPoint locationWithLatitude:dddd.latitude longitude:dddd.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
    
    if(!isUnfold&&_startPoint&&_endPoint&&wasUserAction){
        isFreshDataLJJ = NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            _tableView.frame = CGRectMake(0, titleHIGHT, SCREEN_WIDTH, heighFloat);
            _tableView.scrollEnabled = YES;
            [bottomBtn setImage:[UIImage imageNamed:@"首页_上拉"] forState:UIControlStateNormal];
            bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
            isUnfold = YES;
            
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
        }];
    }

   // }
}
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        NSLog(@"%@",response.regeocode.formattedAddress);
        if(self.indexNum==1){
        if(isSendFly){
            _startTextField.text = response.regeocode.formattedAddress;
            _startPoint = request.location;
            _startStrName = response.regeocode.formattedAddress;
            _startRNMPoint = request.location;
        }else{
            _endTextField.text = response.regeocode.formattedAddress;
            _endPoint = request.location;
            _endStrName = response.regeocode.formattedAddress;
            _endRNMPoint = request.location;
        }
        }else{
            
            _startTextField.text = response.regeocode.formattedAddress;
            _startPoint = request.location;
        
        }
        if(_startPoint&&_endPoint&&_startTimeString){
            [self clear];
            [self createDriverRoute];
        }

        //解析response获取地址描述，具体解析见 Demo
    }
}
#pragma mark --------------------选择车型-----------------
-(void)selectCarStyle{
    
    if(!_endPoint){
        ToastWithTitle(@"请先选择终点");
        return;
    }
    if(!_startPoint){
        ToastWithTitle(@"请先选择起点");
        return;
    }
    if(!_startTimeString){
        ToastWithTitle(@"请先选择出发时间");
        return;
    }
    NSMutableArray * carStyleArr = [NSMutableArray array];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [HttpRequest postWithURL:HTTP_URLIP(cars_Type) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        for(NSDictionary * dict in responseObject[@"data"]){
            carStyleModel * model = [[carStyleModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [carStyleArr addObject:model];
        }
        carStyleSelectView * select =[[carStyleSelectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) witharr:carStyleArr];
        select.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:select];

    } failure:^(NSError *error) {
        
    }];
}

-(void)carStylechoose:(carStyleModel *)model{

    [_selectCarBtn setTitle:model.typeName forState:UIControlStateNormal];
    _carStyleStr = model.typeCarID;
    selectCarModel = model;
    if(_startPoint&&_endPoint&&_startTimeString){
    [self loadMoney];
    }
}
#pragma mark ----------------------往返时间-------------------------
-(void)startClick{
    if(!_distanceStr){
        [self clear];
        [self createDriverRoute];
    }
    MHDatePicker *_selectTimePicker = [[MHDatePicker alloc] init];
    __weak typeof(self) weakSelf = self;
    [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        _startLabel.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"];
        _startTimeString = [logicDone timeWithDateTime:selectedDate];
             if(_carStyleStr&&_startPoint&&_endPoint){
            [weakSelf loadMoney];
        }

    }];
}

-(void)returnClick{
    
    MHDatePicker *_selectTimePicker = [[MHDatePicker alloc] init];
    __weak typeof(self) weakSelf = self;
    [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        _returnLabel.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"];
        _returnTimeString = [logicDone timeWithDateTime:selectedDate];
        [self loadMoney];
    }];
    
}


#pragma mark --------------------------预估计费详情---------------------------

-(void)loadMoney{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    if(_distanceStr){
    [parameters setObject:_distanceStr forKey:@"milage"];
    }else{
        return;
    }
     if(_carStyleStr){
    [parameters setObject:_carStyleStr forKey:@"carType"];
     }else{
         return;
     }
    if(_startTimeString){
    NSInteger timeNum = _estimatedTimeStr.integerValue+_startTimeString.integerValue;
    [parameters setObject:intToStr(timeNum) forKey:@"endTime"];
    [parameters setObject:_startTimeString forKey:@"startTime"];
    }else{
        return;
    }
    SET_OBJRCT(@"accountType", [GVUserDefaults standardUserDefaults].loginType)
    SET_OBJRCT(@"userId", [GVUserDefaults standardUserDefaults].userId)
    SET_OBJRCT(@"productId", self.typeItemNum)
    NSLog(@"%@",parameters);
    if(isSingle){
        [parameters setObject:@"0" forKey:@"isRound"];
    }else{
        [parameters setObject:@"1" forKey:@"isRound"];
    }

    [HttpRequest postWithURL:HTTP_URLIP(Pre_Expenses) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        
        chageMoneyModel * model = [chageMoneyModel new];
        [model setValuesForKeysWithDictionary:responseObject[@"data"][@"ruleFee"]];
        _freeMoneyStr =unKnowToStr(responseObject[@"data"][@"voucher"]);
        _moneyNumStr = [NSString stringWithFormat:@"%.2lf",model.totalFee.floatValue-_freeMoneyStr.floatValue];
        _strokeFee = [NSString stringWithFormat:@"%.2lf",model.totalFee.floatValue];
        _conpuneLabel.text = [NSString stringWithFormat:@"优惠券已抵扣%@元",_freeMoneyStr];
        [self changeLabelWithText:_moneyNumStr];
      
    } failure:^(NSError *error) {
        _freeMoneyLabel.text = @"哦哦,数据不见了";
        _strokeFee = @"";
        _conpuneLabel.text = @"点击重试";
    }];
    
}

-(void)jumpToFreeInfo{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    
    if(_distanceStr){
        [parameters setObject:_distanceStr forKey:@"milage"];
    }
    
    if(_carStyleStr){
        [parameters setObject:_carStyleStr forKey:@"carType"];
    }
    
    if(_startTimeString){
        NSInteger timeNum = _estimatedTimeStr.integerValue+_startTimeString.integerValue;
        [parameters setObject:intToStr(timeNum) forKey:@"endTime"];
        [parameters setObject:_startTimeString forKey:@"startTime"];
    }
    SET_OBJRCT(@"accountType", [GVUserDefaults standardUserDefaults].loginType)
    SET_OBJRCT(@"userId", [GVUserDefaults standardUserDefaults].userId)
    SET_OBJRCT(@"productId", self.typeItemNum)
    if(isSingle){
        [parameters setObject:@"0" forKey:@"isRound"];
    }else{
        [parameters setObject:@"1" forKey:@"isRound"];
    }

    [HttpRequest postWithURL:HTTP_URLIP(Pre_Expenses) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        
        chageMoneyModel * model = [chageMoneyModel new];
        [model setValuesForKeysWithDictionary:responseObject[@"data"][@"ruleFee"]];
         _freeMoneyStr = unKnowToStr(responseObject[@"data"][@"voucher"]);
        _moneyNumStr = [NSString stringWithFormat:@"%.2lf",model.totalFee.floatValue-_freeMoneyStr.floatValue];
        _strokeFee = [NSString stringWithFormat:@"%.2lf",model.totalFee.floatValue];
        _conpuneLabel.text = [NSString stringWithFormat:@"优惠券已抵扣%@元",_freeMoneyStr];
        [self changeLabelWithText:_moneyNumStr];
        NSArray * arr = @[model.totalFee,_distanceStr,_estimatedTimeStr];
        chargeSelectInfoView * charge = [[chargeSelectInfoView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) with:model withCar:selectCarModel withLengh:arr];
        [[UIApplication sharedApplication].keyWindow addSubview:charge];

    } failure:^(NSError *error) {
        
    }];

 
}

#pragma mark ---------地址禁止编辑-----------------

-(void)selectStartPlace{

    selectWhereViewController * select = [[selectWhereViewController alloc]init];
    select.title = @"选择上车地点";
    select.delegate = self;
    select.typeNum = 1;
    select.cityString = cityName;
    [self.navigationController pushViewController:select animated:YES];
    
}
-(void)selectEndPlace{

    selectWhereViewController * select = [[selectWhereViewController alloc]init];
    select.title = @"选择下车地点";
    select.delegate = self;
    select.typeNum = 2;
    select.cityString = cityName;
    [self.navigationController pushViewController:select animated:YES];

}

#pragma mark ----------------挑选司机------------

-(void)selectDriver{
    
    if(!_startTimeString){
        ToastWithTitle(@"请先选择出发时间");
        return;
    }
    collectDriverViewController * colloct = [[collectDriverViewController alloc]init];
    colloct.typeNum = 2;
    colloct.startTime = _startTimeString;
    colloct.endTime = _estimatedTimeStr;
    colloct.delegate = self;
    [self.navigationController pushViewController:colloct animated:YES];

}

-(void)selectDriverSureName:(NSString *)string withID:(NSString *)driverID{

    _driverLabel.text = string;
    _driverID = driverID;
}

#pragma mark ---------设置label样式-----------------
-(void)changeLabelWithText:(NSString*)needText
{
    NSAttributedString * attrString = [myLjjTools createStrLabelTextWith:[NSString stringWithFormat:@"约%@元",needText] and:nil andFont:nil with:needText and:MAINThemeColor];
    [_freeMoneyLabel setAttributedText:attrString];

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
