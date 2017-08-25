//
//  myMessageListViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "myMessageListViewController.h"
#import "systemNewsListViewController.h"
#import "chatRoomListViewController.h"
@interface myMessageListViewController ()<UIScrollViewDelegate>{

    UISegmentedControl * segMent;
}
@property (nonatomic, weak) UIScrollView *contentScrollView;
@end

@implementation myMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContentScrollView];
    [self addChildViewController];
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * SCREEN_WIDTH, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    [self createTitleView];
    // Do any additional setup after loading the view.
}

-(void)createTitleView{

    segMent = [[UISegmentedControl alloc]initWithItems:@[@"聊天室",@"系统消息"]];
    segMent.frame = CGRectMake(0, 0, 141, 31);
    segMent.tintColor = WHITEColor;
    segMent.selectedSegmentIndex = 0;
    UIFont *font = FontSize(15);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segMent setTitleTextAttributes:attributes
                           forState:UIControlStateNormal];
    self.navigationItem.titleView = segMent;
    [segMent addTarget:self action:@selector(segchange:) forControlEvents:UIControlEventValueChanged];
    
    [self setUpOneChildViewController:0];

}

-(void)segchange:(UISegmentedControl *)segmentControl{
    NSLog(@"%ld",segmentControl.selectedSegmentIndex);
    self.contentScrollView.contentOffset = CGPointMake(segmentControl.selectedSegmentIndex*SCREEN_WIDTH, 0);
    [self setUpOneChildViewController:segmentControl.selectedSegmentIndex];
}


#pragma mark - 设置内容
- (void)setupContentScrollView
{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
  
    [self.view addSubview:contentScrollView];
    
    self.contentScrollView = contentScrollView;
}

#pragma mark - 添加子控制器
- (void)addChildViewController
{
    // NSLog(@"%@",);
    
    chatRoomListViewController * chat = [[chatRoomListViewController alloc]init];
    
    [self addChildViewController:chat];
    
    systemNewsListViewController * system = [[systemNewsListViewController alloc]init];
    
     [self addChildViewController:system];
}

- (void)setUpOneChildViewController:(NSUInteger)i
{
    CGFloat x = i * SCREEN_WIDTH;
    
    UIViewController *vc = self.childViewControllers[i];
    
    if (vc.view.superview) {
        
        return;
    }
    vc.view.frame = CGRectMake(x, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.contentScrollView.frame.origin.y);
    
    [self.contentScrollView addSubview:vc.view];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger i = self.contentScrollView.contentOffset.x / SCREEN_WIDTH;
     NSLog(@"%ld",i);
    segMent.selectedSegmentIndex = i;
    [self setUpOneChildViewController:i];
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
