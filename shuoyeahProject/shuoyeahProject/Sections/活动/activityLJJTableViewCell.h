//
//  activityLJJTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/14.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "activityListModel.h"
@interface activityLJJTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headActiImage;//活动图
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
-(void)loadDataFrom:(activityListModel*)model;
@end
