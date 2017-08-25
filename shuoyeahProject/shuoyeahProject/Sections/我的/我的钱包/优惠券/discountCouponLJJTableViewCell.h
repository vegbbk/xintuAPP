//
//  discountCouponLJJTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "discountCouponListModel.h"
@interface discountCouponLJJTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)loadDataFrom:(discountCouponListModel*)model;

@end
