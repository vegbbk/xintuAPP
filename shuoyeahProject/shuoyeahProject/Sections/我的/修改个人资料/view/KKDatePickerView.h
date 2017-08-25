//
//  KKDatePickerView.h
//  PickerView
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKDatePickerViewModel.h"
@protocol dataSelectDelegate <NSObject>
-(void)dataSelectClick:(NSString *)timeStr;
-(void)cancelViewData;
@end
@interface KKDatePickerView : UIView

@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic, strong)KKDatePickerViewModel *model ;
@property (nonatomic,assign)id<dataSelectDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame;
@end
