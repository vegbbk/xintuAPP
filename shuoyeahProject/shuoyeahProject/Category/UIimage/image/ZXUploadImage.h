//
//  ZXUploadImage.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/8.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//


#import <Foundation/Foundation.h>
//吧单例方法定义为宏，使用起来更方便
#define ZXUPLOAD_IMAGE [ZXUploadImage shareUploadImage]
//写了一个代理方法
@protocol ZXUploadImageDelegate <NSObject>
@optional
- (void)uploadImageToServerWithImage:(UIImage *)image;
@end
@interface ZXUploadImage : NSObject < UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>
{
    //如果你调不出来UIViewController,请添加UIKit头文件
    UIViewController *_fatherViewController;
    BOOL isTailoring;
}
@property (nonatomic, weak) id <ZXUploadImageDelegate> uploadImageDelegate;
//单例方法
+ (ZXUploadImage *)shareUploadImage;
//弹出选项的方法
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC isTailoring:(BOOL)isChoose
delegate:(id<ZXUploadImageDelegate>)aDelegate;
@end
