//
//  routeInfoHeadTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "routeListLJJModel.h"
@protocol driverCallDelegate <NSObject>
-(void)driverCallClick;
-(void)driverPhoneCallClick;
@end
@interface routeInfoHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starOne;
@property (weak, nonatomic) IBOutlet UIImageView *starTwo;
@property (weak, nonatomic) IBOutlet UIImageView *starThree;
@property (weak, nonatomic) IBOutlet UIImageView *starFour;
@property (weak, nonatomic) IBOutlet UIImageView *starFive;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneCallBtn;

- (IBAction)IMchatClick:(UIButton *)sender;
- (IBAction)takePhoneClick:(UIButton *)sender;
-(void)loadDataFrom:(routeListLJJModel*)model;
@property (strong, nonatomic) UIButton *callDriverBtn;
@property (nonatomic,assign)id<driverCallDelegate>delegate;
@end
