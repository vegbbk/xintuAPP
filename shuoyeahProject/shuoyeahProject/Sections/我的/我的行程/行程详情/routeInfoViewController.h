//
//  routeInfoViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"
#import "routeListLJJModel.h"
@interface routeInfoViewController : baseLJJViewController
@property (nonatomic,strong)routeListLJJModel * routeModel;
@property (nonatomic,copy)NSString * indexSelectNum;
@property (nonatomic,copy)NSString * selectIndex;
@property (nonatomic,assign)BOOL isBackTop;
@end
