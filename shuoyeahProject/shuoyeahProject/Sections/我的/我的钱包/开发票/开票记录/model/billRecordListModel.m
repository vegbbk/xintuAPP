//
//  billRecordListModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/24.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "billRecordListModel.h"

@implementation billRecordListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        self.billRecordid = value;
    }
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
