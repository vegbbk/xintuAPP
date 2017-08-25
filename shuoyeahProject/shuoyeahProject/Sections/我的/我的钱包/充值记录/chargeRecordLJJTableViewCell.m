//
//  chargeRecordLJJTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/14.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "chargeRecordLJJTableViewCell.h"

@implementation chargeRecordLJJTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadDataFrom:(chargeHistoryModel *)model{

    switch (model.Channel.integerValue) {
        case 1:
             self.chargeTimeLabel.text = @"微信充值";
            break;
        case 2:
            self.chargeTimeLabel.text = @"支付宝充值";
            break;
        case 3:
            self.chargeTimeLabel.text = @"其他充值";
            break;

        default:
            break;
    }
    //self.changeTitleLabel.text = model.Channel;
    self.chargeTimeLabel.text = model.ChargeTime;
    self.moneyLabel.text = [NSString stringWithFormat:@"+%.2lf",model.Amount.floatValue];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
