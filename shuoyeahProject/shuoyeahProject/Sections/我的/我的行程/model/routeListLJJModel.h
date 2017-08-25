//
//  routeListLJJModel.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/19.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface routeListLJJModel : NSObject
@property(nonatomic,copy)NSString * actEndTime;
@property(nonatomic,copy)NSString * addTime;
@property(nonatomic,copy)NSString * airplaneNum;
@property(nonatomic,copy)NSString * carId;
@property(nonatomic,copy)NSString * driverId;
@property(nonatomic,copy)NSString * driverStartTime;
@property(nonatomic,copy)NSString * endAddress;
@property(nonatomic,copy)NSString * endLngLat;
@property(nonatomic,copy)NSString * routeId;
@property(nonatomic,copy)NSString * isRound;
@property(nonatomic,copy)NSString * milage;
@property(nonatomic,copy)NSString * milageUnit;
@property(nonatomic,copy)NSString * orderSn;
@property(nonatomic,copy)NSString * preEndTime;
@property(nonatomic,copy)NSString * userHeadImg;
@property(nonatomic,copy)NSString * strokeNote;
@property(nonatomic,copy)NSString * startAddress;
@property(nonatomic,copy)NSString * roundTime;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * startTime;
@property(nonatomic,copy)NSString * strokeSn;
@property(nonatomic,copy)NSString * driverName;
@property(nonatomic,copy)NSString * driverHeadImg;
@property(nonatomic,copy)NSString * strokeId;
@property(nonatomic,copy)NSString * startLngLat;
@property(nonatomic,copy)NSString * driverHXAccount;

@property(nonatomic,copy)NSString * driverAge;
@property(nonatomic,copy)NSString * driverDrage;
@property(nonatomic,copy)NSString * driverScore;
@property(nonatomic,copy)NSString * driverPhone;

@property(nonatomic,copy)NSString * studentName;

@property(nonatomic,copy)NSString * status;//行程状态 //0,已取消,1,未开始,2进行中,3,已完成
@property(nonatomic,copy)NSString * orderPayStatus;//支付状态 0未支付,1已支付完成
@property(nonatomic,copy)NSString * strokeType;//学生单  5

@property(nonatomic,copy)NSString * orderPrePay;//预支付
@property(nonatomic,copy)NSString * orderActPay;

@property(nonatomic,copy)NSString * isComment;

@property(nonatomic,copy)NSString * carTypeName;//车型名称
@property(nonatomic,copy)NSString * carLicense;//车牌

@property(nonatomic,copy)NSString *strokeTypeName;

@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *isReceipt;

@property(nonatomic,copy)NSString *caregiverName;
@property(nonatomic,copy)NSString *caregiverPhone;

@property(nonatomic,copy)NSString *schoolType;//1：上学，2：放学
@end
