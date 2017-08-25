//
//  myCompanyViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/5.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"
@interface GroupDataModel : NSObject

@property (nonatomic, copy) NSString *groupTitle;
@property (nonatomic, copy) NSArray *groupData;

@end

@interface myCompanyViewController : baseLJJViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSMutableArray *arrayData;
@end
