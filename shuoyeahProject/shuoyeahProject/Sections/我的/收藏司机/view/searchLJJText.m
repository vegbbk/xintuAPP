//
//  searchLJJText.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/6/15.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "searchLJJText.h"

@implementation searchLJJText

-(id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self createUI:frame];
        self.backgroundColor = WHITEColor;
    }
    return self;
}

-(void)createUI:(CGRect)frame{

    self.inputText = [myLjjTools createTextFieldFrame:CGRectMake(10, 4, frame.size.width-36, frame.size.height-8) andPlaceholder:@"" andTextColor:BlackColor andTextFont:FontSize(15) andReturnType:UIReturnKeySearch];
    self.inputText.placeholder = @"请输入司机姓名";
    [self addSubview:_inputText];
    
    UIButton * searBtn = [myLjjTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(_inputText.frame), (frame.size.height-20)/2.0, 20, 20) andImage:[UIImage imageNamed:@"我的_搜索放大镜"] andSelecter:@selector(searchAction) andTarget:self];
    [self addSubview:searBtn];
    
}

-(void)setCustomPlaceholder:(NSString *)customPlaceholder{
    self.customPlaceholder = customPlaceholder;
    self.inputText.placeholder = customPlaceholder;
}

-(void)searchAction{
    [self.delegate searchTextInputLJJClick:self.inputText.text];
}

@end
