//
//  FYLSegmentView.m
//  FYLPageViewController
//
//  Created by FuYunLei on 2017/4/17.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import "FYLSegmentView.h"

@interface FYLSegmentView()

@property(nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)CALayer *maskLayer;

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,assign)CGFloat itemWidth;
@property (nonatomic,strong)NSMutableArray * buttons;
@end

@implementation FYLSegmentView

- (FYLSegmentView *)initWithTitles:(NSArray *)titles{
    
    if (self = [super initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 38)]) {
        self.titles = titles;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _buttons = [NSMutableArray array];
    _totalLabel = [myLjjTools createLabelWithFrame:CGRectMake(65, 10, SCREEN_WIDTH-65*2, 16) andTitle:@"我的总行驶里程:暂无" andTitleFont:FontSize(12) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentCenter andBgColor:MAINThemeOrgColor];
    _totalLabel.layer.cornerRadius = 8.0;
    _totalLabel.clipsToBounds= YES;
    [self addSubview:_totalLabel];
    
//    for(int i = 0;i<3;i++){
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake((SCREEN_WIDTH-28)/3.0*i+14, CGRectGetMaxY(_totalLabel.frame)+12, (SCREEN_WIDTH-28)/3.0, 36);
//        [button setTitle:titleArr[i] forState:UIControlStateNormal];
//        button.titleLabel.font=FontSize(15);
//        button.tag = 222+i;
//        if(i==0){
//            [button setTitleColor:WHITEColor forState:UIControlStateNormal];
//            [button setBackgroundColor:MAINThemeColor];
//            [myLjjTools roundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadius:4.0 with:button];
//        }else{
//            [button setTitleColor:rgb(170, 170, 170) forState:UIControlStateNormal];
//            [button setBackgroundColor:WHITEColor];
//        }
//        if(i==2){
//            
//            [myLjjTools roundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadius:4.0 with:button];
//            
//        }
//        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:button];
//        [_buttons addObject:button];
//    }

}
///标签点击事件
- (void)btnClick:(UIButton *)btn{
    NSUInteger i = btn.tag-222;
    for(UIButton * butt in _buttons){
        [butt setTitleColor:rgb(170, 170, 170) forState:UIControlStateNormal];
        [butt setBackgroundColor:WHITEColor];
    }
    [btn setTitleColor:WHITEColor forState:UIControlStateNormal];
    [btn setBackgroundColor:MAINThemeColor];
    if ([self.delegate respondsToSelector:@selector(FYLSegmentView:didClickTagAtIndex:)]) {
        [self.delegate FYLSegmentView:self didClickTagAtIndex:i];
    }
    
}

-(void)setSelectBtn:(NSInteger)indexNum{

    NSUInteger i = 222+indexNum;
    UIButton * btn = (UIButton*)[self viewWithTag:i];
    for(UIButton * butt in _buttons){
        
        [butt setTitleColor:rgb(170, 170, 170) forState:UIControlStateNormal];
        [butt setBackgroundColor:WHITEColor];
    }
    [btn setTitleColor:WHITEColor forState:UIControlStateNormal];
    [btn setBackgroundColor:MAINThemeColor];

}

@end
