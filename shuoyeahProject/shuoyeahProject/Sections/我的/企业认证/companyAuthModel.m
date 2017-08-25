//
//  companyAuthModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/9.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "companyAuthModel.h"

@implementation companyAuthModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        
        self.companyID = value;
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
