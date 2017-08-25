//
//  dressInfoLJJModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/4.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "dressInfoLJJModel.h"

@implementation dressInfoLJJModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        
        self.dressID = value;
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
