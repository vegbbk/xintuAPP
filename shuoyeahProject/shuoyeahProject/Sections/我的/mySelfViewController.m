//
//  mySelfViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/28.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "mySelfViewController.h"
#import "MineCell.h"
#import "loginViewController.h"
#import "myUpDataViewController.h"
#import "companyAuthViewController.h"
#import "collectDriverViewController.h"
#import "myWalletViewController.h"
#import "mySetViewController.h"
#import "FYLPageViewController.h"
#import "myCompanyViewController.h"

@interface mySelfViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSArray *picArr;
    NSArray *imgArr;
    UIImageView * avtarImg;//头像
    UIButton * loginButton;//登录按钮
    UILabel * userNameLabel;//用户名
    NSString * namePhoneStr;
    companyAuthModel*_companyModel;
}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation mySelfViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = WHITEColor;
    picArr = @[@"企业认证",@"收藏司机",@"我的钱包",@"我的行程",@"我的客服",@"设置"];
    imgArr = @[@"我的订单",@"关注",@"余额-(2)",@"预约",@"评论-(1)",@"设置-(1)"];
    [self setHeadTitle];
    [self createTabel];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucFreshDataAction) name:loginSucFreshData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitSucFreshDataAction) name:exitSucFreshData object:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if([GVUserDefaults standardUserDefaults].LOGINSUC){
    [self loadData];
    }
    if([GVUserDefaults standardUserDefaults].userHeadImg){
     [avtarImg sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP([GVUserDefaults standardUserDefaults].userHeadImg)] placeholderImage:[UIImage imageNamed:@"user"]];
    }else{
      avtarImg.image = [UIImage imageNamed:@"user"];
    }
    
    if([GVUserDefaults standardUserDefaults].userName){
        userNameLabel.text = [GVUserDefaults standardUserDefaults].userName;
    }
}

-(void)loadData{
    
    if([GVUserDefaults standardUserDefaults].LOGINSUC){
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(get_EnterpriseDetail) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
         _companyModel = [[companyAuthModel alloc]init];
        [_companyModel setValuesForKeysWithDictionary:responseObject[@"data"][@"company"]];
        [GVUserDefaults standardUserDefaults].isAdmin = responseObject[@"data"][@"certificate"][@"isAdmin"];
        [GVUserDefaults standardUserDefaults].companyId = responseObject[@"data"][@"certificate"][@"companyId"];
        [GVUserDefaults standardUserDefaults].companyName = responseObject[@"data"][@"certificate"][@"companyName"];
        [self loginSucFreshDataAction];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
         [self.tableView.mj_header endRefreshing];
    }];
    }
    
}
#pragma mark -----------登陆成功刷新数据---------------
-(void)loginSucFreshDataAction{

    if([GVUserDefaults standardUserDefaults].userName){
        namePhoneStr = [NSString stringWithFormat:@"%@",[GVUserDefaults standardUserDefaults].userName];
    }else{
        namePhoneStr = [NSString stringWithFormat:@"%@",[GVUserDefaults standardUserDefaults].userPhone];
    }
    userNameLabel.text = namePhoneStr;
    loginButton.hidden = YES;
    userNameLabel.hidden = NO;
   // avtarImg.image = [UIImage imageNamed:@"user"];
    if([GVUserDefaults standardUserDefaults].isAdmin.integerValue==1&&[GVUserDefaults standardUserDefaults].loginType.integerValue==1){
    picArr = @[@"企业认证",@"收藏司机",@"我的钱包",[GVUserDefaults standardUserDefaults].companyName,@"我的行程",@"我的客服",@"设置"];
    imgArr = @[@"我的订单",@"关注",@"余额-(2)",@"公司",@"预约",@"评论-(1)",@"设置-(1)"];
    }else{
    picArr = @[@"企业认证",@"收藏司机",@"我的钱包",@"我的行程",@"我的客服",@"设置"];
    imgArr = @[@"我的订单",@"关注",@"余额-(2)",@"预约",@"评论-(1)",@"设置-(1)"];
    }
    [self.tableView reloadData];

}

-(void)exitSucFreshDataAction{
    loginButton.hidden = NO;
    userNameLabel.hidden = YES;
    avtarImg.image = nil;
    picArr = @[@"企业认证",@"收藏司机",@"我的钱包",@"我的行程",@"我的客服",@"设置"];
    imgArr = @[@"我的订单",@"关注",@"余额-(2)",@"预约",@"评论-(1)",@"设置-(1)"];
    [self.tableView reloadData];
}

