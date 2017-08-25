//
//  changePhoneNumViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/29.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "changePhoneNumViewController.h"

@interface changePhoneNumViewController (){
    
    UITextField * textPhone;//手机号
    UITextField * codePhone;//验证码
}


@end

@implementation changePhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机";
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    
    UIImageView * phoneImage = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(27), heiSize(50)+64+10, 13, 17) andImageName:@"手机-(3)" andBgColor:nil];
    [self.view addSubview:phoneImage];
    
    textPhone = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(phoneImage.frame)+10, heiSize(50)+64, SCREEN_WIDTH-101-CGRectGetMaxX(phoneImage.frame)-10-15, 40) andPlaceholder:@"请输入手机号" andTextColor:textMainColor andTextFont:[UIFont systemFontOfSize:fontSizeLJJ] andReturnType:UIReturnKeyDone];
    textPhone.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:textPhone];
    
    UIButton * button = [myLjjTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(textPhone.frame), heiSize(50)+64, 101, 36) andTitle:@"发送验证码" andTitleColor:textMainColor andBgColor:WHITEColor andSelecter:@selector(sendCodeClick:) andTarget:self];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.cornerRadius=4.0;
    button.layer.borderColor = MAINThemeColor.CGColor;
    button.layer.borderWidth = 1;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
    
    UIView * lineOne = [myLjjTools createViewWithFrame:CGRectMake(10, CGRectGetMaxY(textPhone.frame)+5, SCREEN_WIDTH-20, 1) andBgColor:rgb(206, 206, 206)];
    [self.view addSubview:lineOne];
    
    UIImageView * codeImage = [myLjjTools createImageViewWithFrame:CGRectMake(widSize(27), CGRectGetMaxY(lineOne.frame)+15+10+4, 17, 13) andImageName:@"验证码-(3)" andBgColor:nil];
    [self.view addSubview:codeImage];
    
    codePhone = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(codeImage.frame)+10, CGRectGetMaxY(lineOne.frame)+15, SCREEN_WIDTH-101-CGRectGetMaxX(codeImage.frame)-10-15, 40) andPlaceholder:@"请输入数字验证码" andTextColor:textMainColor andTextFont:[UIFont systemFontOfSize:fontSizeLJJ] andReturnType:UIReturnKeyDone];
    [self.view addSubview:codePhone];
    
    UIView * lineTwo = [myLjjTools createViewWithFrame:CGRectMake(10, CGRectGetMaxY(codePhone.frame)+5, SCREEN_WIDTH-20, 1) andBgColor:rgb(206, 206, 206)];
    [self.view addSubview:lineTwo];
    
    UIButton * doneBtn = [myLjjTools createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(lineTwo.frame)+heiSize(80.0), SCREEN_WIDTH-30, heiSize(56)) andTitle:@"确定修改" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(doneClick) andTarget:self];
    doneBtn.layer.cornerRadius=4.0;
    doneBtn.layer.borderColor = MAINThemeColor.CGColor;
    doneBtn.layer.borderWidth = 1;
    doneBtn.clipsToBounds = YES;
    [self.view addSubview:doneBtn];
    
}

-(void)doneClick{
    
    if([[JudgeSummaryLJJ valiMobile:textPhone.text]length]!=0){
        [SVProgressHUD showErrorWithStatus:[JudgeSummaryLJJ valiMobile:textPhone.text]];
        return;
    }
    if(codePhone.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空哦"];
        return;
    }
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:textPhone.text forKey:@"userPhone"];
    [parameters setObject:codePhone.text forKey:@"smsCode"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(change_UserPhone) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
         [GVUserDefaults standardUserDefaults].userPhone = textPhone.text;
         [self.delegate changePhoneNumber:textPhone.text];
         ToastWithTitle(@"修改成功!");
         [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
   
    
}

-(void)sendCodeClick:(UIButton*)btn{
    
    if([[JudgeSummaryLJJ valiMobile:textPhone.text]length]!=0){
        [SVProgressHUD showErrorWithStatus:[JudgeSummaryLJJ valiMobile:textPhone.text]];
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
