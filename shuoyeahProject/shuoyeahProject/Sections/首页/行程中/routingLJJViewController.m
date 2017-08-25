//
//  routingLJJViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "routingLJJViewController.h"
#import "routingAllLJJView.h"
#import "GCDAsyncSocket.h"
#import "SocketManager.h"
#import "routingingModel.h"
#import "mapViewLJJTools.h"
#define HTTPID @"119.23.44.62"//192.168.199.177 //120.25.193.252
@interface routingLJJViewController ()<AMapLocationManagerDelegate,AMapNaviDriveManagerDelegate,AMapNaviDriveViewDelegate,GCDAsyncSocketDelegate,AMapNaviDriveDataRepresentable>{
    routingAllLJJView * routing;
}
@property (nonatomic, strong) AMapLocationManager*locationManager;
@property (nonatomic, strong)AMapNaviDriveManager*driveManager;
@property (nonatomic, strong) AMapNaviDriveView *driveView;

@property (nonatomic, strong) AMapNaviPoint *startPointNav;
@property (nonatomic, strong) AMapNaviPoint *endPointNav;
@property (strong, nonatomic)GCDAsyncSocket * clientSocket;
@property (nonatomic, retain) NSTimer    *connectTimer; // 计时器
/**
 *  连接状态：1已连接，-1未连接，0连接中
 */
@property (nonatomic, assign) NSInteger connectStatus;
@property (nonatomic, assign) NSInteger reconnectionCount;  // 建连失败重连次数
@property (nonatomic, strong) NSTimer *reconnectTimer;  // 重连定时器
@property (nonatomic, strong) NSTimer *connectLJJTimer;  // 定时器

@property (nonatomic, strong) UIButton * navBtn;
@end
//29.602388 106.376076  29.611126 106.310354
@implementation routingLJJViewController

