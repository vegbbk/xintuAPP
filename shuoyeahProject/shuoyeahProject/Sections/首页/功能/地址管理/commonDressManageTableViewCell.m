//
//  commonDressManageTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "commonDressManageTableViewCell.h"

@implementation commonDressManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.defaultBtn.imageRect = CGRectMake(0, 2, 14, 13);
    self.defaultBtn.titleRect = CGRectMake(18, 2, 52, 12);
    
    self.writeBtn.imageRect = CGRectMake(0, 1, 16, 14);
    self.writeBtn.titleRect = CGRectMake(16, 2, 30, 12);
    
    self.deleteBtn.imageRect = CGRectMake(0, 1, 16, 14);
    self.deleteBtn.titleRect = CGRectMake(16, 2, 30, 12);
    // Initialization code
}

-(void)loadDataFrom:(dressInfoLJJModel *)model{

    self.headImage.image = [UIImage imageNamed:PicHeadLifeArr[model.addIcon.integerValue]];
    self.titleLabel.text = model.addName;
    self.dressLabel.text = model.address;
    if(model.isDefault.integerValue==1){
    [self.defaultBtn setImage:[UIImage imageNamed:@"首页_常用地址_默认"] forState:UIControlStateNormal];
    }else{
    [self.defaultBtn setImage:[UIImage imageNamed:@"首页_常用地址_不默认"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)writeClick:(UIButton *)sender {
    [self.delegate editerClick:self.indexPath];
}

- (IBAction)deleteClick:(UIButton *)sender {
    [self.delegate deleteClick:self.indexPath];
}

- (IBAction)defaultClick:(UIButton *)sender {
    
    [self.delegate setDefault:self.indexPath];
    [sender setImage:[UIImage imageNamed:@"首页_常用地址_默认"] forState:UIControlStateNormal];
    
}
@end
