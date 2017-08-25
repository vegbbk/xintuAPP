//
//  myRouteViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "myRouteViewController.h"
#import "routeLJJTableViewCell.h"
#import "routeInfoViewController.h"
#import "touSuMessageViewController.h"
#import "routeListLJJModel.h"
#import "payMoneyOrderViewController.h"
#import "priceDiffLJJViewController.h"
#import "routingLJJViewController.h"
#import "driverAndStudentMapViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "studentListOrderViewController.h"
#import "driveNameAndUrlModel.h"
#import "chatIMInfoViewController.h"
@interface myRouteViewController ()<UITableViewDelegate,UITableViewDataSource,cancelRouteDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;
@end

@implementation myRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabel];
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    if([GVUserDefaults standardUserDefaults].LOGINSUC){
    [self loadData:YES];
    }else{
    [logicDone presentLoginView];
    }
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucFreshDataAction) name:loginSucFreshData object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginExitFreshDataAction) name:exitSucFreshData object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshData) name:@"routeLIstFreshLJJ" object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     if([GVUserDefaults standardUserDefaults].LOGINSUC){
     _pageNum = 1;
    [self loadData:YES];
    }
}

-(void)loginSucFreshDataAction{
    _pageNum = 1;
    [self loadData:YES];
}

-(void)freshData{

    _pageNum = 1;
    [self loadData:YES];
    
}

-(void)loginExitFreshDataAction{
    if(_dataArr.count>0){
        [_dataArr removeAllObjects];
    }
    [self.tableView reloadData];
}
-(void)loadData:(BOOL)firstPage{

    if([GVUserDefaults standardUserDefaults].LOGINSUC){
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:intToStr(_pageNum)  forKey:@"pageNumber"];
    [parameters setObject:@"10"  forKey:@"pageSize"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(get_UserStrokeList) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        if(firstPage){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dictt in responseObject[@"data"][@"list"]){
            routeListLJJModel *model = [[routeListLJJModel alloc]init];
            [model setValuesForKeysWithDictionary:dictt];
            [_dataArr addObject:model];
        }
        if(responseObject[@"data"][@"totalmileage"][@"total"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"routeTotalMessage" object:self userInfo:@{@"totalMileage":responseObject[@"data"][@"totalmileage"][@"total"]}];
        }else{
         [[NSNotificationCenter defaultCenter] postNotificationName:@"routeTotalMessage" object:self userInfo:@{@"totalMileage":@"0"}];
        }
        [self.tableView reloadData];
        if([responseObject[@"data"][@"list"] count]==0){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
        
    }
}

#pragma mark ----------------------------tableView----------------------------------
-(void)createTabel{
    CGFloat hei=0;
    if(self.isHead){
        hei=44;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-38-hei) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    _tableView.backgroundColor = BACKLJJcolor;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    //_tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"routeLJJTableViewCell" bundle:nil] forCellReuseIdentifier:@"routeLJJcell"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self loadData:NO];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        _pageNum=1;
        [self loadData:YES];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    routeLJJTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"routeLJJcell" forIndexPath:indexPath];
    cell.backgroundColor = CLEARCOLOR;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if(indexPath.row<_dataArr.count){
    routeListLJJModel * model = _dataArr[indexPath.row];
    [cell loadDataFrom:model.status.integerValue withData:model];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 146;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row<_dataArr.count){
    routeListLJJModel * model = _dataArr[indexPath.row];
   
    if(model.strokeType.integerValue==5){
    studentListOrderViewController * order = [studentListOrderViewController new];
    order.strokeId = model.strokeId;
    [self.navigationController pushViewController:order animated:YES];
    }else{
    if(model.status.integerValue==2){
    routingLJJViewController * tout = [[routingLJJViewController alloc]init];
    tout.strokeSn = model.strokeSn;
    tout.dataModel = model;
    [self.navigationController pushViewController:tout animated:YES];
    }else{
    routeInfoViewController * route = [[routeInfoViewController alloc]init];
    route.routeModel = model;
    route.isBackTop = YES;
    route.indexSelectNum = model.status;
    route.selectIndex = model.orderPayStatus;
    [self.navigationController pushViewController:route animated:YES];
    }
    }
    }
}


#pragma mark -------------取消行程-------------

-(void)cancelRouteClick:(NSIndexPath *)indexPath{
     if(indexPath.row<_dataArr.count){
    routeListLJJModel * model = _dataArr[indexPath.row];
    payMoneyOrderViewController * pay = [[payMoneyOrderViewController alloc]init];
    priceDiffLJJViewController *vc = [[priceDiffLJJViewController alloc] init];
    if(model.orderPayStatus.integerValue==0){
        pay.typeCate = 1;
        pay.orderSn = model.orderSn;
        pay.moneyStr = model.orderPrePay;
        [self.navigationController pushViewController:pay animated:YES];
    }else if(model.orderPayStatus.integerValue==1&&model.status.integerValue==3){
        vc.orderSn = model.orderSn;
        [self.navigationController pushViewController:vc animated:YES];
    }
         
    }
}
#pragma mark -------------聊天-------------
-(void)chatWithDriverClick:(NSIndexPath *)indexPath{

    if(indexPath.row<_dataArr.count){
        routeListLJJModel * model = _dataArr[indexPath.row];
        [GVUserDefaults standardUserDefaults].DriverHXAccount = model.driverName;
        if(!IsStrEmpty(model.driverHeadImg)){
            [GVUserDefaults standardUserDefaults].DriverHXHeadImg = model.driverHeadImg;
        }else{
            [GVUserDefaults standardUserDefaults].DriverHXHeadImg = @"";
            model.driverHeadImg = @"";
        }
        driveNameAndUrlModel * model1 = [[driveNameAndUrlModel alloc]init];
        model1.driverHXID = model.driverHXAccount;
        model1.driverHeadImg = model.driverHeadImg;
        model1.driverName = model.driverName;
        if(![[SqliteTools sharedSqliteTools]isExistAppWithName:model1.driverHXID]){
            [[SqliteTools sharedSqliteTools]insertAppModel:model1];
        }else{
            [[SqliteTools sharedSqliteTools]updateData:model1];
        }
        chatIMInfoViewController * info = [[chatIMInfoViewController alloc]initWithConversationChatter:model.driverHXAccount conversationType:EMConversationTypeChat];
        info.title = model.driverName;
        [self.navigationController pushViewController:info animated:YES];
    }
}
#pragma mark -------------打电话-------------
-(void)takePhoneWithDriver:(NSIndexPath *)indexPath{

    if(indexPath.row<_dataArr.count){
        routeListLJJModel * model = _dataArr[indexPath.row];
        if(model.driverPhone){
            [myLjjTools directPhoneCallWithPhoneNum:model.driverPhone];
        }else{
            ToastWithTitle(@"没有获取到司机电话哦");
        }
    }

}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无行程哦";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                                 NSForegroundColorAttributeName: RGB170};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
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
