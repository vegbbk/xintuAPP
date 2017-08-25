//
//  payMoneyOrderViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/25.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "payMoneyOrderViewController.h"
#import "ThreePartyPayTool.h"
#import "walletLJJModel.h"
#import "chageljjMoneyModel.h"
#import "FYLPageViewController.h"
#import "moneyNoEnoughView.h"
#import "jifenCZViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "paySuccessViewController.h"
@interface payMoneyOrderViewController ()<gotoChargeMoneyDelegate>{
 NSString * payType;//充值类型
    walletLJJModel * dataModel;
}
@end

@implementation payMoneyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=NO;
    self.title = @"支付";
    payType =@"3";
    [self.balanceBtn setImage:[UIImage imageNamed:@"我的_充值_选中"] forState:UIControlStateNormal];
    self.surePayBtn.layer.cornerRadius = 4.0;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.surePayBtn.clipsToBounds = YES;
    if(self.typeCate==1){
        self.backWAPayView.hidden = YES;
        self.surePayBtn.hidden = YES;
        self.balancePayBtn = [myLjjTools createButtonWithFrame:CGRectMake(50, 200+64, SCREEN_WIDTH-100, 40) andTitle:@"确认支付" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(balanceOnlyClick) andTarget:self];
        self.balancePayBtn.layer.cornerRadius = 4.0;
        self.balancePayBtn.clipsToBounds = YES;
        self.balancePayBtn.titleLabel.font = FontSize(15);
        [self.view addSubview:self.balancePayBtn];
    }else{
    self.diffMoneyLabel.text = @"订单金额";
    }
    self.navigationItem.leftBarButtonItem = [self itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    [self.weichatPayLabel addTapGuester:YES with:^{
        [self.alipayBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
        [self.weiPayBtn setImage:[UIImage imageNamed:@"我的_充值_选中"] forState:UIControlStateNormal];
        [self.balanceBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
        payType = @"1";
    }];
    
    [self.alipayLabel addTapGuester:YES with:^{
        [self.weiPayBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
        [self.alipayBtn setImage:[UIImage imageNamed:@"我的_充值_选中"] forState:UIControlStateNormal];
        [self.balanceBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
        payType = @"2";
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.banlanceView addGestureRecognizer:tap];
    
    self.totalMoneyLaebl.text = [NSString stringWithFormat:@"%.2lf元",self.moneyStr.floatValue];
    [self loadData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSucClick) name:@"successPayLJJ" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentSucClick) name:@"successPayLJJALIPAY" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self loadData];

}

- (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[self imageWithName:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithName:highIcon] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 10, 20);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (UIImage *)imageWithName:(NSString *)name
{
    if (iOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) { // 没有_os7后缀的图片
            image = [UIImage imageNamed:name];
        }
        return image;
    }
    // 非iOS7
    return [UIImage imageNamed:name];
}
#pragma mark ---------余额支付----------------
-(void)balanceOnlyClick{

    if(self.moneyStr.floatValue>dataModel.balance.floatValue){
//    moneyNoEnoughView * no = [[moneyNoEnoughView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    no.delegate = self;
//    [self.view addSubview:no];
        ToastWithTitle(@"余额不足,请选择其他支付方式");
    }else{
        NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
        SET_OBJRCT(@"orderSn", self.orderSn);
        SET_OBJRCT(@"channel", payType);
        SET_OBJRCT(@"accountType", [GVUserDefaults standardUserDefaults].loginType)
        SET_OBJRCT(@"companyId", [GVUserDefaults standardUserDefaults].companyId)
        [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
        NSLog(@"%@",parameters);
        [HttpRequest postWithURL:HTTP_URLIP(@"pay/orderPay") params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
            ToastWithTitle(@"订单支付成功!");
            [[NSNotificationCenter defaultCenter ] postNotificationName:@"routingFreshDeleLJJ" object:nil];
            [self presentSucClick];
        } failure:^(NSError *error){
          
        }];
    }
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadData{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].loginType forKey:@"assignment"];
    if([GVUserDefaults standardUserDefaults].loginType.integerValue==1){
        [parameters setObject:[GVUserDefaults standardUserDefaults].companyId forKey:@"companyId"];
    }
    [HttpRequest postWithURL:HTTP_URLIP(get_Balance) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        dataModel = [[walletLJJModel alloc]init];
        [dataModel setValuesForKeysWithDictionary:responseObject[@"data"]];
        self.balanceLabel.text = [NSString stringWithFormat:@"可用余额    %.2lf元",dataModel.balance.floatValue];
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation我的_充值_未选中

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)tapClick{
    [self.weiPayBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
    [self.alipayBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
    [self.balanceBtn setImage:[UIImage imageNamed:@"我的_充值_选中"] forState:UIControlStateNormal];
    payType = @"3";

}

- (IBAction)balanceClick:(UIButton *)sender {
    
    [self.weiPayBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
    [self.alipayBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
    [self.balanceBtn setImage:[UIImage imageNamed:@"我的_充值_选中"] forState:UIControlStateNormal];
     payType = @"3";
    
}
- (IBAction)weiPayClick:(UIButton *)sender {
    [self.alipayBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"我的_充值_选中"] forState:UIControlStateNormal];
    [self.balanceBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
     payType = @"1";
}


- (IBAction)alipayClick:(UIButton *)sender {
    [self.weiPayBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"我的_充值_选中"] forState:UIControlStateNormal];
    [self.balanceBtn setImage:[UIImage imageNamed:@"我的_充值_未选中"] forState:UIControlStateNormal];
     payType = @"2";
}

- (IBAction)surePayMoneyClick:(id)sender {
    if([payType isEqualToString:@"3"]){
    
    [self balanceOnlyClick];
    
    }else{
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    SET_OBJRCT(@"orderSn", self.orderSn);
    SET_OBJRCT(@"channel", payType);
    SET_OBJRCT(@"assignment", [GVUserDefaults standardUserDefaults].loginType)
    SET_OBJRCT(@"companyId", [GVUserDefaults standardUserDefaults].companyId)
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    NSLog(@"%@",parameters);
    [HttpRequest postWithURL:HTTP_URLIP(@"pay/orderPay") params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
         NSLog(@"%@",responseObject);
        chageljjMoneyModel * model = [chageljjMoneyModel new];
        [model setValuesForKeysWithDictionary:responseObject[@"data"]];
        if([payType isEqualToString:@"1"]){
            [ThreePartyPayTool  weChatPayWithProductName:model];
        }else if([payType isEqualToString:@"2"]){
            [ThreePartyPayTool alipayPayWithProductName:model.alipay];
        }
    } failure:^(NSError *error) {
        // chargeSucLJJViewController * charg = [[chargeSucLJJViewController alloc]init];
        // [self.navigationController pushViewController:charg animated:YES];
    }];
    }
}
#pragma mark -----------去充值-----------
-(void)gotoChargeAction{
    jifenCZViewController * czjf = [[jifenCZViewController alloc]init];
    [self.navigationController pushViewController:czjf animated:YES];
}

-(void)presentSucClick{
    paySuccessViewController *vc = [[paySuccessViewController alloc] init];
    vc.orderSn = self.orderSn;
    [self.navigationController pushViewController:vc animated:YES];
}
//NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
//[parameters setObject:self.orderSn forKey:@"orderSn"];
//[HttpRequest postWithURL:HTTP_URLIP(@"charging/weixinPay") params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
//    chageljjMoneyModel * model = [chageljjMoneyModel new];
//    [model setValuesForKeysWithDictionary:responseObject[@"data"]];
//    if([payType isEqualToString:@"1"]){
//        [ThreePartyPayTool  weChatPayWithProductName:model];
//    }else{
//        [ThreePartyPayTool alipayPayWithProductName:@"致富宝" productDescription:@"测试一下" payprice:@"" tradeNO:@"4564613"];
//    }
//    
//}failure:^(NSError *error) {
//    // chargeSucLJJViewController * charg = [[chargeSucLJJViewController alloc]init];
//    // [self.navigationController pushViewController:charg animated:YES];
//}];



@end
