//
//  messageAlert.h
//  IMshuoyeah
//
//  Created by shuoyeah on 16/5/9.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface messageAlert : NSObject
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}
- (id)initSystemShake;//系统 震动
- (void)play;//播放
-(void)playSound;
@end
