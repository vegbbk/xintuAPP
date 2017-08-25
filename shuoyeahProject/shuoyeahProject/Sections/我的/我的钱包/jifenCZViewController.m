//
//  jifenCZViewController.m
//  shuoyeahProject
//
//  Created by shuoyeah on 16/8/17.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "jifenCZViewController.h"
#import "ThreePartyPayTool.h"
#import "chargeSucLJJViewController.h"
@interface jifenCZViewController ()<UITextFieldDelegate>{

    NSString * payType;//充值类型

        UIAlertView* _alertView;
        NSMutableData* _responseData;
        CGFloat _maxWidth;
        CGFloat _maxHeight;
        
        UITextField *_urlField;
        UITextField *_modeField;
        UITextField *_curField;

}
@end

@implementation jifenCZViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    payType =@"1";
    _moneyTextField.delegate = self;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.weixPayClick.selected = YES;
    [self.weixPayClick setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
    [self.weixPayClick setImage:[UIImage imageNamed:@"我的_充值_选中"] forState:UIControlStateSelected];
    
    [self.wangyButton setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
    [self.wangyButton setImage:[UIImage imageNamed:@"我的_充值_选中"] forState:UIControlStateSelected];
    
    self.surePayButton.layer.cornerRadius = 4;
    
    UITapGestureRecognizer * tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unionPayClick)];
    [self.unionPayLabel addGestureRecognizer:tapOne];
    
    UITapGestureRecognizer * tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kuaiqianClick)];
    [self.kuaiqianLabel addGestureRecognizer:tapTwo];
    
     [_moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSucClick) name:@"successPayLJJ" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSucClick) name:@"successPayLJJALIPAY" object:nil];
//    self.surePayButton.layer.borderColor = lineColor.CGColor;
//    self.surePayButton.layer.borderWidth = 1;
    // Do any additional setup after loading the view from its nib.
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
 //   NSCharacterSet *cs;
 //   cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
  //  NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
 //   BOOL canChange = [string isEqualToString:filtered];
    
 //   return _moneyTextField.text.length>=5?NO: canChange;
    
//}

-(void)presentSucClick{

     chargeSucLJJViewController * charg = [[chargeSucLJJViewController alloc]init];
     charg.moneyStr = self.moneyTextField.text;
     charg.typeFrom = self.typeFrom;
     charg.routDataModel = self.routDataModel;
     [self.navigationController pushViewController:charg animated:YES];
    
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

-(void)textFieldDidChange:(UITextField*)textField{

    [_surePayButton setTitle:[NSString stringWithFormat:@"确认充值 ¥%@",textField.text] forState:UIControlStateNormal];

}


- (IBAction)weixAction:(UIButton *)sender {
     self.weixPayClick.selected = YES;
    //sender.selected = !sender.selected;
    self.wangyButton.selected = NO;
    payType = @"1";
}

-(void)unionPayClick{

    self.weixPayClick.selected = YES;
    //sender.selected = !sender.selected;
    self.wangyButton.selected = NO;
    payType = @"1";


}

- (IBAction)wangyinClick:(UIButton *)sender {
    
    //sender.selected = !sender.selected;
    self.weixPayClick.selected = NO;
    self.wangyButton.selected = YES;
    payType = @"2";
    
}

-(void)kuaiqianClick{

    self.weixPayClick.selected = NO;
    self.wangyButton.selected = YES;
    payType = @"2";

}

#pragma mark --------------------------充值----------------------------------------
- (IBAction)sureClick:(UIButton *)sender {
   
    
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(_moneyTextField.text.length==0){
        [self.view makeToast:@"充值金额不能为空哦" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if(_moneyTextField.text.integerValue==0){
        [self.view makeToast:@"调皮,充值金额不能为零哦" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if(_moneyTextField.text.length>7){
        [self.view makeToast:@"充值金额不能高于7位数哦" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:_moneyTextField.text forKey:@"amount"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].loginType forKey:@"assignment"];
    if([[GVUserDefaults standardUserDefaults].loginType isEqualToString:@"1"]){
    [parameters setObject:[GVUserDefaults standardUserDefaults].companyId forKey:@"companyId"];
    }
    [parameters setObject:payType forKey:@"channel"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    NSLog(@"%@",parameters);
    [HttpRequest postWithURL:HTTP_URLIP(charge_Money) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        
        chageljjMoneyModel * model = [chageljjMoneyModel new];
        [model setValuesForKeysWithDictionary:responseObject[@"data"]];
        if([payType isEqualToString:@"1"]){
            [ThreePartyPayTool  weChatPayWithProductName:model];
        }else{
            [ThreePartyPayTool alipayPayWithProductName:model.alipay];
        }
        
    } failure:^(NSError *error) {
       // chargeSucLJJViewController * charg = [[chargeSucLJJViewController alloc]init];
       // [self.navigationController pushViewController:charg animated:YES];
    }];

 }

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}


@end
