//
//  addDressLJJViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"
#import "dressInfoLJJModel.h"
@protocol addDressSucDelegate <NSObject>
-(void)addDressSucFreshData;
@end
@interface addDressLJJViewController : baseLJJViewController
@property(nonatomic,assign)NSInteger typeNum;//1添加,2编辑
@property(nonatomic,strong)dressInfoLJJModel * dataModel;//地址数据模型
@property(nonatomic,assign)id<addDressSucDelegate>delegate;
@end
