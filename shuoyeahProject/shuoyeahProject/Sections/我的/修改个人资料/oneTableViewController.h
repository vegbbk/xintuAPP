//
//  oneTableViewController.h
//  IMshuoyeah
//
//  Created by shuoyeah on 16/4/5.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobAndIndustModel.h"
@protocol selectHZdelegate <NSObject>
-(void)selectHZClick:(jobAndIndustModel*)model with:(NSInteger)number;
@end
@interface oneTableViewController : UITableViewController
@property (nonatomic,assign)id<selectHZdelegate>delegate;
@property (nonatomic,assign)NSInteger number;//1,行业.2职业
@property (nonatomic,copy)NSString * industryId;//行业id
@end
