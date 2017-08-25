//
//  changePassWordViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/4/18.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "changePassWordViewController.h"

@interface changePassWordViewController (){
    
    UITextField * oldPassWord;//手机号
    UITextField * newPassWord;//验证码
    UITextField * passWord;//密码
}


@end

@implementation changePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    
    UIImageView * phoneImage = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(27), heiSize(50)+64+10,18, 20) andImageName:@"我的_Temperature" andBgColor:nil];
    phoneImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:phoneImage];
    
    oldPassWord = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(phoneImage.frame)+10, heiSize(50)+64, SCREEN_WIDTH-CGRectGetMaxX(phoneImage.frame)-10-15, 40) andPlaceholder:@"请输入原密码" andTextColor:textMainColor andTextFont:[UIFont systemFontOfSize:fontSizeLJJ] andReturnType:UIReturnKeyDone];
    oldPassWord.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:oldPassWord];
    
    UIView * lineOne = [myLjjTools createViewWithFrame:CGRectMake(10, CGRectGetMaxY(oldPassWord.frame)+5, SCREEN_WIDTH-20, 1) andBgColor:rgb(206, 206, 206)];
    [self.view addSubview:lineOne];
    
    UIImageView * codeImage = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(27), CGRectGetMaxY(lineOne.frame)+15+10+4, 18, 20) andImageName:@"我的_account" andBgColor:nil];
    codeImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:codeImage];
    
    newPassWord = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(codeImage.frame)+10, CGRectGetMaxY(lineOne.frame)+15, SCREEN_WIDTH-101-CGRectGetMaxX(codeImage.frame)-10-15, 40) andPlaceholder:@"请输入新密码" andTextColor:textMainColor andTextFont:[UIFont systemFontOfSize:fontSizeLJJ] andReturnType:UIReturnKeyDone];
    [self.view addSubview:newPassWord];
    
    UIView * lineTwo = [myLjjTools createViewWithFrame:CGRectMake(10, CGRectGetMaxY(newPassWord.frame)+5, SCREEN_WIDTH-20, 1) andBgColor:rgb(206, 206, 206)];
    [self.view addSubview:lineTwo];
    
    UIImageView * passImage = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(27), CGRectGetMaxY(lineTwo.frame)+15+10, 18, 20) andImageName:@"密码-(1)" andBgColor:nil];
    passImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:passImage];
    
    passWord = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(passImage.frame)+10, CGRectGetMaxY(lineTwo.frame)+15, SCREEN_WIDTH-CGRectGetMaxX(passImage.frame)-10-15, 40) andPlaceholder:@"请再次输入新密码" andTextColor:textMainColor andTextFont:[UIFont systemFontOfSize:fontSizeLJJ] andReturnType:UIReturnKeyDone];
    passWord.secureTextEntry = YES;
    [self.view addSubview:passWord];
    
    UIView * lineThree = [myLjjTools createViewWithFrame:CGRectMake(10, CGRectGetMaxY(passWord.frame)+5, SCREEN_WIDTH-20, 1) andBgColor:rgb(206, 206, 206)];
    [self.view addSubview:lineThree];
    
    
    UIButton * doneBtn = [myLjjTools createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(lineThree.frame)+50, SCREEN_WIDTH-30, heiSize(50)) andTitle:@"完成" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(doneClick) andTarget:self];
    doneBtn.layer.cornerRadius=4.0;
    doneBtn.layer.borderColor = MAINThemeColor.CGColor;
    doneBtn.layer.borderWidth = 1;
    doneBtn.clipsToBounds = YES;
    [self.view addSubview:doneBtn];
    
}

-(void)doneClick{
    
    if(newPassWord.text.length==0){
        
        [SVProgressHUD showErrorWithStatus:@"新密码不能为空哦"];
        return;
    }
    if(newPassWord.text.length<6){
        
        ToastWithTitle(@"密码不能少于6位数哦");
        return;
    }
    if(newPassWord.text.length>12){
        
        ToastWithTitle(@"密码不能大于12位数哦");
        return;
    }

    if(oldPassWord.text.length==0){
        
        [SVProgressHUD showErrorWithStatus:@"旧密码不能为空哦"];
        return;
    }
    if(![passWord.text isEqualToString:newPassWord.text]){
        
        [SVProgressHUD showErrorWithStatus:@"两次密码不一样哦"];
        return;
    }
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [parameters setObject:oldPassWord.text forKey:@"userOldPass"];
    [parameters setObject:newPassWord.text forKey:@"userPassword"];
    [HttpRequest postWithURL:HTTP_URLIP(change_UserPassword) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject){
        ToastWithTitle(@"修改成功!");
        [self.navigationController popToRootViewControllerAnimated:YES];
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
