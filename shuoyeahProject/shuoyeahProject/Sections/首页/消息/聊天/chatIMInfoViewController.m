//
//  chatIMInfoViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/4/17.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "chatIMInfoViewController.h"

@interface chatIMInfoViewController ()

@end

@implementation chatIMInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chatBarMoreView removeItematIndex:4];
    [self.chatBarMoreView removeItematIndex:3];
    // Do any additional setup after loading the view.
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
