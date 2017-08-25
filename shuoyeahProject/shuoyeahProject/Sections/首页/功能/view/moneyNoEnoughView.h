//
//  moneyNoEnoughView.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/12.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol gotoChargeMoneyDelegate <NSObject>
-(void)gotoChargeAction;
//-(void)continueTakeOrder;
@end
@interface moneyNoEnoughView : UIView
@property(nonatomic,assign)id<gotoChargeMoneyDelegate>delegate;
@end
