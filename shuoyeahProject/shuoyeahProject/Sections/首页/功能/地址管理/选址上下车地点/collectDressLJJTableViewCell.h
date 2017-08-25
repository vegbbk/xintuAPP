//
//  collectDressLJJTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dressInfoLJJModel.h"
@protocol selectCommonDressDelegate <NSObject>
-(void)selectCommonDress;
-(void)selectDress:(dressInfoLJJModel*)model;
@end
@interface collectDressLJJTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *colloctView;
@property (nonatomic,assign)id<selectCommonDressDelegate>delegate;

@end
