//
//  mapViewLJJTools.m
//  shuoyeahProject
//
//  Created by 刘建基 on 2017/6/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "mapViewLJJTools.h"

@implementation mapViewLJJTools
+ (AMapNaviDriveManager *)sharedAMapNaviDriveManager
{
    static AMapNaviDriveManager *socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [[AMapNaviDriveManager alloc] init];
    });
    return socket;
}
@end
