//
//  priceDiffLJJViewController.m
//  shuoyeahProject
//
//  Created by 刘建基 on 2017/6/19.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "priceDiffLJJViewController.h"
#import "priceDifffLJJModel.h"
#import "payMoneyOrderViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface priceDiffLJJViewController (){

    UILabel * totalMoneylabel;
    UILabel * alearLabel;
    UILabel * getDiffLabel;
    UILabel * milageFeeLabel;
    UILabel * timeFeeLabel;
    UILabel * totalFeeLabel;
    UILabel * dyMultipleLabel;
    UILabel * distanceTimeLabel;
    UILabel * stopLabel;
    UILabel * brigeLabel;
    UILabel * onePriceLabel;
    UILabel * lastPriceLabel;
    priceDifffLJJModel * model;
    UIButton * btn;
}

@end

@implementation priceDiffLJJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单支付";
    self.view.backgroundColor = BACKLJJcolor;
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [self itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    UILabel * label = [myLjjTools createLabelWithFrame:CGRectMake(0, 20+64, SCREEN_WIDTH, 40) andTitle:@"总费用:暂无" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:label];
    totalMoneylabel = label;
    
    UILabel * label2 = [myLjjTools createLabelWithFrame:CGRectMake(0,  CGRectGetMaxY(label.frame), SCREEN_WIDTH, 40) andTitle:@"起步费:暂无" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:label2];
    getDiffLabel = label2;
    
    UILabel * label21 = [myLjjTools createLabelWithFrame:CGRectMake(0,  CGRectGetMaxY(label2.frame), SCREEN_WIDTH, 40) andTitle:@"里程费:暂无" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:label21];
    milageFeeLabel = label21;
    
    UILabel * label22 = [myLjjTools createLabelWithFrame:CGRectMake(0,  CGRectGetMaxY(label21.frame), SCREEN_WIDTH, 40) andTitle:@"时长费:暂无" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:label22];
    timeFeeLabel = label22;
    
    stopLabel = [myLjjTools createLabelWithFrame:CGRectMake(0,  CGRectGetMaxY(label22.frame), SCREEN_WIDTH, 40) andTitle:@"停车费:0元" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:stopLabel];
    
    brigeLabel = [myLjjTools createLabelWithFrame:CGRectMake(0,  CGRectGetMaxY(stopLabel.frame), SCREEN_WIDTH, 40) andTitle:@"路桥费:0元" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:brigeLabel];
    
    onePriceLabel = [myLjjTools createLabelWithFrame:CGRectMake(0,  CGRectGetMaxY(brigeLabel.frame), SCREEN_WIDTH, 40) andTitle:@"一口价:0元" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:onePriceLabel];
    
    lastPriceLabel = [myLjjTools createLabelWithFrame:CGRectMake(0,  CGRectGetMaxY(onePriceLabel.frame), SCREEN_WIDTH, 40) andTitle:@"最低消费:0元" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:lastPriceLabel];
    
    UILabel * label23 = [myLjjTools createLabelWithFrame:CGRectMake(0,  CGRectGetMaxY(lastPriceLabel.frame), SCREEN_WIDTH, 1) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:label23];
    dyMultipleLabel = label23;

    UILabel * label3 = [myLjjTools createLabelWithFrame:CGRectMake(0,  CGRectGetMaxY(label23.frame), SCREEN_WIDTH, 40) andTitle:@"0公里  0小时" andTitleFont:FontSize(13) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:WHITEColor];
    [self.view addSubview:label3];
    distanceTimeLabel = label3;

    btn = [myLjjTools createButtonWithFrame:CGRectMake(16, CGRectGetMaxY(label3.frame)+20, SCREEN_WIDTH-32, 40) andTitle:@"立即支付" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(chargeClick) andTarget:self];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    [self.view addSubview:btn];
    [self loadData];
    if(self.typeNum==10){
        btn.hidden = YES;
        self.navigationItem.title = @"费用详情";
    }else{
        btn.hidden = NO;
        self.navigationItem.title = @"订单支付";
    }
    // Do any additional setup after loading the view.
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
- (void)back
{
    if(self.typeNum==10){
    [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)loadData{

    NSString * url = @"";
    if(self.typeNum==10){
        url = HTTP_URLIP(@"pay/getPayDetail");
    }else{
        url = HTTP_URLIP(@"pay/getDiffPrice");
    }
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    SET_OBJRCT(@"orderSn", self.orderSn);
    [HttpRequest postWithURL:url params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        model = [[priceDifffLJJModel alloc]init];
        [model setValuesForKeysWithDictionary:responseObject[@"data"]];
        totalMoneylabel.text = [NSString stringWithFormat:@"实际费用:%.2lf元",model.totalFee.floatValue];
        getDiffLabel.text = [NSString stringWithFormat:@"起步费:%.2lf元",model.startFee.floatValue];
        milageFeeLabel.text = [NSString stringWithFormat:@"里程费:%.2lf元",model.milageFee.floatValue];
        timeFeeLabel.text = [NSString stringWithFormat:@"时长费:%.2lf元",model.timeFee.floatValue];
        stopLabel.text = [NSString stringWithFormat:@"停车费:%.2lf元",model.stopFee.floatValue];
        brigeLabel.text = [NSString stringWithFormat:@"路桥费:%.2lf元",model.roadFee.floatValue];
        if(model.feeType.floatValue==2){
            onePriceLabel.text = @"一口价:0.00元";
        }else{
            onePriceLabel.text= [NSString stringWithFormat:@"一口价:%.2lf元",model.totalFee.floatValue];
        }
        lastPriceLabel.text = [NSString stringWithFormat:@"最低消费:%.2lf元",model.leastFee.floatValue];
        distanceTimeLabel.text = [NSString stringWithFormat:@"%@公里  %@分钟",model.mileage,model.time];//动态加价倍数:暂无
        if(model.dyMultiple.floatValue!=0.0){
            dyMultipleLabel.frame = CGRectMake(0,  CGRectGetMaxY(lastPriceLabel.frame), SCREEN_WIDTH, 40);
            distanceTimeLabel.frame = CGRectMake(0,  CGRectGetMaxY(dyMultipleLabel.frame), SCREEN_WIDTH, 40);
            btn.frame = CGRectMake(16, CGRectGetMaxY(distanceTimeLabel.frame)+20, SCREEN_WIDTH-32, 40);
            dyMultipleLabel.text = [NSString stringWithFormat:@"动态加价倍数:%@",model.dyMultiple];
       }
    } failure:^(NSError *error){
        
    }];
}

-(void)chargeClick{

    payMoneyOrderViewController * pay = [[payMoneyOrderViewController alloc]init];
    pay.typeCate = 2;
    pay.orderSn = model.orderSn;
    pay.moneyStr = [NSString stringWithFormat:@"%.2lf",model.totalFee.floatValue];
    [self.navigationController pushViewController:pay animated:YES];

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
