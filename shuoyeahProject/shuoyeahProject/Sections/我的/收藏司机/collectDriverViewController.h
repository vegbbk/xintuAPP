//
//  collectDriverViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/29.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseLJJViewController.h"
@protocol selectDriverNameDelegate <NSObject>
-(void)selectDriverSureName:(NSString *)string withID:(NSString*)driverID;
@end
@interface collectDriverViewController : baseLJJViewController
@property(nonatomic,assign)NSInteger typeNum;//1收藏司机 2选择司机
@property(nonatomic,assign)id<selectDriverNameDelegate>delegate;
@property(nonatomic,copy)NSString * startTime;
@property(nonatomic,copy)NSString * endTime;
@end
