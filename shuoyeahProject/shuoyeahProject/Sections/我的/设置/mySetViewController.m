//
//  mySetViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "mySetViewController.h"
#import "touSuMessageViewController.h"
#import "changePassWordViewController.h"
#import "ljjUrlWebViewController.h"
@interface mySetViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSArray * titleArr;

}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation mySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    titleArr = @[@"关于产品",@"联系我们",@"投诉反馈",@"当前版本",@"修改密码"];
    [self createTable];
    // Do any additional setup after loading the view.
}
-(void)createTable{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = WHITEColor;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView  setSeparatorColor:LINECOLOR];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"mysetCEll";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    if(indexPath.row==3){
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = @"iOS 1.1.0";
        cell.detailTextLabel.font = FontSize(15);
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.textColor = rgb(170, 170, 170);
    }else{
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
        cell.textLabel.text = titleArr[indexPath.row];
        cell.textLabel.font = FontSize(15);
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 111;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 111) andBgColor:WHITEColor];
    
    UIButton * button = [myLjjTools createButtonWithFrame:CGRectMake(widSize(67), 75, SCREEN_WIDTH-widSize(67)*2, 36) andTitle:@"退出登录" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(doneAction) andTarget:self];
    button.layer.cornerRadius = 3.0;
    button.clipsToBounds = YES;
    [view addSubview:button];

    return view;
    
}

#pragma mark -----------退出登录-------------------
-(void)doneAction{
    
    [GVUserDefaults standardUserDefaults].userName = nil;
    [GVUserDefaults standardUserDefaults].userId = nil;
    [GVUserDefaults standardUserDefaults].userAcountStatus = nil;
    [GVUserDefaults standardUserDefaults].userAddTime = nil;
    [GVUserDefaults standardUserDefaults].userBirthDay = nil;
    [GVUserDefaults standardUserDefaults].userIndustry = nil;
    [GVUserDefaults standardUserDefaults].userJob = nil;
    [GVUserDefaults standardUserDefaults].userSex= nil;
    [GVUserDefaults standardUserDefaults].userSignature = nil;
    [GVUserDefaults standardUserDefaults].LOGINSUC = NO;
    [GVUserDefaults standardUserDefaults].userHeadImg = nil;
    [JPUSHService setTags:nil aliasInbackground:@""];
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
    }
    ToastWithTitle(@"退出成功!");
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:exitSucFreshData object:self userInfo:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==2){//投诉建议
    
        touSuMessageViewController * tousu = [[touSuMessageViewController alloc]init];
        tousu.typeNumber = 1;
        [self.navigationController pushViewController:tousu animated:YES];
    
    }else if(indexPath.row==1){//打电话
    
        [myLjjTools directPhoneCallWithPhoneNum:@"023-67757777"];
    }else if(indexPath.row==4){
    
        changePassWordViewController * changePaa = [[changePassWordViewController alloc]init];
        [self.navigationController pushViewController:changePaa animated:YES];
    }else if(indexPath.row==0){
    
        [HttpRequest postWithURL:HTTP_URLIP(get_AboutApp) params:nil andNeedHub:YES success:^(NSDictionary *responseObject){
            ljjUrlWebViewController * web = [[ljjUrlWebViewController alloc]init];
            if([responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
            web.htmlUrl=responseObject[@"data"][@"content"];
            }
            [self.navigationController pushViewController:web animated:YES];
        } failure:^(NSError *error) {
            
        }];

    
    }
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
