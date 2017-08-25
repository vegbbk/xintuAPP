//
//  colloctDriverTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "colloctDriverListModel.h"
@protocol colloctDriverActionDelegate <NSObject>
-(void)olloctDriverClick:(NSIndexPath*)indexPath;
@end
@interface colloctDriverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;//驾照驾龄
@property (weak, nonatomic) IBOutlet UIImageView *starOne;
@property (weak, nonatomic) IBOutlet UIImageView *starTwo;
@property (weak, nonatomic) IBOutlet UIImageView *starThree;
@property (weak, nonatomic) IBOutlet UIImageView *starFour;
@property (weak, nonatomic) IBOutlet UIImageView *starFive;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;//分数
@property (weak, nonatomic) IBOutlet UILabel *peopleNumber;//评价人数
@property (nonatomic,strong)NSIndexPath*indexPath;
@property (nonatomic,assign)id<colloctDriverActionDelegate>delegate;
-(void)loadDataWith:(colloctDriverListModel*)model;
@end
