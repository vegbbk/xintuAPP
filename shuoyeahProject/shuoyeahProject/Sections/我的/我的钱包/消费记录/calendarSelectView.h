//
//  calendarSelectView.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/14.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKDatePickerViewModel.h"
@protocol FreeDataSelectDelegate <NSObject>
-(void)FreeDataSelectClick:(NSString *)yearStr with:(NSString *)monthStr;
-(void)FreeCancelViewData;
@end

@interface calendarSelectView : UIView
@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic, strong)KKDatePickerViewModel *model ;
@property (nonatomic,assign)id<FreeDataSelectDelegate>delegate;

@end
