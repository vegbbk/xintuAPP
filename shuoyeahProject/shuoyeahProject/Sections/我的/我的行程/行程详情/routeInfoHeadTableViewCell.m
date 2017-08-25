//
//  routeInfoHeadTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "routeInfoHeadTableViewCell.h"

@implementation routeInfoHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.callDriverBtn.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 0);
    self.phoneCallBtn.touchAreaInsets = UIEdgeInsetsMake(10, 0, 10, 8);
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:39 with:self.headImageView];
}

- (IBAction)IMchatClick:(UIButton *)sender {
    [self.delegate driverCallClick];
}

- (IBAction)takePhoneClick:(UIButton *)sender {
    
    [self.delegate driverPhoneCallClick];
    
}

-(void)loadDataFrom:(routeListLJJModel *)model{

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(model.driverHeadImg)] placeholderImage:[UIImage imageNamed:defaultHeadName]];
    self.nameLabel.text = model.driverName;
    if(!model.driverName){
        model.driverName = @"";
    }
    CGSize size = [myLjjTools countTxtWith:model.driverName andWithFont:FontSize(17) with:200];
    self.callDriverBtn.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+22+size.width, 20, 23, 22);
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",model.driverScore];
    [self loadStar:model.driverScore.integerValue];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
