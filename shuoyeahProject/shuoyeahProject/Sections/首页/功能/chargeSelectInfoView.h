//
//  chargeSelectInfoView.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/12.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "carStyleModel.h"
#import "chageMoneyModel.h"
@interface chargeSelectInfoView : UIView
-(id)initWithFrame:(CGRect)frame with:(chageMoneyModel*)model withCar:(carStyleModel*)carModel withLengh:(NSArray*)otherData;
@end
