//
//  HomeViewController.m
//  shuoyeahProject
//
//  Created by shuoyeah on 16/7/28.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "HomeViewController.h"
#import "businessLJJViewController.h"
#import "routingLJJViewController.h"
#import "myMessageListViewController.h"
#import "paySuccessViewController.h"
#import "headListItemsModel.h"
#import "routeListLJJModel.h"
#import "ljjUrlWebViewController.h"
#import "priceDiffLJJViewController.h"
#import "routingRoadHeadView.h"
#import "messageAlert.h"
#define HEIBOTTOM 200
@interface HomeViewController ()<UIAlertViewDelegate,headListRoutDelegate,EMChatManagerDelegate>{

    UIImageView * backOrderView;
    NSMutableArray * _routingArr;//行程中订单
    routingRoadHeadView * _routingBtn;
    UIView * backView;
      CGFloat hei;
    UIButton *newsButton;
}
@property (nonatomic,copy)NSString * string;
@property (nonatomic,strong)NSMutableArray * itemDataArr;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemDataArr = [NSMutableArray new];
    _routingArr = [NSMutableArray array];
    [self setRightBtn];
    [self setBackImg];
    [self initData];
    [self loadDataList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFreshDataAction) name:loginSucFreshData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFreshDataAction) name:exitSucFreshData object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFreshDataAction) name:@"routingFreshDeleLJJ" object:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
}

- (void)messagesDidReceive:(NSArray *)aMessages{

    messageAlert * playsound = [[messageAlert alloc]initSystemShake];
    [playsound play];
    [newsButton setBackgroundImage:[UIImage imageNamed:@"消息提示点"] forState:normal];
}

-(void)loginFreshDataAction{
    
    [self loadRoutingData];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationItem.titleView = [UIView new];
    [self setNav];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self setNavBack];
    
}


