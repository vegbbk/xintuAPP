//
//  complaintModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/26.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "complaintModel.h"

@implementation complaintModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        
        self.complaintID = value;
    }

}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
