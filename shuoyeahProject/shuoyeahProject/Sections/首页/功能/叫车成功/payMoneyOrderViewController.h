//
//  payMoneyOrderViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/25.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payMoneyOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *totalMoneyLaebl;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (nonatomic,copy)NSString * orderSn;
@property (weak, nonatomic) IBOutlet UILabel *weichatPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *alipayLabel;
@property (nonatomic,copy)NSString * moneyStr;
- (IBAction)balanceClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *weiPayBtn;
- (IBAction)weiPayClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
- (IBAction)alipayClick:(UIButton *)sender;
- (IBAction)surePayMoneyClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *surePayBtn;
@property (weak, nonatomic) IBOutlet UIView *backWAPayView;
@property (weak, nonatomic) IBOutlet UIView *banlanceView;
@property (nonatomic,strong)UIButton * balancePayBtn;
@property (weak, nonatomic) IBOutlet UILabel *diffMoneyLabel;
@property (nonatomic,assign)NSInteger typeCate;//1余额支付,2正常支付
@end
