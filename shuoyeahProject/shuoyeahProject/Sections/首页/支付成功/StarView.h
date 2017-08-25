//
//  StarView.h
//  EvaluationStar
//
//  Created by 赵贺 on 15/11/26.
//  Copyright © 2015年 赵贺. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol starDelegate <NSObject>
-(void)selectNumber:(NSInteger)number and:(NSInteger)tagNum;
@end
@interface StarView : UIView
@property(nonatomic,assign)id<starDelegate>delegate;
- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star;
@end
