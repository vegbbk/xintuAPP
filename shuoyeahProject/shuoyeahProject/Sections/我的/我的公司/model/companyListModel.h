//
//  companyListModel.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/8.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface companyListModel : NSObject
@property(nonatomic,copy)NSString *departName;//部门名
@property(nonatomic,strong)NSArray *employees;//部门员工
@end
