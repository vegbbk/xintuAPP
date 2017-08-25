//
//  billByRouteListViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/5.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "billByRouteListViewController.h"
#import "billByRouteListTableViewCell.h"
#import "billByRouteWhereViewController.h"
#import "billByRouteListModel.h"
#import "UIScrollView+EmptyDataSet.h"
@interface billByRouteListViewController ()<UITableViewDelegate,UITableViewDataSource,billByRouteDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{

    UIButton * _rightDoneButton;
    NSMutableArray * _selectArr;//选中的

}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;

@end

@implementation billByRouteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开发票";
    [self initArr];
    [self createRightBtn];
    [self createTable];
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    [self loadData:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(freshData) name:@"routeApplyLJJ" object:nil];
    // Do any additional setup after loading the view.
}

-(void)freshData{

    _pageNum = 1;
    [_selectArr removeAllObjects];
    [self loadData:YES];
    
}

-(void)initArr{

    _selectArr = [NSMutableArray array];

}

-(void)loadData:(BOOL)firstPage{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:intToStr(_pageNum)  forKey:@"pageNumber"];
    [parameters setObject:@"10"  forKey:@"pageSize"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(get_OrderListByReciept) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        if(firstPage){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dictt in responseObject[@"data"]){
            billByRouteListModel *model = [[billByRouteListModel alloc]init];
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


-(void)createRightBtn{
    
    _rightDoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _rightDoneButton.frame = CGRectMake(0, 0, 40, 20);
    [_rightDoneButton setTitle:@"确定" forState:UIControlStateNormal];
    [_rightDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightDoneButton.titleLabel.font = FontSize(15);
    // [releaseButton setBackgroundColor:MAINThemeColor];
    [_rightDoneButton addTarget:self action:@selector(DoneAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightDoneButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
}

-(void)DoneAction{

    if(_selectArr.count==0){
        ToastWithTitle(@"您没有可开的行程哦");
        return;
    }
    NSString * orderStr = nil;
    for(NSIndexPath * index in _selectArr){
        if(index.section<_dataArr.count){
        billByRouteListModel * model = _dataArr[index.section];
        if(orderStr){
        orderStr = [NSString stringWithFormat:@"%@,%@",orderStr,model.orderId];
        }else{
        orderStr = [NSString stringWithFormat:@"%@",model.orderId];
        }
        }
    }
    billByRouteWhereViewController * where = [[billByRouteWhereViewController alloc]init];
    where.orderStr = orderStr;
    [self.navigationController pushViewController:where animated:YES];

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
    [_tableView registerNib:[UINib nibWithNibName:@"billByRouteListTableViewCell" bundle:nil] forCellReuseIdentifier:@"billByRouteCell"];
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
    
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 9;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    billByRouteListTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"billByRouteCell" forIndexPath:indexPath];
    cell.backgroundColor = BACKLJJcolor;
    if(_dataArr.count>indexPath.row){
    cell.indexPath = indexPath;
    cell.delegate = self;
    billByRouteListModel * model = _dataArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([_selectArr containsObject:indexPath]){
    [cell loadDataFrom:YES withData:model];
    }else{
    [cell loadDataFrom:NO withData:model];
    }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 106;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)billByRouteSelect:(NSIndexPath *)selectNum{

    if([_selectArr containsObject:selectNum]){
    
        [_selectArr removeObject:selectNum];
    
    }else{
    
        [_selectArr addObject:selectNum];
    }
    [self.tableView reloadData];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您没有可开票行程哦";
    
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
