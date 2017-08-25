//
//  routingInfoNewTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/7/6.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "routingInfoNewTableViewCell.h"

@implementation routingInfoNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeNameLabel.layer.cornerRadius = 4.0;
    self.typeNameLabel.clipsToBounds = YES;
    // Initialization code
}

- (IBAction)priceInfoClick:(UIButton *)sender {
  
    if (_ToPayIndexPath) {
        _ToPayIndexPath(@"2");
    }
    
}

-(void)laodDataFrom:(routeListLJJModel *)model{
    if(model.strokeTypeName){
    CGSize size = [myLjjTools countTxtWith:model.strokeTypeName andWithFont:FontSize(15) with:200];
    self.typeNameLabel.frame = CGRectMake(16, 6, size.width+8, 30);
    self.typeNameLabel.text = model.strokeTypeName;
    }else{
    self.typeNameLabel.frame = CGRectMake(16, 6, 60, 30);
    }
    if(model.carTypeName){
    CGSize size = [myLjjTools countTxtWith:model.carTypeName andWithFont:FontSize(15) with:200];
    self.carTypeLabel.frame = CGRectMake(CGRectGetMaxX(self.typeNameLabel.frame)+8, 12, size.width+8, 20);
    self.carTypeLabel.text = model.carTypeName;
    }else{
    self.carTypeLabel.frame = CGRectMake(CGRectGetMaxX(self.typeNameLabel.frame)+8, 12, 40, 20);
    }
    self.otherLabel.frame = CGRectMake(CGRectGetMaxX(self.carTypeLabel.frame)+8, 15, SCREEN_WIDTH-CGRectGetMaxX(self.carTypeLabel.frame)-10, 16);
    if(model.strokeNote){
        self.otherLabel.text = model.strokeNote;
    }
    if(!model.airplaneNum){
    model.airplaneNum = @"";
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 预计%@司机到达",model.airplaneNum,[logicDone timeIntChangeToStr:model.startTime]];
    self.startPlaceLabel.text = model.startAddress;
    self.endPlaceLabel.text = model.endAddress;
    if(model.status.integerValue==3){
       self.priceBtn.hidden = NO;
    }
    if(self.timeLabel.hidden){
        if(model.carLicense){
            self.otherLabel.text = model.carLicense;
        }else{
            self.otherLabel.text = @"暂无";
        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
