//
//  carStyleSelectView.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/10.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "carStyleModel.h"
@protocol styleSelectchooseDelegate <NSObject>

-(void)carStylechoose:(carStyleModel*)model;

@end

@interface carStyleSelectView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *uitable;
@property (nonatomic,assign)id<styleSelectchooseDelegate>delegate;
-(id)initWithFrame:(CGRect)frame witharr:(NSArray*)array;

@end
