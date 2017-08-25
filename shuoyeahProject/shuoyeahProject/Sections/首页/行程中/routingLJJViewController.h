//
//  routingLJJViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"
#import "routeListLJJModel.h"
@interface routingLJJViewController : baseLJJViewController
@property(nonatomic,copy)NSString * strokeSn;
@property(nonatomic,strong)routeListLJJModel * dataModel;
@end
