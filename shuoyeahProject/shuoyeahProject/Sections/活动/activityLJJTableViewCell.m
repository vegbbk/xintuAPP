//
//  activityLJJTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/14.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "activityLJJTableViewCell.h"

@implementation activityLJJTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadDataFrom:(activityListModel *)model{

    [self.headActiImage sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(model.activeImg)] placeholderImage:[UIImage imageNamed:@"活动_banner"]];
    self.titleLabel.text = model.activeTitle;
    self.infoLabel.text = model.activeContent;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
