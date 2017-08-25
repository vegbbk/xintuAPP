//
//  searchLJJText.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/6/15.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol searchTextInputLJJDelegate <NSObject>
-(void)searchTextInputLJJClick:(NSString *)searStr;
@end
@interface searchLJJText : UIView
@property (nonatomic,strong)UITextField * inputText;
@property (nonatomic, strong) NSString *customPlaceholder;
@property (nonatomic,assign)id<searchTextInputLJJDelegate>delegate;
@end
