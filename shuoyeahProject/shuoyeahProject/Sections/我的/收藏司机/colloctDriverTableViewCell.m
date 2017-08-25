//
//  colloctDriverTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "colloctDriverTableViewCell.h"

@implementation colloctDriverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:25 with:self.headImageView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTap)];
    [self.headImageView addGestureRecognizer:tap];
    // Initialization code
}

-(void)loadDataWith:(colloctDriverListModel *)model{
    self.peopleNumber = [myLjjTools createLabelTextWithView:self.peopleNumber andwithChangeColorTxt:@"11" withColor:MAINThemeColor];
    if(model.driverScore){
    [self loadStar:model.driverScore.integerValue];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",model.driverScore];
    }else{
    [self loadStar:0];
    self.scoreLabel.text = @"0分";
    }
    self.infoLabel.text = [NSString stringWithFormat:@"驾照:%@               驾龄:2年",model.driverCardNumber];
    if(model.persons){
    self.peopleNumber.text = [NSString stringWithFormat:@"%@人",model.persons];
    }else{
    self.peopleNumber.text = [NSString stringWithFormat:@"%@人",model.total];
    }
    self.nameLabel.text = model.driverName;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(model.driverHeadImg)] placeholderImage:[UIImage imageNamed:defaultHeadName]];
}

-(void)loadStar:(CGFloat)lengthNum{

    if(lengthNum>=1){
        self.starOne.image = [UIImage imageNamed:@"我的_星星_up"];
    }else{
        self.starOne.image = [UIImage imageNamed:@"我的_星星_d"];
    }
    if(lengthNum>=2){
        self.starTwo.image = [UIImage imageNamed:@"我的_星星_up"];
    }else{
        self.starTwo.image = [UIImage imageNamed:@"我的_星星_d"];
    }
    if(lengthNum>=3){
        self.starThree.image = [UIImage imageNamed:@"我的_星星_up"];
    }else{
        self.starThree.image = [UIImage imageNamed:@"我的_星星_d"];
    }
    if(lengthNum>=4){
        self.starFour.image = [UIImage imageNamed:@"我的_星星_up"];
    }else{
        self.starFour.image = [UIImage imageNamed:@"我的_星星_d"];
    }
    if(lengthNum>=5){
        self.starFive.image = [UIImage imageNamed:@"我的_星星_up"];
    }else{
        self.starFive.image = [UIImage imageNamed:@"我的_星星_d"];
    }
    
}

-(void)headImageTap{

    [self.delegate olloctDriverClick:self.indexPath];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
