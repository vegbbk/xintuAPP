//
//  carStyleModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/2.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "carStyleModel.h"

@implementation carStyleModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.typeCarID = value;
    }    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
