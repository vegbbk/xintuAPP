//
//  chageljjMoneyModel.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/26.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chageljjMoneyModel : NSObject
@property (nonatomic , copy) NSString              * timestamp;
@property (nonatomic , copy) NSString              * partnerid;
@property (nonatomic , copy) NSString              * package;
@property (nonatomic , copy) NSString              * noncestr;
@property (nonatomic , copy) NSString              * sign;
@property (nonatomic , copy) NSString              * appid;
@property (nonatomic , copy) NSString              * prepayid;
@property (nonatomic , copy) NSString              * alipay;
@end
