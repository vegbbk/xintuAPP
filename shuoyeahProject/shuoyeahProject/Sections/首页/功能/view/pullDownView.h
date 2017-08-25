//
//  pullDownView.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/4/20.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "headCateButton.h"
#import "MHDatePicker.h"
#import "WKFRadarView.h"
@protocol pullDownDelegate <NSObject>

-(void)selectCarStyle;
-(void)sureCarClick;
-(void)jumpToFreeInfo;
-(void)selectStartPlace;
-(void)selectEndPlace;
@end
@interface pullDownView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)CGFloat titleHIGHT;
@property (nonatomic,assign)CGFloat heighFloat;
@property (nonatomic,strong)UILabel * startTextField;
@property (nonatomic,strong)AMapGeoPoint*startPoint;//起点
@property (nonatomic,strong)UILabel * endTextField;
@property (nonatomic,strong)AMapGeoPoint* endPoint;//终点
@property (nonatomic,strong)UILabel * startTimeLabel;
@property (nonatomic,strong)UIButton * bottomBtn;//确认用车
@property (nonatomic,strong)headCateButton * singleBtn;//单程
@property (nonatomic,strong)headCateButton * doubleBtn;//往返
@property (nonatomic,strong)UILabel * startLabel;
@property (nonatomic,strong)UILabel * returnLabel;
@property (nonatomic,strong)UIImageView * returnImg;
@property (nonatomic,strong)UILabel * returnTimeLabel;
@property (nonatomic,assign)BOOL isSingle;//是否是单程
@property (nonatomic,assign)BOOL isUnfold;//是否展开
@property (nonatomic,strong)UILabel * freeMoneyLabel;//估价
@property (nonatomic,strong)UILabel * driverLabel;//司机
@property (nonatomic,strong)UITextField * otherText;
@property (nonatomic,strong)NSMutableArray * buttonsArr;
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UITextField * flightText;//航班信息
@property (nonatomic,strong)UIImageView * plainImageView;

@property (nonatomic,strong)UITextField * selectField;

@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)MAMapView *mapView;//地图

@property(nonatomic,assign)NSInteger indexNum ;//1接送机  2周末游玩
-(id)initWithFrame:(CGRect)frame with:(NSInteger)indexNum with:(CGFloat)titleHIGHT with:(CGFloat)heighFloat;
@property(nonatomic,assign)id<pullDownDelegate>delegate;
@end
