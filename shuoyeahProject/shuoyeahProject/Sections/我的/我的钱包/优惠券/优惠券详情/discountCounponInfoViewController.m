//
//  discountCounponInfoViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "discountCounponInfoViewController.h"

@interface discountCounponInfoViewController ()

@end

@implementation discountCounponInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠券详情";
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI{

    UILabel * denominationLabel =[myLjjTools createLabelWithFrame:CGRectMake(15, 26+64, SCREEN_WIDTH-30, 15) andTitle:[NSString stringWithFormat:@"优惠面额   %@元",self.model.amount] andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:denominationLabel];

    UILabel * useStateLabel =[myLjjTools createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(denominationLabel.frame)+21, SCREEN_WIDTH-30, 15) andTitle:@"使用状态   待使用" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    if(_model.amount.integerValue==0){
        useStateLabel.text = @"使用状态   已使用";
    }
    [self.view addSubview:useStateLabel];
    
    UILabel * usefulLifeLabel =[myLjjTools createLabelWithFrame:CGRectMake(15, CGRectGetMaxY(useStateLabel.frame)+21, SCREEN_WIDTH-30, 15) andTitle:[NSString stringWithFormat:@"有效期   %@前",[logicDone timeIntChangeToStr:intToStr(_model.expireTime.integerValue)]] andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [self.view addSubview:usefulLifeLabel];

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, CGRectGetMaxY(usefulLifeLabel.frame)+21, 90, 19);
    [button setTitle:@"使用说明" forState:UIControlStateNormal];
    button.titleLabel.font = FontSize(15);
    [button setTitleColor:RGB170 forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"我的_使用规则"] forState:UIControlStateNormal];
    button.imageRect = CGRectMake(0, 2, 15, 15);
    button.titleRect = CGRectMake(20, 2, 70, 15);
    [button addTarget:self action:@selector(whatUseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

-(void)whatUseClick{



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
