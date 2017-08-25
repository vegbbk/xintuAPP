//
//  chageMoneyModel.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/9.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chageMoneyModel : NSObject
@property(nonatomic,copy)NSString * milageFee;
@property(nonatomic,copy)NSString * oneFreeMileage;
@property(nonatomic,copy)NSString * oneFreeTime;
@property(nonatomic,copy)NSString * overMileageFee;
@property(nonatomic,copy)NSString * feeType;//费用类型(1表示一口价,2表示正常计费)
@property(nonatomic,copy)NSString * overTimeFee;
@property(nonatomic,copy)NSString * roadBridgeFee;
@property(nonatomic,copy)NSString * startFee;
@property(nonatomic,copy)NSString * stopFee;
@property(nonatomic,copy)NSString * totalFee;
@property(nonatomic,copy)NSString * waitTimeFee;
@property(nonatomic,copy)NSString * timeFee;
@property(nonatomic,copy)NSString * nightFee;
@property(nonatomic,copy)NSString * dyMultiple;
@end

