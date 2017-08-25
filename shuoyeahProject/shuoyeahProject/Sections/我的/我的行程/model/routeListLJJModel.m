//
//  routeListLJJModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/19.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "routeListLJJModel.h"

@implementation routeListLJJModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        
        self.strokeId = value;
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
