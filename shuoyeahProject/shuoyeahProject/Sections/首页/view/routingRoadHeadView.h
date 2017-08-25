//
//  routingRoadHeadView.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/6/26.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol headListRoutDelegate <NSObject>
-(void)routingClick;
@end
@interface routingRoadHeadView : UIView
@property(nonatomic,assign)id<headListRoutDelegate>delegate;
@property(nonatomic,strong)UILabel * startLabel;
@property(nonatomic,strong)UILabel * endLabel;
@end
