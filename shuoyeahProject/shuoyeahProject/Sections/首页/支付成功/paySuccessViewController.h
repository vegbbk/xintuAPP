//
//  paySuccessViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/12.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"

@interface paySuccessViewController : baseLJJViewController
@property (weak, nonatomic) IBOutlet UIView *oneStarView;
@property (weak, nonatomic) IBOutlet UIView *twoStarView;
@property (weak, nonatomic) IBOutlet UIView *threeStarView;
@property (weak, nonatomic) IBOutlet UIView *fourStarView;
@property (weak, nonatomic) IBOutlet UIImageView *ZOneStar;
@property (weak, nonatomic) IBOutlet UIImageView *ZtwoStar;
@property (weak, nonatomic) IBOutlet UIImageView *ZthreeStar;
@property (weak, nonatomic) IBOutlet UIImageView *ZfourStar;
@property (weak, nonatomic) IBOutlet UIImageView *ZfiveStar;
@property (weak, nonatomic) IBOutlet UILabel *serveLabel;
@property (weak, nonatomic) IBOutlet UILabel *environmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *driveLabel;
- (IBAction)commitCommentClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *lineViewLJJ;
- (IBAction)complainClick:(UIButton *)sender;
@property (nonatomic,copy)NSString * orderSn;
@property (weak, nonatomic) IBOutlet UILabel *moneyTotalLabel;
@property (weak, nonatomic) IBOutlet UIButton *complainBtn;
@property (nonatomic,copy)NSString * strokeId;


@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentOne;
@property (weak, nonatomic) IBOutlet UIImageView *commentTwo;
@property (weak, nonatomic) IBOutlet UIImageView *commentThree;
@property (weak, nonatomic) IBOutlet UIImageView *commentFour;
@property (weak, nonatomic) IBOutlet UIImageView *commentFive;

@end
