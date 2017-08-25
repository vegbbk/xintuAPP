//
//  xialaView.h
//  shuoyeahProject
//
//  Created by shuoyeah on 16/8/11.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sectionListModel.h"
@protocol xialachooseDelegate <NSObject>
-(void)xialachooseRetuDataWith:(sectionListModel*)model;
@end
@interface xialaView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *uitable;
@property (nonatomic,assign)id<xialachooseDelegate>delegate;
-(id)initWithFrame:(CGRect)frame witharr:(NSArray*)array;
@end
