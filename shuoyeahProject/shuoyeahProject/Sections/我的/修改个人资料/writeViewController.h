//
//  writeViewController.h
//  IMshuoyeah
//
//  Created by shuoyeah on 16/4/1.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseLJJViewController.h"
@protocol sendInfoDelegate <NSObject>

-(void)sendInfowith:(NSString *)string;

@end

@interface writeViewController : baseLJJViewController
@property (nonatomic,copy)NSString * titleStr;
@property (nonatomic,copy)NSString * signatureStr;
@property (nonatomic,assign)id<sendInfoDelegate>delegate;
@end
