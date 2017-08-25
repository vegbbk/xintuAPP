//
//  consumeHIstoryLJJTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "consumeListModel.h"
@interface consumeHIstoryLJJTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPlaceLabel;
-(void)loadDataFrom:(consumeListModel*)model;

@end
