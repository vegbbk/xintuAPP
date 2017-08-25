//
//  ViewController.m
//  FYLPageViewController
//
//  Created by FuYunLei on 2017/4/17.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import "FYLPageViewController.h"
#import "myRouteViewController.h"
#import "studentListOrderViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface FYLPageViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate,FYLSegmentViewDelegate>
{
    BOOL _done; //是否翻页完成
    NSInteger _currentPage;//当前控制器对应下标
}
@property(nonatomic,strong) UIPageViewController *pageVC;

@property(nonatomic,strong) NSMutableArray *viewControllers;

@property (nonatomic,strong)FYLSegmentView *viewSegment;

@end

@implementation FYLPageViewController

//- (instancetype)initWithviewControllers:(NSArray *)viewControllers
//{
//    self = [super init];
//    if (self) {
//       // self.viewControllers = viewControllers;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
  //  self.title = @"PageViewController使用";
    //!!!!不能省略
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    //[self creatrNav];
    self.navigationController.navigationBar.translucent = YES;
    if([self.title isEqualToString:@"我的行程"]){
    self.navigationItem.leftBarButtonItem = [self itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentTotal:) name:@"routeTotalMessage" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=YES;
}

- (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 10, 20);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)back{

    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)presentTotal:(NSNotification*)text{

    float total = [text.userInfo[@"totalMileage"] floatValue];
    _viewSegment.totalLabel.text = [NSString stringWithFormat:@"我的总行驶里程:%.1lfkm",total];
    
}

-(void)creatrNav{

    UIBarButtonItem * item = [myLjjTools createRightNavItem:@"学生单" andFont:FontSize(15) andSelecter:@selector(studentClick) andTarget:self];
    self.navigationItem.rightBarButtonItem = item;

}

-(void)studentClick{
    studentListOrderViewController * order = [studentListOrderViewController new];
    [self.navigationController pushViewController:order animated:YES];
}

-(void)createUI{
    [self.view addSubview:self.viewSegment];
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
}

- (NSMutableArray *)viewControllers {
    
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
        
        for (int i = 1; i <= 1; i++) {
            myRouteViewController *vc = [[myRouteViewController alloc] init];
            vc.isHead = self.isHead;
            if(i==1){
            vc.indexSelectNum = 1;
            }else if(i==2){
            vc.indexSelectNum = 0;
            }else if(i==3){
            vc.indexSelectNum = 3;
            }
            [_viewControllers addObject:vc];
        }
    }
    return _viewControllers;
}


#pragma mark - FYLSegmentViewDelegate
- (void)FYLSegmentView:(FYLSegmentView *)segmentView didClickTagAtIndex:(NSInteger)index{
    
    if (index == _currentPage) {
        return;
    }
    
    __weak typeof(FYLPageViewController *)weakSelf = self;
    // 'forward'.0 is right-to-left,
    [self.pageVC setViewControllers:@[self.viewControllers[index]] direction:index<_currentPage animated:YES completion:^(BOOL finished) {
        _currentPage = index;
        
         [weakSelf.viewSegment setSelectBtn:index];

    }];
    
}


#pragma mark - UIPageViewControllerDataSource
// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.viewControllers count]) {
        return nil;
    }
    
    return self.viewControllers[index];
}
// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    
    return self.viewControllers[index];
}

#pragma mark - UIPageViewControllerDelegate

// 开始翻页调用
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {
    NSLog(@"开始翻页");
}
// 翻页完成调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    _done = YES;
    
    NSInteger index = [self.viewControllers indexOfObject:pageViewController.viewControllers[0]];
    _currentPage = index;
    [_viewSegment setSelectBtn:index];
    
    NSLog(@"翻页完成");
}
- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
    return UIInterfaceOrientationPortrait;
}


#pragma mark - Tool
// 根据数组元素，得到下标值
- (NSUInteger)indexOfViewController:(UIViewController *)viewControlller {
    return [self.viewControllers indexOfObject:viewControlller];
}
#pragma mark - SCrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //    LOG(@"滚动 = %f", scrollView.contentOffset.x-SCREEN_WIDTH);
//    NSInteger offsetX = scrollView.contentOffset.x-SCREEN_WIDTH;
//    
//    if (!_done) {
//
//        [_viewSegment sele];
//        
//    }else
//    {
//        _done = NO;
//    }
//}
#pragma mark - lazy load
//头部标签视图
- (FYLSegmentView *)viewSegment{
    
    if (!_viewSegment) {
        _viewSegment = [[FYLSegmentView alloc] initWithTitles:@[]];
        _viewSegment.delegate = self;
    }
    return _viewSegment;
 
}
- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        
        _pageVC.view.frame = CGRectMake(0, 64+38, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 38);
        
        for (UIView *subview in _pageVC.view.subviews) {
            
            [(UIScrollView *)subview setDelegate:self];
            //设置是否支持手势滑动
            //            [(UIScrollView *)subview setScrollEnabled:NO];
            
        }
        [_pageVC setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    return _pageVC;
}

@end
