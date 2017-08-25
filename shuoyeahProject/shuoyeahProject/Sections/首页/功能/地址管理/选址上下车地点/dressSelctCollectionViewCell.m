//
//  dressSelctCollectionViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "dressSelctCollectionViewCell.h"

@implementation dressSelctCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadData{

    self.headImage.image = [UIImage imageNamed:@"首页_选择上车_添加"];
    self.nameLabel.text = @"添加";
}
@end
