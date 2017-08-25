//
//  discountCouponListViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "discountCouponListViewController.h"
#import "discountCouponLJJTableViewCell.h"
#import "discountCounponInfoViewController.h"
#import "discountCouponListModel.h"
#import "UIScrollView+EmptyDataSet.h"
@interface discountCouponListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;
@end

@implementation discountCouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券";
    [self createTable];
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    [self loadData:YES];

    // Do any additional setup after loading the view.discountCouponLJJID
}

-(void)loadData:(BOOL)firstPage{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:intToStr(_pageNum)  forKey:@"pageNumber"];
    [parameters setObject:@"10"  forKey:@"pageSize"];
    SET_OBJRCT(@"assignment", [GVUserDefaults standardUserDefaults].loginType)
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(get_VoucherHistory) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        if(firstPage){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dictt in responseObject[@"data"]){
            discountCouponListModel *model = [[discountCouponListModel alloc]init];
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
    [_tableView registerNib:[UINib nibWithNibName:@"discountCouponLJJTableViewCell" bundle:nil] forCellReuseIdentifier:@"discountCouponLJJID"];
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
    
    if(section==0){
        return 38;
    }else{
        return 0.1;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if(section==0){
        UIView * backView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38) andBgColor:WHITEColor];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH-110, 9, 90, 19);
        [button setTitle:@"如何使用" forState:UIControlStateNormal];
        button.titleLabel.font = FontSize(15);
        [button setTitleColor:RGB170 forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"我的_使用规则"] forState:UIControlStateNormal];
        button.imageRect = CGRectMake(0, 2, 15, 15);
        button.titleRect = CGRectMake(20, 2, 70, 15);
        [button addTarget:self action:@selector(whatUseClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        return backView;
    }else{
        return nil;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == _dataArr.count-1){
        return 30;
    }else{
        return 10;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

     if(section == _dataArr.count-1){
    UILabel * label = [myLjjTools createLabelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) andTitle:@"活动由航美提供,与设备生产商Apple Inc.公司无关" andTitleFont:FontSize(13) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    label.numberOfLines = 0;
    return label;
     }else{
         return nil;
     }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    discountCouponLJJTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"discountCouponLJJID" forIndexPath:indexPath];
    if(_dataArr.count>indexPath.section){
    discountCouponListModel * model = _dataArr[indexPath.section];
    [cell loadDataFrom:model];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 93;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_dataArr.count>indexPath.section){
    discountCouponListModel * model = _dataArr[indexPath.section];
    discountCounponInfoViewController * disc = [[discountCounponInfoViewController alloc]init];
    disc.model = model;
    [self.navigationController pushViewController:disc animated:YES];
    }
}
#pragma mark ----------如何使用--------------------
-(void)whatUseClick{


}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您还没有优惠券哦";
    
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
