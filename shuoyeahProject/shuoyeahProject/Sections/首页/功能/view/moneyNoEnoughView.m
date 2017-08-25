//
//  moneyNoEnoughView.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/12.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "moneyNoEnoughView.h"

@implementation moneyNoEnoughView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
        [self createUI];
    }
    return self;
}

-(void)createUI{

    UIView * backView = [myLjjTools createViewWithFrame:CGRectMake(16, (SCREEN_HEIGHT-260-64)/2.0, SCREEN_WIDTH-32, 260) andBgColor:WHITEColor];
    backView.layer.cornerRadius = 4.0;
    [self addSubview:backView];
    
    UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake((backView.frame.size.width-56)/2.0, 35, 56, 68) andImageName:@"首页_余额不足" andBgColor:nil];
    [backView addSubview:imageView];
    
    UILabel * label = [myLjjTools createLabelWithFrame:CGRectMake(60, CGRectGetMaxY(imageView.frame)+10, backView.frame.size.width-120, 20) andTitle:@"余额不足" andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [backView addSubview:label];
    
    UILabel * labelInfo = [myLjjTools createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame)+10, backView.frame.size.width-40, 20) andTitle:@"您的余额不足以支付本次行程哦~" andTitleFont:FontSize(13) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
    [backView addSubview:labelInfo];
    
    UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake(30, CGRectGetMaxY(labelInfo.frame)+20, backView.frame.size.width-60, 40) andTitle:@"去充值" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(chargeAcyion) andTarget:self];
    btn.layer.cornerRadius = 5.0;
    [backView addSubview:btn];
    
//    UIButton * btn1 = [myLjjTools createButtonWithFrame:CGRectMake(30, CGRectGetMaxY(btn.frame)+20, backView.frame.size.width-60, 40) andTitle:@"继续下单" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(continueTakeOrder) andTarget:self];
//    btn1.layer.cornerRadius = 5.0;
//    [backView addSubview:btn1];

}

-(void)chargeAcyion{

    [self.delegate gotoChargeAction];
    [self removeFromSuperview];
}

//-(void)continueTakeOrder{
//
//    [self.delegate continueTakeOrder];
//    [self removeFromSuperview];
//    
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self removeFromSuperview];

}

@end
