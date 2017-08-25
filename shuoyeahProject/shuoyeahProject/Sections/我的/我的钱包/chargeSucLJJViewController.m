//
//  chargeSucLJJViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/25.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "chargeSucLJJViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "routeInfoViewController.h"
@interface chargeSucLJJViewController ()

@end

@implementation chargeSucLJJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值成功";
    self.chageTextLabel.text = [NSString stringWithFormat:@"您已成功充值%.2lf元",self.moneyStr.floatValue];
    if(self.typeFrom==1){
        [self.swatchBtn setTitle:@"去钱包查看" forState:UIControlStateNormal];
    }else{
        [self.swatchBtn setTitle:@"继续下单" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)chageBtnClick:(UIButton *)sender {

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
@end
