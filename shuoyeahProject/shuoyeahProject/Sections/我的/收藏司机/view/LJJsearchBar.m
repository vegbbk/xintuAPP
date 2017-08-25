//
//  LJJsearchBar.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "LJJsearchBar.h"

@implementation LJJsearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(widSize(70), heiSize(11), widSize(236), heiSize(31));
        self.font = [UIFont systemFontOfSize:15];
        //self.placeholder = @"请输入查询条件";
        // 提前在Xcode上设置图片中间拉伸
       // self.background = [UIImage imageNamed:@"我的_搜索框"];
        
        // 通过init初始化的控件大多都没有尺寸
        
        UIView * view = [myLjjTools createViewWithFrame:CGRectMake(0, 0, 30, 20) andBgColor:CLEARCOLOR];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"我的_搜索放大镜"];
        // contentMode：default is UIViewContentModeScaleToFill，要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
        searchIcon.contentMode = UIViewContentModeCenter;
        searchIcon.frame = CGRectMake(0, 0, 20, 20);
        [view addSubview:searchIcon];
        self.rightView = view;
        self.returnKeyType = UIReturnKeySearch;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.placeholder = @"   请输入司机姓名";
        self.layer.cornerRadius = heiSize(30)/2.0;
        self.clipsToBounds = YES;
        self.layer.borderColor = LINECOLOR.CGColor;
        self.layer.borderWidth = 1;
        
        self.backgroundColor = RGBACOLOR(255, 255, 255, 0.15);
    }
    return self;
}

+(instancetype)searchBar
{
    return [[self alloc] init];
}

@end
