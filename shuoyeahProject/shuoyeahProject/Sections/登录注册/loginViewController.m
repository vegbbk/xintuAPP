//
//  loginViewController.m
//  shuoyeahProject
//
//  Created by shuoyeah on 16/7/28.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "loginViewController.h"
#import "UserModel.h"
#import "forgetPasswordViewController.h"
#import "registerViewController.h"
@interface loginViewController (){

    UIButton * cpmpanyBtn;//企业
    UIButton * defaultBtn;//个人
    NSString * accountType;
}

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.loginButton.layer.cornerRadius = 3.0;
    self.loginButton.clipsToBounds = YES;
    accountType = @"1";
    [self createSelectBtn];
    NSLog(@"登录测试%@", [GVUserDefaults standardUserDefaults].userName);
    if([GVUserDefaults standardUserDefaults].userPhone){
        self.accountTextField.text = [GVUserDefaults standardUserDefaults].userPhone;
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)createSelectBtn{

    cpmpanyBtn = [myLjjTools createButtonWithFrame:CGRectMake((SCREEN_WIDTH-160)/3.0, 20+64, 80, 40) andTitle:@"企业" andTitleColor:BlackColor andImage:[UIImage imageNamed:@"登录-选中"] andSelecter:@selector(companyClick) andTarget:self andBgColor:nil];
    cpmpanyBtn.imageRect = CGRectMake(62, 11, 18, 18);
    cpmpanyBtn.titleRect = CGRectMake(0, 10, 60, 20);
    [self.view addSubview:cpmpanyBtn];

    defaultBtn = [myLjjTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(cpmpanyBtn.frame)+(SCREEN_WIDTH-160)/3.0, 20+64, 80, 40) andTitle:@"个人" andTitleColor:BlackColor andImage:[UIImage imageNamed:@"登录-未选中"] andSelecter:@selector(selfDefaultClick) andTarget:self andBgColor:nil];
    defaultBtn.imageRect = CGRectMake(62, 11, 18, 18);
    defaultBtn.titleRect = CGRectMake(0, 10, 60, 20);
    [self.view addSubview:defaultBtn];
    
}

-(void)companyClick{

    accountType = @"1";
    [cpmpanyBtn setImage:[UIImage imageNamed:@"登录-选中"] forState:UIControlStateNormal];
    [defaultBtn setImage:[UIImage imageNamed:@"登录-未选中"] forState:UIControlStateNormal];
}

-(void)selfDefaultClick{

    accountType = @"2";
    [defaultBtn setImage:[UIImage imageNamed:@"登录-选中"] forState:UIControlStateNormal];
    [cpmpanyBtn setImage:[UIImage imageNamed:@"登录-未选中"] forState:UIControlStateNormal];
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
#pragma mark -------注册-----------
- (IBAction)registerClick:(id)sender {
    
    registerViewController * forget = [[registerViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
    
}
#pragma mark -------忘记密码-----------
- (IBAction)forgetPassClick:(UIButton *)sender {
    forgetPasswordViewController * forget = [[forgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forget animated:YES];
}
#pragma mark -------登录-----------
- (IBAction)loginButtonAction:(UIButton *)sender {
    
    if(self.accountTextField.text.length==0||self.passWordTextField.text.length==0){
        ToastWithTitle(@"账号或密码不能为空哦");
        return;
    }
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:self.accountTextField.text forKey:@"userPhone"];
    [parameters setObject:self.passWordTextField.text forKey:@"userPass"];
    [parameters setObject:accountType forKey:@"loginType"];
    [HttpRequest postWithURL:HTTP_URLIP(user_Login) params:parameters andNeedHub:YES success:^(NSDictionary* responseObject) {
        
        [GVUserDefaults standardUserDefaults].loginType = accountType;
        [GVUserDefaults standardUserDefaults].passAmin = self.passWordTextField.text;
        [GVUserDefaults standardUserDefaults].userPhone = responseObject[@"data"][@"user"][@"userPhone"];
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userName"])){
        [GVUserDefaults standardUserDefaults].userName =unKnowToStr(responseObject[@"data"][@"user"][@"userName"]);
        }
        [GVUserDefaults standardUserDefaults].userAcountStatus = responseObject[@"data"][@"user"][@"userAcountStatus"];
        [GVUserDefaults standardUserDefaults].userAddTime = responseObject[@"data"][@"user"][@"userAddTime"];
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userBirthDay"])){
        [GVUserDefaults standardUserDefaults].userBirthDay = responseObject[@"data"][@"user"][@"userBirthDay"];
        }
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userIndustry"])){
        [GVUserDefaults standardUserDefaults].userIndustry = responseObject[@"data"][@"user"][@"userIndustry"];
        }
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userHeadImg"])){
        [GVUserDefaults standardUserDefaults].userHeadImg =responseObject[@"data"][@"user"][@"userHeadImg"];
        }
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userJob"])){
        [GVUserDefaults standardUserDefaults].userJob = responseObject[@"data"][@"user"][@"userJob"];
        }
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userSex"])){
        [GVUserDefaults standardUserDefaults].userSex= responseObject[@"data"][@"user"][@"userSex"];
        }
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userSignature"])){
        [GVUserDefaults standardUserDefaults].userSignature = responseObject[@"data"][@"user"][@"userSignature"];
        }
        [GVUserDefaults standardUserDefaults].userId = responseObject[@"data"][@"user"][@"id"];
        if(!IsStrEmpty(unKnowToStr(responseObject[@"data"][@"company"][@"companyId"]))){
        [GVUserDefaults standardUserDefaults].companyId = responseObject[@"data"][@"company"][@"companyId"];
        }
        if(!IsStrEmpty(responseObject[@"data"][@"company"][@"companyName"])){
        [GVUserDefaults standardUserDefaults].companyName = responseObject[@"data"][@"company"][@"companyName"];
        }
        [GVUserDefaults standardUserDefaults].isAdmin = responseObject[@"data"][@"company"][@"isAdmin"];
        [GVUserDefaults standardUserDefaults].LOGINSUC = YES;
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userAlias"])){
        [JPUSHService setTags:nil aliasInbackground:responseObject[@"data"][@"user"][@"userAlias"]];
        }
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userHXAccount"])){
            [GVUserDefaults standardUserDefaults].userHXAccount = responseObject[@"data"][@"user"][@"userHXAccount"];
        }else{
            [GVUserDefaults standardUserDefaults].userHXAccount = @"";
        }
        if(!IsStrEmpty(responseObject[@"data"][@"user"][@"userHXPassword"])){
            [GVUserDefaults standardUserDefaults].userHXPassword = responseObject[@"data"][@"user"][@"userHXPassword"];
        }else{
            [GVUserDefaults standardUserDefaults].userHXPassword = @"";
        }
        EMError *error = [[EMClient sharedClient] loginWithUsername:[GVUserDefaults standardUserDefaults].userHXAccount password:[GVUserDefaults standardUserDefaults].userHXPassword];
        if (!error) {
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:loginSucFreshData object:self userInfo:nil];

    } failure:^(NSError *error) {
        
    }];
    
//    NSMutableDictionary * diction = [NSMutableDictionary dictionary];
//    [HttpRequest postWithURL:@"" params:diction andNeedHub:YES success:^(id responseObject) {
//        
//        [GVUserDefaults standardUserDefaults].userName = _accountTextField.text;
//        UserModel * model = [NSKeyedArchiver archivedDataWithRootObject:]
//    } failure:^(NSError *error) {
//        
//    }];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
