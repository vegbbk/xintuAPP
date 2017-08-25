//
//  chatRoomListTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/4/17.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "chatRoomListTableViewCell.h"

@implementation chatRoomListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:25.0 with:self.headImage];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:8.0 with:self.numberLabel];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
