//
//  picHeadSelectView.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol picHeadSelectDelegate <NSObject>
-(void)picHeadSelectName:(NSString *)nameStr;
@end
@interface picHeadSelectView : UIView
@property(nonatomic,assign)id<picHeadSelectDelegate>delegate;
@end
