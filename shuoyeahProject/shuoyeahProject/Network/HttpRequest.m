//
//  HttpRequest.m
//  WorldHome
//
//  Created by yyt on 14-11-28.
//  Copyright (c) 2014年 yyt. All rights reserved.
//

#import "HttpRequest.h"
#import "AFURLSessionManager.h"
#import "AFHTTPSessionManager.h"
#import <CommonCrypto/CommonDigest.h>
//#import "HttpClient.h"
@implementation HttpRequest
/**
 *  发送get请求
 */
+ (void)getWithURL:(NSString *)url params:(NSMutableDictionary *)params success:(Success)success failure:(Failure)failure
{
    // 1.创建请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 12;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [SVProgressHUD show];
    
    // 2.发送请求
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        //这里可以获取进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        [SVProgressHUD dismiss];
        if (success) {
             success(responseObject);
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (failure) {
            if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
                [SVProgressHUD showErrorWithStatus:defaultFailNet];
            }
            failure(error);
        }
        
    }];
    
}

/**
 *  发送POST请求
 */

+ (void)postWithURL:(NSString *)url params:(NSMutableDictionary *)params andNeedHub:(BOOL)isYES success:(Success)success failure:(Failure)failure
{
    //获取当前时间戳
    NSString * string = [NSString stringWithFormat:@"%@%@%@",HTTPappSecret,HTTPnonce,@"131"];
    string = [HttpRequest getsha:string];
    // 1.创建请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 12;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager.requestSerializer setValue:HTTPappKey forHTTPHeaderField:@"appKey"];
    [manager.requestSerializer setValue:HTTPappSecret forHTTPHeaderField:@"appSecret"];
    [manager.requestSerializer setValue:HTTPnonce forHTTPHeaderField:@"nonce"];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"signature"];
    [manager.requestSerializer setValue:@"131" forHTTPHeaderField:@"curTime"];
    if (isYES) {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
     //这里可以获取进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSData *responseData1 = responseObject;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseDict);
        if (isYES) {
            [SVProgressHUD dismiss];
        }
        if([unKnowToStr(responseDict[@"status"]) isEqualToString:@"true"]||[responseDict[@"status"] integerValue]==200||[unKnowToStr(responseDict[@"status"]) isEqualToString:@"balance"]){
           // NSLog(@"数据--------------%@",responseDict[@"data"]);
            if (success) {
                success(responseDict);
            }
        }else{
          NSError * _Nonnull error;
          if (failure) {
              failure(error);
          }
            if([url isEqualToString:HTTP_URLIP(get_EnterpriseDetail)]){
            
            }else{
            [[UIApplication sharedApplication].keyWindow makeToast:unKnowToStr(responseDict[@"msg"]) duration:1.5 position:CSToastPositionCenter];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    if (failure) {
        if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
            if (isYES) {
                [SVProgressHUD dismiss];
            }
             [[UIApplication sharedApplication].keyWindow makeToast:defaultFailNet duration:1.5 position:CSToastPositionCenter];
            }
        failure(error);
    }

    }];    
}

+(NSString*)getsha:(NSString*)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

/**
 *  上传图片一张或多张
 */

+ (void) postImageWithURL:(NSString*)url
                      params:(NSMutableDictionary*)params
                        path:(NSArray *)paths
                      photos:(NSArray*)images
                     success:(Success)success
                     failure:(Failure)failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置返回格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"charset=UTF-8", nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 请求不使用AFN默认转换,保持原有数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // 响应不使用AFN默认转换,保持原有数据
    NSString * string = [NSString stringWithFormat:@"%@%@%@",HTTPappSecret,HTTPnonce,@"131"];
    string = [HttpRequest getsha:string];
    [manager.requestSerializer setValue:HTTPappKey forHTTPHeaderField:@"appKey"];
    [manager.requestSerializer setValue:HTTPappSecret forHTTPHeaderField:@"appSecret"];
    [manager.requestSerializer setValue:HTTPnonce forHTTPHeaderField:@"nonce"];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"signature"];
    [manager.requestSerializer setValue:@"131" forHTTPHeaderField:@"curTime"];

    // 2.发送请求
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for(int i = 0;i<images.count;i++){
            UIImage * image = images[i];
            NSString * path = paths[i];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.1) name:path fileName:fileName mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //这里可以获取进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *responseData1 = responseObject;
        [SVProgressHUD dismiss];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableContainers error:nil];
        if([unKnowToStr(responseDict[@"status"]) isEqualToString:@"true"]){
        if (success)
        {
            success(responseDict);
        }
        }else{
            NSError * _Nonnull error;
            if (failure) {
                failure(error);
            }
            [[UIApplication sharedApplication].keyWindow makeToast:unKnowToStr(responseDict[@"msg"]) duration:1.5 position:CSToastPositionCenter];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (failure)
        {
            failure(error);
        }
        
        
    }];
    
}

/**
 *  下载
 *
 *  @param URLString       请求的链接
 *  @param progress        进度的回调
 *  @param destination     返回URL的回调
 *  @param downLoadSuccess 下载成功的回调
 *  @param failure         下载失败的回调
 */
+ (NSURLSessionDownloadTask *)downLoadWithURL:(NSString *)URLString progress:(Progress)progress destination:(Destination)destination downLoadSuccess:(DownLoadSuccess)downLoadSuccess failure:(Failure)failure;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress)
        {
            progress(downloadProgress); // HDLog(@"%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (destination)
        {
            return destination(targetPath, response);
        }
        else
        {
            return nil;
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error)
        {
            failure(error);
        }
        else
        {
            downLoadSuccess(response, filePath);
        }
    }];
    
    // 开始启动任务
    [task resume];
    
    return task;
}



@end
