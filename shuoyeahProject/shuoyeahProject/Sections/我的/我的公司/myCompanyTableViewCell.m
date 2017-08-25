//
//  myCompanyTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/5.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "myCompanyTableViewCell.h"

@implementation myCompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:17.0 with:self.headImgeView];
    // Initialization code
}

-(void)loadDataFrom:(companyPeopleModel *)model{

    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.phone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