- (void)dealloc
{
    [self.driveManager stopNavi];
    [self.driveManager removeDataRepresentative:self.driveView];
    [self.driveManager setDelegate:nil];
    self.locationManager.delegate = nil;
    self.driveView.delegate = nil;
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //当前视图控制器在栈中，故为push操作
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        //当前视图控制器不在栈中，故为pop操作
        [self.clientSocket disconnect];
        self.clientSocket.delegate = nil;
        self.clientSocket = nil;
        [self.connectLJJTimer invalidate];
        _connectLJJTimer = nil;
        [routing.progressView removeFromSuperview];
        routing.progressView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"行程中";
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [SVProgressHUD showWithStatus:@"导航规划中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self creatrNavi];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if(err){
        if(self.connectLJJTimer){
            [self.connectLJJTimer invalidate];
            self.connectLJJTimer = nil;
            self.connectLJJTimer = 0;
        }
        if(self.reconnectionCount>=0 && self.reconnectionCount <= 5) {
            
            [_reconnectTimer invalidate];
            _reconnectTimer=nil;
            NSTimeInterval time = 6;
            if (!self.reconnectTimer) {
                self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                       target:self
                                                                     selector:@selector(reconnection:)
                                                                     userInfo:nil
                                                                      repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:self.reconnectTimer forMode:NSRunLoopCommonModes];
            }
            self.reconnectionCount++;
            
        }else{
            [self.reconnectTimer invalidate];
            self.reconnectTimer = nil;
            self.reconnectionCount = 0;
        }
    }else{
        NSLog(@"主动断开");
    }
}
- (void)reconnection:(NSTimer *)timer {
    NSError *error = nil;
    if (![self.clientSocket connectToHost:HTTPID onPort:9999 withTimeout:5 error:&error]) {
        self.connectStatus = -1;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock{
    
    NSLog(@"关了读取");
    
}

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port{
    
    if(self.reconnectTimer){
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
        self.reconnectionCount = 0;
    }
    NSLog(@"连接成功了");
    self.connectStatus = 1;
    SocketManager * socketManager = [SocketManager sharedSocketManager];
    socketManager.mySocket = sock;
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    SET_OBJRCT(@"strokeSN", self.strokeSn)
    [parameters setObject:@"2" forKey:@"requestType"];
    NSString * jsStr = [myLjjTools crazy_ObjectToJsonString:parameters];
    jsStr = [NSString stringWithFormat:@"%@\n",jsStr];
    [self.clientSocket writeData:[jsStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:0];
    [self.clientSocket readDataWithTimeout:3 tag:0];
    WEAKSELF
    weakSelf.connectLJJTimer = [NSTimer scheduledTimerWithTimeInterval:4 repeats:YES block:^(NSTimer * _Nonnull timer){
        NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
        SET_OBJRCT(@"strokeSN", weakSelf.strokeSn)
        [parameters setObject:@"2" forKey:@"requestType"];
        NSString * jsStr = [myLjjTools crazy_ObjectToJsonString:parameters];
        jsStr = [NSString stringWithFormat:@"%@\n",jsStr];
        [weakSelf.clientSocket writeData:[jsStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:0];
        [weakSelf.clientSocket readDataWithTimeout:3 tag:0];
    }];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@----",responseDict);
    routingingModel * model = [[routingingModel alloc]init];
    [model setValuesForKeysWithDictionary:responseDict[@"data"]];
    if([responseDict[@"data"] isKindOfClass:[NSDictionary class]]){
    if([responseDict[@"data"] count]!=0){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"routingMoneyNotiLJJ" object:self userInfo:@{@"notiMoney":responseDict[@"data"]}];
    [self loadDataFrom:model];
    }
    }else{
    }
}
#pragma mark ----------------加载数据----------------------------
-(void)loadDataFrom:(routingingModel *)model{
    
    if(model.alreadyMileage&&model.preMileage){
    routing.progressView.progress = model.alreadyMileage.floatValue/(model.alreadyMileage.floatValue+model.preMileage.floatValue);
    }
    routing.totalMoneyLabel.text = [NSString stringWithFormat:@"%.2lf元\n累计费用",model.totalFee.floatValue];
    routing.allMonyLabel.text = [NSString stringWithFormat:@"累计费用  %.2lf元",model.totalFee.floatValue];
    if(!model.preTime){
        model.preTime=@"0";
    }
    routing.residueTimeLabel.text = [NSString stringWithFormat:@"预计 %@min后 到达",model.preTime];
    NSAttributedString * astr11 = [myLjjTools createStrLabelTextWith:[NSString stringWithFormat:@"预计 %@min后 到达",model.preTime] and:[NSString stringWithFormat:@"%@min后",model.preTime] andFont:FontSize(14) with:nil and:nil];
    routing.residueTimeLabel.attributedText = astr11;
    routing.endPathLabel.text = [NSString stringWithFormat:@"已行驶里程:%.1lfkm",model.alreadyMileage.floatValue];
    routing.lastPathLabel.text = [NSString stringWithFormat:@"预计里程:%.1lfkm",model.preMileage.floatValue];
    if(!model.alreadyMileage){
        model.alreadyMileage=@"0";
    }
    NSAttributedString * astr1 = [myLjjTools createStrLabelTextWith:[NSString stringWithFormat:@"已行驶里程  %.1lfkm",model.alreadyMileage.floatValue] and:[NSString stringWithFormat:@"%.1lfkm",model.alreadyMileage.floatValue] andFont:FontSize(19) with:[NSString stringWithFormat:@"%.1lfkm",model.alreadyMileage.floatValue] and:MAINThemeOrgColor];
    routing.endPathLabel1.attributedText = astr1;
    if(!model.preMileage){
        model.preMileage=@"0";
    }
    NSAttributedString * astr2 = [myLjjTools createStrLabelTextWith:[NSString stringWithFormat:@"预计里程  %.1lfkm",model.preMileage.floatValue] and:[NSString stringWithFormat:@"%.1lfkm",model.preMileage.floatValue] andFont:FontSize(19) with:[NSString stringWithFormat:@"%.1lfkm",model.preMileage.floatValue] and:MAINThemeOrgColor];
    routing.lastPathLabel1.attributedText = astr2;
    routing.moneyStr = [NSString stringWithFormat:@"%@",model.totalFee];
    routing.dataModel = model;

}
#pragma mark -----------发送消息-----------------------
-(void)sendMessageLJJ{

  
}
-(void)creatrNavi{

    [self initDriveView];
    
    [self initDriveManager];
    
    [self initProperties];
    
    routing = [[routingAllLJJView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 323)];
    [self.view addSubview:routing];
    routing.startLabel.text = _dataModel.startAddress;
    routing.endLabel.text = _dataModel.endAddress;

    self.navBtn = [myLjjTools createButtonWithFrame:CGRectMake(SCREEN_WIDTH-100, SCREEN_HEIGHT-60, 80, 40) andTitle:@"继续导航" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(navClick) andTarget:self];
    self.navBtn.layer.cornerRadius = 4.0;
    self.navBtn.hidden = YES;
    [self.view addSubview:self.navBtn];
}

#pragma mark - Initalization

- (void)initProperties
{
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为10s
    self.locationManager.locationTimeout =5;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    self.locationManager.reGeocodeTimeout = 5;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    
            if (error.code == AMapLocationErrorLocateFailed)
            {
                ToastWithTitle(@"定位失败,请退出重新尝试");
                [SVProgressHUD dismiss];
                return;
            }
        }
        
        NSLog(@"location:%@", location);
    
        NSArray * arr2 = [_dataModel.endLngLat componentsSeparatedByString:@","];
        
        if(arr2.count<2){
            ToastWithTitle(@"终点有问题,无法导航");
             [SVProgressHUD dismiss];
            return;
        }
        if(!location){
            ToastWithTitle(@"起点有问题,无法导航");
             [SVProgressHUD dismiss];
            return;
        }
        //为了方便展示,选择了固定的起终点
        self.startPointNav = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        self.endPointNav   = [AMapNaviPoint locationWithLatitude:[arr2[1] floatValue] longitude:[arr2[0] floatValue]];
        [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPointNav]
                                                    endPoints:@[self.endPointNav]
                                                    wayPoints:nil
                                              drivingStrategy:AMapNaviDrivingStrategySingleDefault];
        
        }];
    
    
}

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [mapViewLJJTools sharedAMapNaviDriveManager];
        [self.driveManager setDelegate:self];
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.driveManager addDataRepresentative:self.driveView];
    }
}

