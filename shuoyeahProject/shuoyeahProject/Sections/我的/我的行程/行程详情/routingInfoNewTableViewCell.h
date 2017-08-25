//
//  routingInfoNewTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/7/6.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "routeListLJJModel.h"
#import "ljjTopLabel.h"
@interface routingInfoNewTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^ToPayIndexPath)(NSString * str);
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPlaceLabel;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
- (IBAction)priceInfoClick:(UIButton *)sender;

-(void)laodDataFrom:(routeListLJJModel *)model;

@end
