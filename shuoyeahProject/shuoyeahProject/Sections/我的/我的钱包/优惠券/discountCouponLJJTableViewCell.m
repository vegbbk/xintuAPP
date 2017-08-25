//
//  discountCouponLJJTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "discountCouponLJJTableViewCell.h"

@implementation discountCouponLJJTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadDataFrom:(discountCouponListModel *)model{

    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",model.amount.floatValue];
    self.titleLabel.text = model.name;
    self.infoLabel.text = model.content;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[logicDone timeIntChangeToStr:intToStr(model.expireTime.integerValue)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
