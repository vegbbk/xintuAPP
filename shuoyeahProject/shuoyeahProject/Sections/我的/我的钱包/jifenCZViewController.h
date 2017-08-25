//
//  jifenCZViewController.h
//  shuoyeahProject
//
//  Created by shuoyeah on 16/8/17.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "routeListLJJModel.h"
@interface jifenCZViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *weixPayClick;

- (IBAction)weixAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *wangyButton;
@property (strong, nonatomic) IBOutlet UIButton *surePayButton;//确认支付
@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;//金额
@property (weak, nonatomic) IBOutlet UILabel *unionPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *kuaiqianLabel;
@property (nonatomic,assign)NSInteger typeFrom;//1充值2余额不足充值
@property (nonatomic,strong)routeListLJJModel * routDataModel;
- (IBAction)wangyinClick:(UIButton *)sender;
- (IBAction)sureClick:(UIButton *)sender;
@end
