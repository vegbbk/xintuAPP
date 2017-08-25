//
//  ZXUploadImage.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/8.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "ZXUploadImage.h"
#import "HKImageClipperViewController.h"
static ZXUploadImage *zxUploadImage = nil;
@implementation ZXUploadImage
+ (ZXUploadImage *)shareUploadImage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zxUploadImage = [[ZXUploadImage alloc] init];
    });
    return zxUploadImage;
}
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC isTailoring:(BOOL)isChoose
                                     delegate:(id<ZXUploadImageDelegate>)aDelegate {
    zxUploadImage.uploadImageDelegate = aDelegate;
    _fatherViewController = fatherVC;
    isTailoring = isChoose;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
          [self fromPhotos];
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       
         [self createPhotoView];
    }]];
    [fatherVC presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark - 头像(相机和从相册中选择)
- (void)createPhotoView {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
        imagePC.sourceType                = UIImagePickerControllerSourceTypeCamera;
        imagePC.delegate                  = self;
        imagePC.allowsEditing             = !isTailoring;
        [_fatherViewController presentViewController:imagePC
                                            animated:YES
                                          completion:^{
                                          }];
        
    }else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"该设备没有照相机"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
        [alert show];
    }
}
//图片库方法(从手机的图片库中查找图片)
- (void)fromPhotos {
    
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    imagePC.sourceType                = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePC.delegate                  = self;
    imagePC.allowsEditing             = !isTailoring;
    [_fatherViewController presentViewController:imagePC
                                        animated:YES
                                      completion:^{
                                      }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if(isTailoring){
        UIImage*image = [self turnImageWithInfo:info];
        HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                         resultImgSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH *3/4.0) clipperType:ClipperTypeImgMove];
        clipperVC.cancelClippedHandler = ^(){
            [picker dismissViewControllerAnimated:YES completion:nil];
        };
        clipperVC.successClippedHandler = ^(UIImage *clippedImage){
            
            if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithImage:)]) {
                [self.uploadImageDelegate uploadImageToServerWithImage:clippedImage];
            }
             [picker dismissViewControllerAnimated:YES completion:nil];
        };
        [picker pushViewController:clipperVC animated:YES];
    }else{
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /**
     *  上传用户头像
     */
    if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithImage:)]) {
        [self.uploadImageDelegate uploadImageToServerWithImage:image];
    }
        
    }
}

- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return image;
    
}

@end
