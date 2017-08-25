//
//  routingRoadHeadView.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/6/26.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "routingRoadHeadView.h"

@implementation routingRoadHeadView

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = WHITEColor;
        [self createUI];
    }
    return self;
}

-(void)createUI{

    UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 9, 8, 11) andImageName:@"我的_起点" andBgColor:nil];
    [self addSubview:imageView];
    self.startLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+11, 5, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-11-50, 20) andTitle:@"" andTitleFont:FontSize(12) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self addSubview:self.startLabel];
    
    UIImageView * imageView1 = [myLjjTools createImageViewWithFrame:CGRectMake(16, CGRectGetMaxY(imageView.frame)+9, 8, 11) andImageName:@"我的_终点" andBgColor:nil];
    [self addSubview:imageView1];
    self.endLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+11,CGRectGetMaxY(self.startLabel.frame), SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-11-50, 20) andTitle:@"" andTitleFont:FontSize(12) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self addSubview:self.endLabel];
    
    UIImageView * imageView11 = [myLjjTools createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-10-40, 5, 40, 40) andImageName:@"行程中" andBgColor:nil];
    [self addSubview:imageView11];
    
    UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) andTitle:@"" andTitleColor:nil andBgColor:nil andSelecter:@selector(btnClick) andTarget:self];
    [self addSubview:btn];
}

-(void)btnClick{
    [self.delegate routingClick];

}

@end
