//
//  driverInfoLJJViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"
#import "colloctDriverListModel.h"
@protocol colloctActionFreshDelegate <NSObject>
-(void)colloctActionFreshData:(colloctDriverListModel*)model;
@end
@interface driverInfoLJJViewController : baseLJJViewController
@property(nonatomic,copy)NSString * driverId;//司机id
@property(nonatomic,strong)colloctDriverListModel * dataModel;//收藏id
@property(nonatomic,assign)id<colloctActionFreshDelegate>delegate;
@end
