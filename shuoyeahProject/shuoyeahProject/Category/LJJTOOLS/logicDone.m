//
//  logicDone.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/7.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "logicDone.h"
#import<CommonCrypto/CommonDigest.h>
@implementation logicDone

+(void)presentLoginView{

     [[NSNotificationCenter defaultCenter] postNotificationName:presentLoginViewMessage object:self userInfo:nil]; 
}

+(NSString *)timeWithData:(NSString*)dateStr{

    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 使用日期格式器格式化日期、时间
    NSDate* date1 = [dateFormatter dateFromString:dateStr];
    NSString *timeSp1 = [NSString stringWithFormat:@"%lld", ((long long)[date1 timeIntervalSince1970])];
    NSLog(@"凌晨时间戳:%@",timeSp1);
    return timeSp1;
}

+(NSString*)timeWithDateTime:(NSDate *)date{
    // 创建一个日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    // 使用日期格式器格式化日期、时间
    NSString *dayDateString = [dateFormatter stringFromDate:date];
    NSDate* date1 = [dateFormatter dateFromString:dayDateString];
    NSString *timeSp1 = [NSString stringWithFormat:@"%lld", ((long long)[date1 timeIntervalSince1970])];
    NSLog(@"凌晨时间戳:%@",timeSp1);
    return timeSp1;
}

+(NSString *)getCodeFromNet:(NSString *)phoneString{

    NSString * str=@"";
//    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
//    [parameters setObject:phoneString forKey:@"phone"];
//    WEAKSELF
//    [HttpRequest postWithURL:HTTP_URLIP(@"common/getSmsCodeForDev") params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
//        _codeStr = unKnowToStr(responseObject[@"data"][@"code"]);
//    } failure:^(NSError *error) {
//        
//    }];

    return str;
}

+(void)loginNormolWith{
    
    NSString *result = [self md5:@"1234"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userPhone forKey:@"userPhone"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].passAmin forKey:@"userPass"];
    [HttpRequest postWithURL:HTTP_URLIP(user_Login) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        
    } failure:^(NSError *error) {
        
    }];

}

+(NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

+(NSString*)timeIntChangeToStr:(NSString *)timeAStr{
    if(unKnowToStr(timeAStr).length<3||!timeAStr){
    return @"无";
    }
    NSTimeInterval time=[timeAStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
