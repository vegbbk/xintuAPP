//
//  selectWhereViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"
@protocol selectWhereSureDelegate <NSObject>

-(void)selectWhereSureClick:(NSString*)placeStr with:(AMapGeoPoint*)location with:(NSInteger)typeStr;

@end
@interface selectWhereViewController : baseLJJViewController
@property(nonatomic,assign)id<selectWhereSureDelegate>delegate;
@property(nonatomic,assign)NSInteger typeNum;//1上车地点,,2下车地点
@property(nonatomic,copy)NSString * cityString;

@end
