//
//  billRecordViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "billRecordViewController.h"
#import "billRecordTableViewCell.h"
#import "billRecordListModel.h"
#import "UIScrollView+EmptyDataSet.h"
@interface billRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;
@end

@implementation billRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开票记录";
    [self createTable];
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    [self loadData:YES];
    // Do any additional setup after loading the view.
}

-(void)loadData:(BOOL)firstPage{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:intToStr(_pageNum)  forKey:@"pageNumber"];
    [parameters setObject:@"10"  forKey:@"pageSize"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(get_ReceiptHistory) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        if(firstPage){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dictt in responseObject[@"data"]){
            billRecordListModel *model = [[billRecordListModel alloc]init];
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
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView  setSeparatorColor:LINECOLOR];
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
    
    return _dataArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 15;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{


    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"billRecordCell";
    billRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[billRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    if(indexPath.section<_dataArr.count){
    billRecordListModel * model = _dataArr[indexPath.section];
    cell.backgroundColor = BACKLJJcolor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.moneyStr = unKnowToStr(model.amount);
    cell.orderNumStr = unKnowToStr(model.orderIds);
    if(!model.city){
    model.city = @"暂无";
    }
    cell.cityStr = model.city;
    if(!model.title){
        model.title = @"暂无";
    }
    cell.companyStr = model.title;
    if(!model.recipients){
        model.recipients = @"暂无";
    }
    cell.receiveStr = model.recipients;
    if(!model.phonenumber){
        model.phonenumber = @"暂无";
    }
    cell.phoneStr = model.phonenumber;
    if(!model.address){
        model.address = @"暂无";
    }
    cell.dressStr = model.address;
    if(!model.insertTime){
        model.insertTime = @"暂无";
    }
    cell.makeTimeBill = model.insertTime;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 363;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您没有开票记录哦";
    
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
