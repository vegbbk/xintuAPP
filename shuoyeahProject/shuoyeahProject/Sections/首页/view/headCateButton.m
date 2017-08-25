//
//  headCateButton.m
//  GouYunQi_iOS
//
//  Created by shuoyeah on 16/8/22.
//  Copyright © 2016年 GouYunQi. All rights reserved.
//

#import "headCateButton.h"

@implementation headCateButton

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        UIImageView *btnImageView=[[UIImageView alloc] init];
        [self addSubview:btnImageView];
        self.btnImageView=btnImageView;
        
        UILabel *btnLab=[[UILabel alloc] init];
        [btnLab setBackgroundColor:[UIColor clearColor]];
        [btnLab setTextColor:[UIColor blackColor]];

        btnLab.font=[UIFont systemFontOfSize:15];
        btnLab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:btnLab];
        self.btnLab=btnLab;
        
    }
    return self;
}

- (void)layoutSubviews
{
    self.btnImageView.frame=CGRectMake(0, 13, 14, 14);
    
    self.btnLab.frame = CGRectMake(CGRectGetMaxX(self.btnImageView.frame)+5, 10, self.frame.size.width-30, 20);
    
    
}

@end
