//
//  sectionListModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/6.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "sectionListModel.h"

@implementation sectionListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        
        self.departID = value;
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
