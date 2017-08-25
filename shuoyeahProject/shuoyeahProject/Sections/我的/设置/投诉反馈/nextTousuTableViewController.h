//
//  nextTousuTableViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "complaintModel.h"
@protocol typeSelectDelegate <NSObject>
-(void)selectSureType:(complaintModel*)model;
@end
@interface nextTousuTableViewController : UITableViewController
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,assign)id<typeSelectDelegate>delegate;
@end
