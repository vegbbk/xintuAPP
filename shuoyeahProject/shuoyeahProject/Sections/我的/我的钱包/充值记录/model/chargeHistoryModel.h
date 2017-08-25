//
//  chargeHistoryModel.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/16.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chargeHistoryModel : NSObject
@property (nonatomic , copy) NSString              * ChargeTime;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * ChargeUserId;
@property (nonatomic , copy) NSString              * AccountId;
@property (nonatomic , copy) NSString              * Amount;
@property (nonatomic , copy) NSString              * Channel;

@end