-(void)loadDataList{

    [HttpRequest postWithURL:HTTP_URLIP(get_BusTypeList) params:nil andNeedHub:YES success:^(NSDictionary *responseObject) {
        
        if([responseObject[@"data"] isKindOfClass:[NSArray class]]){
        for(NSDictionary * dict in responseObject[@"data"]){
        headListItemsModel * model =[[headListItemsModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [_itemDataArr addObject:model];
        }
        }
        if(_itemDataArr.count>0){
        [self setBottomView];
        [self loadRoutingData];
        }else{
        ToastWithTitle(@"没有收到数据");
        }
    } failure:^(NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络连接失败,请检查网络后重试" delegate:self cancelButtonTitle:@"重新连接" otherButtonTitles:nil];
        [alert show];
    }];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [self loadDataList];

}

-(void)setNavBack{

    //设置导航模拟全透明导航
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.translucent = NO;
    //去掉导航下面的一条白线
    self.navigationController.navigationBar.clipsToBounds = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBarTintColor:MAINThemeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

-(void)setNav{

    //设置导航模拟全透明导航
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.translucent = YES;
    //去掉导航下面的一条白线
    self.navigationController.navigationBar.clipsToBounds = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //修改navgationBar的字体的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
}
#pragma mark -----------设置导航栏右侧按钮-------------
-(void)setRightBtn{

    UIView * view = [myLjjTools createViewWithFrame:CGRectMake(0, 0, 65, 24) andBgColor:CLEARCOLOR];

    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    phoneButton.frame = CGRectMake(0, 0, 27, 24);
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"首页_call"] forState:normal];
    [phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneButton];
    
    newsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newsButton.frame = CGRectMake(35, 0, 27, 24);
    [newsButton setBackgroundImage:[UIImage imageNamed:@"首页_messenge"] forState:normal];
    [newsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newsButton addTarget:self action:@selector(newsClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:newsButton];
    
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = ButtonItem;
    
}

-(void)phoneClick{

   // [self.view makeToastActivity];
    [myLjjTools directPhoneCallWithPhoneNum:@"023-67757777"];

}
#pragma mark --------加载数据-----------
-(void)initData{

    
}
#pragma mark --------消息-----------
-(void)newsClick{
    
    [newsButton setBackgroundImage:[UIImage imageNamed:@"首页_messenge"] forState:normal];
    myMessageListViewController * myMessage = [[myMessageListViewController alloc]init];
    [self.navigationController pushViewController:myMessage animated:YES];

}

#pragma mark -----------设置首页背景图-------------
-(void)setBackImg{

    UIImageView * backImageView = [myLjjTools createImageViewWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT-44+64) andImage:[UIImage imageNamed:@"首页_bg"] andBgColor:nil];
    [self.view addSubview:backImageView];

}
#pragma mark -----------底部分栏-------------
-(void)setBottomView{

    UIScrollView * _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    _scroll.scrollEnabled = YES;
    _scroll.backgroundColor = CLEARCOLOR;
    _scroll.bounces = YES;
    _scroll.alwaysBounceVertical = YES;
    _scroll.alwaysBounceHorizontal = NO;
    [self.view addSubview:_scroll];

    NSArray * picArr = @[@"订机票",@"接送机",@"医院",@"周末出游",@"商务用车",@"接送学生"];
    int maxNum;
  
    if(_itemDataArr.count>3){
        maxNum = 2;
        hei = 160;
    }else{
        maxNum=1;
        hei= 80;
    }
    backView= [myLjjTools createViewWithFrame:CGRectMake(0, SCREEN_HEIGHT-hei-44-5, SCREEN_WIDTH, hei) andBgColor:CLEARCOLOR];
    [_scroll addSubview:backView];
    CGFloat SPACE = 1;
    CGFloat BTNWID = (SCREEN_WIDTH-SPACE)/3.0;
    CGFloat BTNHEI = (hei-SPACE*maxNum)/maxNum;
    for(int i=0;i<2;i++){
        for(int j=0;j<3;j++){
            if(i*3+j<_itemDataArr.count){
               
            }else{
             return;
            }
          headListItemsModel * model = _itemDataArr[i*3+j];
          UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
          button.frame = CGRectMake(0+(SCREEN_WIDTH-SPACE)/3.0*j+SPACE*j, BTNHEI*i+SPACE*i, (SCREEN_WIDTH-SPACE)/3.0, BTNHEI);
          [button setBackgroundColor:RGBACOLOR(255, 255, 255, 1)];
          button.tag = 1319+3*i+j;
          [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
          [button setImage:[UIImage imageNamed:picArr[i*3+j]] forState:UIControlStateNormal];
          [button setTitle:model.busTypeName forState:UIControlStateNormal];
          [button setTitleColor:BlackColor forState:UIControlStateNormal];
          button.titleLabel.textAlignment = NSTextAlignmentCenter;
          button.titleLabel.font = FontSize(13);
          button.imageView.contentMode = UIViewContentModeScaleAspectFit;
          button.titleRect = CGRectMake(0, BTNHEI-32, BTNWID, 20);
          button.imageRect = CGRectMake((BTNWID-25)/2.0, 16, 25, 25);
          [backView addSubview:button];
        }
    }
    _routingBtn = [[routingRoadHeadView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame)+1, SCREEN_WIDTH, 50)];
    _routingBtn.delegate = self;
    [self.view addSubview:_routingBtn];
}

-(void)loadRoutingData{

    if(![GVUserDefaults standardUserDefaults].LOGINSUC){
        [logicDone presentLoginView];
        backView.frame = CGRectMake(0, SCREEN_HEIGHT-hei-44-5, SCREEN_WIDTH, hei);
        _routingBtn.frame = CGRectMake(0, CGRectGetMaxY(backView.frame)+1, SCREEN_WIDTH, 50);
        return;
    }
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:@"1"  forKey:@"pageNumber"];
    [parameters setObject:@"1"  forKey:@"pageSize"];
    [parameters setObject:@"2" forKey:@"strokeStatus"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(get_UserStrokeList) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        if(_routingArr.count>0){
        [_routingArr removeAllObjects];
        backView.frame = CGRectMake(0, SCREEN_HEIGHT-hei-44-5, SCREEN_WIDTH, hei);
        _routingBtn.frame = CGRectMake(0, CGRectGetMaxY(backView.frame)+1, SCREEN_WIDTH, 50);
        }
        if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
        for(NSDictionary * dictt in responseObject[@"data"][@"list"]){
            routeListLJJModel *model = [[routeListLJJModel alloc]init];
            [model setValuesForKeysWithDictionary:dictt];
            if(model.strokeType.integerValue!=5){
            [_routingArr addObject:model];
            }
        }
//           routeListLJJModel *model = [[routeListLJJModel alloc]init];
//            model.endLngLat = @"106.310354,29.611126";
//            [_routingArr addObject:model];
        if(_routingArr.count==1){
            routeListLJJModel * model = _routingArr[0];
            backView.frame = CGRectMake(0, SCREEN_HEIGHT-hei-44-58, SCREEN_WIDTH, hei);
            _routingBtn.frame = CGRectMake(0, CGRectGetMaxY(backView.frame)+1, SCREEN_WIDTH, 50);
            _routingBtn.startLabel.text = [NSString stringWithFormat:@"起点   %@",model.startAddress];
            _routingBtn.endLabel.text = [NSString stringWithFormat:@"终点   %@",model.endAddress];
        }
    }
        
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark --------------行程中订单-----------------------
-(void)routingClick{
    if(![GVUserDefaults standardUserDefaults].LOGINSUC){
        [logicDone presentLoginView];
        return;
    }
    routingLJJViewController * tout = [[routingLJJViewController alloc]init];
    if(_routingArr.count>0){
    routeListLJJModel * model = _routingArr[0];
    tout.strokeSn = model.strokeSn;
    tout.dataModel = model;
    [self.navigationController pushViewController:tout animated:YES];
    }else{
    ToastWithTitle(@"列表刷新失败,请重新登录");
    }
    
}

-(void)selectAction:(UIButton*)btn{

    if(![GVUserDefaults standardUserDefaults].LOGINSUC){
        [logicDone presentLoginView];
        return;
    }
    NSInteger number = btn.tag-1319;
    headListItemsModel * model = _itemDataArr[number];
    if(number==1){
        if (!IsStrEmpty(model.url)) {
        ljjUrlWebViewController * url = [[ljjUrlWebViewController alloc]init];
        url.title = model.busTypeName;
            url.url =model.url;
        [self.navigationController pushViewController:url animated:YES];
        }else{
        businessLJJViewController * buss = [[businessLJJViewController alloc]init];
        buss.indexNum = 1;
        buss.typeItemNum = model.itemId;
        [self.navigationController pushViewController:buss animated:YES];
        }
    }else if(number==3){
        if (!IsStrEmpty(model.url)) {
            ljjUrlWebViewController * url = [[ljjUrlWebViewController alloc]init];
            url.title = model.busTypeName;
            url.url =model.url;
            [self.navigationController pushViewController:url animated:YES];
        }else{
        businessLJJViewController * buss = [[businessLJJViewController alloc]init];
        buss.indexNum = 2;
        buss.title = model.busTypeName;
        buss.typeItemNum = model.itemId;
        [self.navigationController pushViewController:buss animated:YES];
        }
    }else if(number==2){
    
        if (!IsStrEmpty(model.url)) {
            ljjUrlWebViewController * url = [[ljjUrlWebViewController alloc]init];
            url.title = model.busTypeName;
            url.url =model.url;
            [self.navigationController pushViewController:url animated:YES];
        }else{
            businessLJJViewController * buss = [[businessLJJViewController alloc]init];
            buss.indexNum = 2;
            buss.title = model.busTypeName;
            buss.typeItemNum = model.itemId;
            [self.navigationController pushViewController:buss animated:YES];
        }
        
    }else if(number==4){
        if (!IsStrEmpty(model.url)) {
            ljjUrlWebViewController * url = [[ljjUrlWebViewController alloc]init];
            url.title = model.busTypeName;
            url.url =model.url;
            [self.navigationController pushViewController:url animated:YES];
        }else{
//        businessLJJViewController * buss = [[businessLJJViewController alloc]init];
//        buss.indexNum = 2;
//        buss.title = model.busTypeName;
//        buss.typeItemNum = model.itemId;
//        [self.navigationController pushViewController:buss animated:YES];
        }
    }else if(number==5){
        if (!IsStrEmpty(model.url)) {
            ljjUrlWebViewController * url = [[ljjUrlWebViewController alloc]init];
            url.title = model.busTypeName;
            url.url =model.url;
            [self.navigationController pushViewController:url animated:YES];
        }else{
//        businessLJJViewController * buss = [[businessLJJViewController alloc]init];
//        buss.indexNum = 2;
//        buss.title = model.busTypeName;
//        buss.typeItemNum = model.itemId;
//        [self.navigationController pushViewController:buss animated:YES];
        }
    }else{
    
        if (!IsStrEmpty(model.url)) {
            ljjUrlWebViewController * url = [[ljjUrlWebViewController alloc]init];
            url.title = model.busTypeName;
            url.url =model.url;
            [self.navigationController pushViewController:url animated:YES];
        }else{
        
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];

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
