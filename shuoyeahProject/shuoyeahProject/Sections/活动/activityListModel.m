//
//  activityListModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/24.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "activityListModel.h"

@implementation activityListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        
        self.activetId = value;
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