-(void)setHeadTitle{
    UILabel * label = [[UILabel alloc]init];
    label.text = @"个人中心";
    label.textColor = WHITEColor;
    label.font = [UIFont boldSystemFontOfSize:19];
    label.frame = CGRectMake(0, 0, 100, 30);
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

-(void)initData{
  // namePhoneStr = @"13594369472\n怡月流云";
    if([GVUserDefaults standardUserDefaults].LOGINSUC){
        [self loginSucFreshDataAction];
    }else{
        [self exitSucFreshDataAction];
    }
}
#pragma mark ----------------------------tableView----------------------------------
-(void)createTabel{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return picArr.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        
        NSString *ID = @"myDataViewController1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            avtarImg=[[UIImageView alloc] init];
            avtarImg.frame=CGRectMake((SCREEN_WIDTH-widSize(75))/2.0, heiSize(21), heiSize(72), heiSize(72));
            avtarImg.layer.masksToBounds=YES;
            avtarImg.layer.cornerRadius=heiSize(72)/2.0;
            avtarImg.layer.borderColor = rgb(194, 194, 194).CGColor;
            avtarImg.layer.borderWidth = 1;
            avtarImg.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upDataClick)];
            [avtarImg addGestureRecognizer:tap];
            [cell addSubview:avtarImg];
            [avtarImg sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP([GVUserDefaults standardUserDefaults].userHeadImg)] placeholderImage:[UIImage imageNamed:@"user"]];
            
            userNameLabel=[[UILabel alloc]init];
            [userNameLabel setBackgroundColor:[UIColor clearColor]];
            [userNameLabel setTextColor:textMainColor];
            [userNameLabel setFont:[UIFont systemFontOfSize:fontSizeLJJ]];
            userNameLabel.textAlignment=NSTextAlignmentCenter;
            if(![GVUserDefaults standardUserDefaults].LOGINSUC){
            userNameLabel.hidden = YES;
            }
            userNameLabel.text = namePhoneStr;
            userNameLabel.numberOfLines = 0;
            userNameLabel.frame = CGRectMake(40, CGRectGetMaxY(avtarImg.frame)+heiSize(12) ,SCREEN_WIDTH-80, 36);
            [cell addSubview:userNameLabel];
            
            loginButton = [myLjjTools createButtonWithFrame:CGRectMake((SCREEN_WIDTH-widSize(101))/2.0,CGRectGetMaxY(avtarImg.frame)+heiSize(15), widSize(101), heiSize(38)) andTitle:@"登录" andTitleColor:MAINThemeColor andBgColor:WHITEColor andSelecter:@selector(loginClick) andTarget:self];
            loginButton.layer.cornerRadius = 4.0;
            loginButton.layer.borderColor = MAINThemeColor.CGColor;
            loginButton.layer.borderWidth = 1.0;
            if([GVUserDefaults standardUserDefaults].LOGINSUC){
                loginButton.hidden = YES;
            }
            loginButton.clipsToBounds = YES;
            [cell addSubview:loginButton];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = rgb(249, 249, 249);
        return cell;
        
    }else{
        
        NSString *ID = @"myDataViewController";
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
            cell.detailTextLabel.textColor=[UIColor lightGrayColor];
            //cell.detailTextLabel.numberOfLines=2;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.imageName = imgArr[indexPath.row-1];
        cell.titleStr = picArr[indexPath.row-1];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        
        return heiSize(160.0);
        
    }else{
        
        return heiSize(60.0);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 if([GVUserDefaults standardUserDefaults].LOGINSUC){
    if(indexPath.row==0){//修改个人资料
    
        
    }else if(indexPath.row==1){//企业认证
        
        companyAuthViewController * company = [[companyAuthViewController alloc]init];
        company.model = _companyModel;
        [self.navigationController pushViewController:company animated:YES];

    }else if(indexPath.row==2){//司机收藏
    
        collectDriverViewController * collect = [[collectDriverViewController alloc]init];
        collect.typeNum = 1;
        [self.navigationController pushViewController:collect animated:YES];
    
    }else if(indexPath.row==3){//我的钱包
    
        myWalletViewController * wallet = [[myWalletViewController alloc]init];
        [self.navigationController pushViewController:wallet animated:YES];
        
    }else if(indexPath.row==6){//设置
    
        if(picArr.count==7){//我的客服
         [myLjjTools directPhoneCallWithPhoneNum:@"023-67757777"];
        }else{
        mySetViewController * set = [[mySetViewController alloc]init];
        [self.navigationController pushViewController:set animated:YES];
        }
    }else if(indexPath.row==4){//我的行程
        if(picArr.count==7){//我的公司
        myCompanyViewController * company = [[myCompanyViewController alloc]init];
        [self.navigationController pushViewController:company animated:YES];
        }else{
        FYLPageViewController * route = [[FYLPageViewController alloc]init];
        route.title = @"我的行程";
        [self.navigationController pushViewController:route animated:YES];
        }
    }else if(indexPath.row==5){
        if(picArr.count==7){//我的公司
            FYLPageViewController * route = [[FYLPageViewController alloc]init];
            route.title = @"我的行程";
            [self.navigationController pushViewController:route animated:YES];
        }else{
           [myLjjTools directPhoneCallWithPhoneNum:@"023-67757777"];
        }
    }else{
        mySetViewController * set = [[mySetViewController alloc]init];
        [self.navigationController pushViewController:set animated:YES];
    }
 }else{
    [logicDone presentLoginView];
 }
}
#pragma  mark ---------------更新个人资料--------------
-(void)upDataClick{
 if([GVUserDefaults standardUserDefaults].LOGINSUC){
    myUpDataViewController * myData = [[myUpDataViewController alloc]init];
    [self.navigationController pushViewController:myData animated:YES];
 }else{
    [logicDone presentLoginView];
 }
}
-(void)loginClick{
   [logicDone presentLoginView];
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
