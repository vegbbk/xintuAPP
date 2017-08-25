//
//  CustomAnnotationLJJView.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/15.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "CustomAnnotationLJJView.h"
#define kCalloutWidth       200.0
#define kCalloutHeight      70.0
@interface CustomAnnotationLJJView ()

@property (nonatomic, strong, readwrite) CustomCalloutLJJView *calloutView;

@end
@implementation CustomAnnotationLJJView

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[CustomCalloutLJJView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight+25)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.image = [UIImage imageNamed:@"首页_小车"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint tempoint = [self.calloutView.button convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.calloutView.button.bounds, tempoint))
        {
            view = self.calloutView.button;
        }
    }
    return view;
}
@end
