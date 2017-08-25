//
//  colloctDriverListModel.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/2.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface colloctDriverListModel : NSObject
@property(nonatomic,copy)NSString * driverHeadImg;
@property(nonatomic,copy)NSString *driverName;
@property(nonatomic,copy)NSString *driverScore;
@property(nonatomic,copy)NSString *driId;//司机id
@property(nonatomic,copy)NSString *colId;//收藏id
@property(nonatomic,copy)NSString *total;//下单量
@property(nonatomic,copy)NSString *driverCardNumber;//驾照
@property(nonatomic,copy)NSString *persons;
@end
