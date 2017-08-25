//
//  discountCouponListModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/24.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "discountCouponListModel.h"

@implementation discountCouponListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        self.discountCouponListId = value;
    }
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