- (void)initDriveView
{
    if (self.driveView == nil)
    {
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), SCREEN_HEIGHT)];
        [self.driveView setDelegate:self];
        self.driveView.cameraDegree = 1.0;
        //将导航界面的界面元素进行隐藏，然后通过自定义的控件展示导航信息
        [self.driveView setShowUIElements:NO];
        [self.driveView setShowCamera:NO];
        [self.driveView setShowCrossImage:NO];
        [self.driveView setShowTrafficBar:NO];
        [self.driveView setShowTrafficButton:NO];
        [self.driveView setShowTurnArrow:NO];
        [self.driveView setCarImage:[UIImage imageNamed:@"导航_小车"]];
        //关闭路况显示，以展示自定义Polyline的样式
        [self.driveView setShowTrafficLayer:NO];
        [self.view addSubview:self.driveView];
        [self.driveView setShowMode:AMapNaviDriveViewShowModeOverview];
    }
}
#pragma mark - AMapNaviDriveManager Delegate

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode{
    
    if(showMode==AMapNaviDriveViewShowModeNormal){
        self.navBtn.hidden = NO;
    }
}

-(void)navClick{

    self.driveView.showMode = AMapNaviDriveViewShowModeCarPositionLocked;
    self.navBtn.hidden = YES;
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    [self.driveManager startGPSNavi];
    [SVProgressHUD dismiss];
    if (!self.clientSocket) {
    self.clientSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError * error = nil;
    [self.clientSocket connectToHost:HTTPID onPort:9999 error:&error];
    }
}

- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager
{
    return NO;
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
