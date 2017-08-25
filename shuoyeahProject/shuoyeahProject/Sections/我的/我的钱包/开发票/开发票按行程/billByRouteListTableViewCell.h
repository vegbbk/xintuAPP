//
//  billByRouteListTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/5.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "billByRouteListModel.h"
@protocol billByRouteDelegate <NSObject>
-(void)billByRouteSelect:(NSIndexPath*)selectNum;
@end
@interface billByRouteListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headButton;
- (IBAction)headBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIImageView *beginImg;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *endImg;
@property (nonatomic,strong)NSIndexPath*indexPath;
@property (nonatomic,assign)id<billByRouteDelegate>delegate;
-(void)loadDataFrom:(BOOL)select withData:(billByRouteListModel*)model;
@end
