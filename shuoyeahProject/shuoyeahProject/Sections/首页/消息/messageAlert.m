//
//  messageAlert.m
//  IMshuoyeah
//
//  Created by shuoyeah on 16/5/9.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "messageAlert.h"
@implementation messageAlert
- (id)initSystemShake
{
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

-(void)playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"liujianji" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:path]),&sound);
        AudioServicesPlaySystemSound(sound);
       
    }
    
    AudioServicesPlaySystemSound(sound);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (void)play
{
    AudioServicesPlaySystemSound(sound);
}
@end
