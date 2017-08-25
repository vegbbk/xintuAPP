//
//  CustomCalloutLJJView.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/15.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "CustomCalloutLJJView.h"

#define kArrorHeight        10
#define kPortraitMargin     5
#define kPortraitWidth      50
#define kPortraitHeight     50

#define kTitleWidth         120
#define kTitleHeight        20
@interface CustomCalloutLJJView ()

@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation CustomCalloutLJJView

//- (void)drawRect:(CGRect)rect
//{
//    
//    [self drawInContext:UIGraphicsGetCurrentContext()];
//    
//    self.layer.shadowColor = [[UIColor whiteColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    
//}
//
//- (void)drawInContext:(CGContextRef)context
//{
//    
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetFillColorWithColor(context,WHITEColor.CGColor);
//    
//    [self getDrawPath:context];
//    CGContextFillPath(context);
//    
//}
//
//- (void)getDrawPath:(CGContextRef)context
//{
//    CGRect rrect = self.bounds;
//    CGFloat radius = 6.0;
//    CGFloat minx = CGRectGetMinX(rrect),
//    midx = CGRectGetMidX(rrect),
//    maxx = CGRectGetMaxX(rrect);
//    CGFloat miny = CGRectGetMinY(rrect),
//    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
//    
//    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
//    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
//    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
//    
//    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
//    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
//    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
//    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
//    CGContextClosePath(context);
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
    UIImageView * backImg = [myLjjTools createImageViewWithFrame:CGRectMake(0, 25, 200, 70) andImageName:@"行程-学生单-气泡" andBgColor:nil];
    backImg.userInteractionEnabled = YES;
    [self addSubview:backImg];
    
    // 添加图片，即商户图
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin*3, kPortraitMargin, kPortraitWidth, kPortraitHeight)];
    self.portraitView.layer.cornerRadius = kPortraitWidth/2.0;
    self.portraitView.clipsToBounds = YES;
    self.portraitView.layer.borderColor = MAINThemeColor.CGColor;
    self.portraitView.layer.borderWidth =1;
    self.portraitView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.portraitView];
    
    // 添加标题，即商户名
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 4 + kPortraitWidth, kPortraitMargin+25, kTitleWidth-40, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = RGB170;
    self.titleLabel.text = @"titletitletitletitle";
    [self addSubview:self.titleLabel];
    
    _button = [myLjjTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+10, kPortraitMargin+25, 25, 25) andImage:[UIImage imageNamed:@"行程_call"] andSelecter:@selector(phoneTake) andTarget:self];
    [self addSubview:_button];
    // 添加副标题，即商户地址
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 4 + kPortraitWidth, kPortraitMargin * 2 + kTitleHeight+25, kTitleWidth, kTitleHeight)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
    self.subtitleLabel.textColor = BlackColor;
    self.subtitleLabel.text = @"subtitleLabelsubtitleLabelsubtitleLabel";
    [self addSubview:self.subtitleLabel];
}

-(void)phoneTake{

    NSLog(@"打电话啦13594369472");
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

- (void)setImage:(UIImage *)image
{
    self.portraitView.image = image;
}
@end
