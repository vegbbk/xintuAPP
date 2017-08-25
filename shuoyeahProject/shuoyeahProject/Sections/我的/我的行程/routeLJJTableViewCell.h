//
//  routeLJJTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "routeListLJJModel.h"
@protocol cancelRouteDelegate <NSObject>
-(void)cancelRouteClick:(NSIndexPath*)indexPath;
-(void)chatWithDriverClick:(NSIndexPath*)indexPath;
-(void)takePhoneWithDriver:(NSIndexPath*)indexPath;
@end
@interface routeLJJTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentName;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (nonatomic,assign)id<cancelRouteDelegate>delegate;
@property (strong, nonatomic) UIButton *callDriverBtn;
@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,copy)NSString * phoneStr;
- (IBAction)cancelClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chatWithDriverBtn;
@property (weak, nonatomic) IBOutlet UIButton *takePhoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *driverCarIDLabel;
- (IBAction)chatBtnClick:(UIButton *)sender;
- (IBAction)takePhoneClick:(UIButton *)sender;
-(void)loadDataFrom:(NSInteger)number withData:(routeListLJJModel*)model;
@property (weak, nonatomic) IBOutlet UILabel *stauteLabel;
@end
