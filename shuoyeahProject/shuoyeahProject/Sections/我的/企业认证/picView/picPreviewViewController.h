//
//  picPreviewViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/4/18.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"
@protocol changePicPreViewDelegate <NSObject>
-(void)changePicPreViewClick:(UIImage*)preImage withType:(NSInteger)typeStr;
@end
@interface picPreviewViewController : baseLJJViewController
@property(nonatomic,assign)id<changePicPreViewDelegate>delegate;
@property(nonatomic,copy)NSString * ImgUrlStr;
@property(nonatomic,assign)NSInteger typeNum;//1营业执照2省身份证正面3身份证反面
@end
