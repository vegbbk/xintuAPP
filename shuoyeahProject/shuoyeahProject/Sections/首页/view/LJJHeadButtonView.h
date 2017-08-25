//
//  LJJHeadButtonView.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/21.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LJJHeadButtonViewDelegate <NSObject>
-(void)LJJHeadButtonViewClick:(NSInteger)tagNum;
@end
@interface LJJHeadButtonView : UIView<UIScrollViewDelegate>
@property(nonatomic,weak)id<LJJHeadButtonViewDelegate>delegate;
-(id)initWithFrame:(CGRect)frame with:(NSArray*)titleArr;
@end
