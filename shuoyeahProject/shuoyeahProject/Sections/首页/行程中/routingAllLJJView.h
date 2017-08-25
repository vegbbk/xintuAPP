//
//  routingAllLJJView.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZJCircleProgressView.h"
#import "ZZCircleProgress.h"
#import "ljjTopLabel.h"
#import "routingingModel.h"
@interface routingAllLJJView : UIView
@property (strong, nonatomic) ZZCircleProgress *progressView;
@property (nonatomic,strong)UIView * allView;
@property (nonatomic,strong)UIView * listView;
@property (nonatomic,strong)UILabel * endPathLabel1;
@property (nonatomic,strong)ljjTopLabel * endLabel;
@property (nonatomic,strong)ljjTopLabel * startLabel;
@property (nonatomic,strong)UILabel * totalMoneyLabel;
@property (nonatomic,strong)UILabel * allMonyLabel;
@property (nonatomic,strong)UILabel * residueTimeLabel;
@property (nonatomic,strong)UILabel * endPathLabel;
@property (nonatomic,strong)UILabel * lastPathLabel;
@property (nonatomic,strong)UILabel * lastPathLabel1;

@property(nonatomic,copy)NSString * moneyStr;
@property(nonatomic,strong)routingingModel * dataModel;
@end
