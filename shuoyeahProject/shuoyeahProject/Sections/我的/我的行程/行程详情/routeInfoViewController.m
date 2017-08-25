//
//  routeInfoViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "routeInfoViewController.h"
#import "routeInfoHeadTableViewCell.h"
#import "driverInfoLJJViewController.h"
#import "driverInfoModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "chatIMInfoViewController.h"
#import "touSuMessageViewController.h"
#import "paySuccessViewController.h"
#import "priceDiffLJJViewController.h"
#import "moneyNoEnoughView.h"
#import "jifenCZViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "driveNameAndUrlModel.h"
#import "routingInfoNewTableViewCell.h"
#import "billByRouteWhereViewController.h"
@interface routeInfoViewController ()<UITableViewDelegate,UITableViewDataSource,gotoChargeMoneyDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)routeListLJJModel * driModel;
@property (nonatomic,copy)NSString * numberStr;
@property (nonatomic,strong)UIImageView * headDriverImg;
@property (nonatomic,strong)UILabel * DriverNameLabel;
@property (nonatomic,strong)UILabel * distanceLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UIImageView * statuImg;
@property (nonatomic,strong)UILabel * carInforLabel;
@property (nonatomic,strong)UILabel * driverInforLabel;
@end

@implementation routeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行程详情";
    [self createTable];
    [self loadData];
    self.navigationController.navigationBar.translucent = YES;
    if(!self.isBackTop){
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=NO;
    }
    self.navigationItem.leftBarButtonItem = [self itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(freshData) name:@"routeApplyLJJ" object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=YES;
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[self imageWithName:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithName:highIcon] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 10, 20);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (UIImage *)imageWithName:(NSString *)name
{
    if (iOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) { // 没有_os7后缀的图片
            image = [UIImage imageNamed:name];
        }
        return image;
    }
    
    // 非iOS7
    return [UIImage imageNamed:name];
}


- (void)back
{   [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadData{

    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    SET_OBJRCT(@"strokeId", _routeModel.strokeId);
    [HttpRequest postWithURL:HTTP_URLIP(get_UserStrokeByStrokeId) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        
        _driModel = [[routeListLJJModel alloc]init];
        _numberStr = unKnowToStr(responseObject[@"data"][@"number"]);
        [_driModel setValuesForKeysWithDictionary:responseObject[@"data"][@"record"]];
        [self.tableView reloadData];
        [_headDriverImg sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(_driModel.driverHeadImg)] placeholderImage:[UIImage imageNamed:defaultHeadName]];
        _DriverNameLabel.text = _driModel.driverName;
        _distanceLabel.text = [NSString stringWithFormat:@"%@km",_driModel.milage];
        _timeLabel.text = [NSString stringWithFormat:@"%.1lfh",(_driModel.preEndTime.integerValue-_driModel.startTime.integerValue)/3600.0];
        switch (_driModel.status.integerValue) {
            case 1:
                _statuImg.image = [UIImage imageNamed:@"未出行"];
                break;
            case 0:
                _statuImg.image = [UIImage imageNamed:@"我的_已取消"];
                break;
            case 3:
                switch (_driModel.orderPayStatus.integerValue) {
                    case 1:
                        _statuImg.image = [UIImage imageNamed:@"我的_已完成"];
                        break;
                    case 0:
                        _statuImg.image = [UIImage imageNamed:@"待支付"];
                        break;
                    default:
                        break;
                }

                break;
            default:
                break;
        }
    } failure:^(NSError *error) {
        
    }];

}

-(void)freshData{

    [self loadData];

}

