//
//  registerViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/28.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "registerViewController.h"

@interface registerViewController (){
    UITextField * textPhone;
    UITextField * codePhone;
    UITextField * passWord;
    BOOL isAgree;//是否同意协议
}

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
     [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    
    UIImageView * phoneImage = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(27), heiSize(50)+64+10, 13, 17) andImageName:@"手机-(3)" andBgColor:nil];
    [self.view addSubview:phoneImage];
    
    textPhone = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(phoneImage.frame)+10, heiSize(50)+64, SCREEN_WIDTH-101-CGRectGetMaxX(phoneImage.frame)-10-15, 40) andPlaceholder:@"请输入手机号" andTextColor:textMainColor andTextFont:[UIFont systemFontOfSize:fontSizeLJJ] andReturnType:UIReturnKeyDone];
    textPhone.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:textPhone];
    
    UIButton * button = [myLjjTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(textPhone.frame), heiSize(50)+64, 101, 36) andTitle:@"发送验证码" andTitleColor:textMainColor andBgColor:WHITEColor andSelecter:@selector(sendCodeClick:) andTarget:self];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.cornerRadius=4.0;
    button.layer.borderColor = MAINThemeColor.CGColor;
    button.layer.borderWidth = 1;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    
    UIView * lineOne = [myLjjTools createViewWithFrame:CGRectMake(widSize(15), CGRectGetMaxY(textPhone.frame)+5, SCREEN_WIDTH-2*widSize(15), 1) andBgColor:rgb(206, 206, 206)];
    [self.view addSubview:lineOne];
    
    UIImageView * codeImage = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(27), CGRectGetMaxY(lineOne.frame)+15+10+4, 17, 13) andImageName:@"验证码-(3)" andBgColor:nil];
    [self.view addSubview:codeImage];
    
    codePhone = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(codeImage.frame)+10, CGRectGetMaxY(lineOne.frame)+15, SCREEN_WIDTH-101-CGRectGetMaxX(codeImage.frame)-10-15, 40) andPlaceholder:@"请输入数字验证码" andTextColor:textMainColor andTextFont:[UIFont systemFontOfSize:fontSizeLJJ] andReturnType:UIReturnKeyDone];
    [self.view addSubview:codePhone];
    
    UIView * lineTwo = [myLjjTools createViewWithFrame:CGRectMake(widSize(15), CGRectGetMaxY(codePhone.frame)+5, SCREEN_WIDTH-2*widSize(15), 1) andBgColor:rgb(206, 206, 206)];
    [self.view addSubview:lineTwo];
    
    UIImageView * passImage = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(27), CGRectGetMaxY(lineTwo.frame)+15+10, 18, 20) andImageName:@"密码-(1)" andBgColor:nil];
    [self.view addSubview:passImage];
    
   passWord = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(passImage.frame)+10, CGRectGetMaxY(lineTwo.frame)+15, SCREEN_WIDTH-CGRectGetMaxX(passImage.frame)-10-15, 40) andPlaceholder:@"请输入6-16位的数字或者字母密码" andTextColor:textMainColor andTextFont:[UIFont systemFontOfSize:fontSizeLJJ] andReturnType:UIReturnKeyDone];
    passWord.secureTextEntry = YES;
    [self.view addSubview:passWord];
    
    UIView * lineThree = [myLjjTools createViewWithFrame:CGRectMake(widSize(15), CGRectGetMaxY(passWord.frame)+5, SCREEN_WIDTH-2*widSize(15), 1) andBgColor:rgb(206, 206, 206)];
    [self.view addSubview:lineThree];
    
    
    UIButton * selectBtn = [myLjjTools createButtonWithFrame:CGRectMake(widSize(27), CGRectGetMaxY(lineThree.frame)+widSize(25), 20, 20) andImage:[UIImage imageNamed:@"未选中"] andSelecter:@selector(selectClick:) andTarget:self];
    [selectBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    [self.view addSubview:selectBtn];
    
    UILabel * notiLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame)+widSize(16), CGRectGetMaxY(lineThree.frame)+widSize(25), SCREEN_WIDTH-CGRectGetMaxX(selectBtn.frame)-widSize(16), 20) andTitle:@"注册即表示你同意《易通用户协议》" andTitleFont:[UIFont systemFontOfSize:14] andTitleColor:rgb(204, 204, 204) andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    notiLabel = [myLjjTools createLabelTextWithView:notiLabel andwithChangeColorTxt:@"《易通用户协议》" withColor:rgb(255,171,38)];
    [self.view addSubview:notiLabel];
    
    UIButton * doneBtn = [myLjjTools createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(notiLabel.frame)+widSize(61), SCREEN_WIDTH-30, heiSize(50)) andTitle:@"完成" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(doneClick) andTarget:self];
    doneBtn.layer.cornerRadius=4.0;
    doneBtn.layer.borderColor = MAINThemeColor.CGColor;
    doneBtn.layer.borderWidth = 1;
    doneBtn.clipsToBounds = YES;
    [self.view addSubview:doneBtn];
    
}
#pragma mark --------注册--------------
-(void)doneClick{
    
    
    if(textPhone.text.length==0){
        
        ToastWithTitle(@"手机号不能为空哦");
        return;
    }
    if(codePhone.text.length==0){
//        NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
//        [parameters setObject:textPhone.text forKey:@"phone"];
//        [HttpRequest postWithURL:HTTP_URLIP(@"common/getSmsCodeForDev") params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
//            codePhone.text = responseObject[@"data"][@"code"];
//        } failure:^(NSError *error) {
//            
//        }];
        ToastWithTitle(@"验证码不能为空哦");
        return;
    }
    if(passWord.text.length<6){
        
        ToastWithTitle(@"密码不能少于6位数哦");
        return;
    }
    if(passWord.text.length>12){
        
        ToastWithTitle(@"密码不能大于12位数哦");
        return;
    }

    
    if(!isAgree){
        
        ToastWithTitle(@"必须同意协议哦");
        return;
    }

    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:textPhone.text forKey:@"userPhone"];
    [parameters setObject:codePhone.text forKey:@"smsCode"];
    [parameters setObject:passWord.text forKey:@"userPass"];
    [HttpRequest postWithURL:HTTP_URLIP(regist_User) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        ToastWithTitle(@"注册成功!");
        [GVUserDefaults standardUserDefaults].userPhone = textPhone.text;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:textPhone.text password:passWord.text];
    if (error==nil) {
        NSLog(@"注册成功");
    }
}
#pragma mark --------发送验证码--------------
-(void)sendCodeClick:(UIButton*)btn{
    
    if([[JudgeSummaryLJJ valiMobile:textPhone.text]length]!=0){
        ToastWithTitle([JudgeSummaryLJJ valiMobile:textPhone.text]);
        return;
    }
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:textPhone.text forKey:@"userPhone"];
    [parameters setObject:@1 forKey:@"codeType"];
    [HttpRequest postWithURL:HTTP_URLIP(send_SMSCode) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        [btn sendMessageBegin:textMainColor andChange:[UIColor lightGrayColor]];
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark --------协议--------------
-(void)selectClick:(UIButton*)btn{

    btn.selected = !btn.selected;
    
    isAgree = btn.selected;
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
