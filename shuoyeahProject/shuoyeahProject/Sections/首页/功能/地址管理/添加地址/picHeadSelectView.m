//
//  picHeadSelectView.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "picHeadSelectView.h"

@implementation picHeadSelectView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
        [self setUI];
    }
    return self;
    
    
}

-(void)setUI{
    
    CGFloat WIDTH = (SCREEN_WIDTH-50*5)/4.0;
    UIView * backView = [myLjjTools createViewWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44+35+35+WIDTH*2+30) andBgColor:WHITEColor];
    UILabel * label = [myLjjTools createLabelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) andTitle:@"选择图标" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentCenter andBgColor:rgb(238, 238, 238)];
    [backView addSubview:label];

    NSArray * picArr = @[@"lift_home",@"lift_company",@"sofa",@"briefcase",@"train",@"aircraft",@"shopping",@"bachelor"];
    for(int i=0;i<2;i++){
        for(int j=0;j<4;j++){
            
        UIButton * butt = [myLjjTools createButtonWithFrame:CGRectMake(50*j+50+WIDTH*j,44+35*i+35+WIDTH*i, WIDTH, WIDTH) andImage:[UIImage imageNamed:picArr[i*2+j]] andSelecter:@selector(btnClick:) andTarget:self];
        butt.tag = 6666+i*2+j;
            [backView addSubview:butt];
        }
    }
    [self addSubview:backView];
    
    [UIView animateWithDuration:0.6 animations:^{
        backView.frame = CGRectMake(0, SCREEN_HEIGHT-(44+35+35+WIDTH*2+30), SCREEN_WIDTH, 44+35+35+WIDTH*2+30);
    }];
    
}

-(void)btnClick:(UIButton*)btn{
    NSInteger num = btn.tag-6666;
    [self.delegate picHeadSelectName:intToStr(num)];
    [self removeFromSuperview];
}

@end