#pragma mark -------------创建table--------------------
-(void)createTable{
    
    UIImageView * hedImg = [myLjjTools createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  160) andImageName:@"矩形-29" andBgColor:nil];
    [self.view addSubview:hedImg];
    
    _headDriverImg = [myLjjTools createImageViewWithFrame:CGRectMake(16, 70, 80, 80) andImageName:@"user" andBgColor:nil];
    _headDriverImg.layer.cornerRadius = 40;
    _headDriverImg.clipsToBounds = YES;
    [hedImg addSubview:_headDriverImg];
    
    _DriverNameLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(_headDriverImg.frame)+15, 85, SCREEN_WIDTH-57-24-CGRectGetMaxX(_headDriverImg.frame)-15, 20) andTitle:@"" andTitleFont:FontSize(17) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [hedImg addSubview:_DriverNameLabel];
    
    UIImageView * locatinImg = [myLjjTools createImageViewWithFrame:CGRectMake(CGRectGetMaxX(_headDriverImg.frame)+15, CGRectGetMaxY(_DriverNameLabel.frame)+20, 12, 16) andImageName:@"收藏工长_距离" andBgColor:nil];
    [hedImg addSubview:locatinImg];
    
    _distanceLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(locatinImg.frame)+W_In_375(8), CGRectGetMaxY(_DriverNameLabel.frame)+20, W_In_375(56), 16) andTitle:@"" andTitleFont:FontSize(12) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [hedImg addSubview:_distanceLabel];
    
    UIImageView * timeImg = [myLjjTools createImageViewWithFrame:CGRectMake(CGRectGetMaxX(_distanceLabel.frame), CGRectGetMaxY(_DriverNameLabel.frame)+20, 14, 15) andImageName:@"stop-watch" andBgColor:nil];
    [hedImg addSubview:timeImg];
    _timeLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(timeImg.frame)+W_In_375(8), CGRectGetMaxY(_DriverNameLabel.frame)+20, W_In_375(56), 16) andTitle:@"" andTitleFont:FontSize(12) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [hedImg addSubview:_timeLabel];
    
    _statuImg = [myLjjTools createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-57-24, 71, 57, 57) andImageName:@"" andBgColor:nil];
    [hedImg addSubview:_statuImg];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(hedImg.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(hedImg.frame)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView  setSeparatorColor:LINECOLOR];
    _tableView.backgroundColor = BACKLJJcolor;
    [_tableView registerNib:[UINib nibWithNibName:@"routingInfoNewTableViewCell" bundle:nil] forCellReuseIdentifier:@"routingInfoNewID"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(_driModel.status.integerValue==3&&_driModel.isReceipt.integerValue==0){
    return 4;
    }else{
    return 3;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        return 2;
    }else if(section==1){
        return 1;
    }else if(section==2){
        return 4;
    }else{
    return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if(section==3||(section==2&&(_driModel.isReceipt.integerValue!=0||_driModel.status.integerValue!=3))){
    return 180;
    }else{
    return 0.1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if(section==3||(section==2&&(_driModel.isReceipt.integerValue!=0||_driModel.status.integerValue!=3))){
    UIView * view = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,heiSize(120)) andBgColor:CLEARCOLOR];
    UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake(widSize(50), heiSize(20), SCREEN_WIDTH-widSize(100), heiSize(40)) andTitle:@"取消订单" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(cancelClick) andTarget:self];
    btn.layer.cornerRadius = 4.0;
    btn.clipsToBounds = YES;
    
    UIButton * btn1 = [myLjjTools createButtonWithFrame:CGRectMake(widSize(50),CGRectGetMaxY(btn.frame)+heiSize(20), SCREEN_WIDTH-widSize(100), heiSize(40)) andTitle:@"继续支付" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(continueClick) andTarget:self];
    btn1.layer.cornerRadius = 4.0;
    btn1.clipsToBounds = YES;

    if(_driModel.status.integerValue==1){
    [view addSubview:btn];
    }else if(_driModel.isComment.integerValue==0&&_driModel.status.integerValue==3&&_driModel.orderPayStatus.integerValue==1){
    [btn setTitle:@"去评价" forState:UIControlStateNormal];
    [view addSubview:btn];
    }else if(_driModel.status.integerValue==3&&_driModel.orderPayStatus.integerValue==0){
    btn1.frame = CGRectMake(widSize(50), heiSize(20), SCREEN_WIDTH-widSize(100), heiSize(40));
    [view addSubview:btn1];
    }
    return view;
    }else{
    return nil;
    }
}

