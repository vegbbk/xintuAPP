//
//  consumeHistoryViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "consumeHistoryViewController.h"
#import "consumeHIstoryLJJTableViewCell.h"
#import "calendarSelectView.h"
#import "routeInfoViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface consumeHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,FreeDataSelectDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{

    UILabel * _timeLabel;
    calendarSelectView *darSelectView;
    NSString * searchStr;
    NSString * timeStr;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;

@end

@implementation consumeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消费记录";
    [self createTable];
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    NSArray *array = [self getSystemTime];
    NSString * yearStr = array[0];
    NSString * monthStr = [NSString stringWithFormat:@"%.2d",[array[1] intValue]];
    searchStr = [NSString stringWithFormat:@"%@-%@",yearStr,monthStr];
    timeStr = [NSString stringWithFormat:@"%@年%@月",yearStr,monthStr];
    [self loadData:YES];
    // Do any additional setup after loading the view.
}

-(void)loadData:(BOOL)firstPage{
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:intToStr(_pageNum)  forKey:@"pageNumber"];
    [parameters setObject:@"10"  forKey:@"pageSize"];
    if (searchStr.length>0) {
        [parameters setObject:searchStr  forKey:@"queryTime"];
    }
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(Pay_mentList) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        if(firstPage){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dictt in responseObject[@"data"]){
            consumeListModel *model = [[consumeListModel alloc]init];
            [model setValuesForKeysWithDictionary:dictt];
            [_dataArr addObject:model];
        }
        [self.tableView reloadData];
        if([responseObject[@"data"] count]==0){
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

-(void)createTable{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    _tableView.backgroundColor = BACKLJJcolor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"consumeHIstoryLJJTableViewCell" bundle:nil] forCellReuseIdentifier:@"consumeHistoryLJJIDcell"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self loadData:NO];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self loadData:YES];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count+1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section==0){
        return 34;
    }else{
        return 0.1;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section==0){
        
        UIView * backView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34) andBgColor:CLEARCOLOR];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH-35, 7, 20, 20);
        [button setImage:[UIImage imageNamed:@"我的_消费记录_日历"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(whatUseClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
       
        _timeLabel = [myLjjTools createLabelWithFrame:CGRectMake(15, 7, SCREEN_WIDTH-60, 20) andTitle:@"2017年5月" andTitleFont:FontSize(17) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
        [backView addSubview:_timeLabel];
        if(timeStr){
            _timeLabel.text = timeStr;
        }
        return backView;
        
    }else{
        return nil;
    }
    
}
// 获取系统时间
-(NSArray*)getSystemTime{
    
    NSDate *date = [NSDate date];
    NSTimeInterval  sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:sec];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *na = [df stringFromDate:currentDate];
    return [na componentsSeparatedByString:@"-"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    consumeHIstoryLJJTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"consumeHistoryLJJIDcell" forIndexPath:indexPath];
    if (indexPath.section!=0) {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section-1<_dataArr.count){
    consumeListModel * model = _dataArr[indexPath.section-1];
    [cell loadDataFrom:model];
    }
    }else{
        cell.hidden = YES;
    }
    return cell;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return 0;
    }else{
    return 103;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    routeInfoViewController * route = [[routeInfoViewController alloc]init];
//    route.routeModel = model;
//    route.isBackTop = YES;
//    route.indexSelectNum = model.status;
//    route.selectIndex = model.orderPayStatus;
//    [self.navigationController pushViewController:route animated:YES];

}
#pragma mark ----------消费日历--------------------
-(void)whatUseClick{
    
    if(!darSelectView){
    darSelectView = [[calendarSelectView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 160)];
        darSelectView.delegate = self;
    [self.view addSubview:darSelectView];
    [UIView animateWithDuration:0.5 animations:^{
        darSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-160, SCREEN_WIDTH, 160);
    }];
    }
}

-(void)FreeCancelViewData{

    darSelectView = nil;

}

-(void)FreeDataSelectClick:(NSString *)yearStr with:(NSString *)monthStr{

    NSString * str = [NSString stringWithFormat:@"%@-%@",yearStr,monthStr];
    NSString * str1 = [NSString stringWithFormat:@"%@年%@月",yearStr,monthStr];
    darSelectView = nil;
    _pageNum=1;
    searchStr = str;
    timeStr = str1;
    [self loadData:YES];
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您还没有消费记录哦";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                                 NSForegroundColorAttributeName: RGB170};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
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
