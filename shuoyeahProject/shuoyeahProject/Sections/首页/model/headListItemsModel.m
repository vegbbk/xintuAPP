//
//  headListItemsModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/24.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "headListItemsModel.h"

@implementation headListItemsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        
        self.itemId = value;
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
