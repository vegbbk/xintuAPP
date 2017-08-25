//
//  mapLJJTool.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/4/17.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "mapLJJTool.h"

@implementation mapLJJTool
//逆地理编码查询
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    //构造AMapReGeocodeSearchRequest对象，设置参数
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
   


}
@end
