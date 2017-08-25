//
//  billByRouteListTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/5.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "billByRouteListTableViewCell.h"

@implementation billByRouteListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:4.0 with:self.backView];
    self.headButton.touchAreaInsets = UIEdgeInsetsMake(30, 30, 30, 30);
       // Initialization code
}

-(void)loadDataFrom:(BOOL)select withData:(billByRouteListModel *)model{

    if(select){
         [self.headButton setImage:[UIImage imageNamed:@"我的_发票_选中"] forState:UIControlStateNormal];
    }else{
        
         [self.headButton setImage:[UIImage imageNamed:@"我的_发票_未选中"] forState:UIControlStateNormal];
    }
    
    self.priceLabel.text = unKnowToStr(model.orderActPay);
    self.orderNumLabel.text = unKnowToStr(model.orderSn);
    self.beginLabel.text = model.startAddress;
    self.endLabel.text= model.endAddress;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}


- (IBAction)headBtnClick:(UIButton *)sender {
    
       [self.delegate billByRouteSelect:self.indexPath];
}
@end
