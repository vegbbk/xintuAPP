//
//  billViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "billViewController.h"
#import "makeBillViewController.h"
#import "billRecordViewController.h"
#import "billByRouteListViewController.h"
@interface billViewController (){

    UILabel * moneyLabel;
    NSString * monryStr;
    NSString * orderIDStr;
}

@end

@implementation billViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票";
    [self createUI];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadData{

    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(get_OrderAmount) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        moneyLabel.text = [NSString stringWithFormat:@"%.2lf元",[responseObject[@"data"][@"amount"] floatValue]];
        monryStr = unKnowToStr(responseObject[@"data"][@"amount"]);
        orderIDStr = unKnowToStr(responseObject[@"data"][@"ids"]);
    } failure:^(NSError *error) {
        
    }];
}

-(void)createUI{

    moneyLabel = [myLjjTools createLabelWithFrame:CGRectMake(10, 124, SCREEN_WIDTH-20, 32) andTitle:@"0.00元" andTitleFont:FontSize(40) andTitleColor:MAINThemeColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    moneyLabel = [self createLabelTextWithView:moneyLabel andwithChangeColorTxt:@"元" withColor:nil];
    [self.view addSubview:moneyLabel];
    UILabel * Label1 = [myLjjTools createLabelWithFrame:CGRectMake(10,CGRectGetMaxY(moneyLabel.frame)+11, SCREEN_WIDTH-20, 15) andTitle:@"可开发票额度" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [self.view addSubview:Label1];

    UIButton * makeBillBtn = [myLjjTools createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(Label1.frame)+58, SCREEN_WIDTH-30, 55) andTitle:@"我要开票" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(makeBillClick) andTarget:self];
    makeBillBtn.layer.borderColor = MAINThemeColor.CGColor;
    makeBillBtn.layer.borderWidth = 1;
    makeBillBtn.layer.cornerRadius = 4.0;
    makeBillBtn.clipsToBounds = YES;
    [self.view addSubview:makeBillBtn];
    
    UIButton * historyBtn = [myLjjTools createButtonWithFrame:CGRectMake(15, CGRectGetMaxY(makeBillBtn.frame)+15, SCREEN_WIDTH-30, 55) andTitle:@"开票记录" andTitleColor:MAINThemeColor andBgColor:WHITEColor andSelecter:@selector(historyClick) andTarget:self];
    historyBtn.layer.borderColor = MAINThemeColor.CGColor;
    historyBtn.layer.borderWidth = 1;
    historyBtn.layer.cornerRadius = 4.0;
    historyBtn.clipsToBounds = YES;
    [self.view addSubview:historyBtn];
    
    NSString * string = @"最高额度仅限实际充值或信用卡的订单费用个，不包含任何优惠券、赠送金额、体验券等优惠活动费用。";
    NSString * str= @"您可开一张或多张发票，单张发票最高限额9999元。";
    
    CGSize hei = [myLjjTools countTxtWith:string andWithFont:FontSize(15) with:SCREEN_WIDTH-47];
    UILabel * notiLabel = [myLjjTools createLabelWithFrame:CGRectMake(32, CGRectGetMaxY(historyBtn.frame)+36, SCREEN_WIDTH-47, hei.height) andTitle:string andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    notiLabel.numberOfLines = 0;
    [self.view addSubview:notiLabel];

    CGSize hei1 = [myLjjTools countTxtWith:str andWithFont:FontSize(15) with:SCREEN_WIDTH-47];
    UILabel * notiLabel1 = [myLjjTools createLabelWithFrame:CGRectMake(32, CGRectGetMaxY(notiLabel.frame)+10, SCREEN_WIDTH-47, hei1.height) andTitle:str andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    notiLabel1.numberOfLines = 0;
    [self.view addSubview:notiLabel1];

    
}
//开发票
-(void)makeBillClick{

//    makeBillViewController * make = [[makeBillViewController alloc]init];
//    make.amount = monryStr;
//    [self.navigationController pushViewController:make animated:YES];
  
    billByRouteListViewController * bill = [[billByRouteListViewController alloc]init];
    [self.navigationController pushViewController:bill animated:YES];

}
//发票记录
-(void)historyClick{

    billRecordViewController * record = [[billRecordViewController alloc]init];
    [self.navigationController pushViewController:record animated:YES];

}

-(UILabel *)createLabelTextWithView:(UILabel *)label andwithChangeColorTxt:(NSString *)string withColor:(UIColor *)color{
    
    NSString *str1 = label.text;
    NSRange range = [str1 rangeOfString:string];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
    //设置单位长度内的内容显示成色
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range];
    label.attributedText = str;
    return label;
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
