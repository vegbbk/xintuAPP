//
//  changePhoneNumViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/29.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"
@protocol changePhoneNumDelegate <NSObject>
-(void)changePhoneNumber:(NSString*)str;
@end
@interface changePhoneNumViewController : baseLJJViewController
@property (nonatomic,assign)id<changePhoneNumDelegate>delegate;
@end
