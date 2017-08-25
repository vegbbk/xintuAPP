//
//  colloctDriverListModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/2.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "colloctDriverListModel.h"

@implementation colloctDriverListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
    
        self.driId = value;
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
