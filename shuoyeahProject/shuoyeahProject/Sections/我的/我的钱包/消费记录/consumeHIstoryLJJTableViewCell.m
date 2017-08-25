//
//  consumeHIstoryLJJTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "consumeHIstoryLJJTableViewCell.h"

@implementation consumeHIstoryLJJTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadDataFrom:(consumeListModel *)model{

    self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf",model.Amount.floatValue];
    self.timeLabel.text = model.PayTime;
    self.startPlaceLabel.text = [NSString stringWithFormat:@"起  %@",model.startAddress];
    self.endPlaceLabel.text = [NSString stringWithFormat:@"终  %@",model.endAddress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
