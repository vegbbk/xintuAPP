//
//  systemNewsListViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "systemNewsListViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "systemNewNotiModel.h"
@interface systemNewsListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{

    NSArray * arr;

}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;
@end

@implementation systemNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arr = @[@"爱的是打算的撒的啊按所大所大所大所多的撒大大撒多的撒打算打算打算打算的的撒打算大所大所多的撒打算大所大所多撒大所多",@"是打算的撒打算打算打算打算打算打算的撒大大的",@"按时打算法萨芬撒西安市西安市西安市小飒飒小撒打算的撒打算的撒的",@"cesadsadadads"];
    [self createTable];
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    [self loadData:YES];

    // Do any additional setup after loading the view.
}

-(void)loadData:(BOOL)firstPage{
    
    if([GVUserDefaults standardUserDefaults].LOGINSUC){
        
        NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
        
        [parameters setObject:intToStr(_pageNum)  forKey:@"pageNumber"];
        [parameters setObject:@"10"  forKey:@"pageSize"];
        SET_OBJRCT(@"value", [GVUserDefaults standardUserDefaults].userId)
        [parameters setObject:@"2" forKey:@"type"];
        
        [HttpRequest postWithURL:HTTP_URLIP(get_SystemMessage) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
            if(firstPage){
                [_dataArr removeAllObjects];
            }
            for(NSDictionary * dictt in responseObject[@"data"]){
                systemNewNotiModel *model = [[systemNewNotiModel alloc]init];
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

- (void)createTable{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView setSeparatorColor:LINECOLOR];
    self.tableView.backgroundColor = BACKLJJcolor;
    // [self.tableView registerNib:[UINib nibWithNibName:@"" bundle:nil] forCellReuseIdentifier:@""];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self loadData:NO];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        _pageNum=1;
        [self loadData:YES];
    }];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView fd_heightForCellWithIdentifier:@"cell" configuration:^(UITableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(_dataArr.count>indexPath.row){
    [self configureCell:cell atIndexPath:indexPath];
    }
    cell.textLabel.font = FontSize(14);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    cell.textLabel.numberOfLines = 0;
    systemNewNotiModel * model = _dataArr[indexPath.row];
    cell.textLabel.text = model.content;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您还没有系统消息哦";
    
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
