//
//  ljjTopLabel.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/6/1.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "ljjTopLabel.h"

@implementation ljjTopLabel

- (id)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    textRect.origin.y = bounds.origin.y;
    return textRect;
}
-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}
@end
