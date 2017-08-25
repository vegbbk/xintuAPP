//
//  commentTypeListModel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "commentTypeListModel.h"

@implementation commentTypeListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if([key isEqualToString:@"id"]){
        
        self.commentTypeID = value;
    }
    
}

- (instancetype)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
