//
//  routingingModel.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/6/7.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface routingingModel : NSObject
@property (nonatomic, copy)NSString * totalFee;//总费用
@property (nonatomic, copy)NSString * preTime;//预计到达时间
@property (nonatomic, copy)NSString * preMileage;//剩余里程
@property (nonatomic, copy)NSString * typeCarID;
@property (nonatomic, copy)NSString * waitTimeFee;//等时费
@property (nonatomic, copy)NSString * overTakeMileageFee;//超出行程费
@property (nonatomic, copy)NSString * overMileageFee;//,超出里程费
@property (nonatomic, copy)NSString * stopFee;//停车费
@property (nonatomic, copy)NSString * feeType;//费用类型
@property (nonatomic, copy)NSString * nightFee;//夜间费
@property (nonatomic, copy)NSString * roadBridgeFee;//路桥费
@property (nonatomic, copy)NSString * overTimeFee;//一口价超出免费里程费
@property (nonatomic, copy)NSString * oneFreeTime;//一口价时长费
@property (nonatomic, copy)NSString * overTakeTimeFee;//超出接送乘客时长费
@property (nonatomic, copy)NSString * alreadyMileage;
@property (nonatomic, copy)NSString * startFee;//起步费
@property (nonatomic, copy)NSString * milageFee;//里程费
@property (nonatomic, copy)NSString * timeFee;//时长费
@property (nonatomic, copy)NSString * dyMultiple;
@property (nonatomic, copy)NSString * leastFee;
@end

