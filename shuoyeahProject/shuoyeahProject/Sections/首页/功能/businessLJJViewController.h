//
//  businessLJJViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/6.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"

@interface businessLJJViewController : baseLJJViewController
@property(nonatomic,assign)NSInteger indexNum ;//1接送机  2周末游玩  3医院看病
@property(nonatomic,copy)NSString * typeItemNum;
@property(nonatomic,strong)MAMapView * mapView;//地图
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong)AMapLocationManager*locationManager;
@end
