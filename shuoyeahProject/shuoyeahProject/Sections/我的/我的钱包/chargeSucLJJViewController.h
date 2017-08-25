//
//  chargeSucLJJViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/25.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "routeListLJJModel.h"
@interface chargeSucLJJViewController : UIViewController
- (IBAction)chageBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *chageTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *swatchBtn;
@property(nonatomic,copy)NSString * moneyStr;
@property (nonatomic,assign)NSInteger typeFrom;//1充值2余额不足充值;
@property (nonatomic,strong)routeListLJJModel * routDataModel;
@end
