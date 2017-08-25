//
//  dressManageLJJViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "dressManageLJJViewController.h"
#import "commonDressManageTableViewCell.h"
#import "addDressLJJViewController.h"
#import "dressInfoLJJModel.h"
@interface dressManageLJJViewController ()<UITableViewDelegate,UITableViewDataSource,commonDressMangeDelegate,addDressSucDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pageNum;

@end

@implementation dressManageLJJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
    self.navigationItem.title = @"常用地址管理";
    [self createTable];
    [self loadData:NO];
    // Do any additional setup after loading the view.
}

-(void)loadData:(BOOL)firstPage{

    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [parameters setObject:intToStr(_pageNum) forKey:@"pageNumber"];
    [parameters setObject:@"10" forKey:@"pageSize"];
    [HttpRequest postWithURL:HTTP_URLIP(get_AddressList) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        if(firstPage){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dictt in responseObject[@"data"][@"list"]){
            dressInfoLJJModel *model = [[dressInfoLJJModel alloc]init];
            [model setValuesForKeysWithDictionary:dictt];
            [_dataArr addObject:model];
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

-(void)createTable{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-48-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKLJJcolor;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView  setSeparatorColor:LINECOLOR];
    [_tableView registerNib:[UINib nibWithNibName:@"commonDressManageTableViewCell" bundle:nil] forCellReuseIdentifier:@"commonDressLJJID"];
    
    UIButton * button = [myLjjTools createButtonWithFrame:CGRectMake(0, SCREEN_HEIGHT-48-64, SCREEN_WIDTH, 48) andTitle:@"添加新地址" andTitleColor:WHITEColor andBgColor:MAINThemeOrgColor andSelecter:@selector(addNewDressClick) andTarget:self];
    [self.view addSubview:button];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self loadData:NO];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        _pageNum=1;
        [self loadData:YES];
    }];

}


-(void)addNewDressClick{

    addDressLJJViewController * add = [[addDressLJJViewController alloc]init];
    add.typeNum = 1;
    add.delegate = self;
    [self.navigationController pushViewController:add animated:YES];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 6.0;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    commonDressManageTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"commonDressLJJID" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if(indexPath.section<_dataArr.count){
    dressInfoLJJModel * model = _dataArr[indexPath.section];
    [cell loadDataFrom:model];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ----------删除----------
-(void)deleteClick:(NSIndexPath *)indexPath{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要删除该地址吗?"preferredStyle:UIAlertControllerStyleAlert];
    WEAKSELF
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteDress:indexPath];
    }];
    [alert addAction:cancelAction];
  
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:OKAction];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

-(void)deleteDress:(NSIndexPath*)indexPath{
    if(indexPath.section<_dataArr.count){
    dressInfoLJJModel * model = _dataArr[indexPath.section];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:model.dressID forKey:@"addId"];
    [HttpRequest postWithURL:HTTP_URLIP(remove_Address) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        [_dataArr removeObject:model];
        [self.tableView reloadData];
        ToastWithTitle(@"删除成功!");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dressLJJfreshID" object:self userInfo:nil];
    } failure:^(NSError *error) {
        
    }];
    }
}

#pragma mark ------------编辑---------
-(void)editerClick:(NSIndexPath *)indexPath{

    if(indexPath.section<_dataArr.count){
    addDressLJJViewController * add = [[addDressLJJViewController alloc]init];
    add.typeNum = 2;
    dressInfoLJJModel * model = _dataArr[indexPath.section];
    add.dataModel = model;
    add.delegate = self;
    [self.navigationController pushViewController:add animated:YES];
    }
}
#pragma mark ------------设置默认---------

-(void)setDefault:(NSIndexPath *)indexPath{

    if(indexPath.section<_dataArr.count){
    dressInfoLJJModel * model = _dataArr[indexPath.section];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:model.dressID forKey:@"addId"];
    [HttpRequest postWithURL:HTTP_URLIP(set_DefaultAddrss) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        commonDressManageTableViewCell * cell =  [_tableView cellForRowAtIndexPath:indexPath];
        [cell.defaultBtn setImage:[UIImage imageNamed:@"首页_常用地址_默认"] forState:UIControlStateNormal];
        _pageNum = 1;
        [self loadData:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dressLJJfreshID" object:self userInfo:nil];
    } failure:^(NSError *error) {
        
    }];
    }
}
#pragma mark ------------地址编辑处理刷新---------
-(void)addDressSucFreshData{
    _pageNum = 1;
    [self loadData:YES];
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
