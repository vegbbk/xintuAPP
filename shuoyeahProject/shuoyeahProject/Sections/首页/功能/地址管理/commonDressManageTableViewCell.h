//
//  commonDressManageTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dressInfoLJJModel.h"
@protocol commonDressMangeDelegate  <NSObject>
-(void)deleteClick:(NSIndexPath*)indexPath;
-(void)editerClick:(NSIndexPath*)indexPath;
-(void)setDefault:(NSIndexPath*)indexPath;
@end
@interface commonDressManageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dressLabel;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,assign)id<commonDressMangeDelegate>delegate;
- (IBAction)writeClick:(UIButton *)sender;
- (IBAction)deleteClick:(UIButton *)sender;
- (IBAction)defaultClick:(UIButton *)sender;
-(void)loadDataFrom:(dressInfoLJJModel*)model;
@end
