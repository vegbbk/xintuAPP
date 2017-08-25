//
//  myCompanyViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/5.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "myCompanyViewController.h"
#import "myCompanyTableViewCell.h"
#import "LJJAlertPromView.h"
#import "phoneBookInviteViewController.h"
#import "companyPeopleModel.h"
#import "companyListModel.h"
@implementation GroupDataModel

@synthesize groupTitle;
@synthesize groupData;

@end

@interface myCompanyViewController ()<LJJAlertPromViewDelegate,phoneBookInviteDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *selectedArr;//控制列表是否被打开
    UIButton * inviteBtn;
    NSString * sectionSelectPhone;
}
@property(nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation myCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公司";
    _dataArr = [NSMutableArray array];
    GroupDataModel *model0 = [[GroupDataModel alloc] init];
    model0.groupTitle = @"重庆朔悦科技";
    model0.groupData = @[@"西安", @"宝鸡", @"咸阳", @"延安"];
    _arrayData =[NSMutableArray arrayWithArray:@[model0]];
    [self createUI];
    [self createPeople];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadData{

    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(get_CompanyUsers) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        
        if(_dataArr.count>0){
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dict in responseObject[@"data"]){
            companyListModel * model = [[companyListModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            NSMutableArray * peopleArr = [NSMutableArray new];
            for(NSDictionary * dic in model.employees){
                companyPeopleModel * model = [[companyPeopleModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [peopleArr addObject:model];
            }
            model.employees = peopleArr;
            [_dataArr addObject:model];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark -------------邀请员工------------

-(void)createPeople{

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame = CGRectMake(0, 0, 70, 30);
    [rightButton setTitle:@"邀请员工" forState:normal];
    rightButton.titleLabel.font = FontSize(15);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(invitClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

}

-(void)invitClick{

    inviteBtn.hidden = YES;
    LJJAlertPromView * ljjView = [[LJJAlertPromView alloc]initWithFrame:self.view.frame with:3];
    ljjView.delegate = self;
    [ljjView show];
   
}

-(void)selectSubmitPeople:(NSString *)nameStr with:(NSString *)phoneStr{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].companyId forKey:@"companyId"];
    [parameters setObject:sectionSelectPhone forKey:@"departId"];
    [parameters setObject:phoneStr forKey:@"userPhone"];
    [HttpRequest postWithURL:HTTP_URLIP(setUser_Department) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        ToastWithTitle(@"邀请成功!");
        [self loadData];
    } failure:^(NSError *error) {
        
    }];

}

-(void)selectSubmitGoOnPeople:(NSString *)nameStr with:(NSString *)phoneStr{



}

-(void)selectSubmitPeopleModel:(sectionListModel *)mdoel{
 
    if(mdoel){
    sectionSelectPhone = mdoel.departID;
    }else{
    sectionSelectPhone = @"";
    }
    LJJAlertPromView * ljjView = [[LJJAlertPromView alloc]initWithFrame:self.view.frame with:1];
    ljjView.delegate = self;
    [ljjView show];

  
}

-(void)selectPhoneBook{

    phoneBookInviteViewController * phone = [[phoneBookInviteViewController alloc]init];
    phone.delegate = self;
    [self.navigationController pushViewController:phone animated:YES];

}
#pragma mark -------------通讯录邀请--------------------
-(void)phoneBookInviteAction:(NSMutableArray *)bookArr{

    NSString * phoneStr = @"";
    if(bookArr.count==0){
        ToastWithTitle(@"没有邀请人无法提交");
        return;
    }
    for(PersonModel * model in bookArr){
        phoneStr = [NSString stringWithFormat:@"%@,%@",phoneStr,model.tel];
    }
    phoneStr = [phoneStr substringFromIndex:1];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].companyId forKey:@"companyId"];
    SET_OBJRCT(@"departId", sectionSelectPhone);
    [parameters setObject:phoneStr forKey:@"userPhones"];
    NSLog(@"-------------%@----------",parameters);
    [HttpRequest postWithURL:HTTP_URLIP(set_UserDepartmentBatch) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject){
        [self loadData];
    } failure:^(NSError *error){
        
    }];

}
#pragma mark -------------公司员工列表------------------------

-(void)createUI{

    self.view.frame = [UIScreen mainScreen].bounds;
    
    // style必须是UITableViewStylePlain
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [_tableView  setSeparatorColor:LINECOLOR];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = [[UIView alloc] init];
    _tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"myCompanyTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCompanyCell"];
    
    selectedArr = [[NSMutableArray alloc] init];
    
    inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inviteBtn.frame = CGRectMake(widSize(130), heiSize(276), widSize(115), widSize(115));
    [inviteBtn setBackgroundImage:[UIImage imageNamed:@"我的_邀请员工"] forState:UIControlStateNormal];
    [inviteBtn setTitle:@"邀请员工" forState:UIControlStateNormal];
    inviteBtn.hidden = YES;
    [inviteBtn addTarget:self action:@selector(invitClick) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:inviteBtn];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    companyListModel*model = [_dataArr objectAtIndex:section];
    if(_dataArr.count==1&&section==0&&model.employees.count==0){
    return 54.0;
    }else{
    return 0.0;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    companyListModel*model = [_dataArr objectAtIndex:section];
    if(_dataArr.count==1&&section==0&&model.employees.count==0){
        UILabel * view = [myLjjTools createLabelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54.0) andTitle:@"  暂无任何员工" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:WHITEColor];
        inviteBtn.hidden = NO;
        return view;
    }else{
        return nil;
    }


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld", section];
    
    BOOL isFolder = [selectedArr containsObject:indexStr];
    NSInteger number = 0;
    if (!isFolder) {
        return 0;
    }else{
        companyListModel * model = [_dataArr objectAtIndex:section];
        return model.employees.count;
    }
    
    return number;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    myCompanyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myCompanyCell" forIndexPath:indexPath];
  
    //只需要给当前分组展开的section 添加用户信息即可
    if ([selectedArr containsObject:[NSString stringWithFormat:@"%ld", indexPath.section]]){
        if(indexPath.section<_dataArr.count){
        companyListModel *model = [_dataArr objectAtIndex:indexPath.section];
            if(model.employees.count>indexPath.row){
             companyPeopleModel * model1 = [model.employees objectAtIndex:indexPath.row];
             [cell loadDataFrom:model1];
            }
        }
    }
    
    return cell;
}

#pragma mark -- Table view delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = WHITEColor;
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 10, 11)];
    NSString *string = [NSString stringWithFormat:@"%ld",section];
    if ([selectedArr containsObject:string]) {
        imageView.frame = CGRectMake(15, 20, 10, 11);
        imageView.image=[UIImage imageNamed:@"我的_分组下拉"];
    }else{
        
        imageView.frame = CGRectMake(15, 20, 11, 10);
        imageView.image=[UIImage imageNamed:@"我的_分组"];
        
    }
    [view addSubview:imageView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+8, 0, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-10-80, 50)];
    
    companyListModel *model = [_dataArr objectAtIndex:section];
    titleLabel.text = model.departName;
    
    [view addSubview:titleLabel];
    
    UILabel *buttomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5f, SCREEN_WIDTH, 0.5)];
    buttomLine.backgroundColor = LINECOLOR;
    
    [view addSubview:buttomLine];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH-80, 50);
    button.tag = section;
    [button addTarget:self action:@selector(openSectioin:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:button];
    
    UIButton *creabutton = [UIButton buttonWithType:UIButtonTypeCustom];
    creabutton.frame = CGRectMake(SCREEN_WIDTH-80, 15, 70, 20);
    creabutton.titleLabel.font = FontSize(15);
    [creabutton setTitle:@"创建部门" forState:UIControlStateNormal];
    [creabutton setTitleColor:MAINThemeColor forState:UIControlStateNormal];
   // creabutton.titleLabel.textColor = MAINThemeColor;
    if(section==0){
        creabutton.hidden = NO;
    }else{
        creabutton.hidden = YES;
    }
    [creabutton addTarget:self action:@selector(createSectionClick) forControlEvents:UIControlEventTouchDown];
    [view addSubview:creabutton];

    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 54.0f;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterSection:(NSInteger)section {
    
    return 0.0f;
}

-(void)openSectioin:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%ld", sender.tag];
    
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([selectedArr containsObject:string])
    {
        [selectedArr removeObject:string];
    }
    else
    {
        [selectedArr addObject:string];
    }
    
    [_tableView reloadData];
}

- (void)setArrayData:(NSMutableArray *)arrayData {
    
    _arrayData = arrayData;
    [_tableView reloadData];
}
#pragma mark -----------创建部门-------------------
-(void)createSectionClick{

    LJJAlertPromView * ljjView = [[LJJAlertPromView alloc]initWithFrame:self.view.frame with:2];
    ljjView.delegate = self;
    [ljjView show];
}

-(void)LJJAlertPromViewClick:(NSString *)sectionNameStr{

    GroupDataModel *model3 = [[GroupDataModel alloc] init];
    model3.groupTitle = sectionNameStr;
    model3.groupData = @[@"乌鲁木齐", @"阿克苏", @"阿勒泰", @"博乐"];
    [_arrayData addObject:model3];
    [_tableView reloadData];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].companyId forKey:@"companyId"];
    [parameters setObject:sectionNameStr forKey:@"departName"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(save_Department) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        ToastWithTitle(responseObject[@"msg"]);
        [self loadData];
    } failure:^(NSError *error) {
        
    }];

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
