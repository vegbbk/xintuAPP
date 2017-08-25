//
//  chargeDetailViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/12.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "routingingModel.h"
@interface chargeDetailViewController : UIViewController
@property(nonatomic,copy)NSString * moneyStr;
@property(nonatomic,strong)routingingModel * dataModel;
@end
