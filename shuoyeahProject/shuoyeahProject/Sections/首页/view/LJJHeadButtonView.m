//
//  LJJHeadButtonView.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/21.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "LJJHeadButtonView.h"
#import "headCateButton.h"
@implementation LJJHeadButtonView{
    UIPageControl * _pageControl;
    NSArray * titleArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame with:(NSArray *)titleArr{

   self = [super  initWithFrame:frame];
    if(self){
        titleArray = titleArr;
        [self setView];
    }
    return self;
}

-(void)setView{
    
    NSInteger number = titleArray.count/4;
    NSInteger numMore = titleArray.count%4;
    if(numMore>0){
        number=number+1;
    }
    UIScrollView* scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 70)];
    //  scroll.backgroundColor = lineColor;
    scroll.contentSize = CGSizeMake(self.frame.size.width*number, 0);
    scroll.scrollEnabled = YES;
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    scroll.showsVerticalScrollIndicator = FALSE;
    scroll.showsHorizontalScrollIndicator = FALSE;
    [self addSubview:scroll];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0-10, CGRectGetMaxY(scroll.frame), 0, 20)];
    _pageControl.center = CGPointMake(self.frame.size.width/2.0, CGRectGetMaxY(scroll.frame));
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = number;
    //        self.backgroundColor = [UIColor redColor];
    [self addSubview:_pageControl];
    [_pageControl setCurrentPageIndicatorTintColor:MAINThemeColor];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    
    for(int i=0;i<titleArray.count;i++){
        
        headCateButton * button = [[headCateButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4.0*i, 0, SCREEN_WIDTH/4.0, 70)];
        button.btnImageView.image = [UIImage imageNamed:@"测试测试.jpeg"];
        button.btnLab.text = titleArray[i];
        button.tag = 1919+i;
        [button addTarget:self action:@selector(cateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:button];
   }

}

-(void)cateButtonClick:(UIButton*)btn{

    [self.delegate LJJHeadButtonViewClick:btn.tag];

}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
}

@end
