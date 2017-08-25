//
//  carStyleTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/10.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "carStyleTableViewCell.h"

@implementation carStyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)loadDatawith:(BOOL)select{
    
    self.headImage.image = [UIImage imageNamed:@"首页_选择车型_经济车型"];
    if(select){
        self.styleLabel.textColor = MAINThemeColor;
        self.detailLabel.textColor = BlackColor;
        self.selectImg.image = [UIImage imageNamed:@"首页_选择车型_已选择"];
    }else{
    
        self.styleLabel.textColor = WHITEColor;
        self.detailLabel.textColor = WHITEColor;
        self.selectImg.image = [UIImage imageNamed:@"首页_选择车型_未选"];
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
