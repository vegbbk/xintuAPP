//
//  LJJAlertPromView.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/20.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xialaView.h"
@protocol LJJAlertPromViewDelegate <NSObject>
-(void)LJJAlertPromViewClick:(NSString*)sectionNameStr;//添加部门
-(void)selectSubmitPeople:(NSString*)departIdStr with:(NSString*)phoneStr ;
-(void)selectSubmitGoOnPeople:(NSString*)nameStr with:(NSString*)phoneStr;
-(void)selectPhoneBook;
-(void)selectSubmitPeopleModel:(sectionListModel*)mdoel;
@end
@interface LJJAlertPromView : UIView<xialachooseDelegate>
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UITextField * textName;
@property (nonatomic ,strong) UITextField * textWay;
@property (nonatomic ,strong) UILabel *sectionLabel;
@property (nonatomic ,strong)xialaView * sectionView;
@property (nonatomic ,strong)UILabel *sectionListLabel;
@property (nonatomic ,strong)sectionListModel*model;
@property (nonatomic ,weak) id <LJJAlertPromViewDelegate>delegate;
-(void)HID;
-(void)show;
-(id)initWithFrame:(CGRect)frame with:(NSInteger)number;//number==1,邀请员工2,创建部门3选择部门4,输入员工信息
@end
