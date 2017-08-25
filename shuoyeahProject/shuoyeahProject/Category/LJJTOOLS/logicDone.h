//
//  logicDone.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/7.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface logicDone : NSObject

//@property(nonatomic,copy)NSString * codeStr;

/**
 判断是否弹出登录界面
 */
+(void)presentLoginView;
//转化时间错
+(NSString *)timeWithData:(NSString*)dateStr;

+(NSString *)timeWithDateTime:(NSDate*)date;
//获取验证码
+(NSString *)getCodeFromNet:(NSString*)phoneString;

+(void)loginNormolWith;
//时间错转换为时间
+(NSString *)timeIntChangeToStr:(NSString *)timeAStr;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
