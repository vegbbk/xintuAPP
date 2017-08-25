//
//  collectDriverViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/29.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "collectDriverViewController.h"
#import "LJJsearchBar.h"
#import "colloctDriverListModel.h"
#import "colloctDriverTableViewCell.h"
#import "driverInfoLJJViewController.h"
#import "searchLJJText.h"
#import "UIScrollView+EmptyDataSet.h"
@interface collectDriverViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,colloctDriverActionDelegate,colloctActionFreshDelegate,searchTextInputLJJDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,strong)searchLJJText * search;
@end

@implementation collectDriverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_typeNum==1){
    self.navigationItem.title = @"收藏司机";
    }else{
    self.navigationItem.title = @"选择司机";
    }
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    [self createTable];
    [self loadData:YES with:@""];
    // Do any additional setup after loading the view.
}

-(void)loadData:(BOOL)firstPage with:(NSString*)nameStr{
    NSLog(@"%@",[GVUserDefaults standardUserDefaults].userId);
    NSString * postUrl ;
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    if(_typeNum==1){
    postUrl = HTTP_URLIP(getUser_CollectList);
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    }else{
    postUrl = HTTP_URLIP(get_DriversList);
    SET_OBJRCT(@"startTime", self.startTime)
    SET_OBJRCT(@"preTime", self.endTime)
    }
    if(nameStr.length>0){
    [parameters setObject:nameStr  forKey:@"driverName"];
    }
    [parameters setObject:intToStr(_pageNum)  forKey:@"pageNumber"];
    [parameters setObject:@"10"  forKey:@"pageSize"];
    [HttpRequest postWithURL:postUrl params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        if(firstPage){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dictt in responseObject[@"data"]){
            colloctDriverListModel *model = [[colloctDriverListModel alloc]init];
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
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
     [_tableView  setSeparatorColor:LINECOLOR];
    self.tableView.backgroundColor = BACKLJJcolor;
    [_tableView registerNib:[UINib nibWithNibName:@"colloctDriverTableViewCell" bundle:nil] forCellReuseIdentifier:@"colloctLJJCell"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self loadData:NO with:@""];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self loadData:YES with:@""];
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return heiSize(53);
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * backView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, heiSize(53)) andBgColor:CLEARCOLOR];
    searchLJJText * search = [[searchLJJText alloc]initWithFrame:CGRectMake(widSize(70), heiSize(11), widSize(236), heiSize(31))];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:3 with:search];
    search.delegate = self;
    search.inputText.delegate = self;
    search.layer.cornerRadius = heiSize(30)/2.0;
    [backView addSubview:search];
    return backView;
}

-(void)searchTextInputLJJClick:(NSString *)searStr{

    [_search.inputText resignFirstResponder];
    _pageNum = 1;
    [self loadData:YES with:searStr];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    colloctDriverTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"colloctLJJCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if (indexPath.row<_dataArr.count) {
    colloctDriverListModel * model = _dataArr[indexPath.row];
    [cell loadDataWith:model];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.typeNum==1){
     if (indexPath.row<_dataArr.count) {
    colloctDriverListModel * model = _dataArr[indexPath.row];
    driverInfoLJJViewController * info = [[driverInfoLJJViewController alloc]init];
    info.driverId = model.driId;
    info.dataModel = model;
    info.delegate = self;
    [self.navigationController pushViewController:info animated:YES];
    }
    }else if(self.typeNum==2){
        [self sureSelectDriverStr:indexPath];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_typeNum==1){
        return NO;
    }else{
    return YES;
    }
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(self.typeNum==1){
            [self deleteColloct:indexPath];
        }else{
            [self sureSelectDriverStr:indexPath];
        }
    }
    
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.typeNum==1){
    return @"删除";
    }else{
    return @"确认";
    }
}
#pragma mark -------------删除收藏------------
-(void)deleteColloct:(NSIndexPath*)indexPath{
     if (indexPath.row<_dataArr.count) {
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:@"" forKey:@"colId"];
    [HttpRequest postWithURL:HTTP_URLIP(remove_UserCollect) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject){
        ToastWithTitle(@"删除成功!");
        colloctDriverListModel * model = _dataArr[indexPath.row];
        [self.dataArr removeObject:model];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    }
}
#pragma mark -----------搜索-------------
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    NSLog(@"横说竖说");
    _pageNum = 1;
    [self loadData:YES with:textField.text];
    return YES;
}
#pragma mark ---------------点击头像----------------
-(void)olloctDriverClick:(NSIndexPath *)indexPath{
     if (indexPath.row<_dataArr.count) {
    colloctDriverListModel * model = _dataArr[indexPath.row];
    driverInfoLJJViewController * info = [[driverInfoLJJViewController alloc]init];
    info.driverId=model.driId;
    info.dataModel = model;
    info.delegate = self;
    [self.navigationController pushViewController:info animated:YES]; 
    }
}

-(void)colloctActionFreshData:(colloctDriverListModel *)model{

    if([_dataArr containsObject:model]){
        [_dataArr removeObject:model];
    }else{
        [_dataArr addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark ---------------确认选择----------------
-(void)sureSelectDriverStr:(NSIndexPath*)indexPath{
 
     if (indexPath.row<_dataArr.count) {
    colloctDriverListModel * model = _dataArr[indexPath.row];
    NSString * nameStr = [NSString stringWithFormat:@"是否选择%@为司机",model.driverName];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:nameStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertOne = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate selectDriverSureName:model.driverName withID:model.driId];
    }];
    UIAlertAction * alertTwo = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
 
    [alert addAction:alertOne];
    [alert addAction:alertTwo];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无收藏的司机哦";
    
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
