//
//  jobAndIndustModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/8.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "jobAndIndustModel.h"

@implementation jobAndIndustModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        
        self.thinkID = value;
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
