//
//  touSuMessageViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"

@interface touSuMessageViewController : baseLJJViewController
@property (nonatomic,assign)NSInteger typeNumber;//1 投诉建议 ,2取消行程理由,3
@property (nonatomic,copy)NSString * orderId;
@end