-(void)cancelClick{

    if(_indexSelectNum.integerValue==1){
        touSuMessageViewController * cancel = [touSuMessageViewController new];
        cancel.typeNumber = 2;
        cancel.orderId = _driModel.strokeId;
        [self.navigationController pushViewController:cancel animated:YES];
    }else if(_driModel.isComment.integerValue==0){
        paySuccessViewController *vc = [[paySuccessViewController alloc] init];
        vc.strokeId = _driModel.strokeId;
        vc.orderSn = _driModel.orderSn;
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}

-(void)continueClick{
    
    priceDiffLJJViewController *vc = [[priceDiffLJJViewController alloc] init];
    vc.orderSn = _driModel.orderSn;
    [self.navigationController pushViewController:vc animated:YES];

    
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
    czjf.routDataModel = _driModel;
    [self.navigationController pushViewController:czjf animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==1){
       
        routingInfoNewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"routingInfoNewID" forIndexPath:indexPath];
        WEAKSELF
        cell.ToPayIndexPath = ^(NSString *str) {
            priceDiffLJJViewController *vc = [[priceDiffLJJViewController alloc] init];
            vc.orderSn = _driModel.orderSn;
            vc.typeNum = 10;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [cell laodDataFrom:_driModel];
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(indexPath.section==2){
    
        NSString *ID = @"routeInfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.textColor = rgb(170, 170, 170);
            cell.textLabel.font = FontSize(15);
            cell.detailTextLabel.font = FontSize(15);
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        }
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"订单号";
                cell.detailTextLabel.text = _driModel.strokeSn;
                break;
            case 0:
                cell.textLabel.text = @"乘车人";
                cell.detailTextLabel.numberOfLines = 0;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",[GVUserDefaults standardUserDefaults].userName,[GVUserDefaults standardUserDefaults].userPhone];
                break;
            case 2:
                cell.textLabel.text = @"是否往返";
                cell.detailTextLabel.text = _driModel.isRound.integerValue?@"是":@"否";
                break;
            case 3:
                cell.textLabel.text = @"往返时间";
                cell.detailTextLabel.text = [logicDone timeIntChangeToStr:_driModel.roundTime];
                break;
            default:
                break;
    }
        return cell;
    
    }else if(indexPath.section==0){
        
        NSString *ID = @"routeInfoCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.textColor = rgb(170, 170, 170);
            cell.textLabel.font = FontSize(15);
            if(indexPath.row==0){
                _carInforLabel = [myLjjTools createLabelWithFrame:CGRectMake(90, 10, SCREEN_WIDTH-100, 30) andTitle:@"" andTitleFont: FontSize(15) andTitleColor:rgb(65, 65, 65) andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
                [cell.contentView addSubview:_carInforLabel];
            }else{
                _driverInforLabel = [myLjjTools createLabelWithFrame:CGRectMake(90, 10, SCREEN_WIDTH-100, 30) andTitle:@"" andTitleFont: FontSize(15) andTitleColor:rgb(65, 65, 65) andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
                [cell.contentView addSubview:_driverInforLabel];
            }
        }
        
        if(indexPath.row==0){
        cell.textLabel.text = @"车辆信息";
            if(_driModel.carLicense){
             _carInforLabel.text = _driModel.carLicense;
            }else{
             _carInforLabel.text = @"暂无";
            }
        }else{
        cell.textLabel.text = @"司机信息";
        _driverInforLabel.text = [NSString stringWithFormat:@"%@  %@",_driModel.driverName,_driModel.driverPhone];;
        }
        return cell;
    
    }else{
    
        NSString *ID = @"routeInfoCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.textColor = rgb(170, 170, 170);
            cell.textLabel.font = FontSize(15);
            cell.detailTextLabel.font = FontSize(15);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        }
        cell.textLabel.text = @"发票";
        cell.detailTextLabel.text = @"去开发票";
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==1){
        return 136;
    }else{
        return 50.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==3){
    billByRouteWhereViewController * where = [[billByRouteWhereViewController alloc]init];
    where.orderStr = _driModel.orderId;
    [self.navigationController pushViewController:where animated:YES];
    }
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
