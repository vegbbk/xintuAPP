//
//  activityListViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/14.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "activityListViewController.h"
#import "activityLJJTableViewCell.h"
#import "activityListModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ljjUrlWebViewController.h"
@interface activityListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;

@end

@implementation activityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabel];
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    [self loadData:YES];
    // Do any additional setup after loading the view. activityCellID
}

-(void)loadData:(BOOL)firstPage{
    
    if([GVUserDefaults standardUserDefaults].LOGINSUC){
        
        NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
        [parameters setObject:intToStr(_pageNum)  forKey:@"pageNumber"];
        [parameters setObject:@"10"  forKey:@"pageSize"];
        [HttpRequest postWithURL:HTTP_URLIP(get_ActiveList) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
            if(firstPage){
                [_dataArr removeAllObjects];
            }
            for(NSDictionary * dictt in responseObject[@"data"]){
                activityListModel *model = [[activityListModel alloc]init];
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
}

#pragma mark ----------------------------tableView----------------------------------
-(void)createTabel{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    _tableView.backgroundColor = BACKLJJcolor;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"activityLJJTableViewCell" bundle:nil] forCellReuseIdentifier:@"activityCellID"];
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
    
    return _dataArr.count;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    activityLJJTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"activityCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = CLEARCOLOR;
    if(self.dataArr.count>indexPath.section){
    activityListModel * model = _dataArr[indexPath.section];
    [cell loadDataFrom:model];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 240;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.dataArr.count>indexPath.section){
        activityListModel * model = _dataArr[indexPath.section];
        ljjUrlWebViewController * url = [[ljjUrlWebViewController alloc]init];
        url.title = @"活动";
        url.url =model.activeUrl;
        [self.navigationController pushViewController:url animated:YES];

    }
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无活动哦";
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
