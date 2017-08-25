//
//  chargeRecordListViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "chargeRecordListViewController.h"
#import "chargeRecordLJJTableViewCell.h"
#import "chargeHistoryModel.h"
#import "UIScrollView+EmptyDataSet.h"
@interface chargeRecordListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;
@end

@implementation chargeRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值记录";
    [self createTabel];
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    [self loadData:YES];
    // Do any additional setup after loading the view. chargeRecordID
}

-(void)loadData:(BOOL)firstPage{
   
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:intToStr(_pageNum)  forKey:@"pageNumber"];
    [parameters setObject:@"10"  forKey:@"pageSize"];
    SET_OBJRCT(@"assignment", [GVUserDefaults standardUserDefaults].loginType)
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(charging_History) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        if(firstPage){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dictt in responseObject[@"data"]){
            chargeHistoryModel *model = [[chargeHistoryModel alloc]init];
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

#pragma mark ----------------------------tableView----------------------------------
-(void)createTabel{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    _tableView.backgroundColor = BACKLJJcolor;
    [_tableView setSeparatorColor:LINECOLOR];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"chargeRecordLJJTableViewCell" bundle:nil] forCellReuseIdentifier:@"chargeRecordID"];
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
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    chargeRecordLJJTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"chargeRecordID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_dataArr.count>indexPath.row){
    chargeHistoryModel * model = _dataArr[indexPath.row];
    [cell loadDataFrom:model];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您还没有充值记录哦";
    
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
