//
//  chargeRecordLJJTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/14.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chargeHistoryModel.h"
@interface chargeRecordLJJTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *changeTitleLabel;//充值标题
@property (weak, nonatomic) IBOutlet UILabel *chargeTimeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//钱
-(void)loadDataFrom:(chargeHistoryModel*)model;
@end
