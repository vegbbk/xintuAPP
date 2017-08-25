//
//  selectMapDressViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "selectMapDressViewController.h"

@interface selectMapDressViewController ()

@end

@implementation selectMapDressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRightNav];
    UITextField * search = [[UITextField alloc]initWithFrame:CGRectMake(15, 6, SCREEN_WIDTH-30, 30)];
    search.placeholder = @"搜索地点";
    search.font = FontSize(15);
    search.layer.cornerRadius = 15;
    search.layer.borderColor = LINECOLOR.CGColor;
    search.layer.borderWidth =1;
    UIView * view = [myLjjTools createViewWithFrame:CGRectMake(0, 0, 43, 20) andBgColor:CLEARCOLOR];
    UIImageView * image = [myLjjTools createImageViewWithFrame:CGRectMake(23, 0, 20, 20) andImageName:@"我的_搜索放大镜" andBgColor:nil];
    [view addSubview:image];
    search.leftViewMode = UITextFieldViewModeAlways;
    search.leftView = view;
    [self.view addSubview:search];

    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    MAMapView *_mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH,heiSize(270))];
    ///把地图添加至view
    [self.view addSubview:_mapView];

    // Do any additional setup after loading the view.
}
#pragma mark --------------确认----------------------
-(void)createRightNav{
    
    UIBarButtonItem * item = [myLjjTools createRightNavItem:@"确定" andFont:FontSize(17) andSelecter:@selector(sureAction) andTarget:self];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)sureAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
