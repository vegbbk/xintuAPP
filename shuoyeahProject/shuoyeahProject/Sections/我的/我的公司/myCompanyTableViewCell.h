//
//  myCompanyTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/5.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "companyPeopleModel.h"
@interface myCompanyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgeView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
-(void)loadDataFrom:(companyPeopleModel*)model;
@end
