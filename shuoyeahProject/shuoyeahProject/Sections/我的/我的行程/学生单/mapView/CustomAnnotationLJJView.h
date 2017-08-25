//
//  CustomAnnotationLJJView.h
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/15.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutLJJView.h"
@interface CustomAnnotationLJJView : MAAnnotationView
@property (nonatomic, readonly) CustomCalloutLJJView *calloutView;
@end
