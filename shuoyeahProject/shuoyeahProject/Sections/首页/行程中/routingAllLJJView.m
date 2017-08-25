//
//  routingAllLJJView.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "routingAllLJJView.h"
#import "chargeDetailViewController.h"

@implementation routingAllLJJView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super  initWithFrame:frame];
    if(self){
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        [self setView];
    }
    return self;
}

-(void)setView{

    self.allView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 323) andBgColor:CLEARCOLOR];
    [self addSubview:self.allView];
    
    
    self.progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-149)/2.0, 34, 149, 149) pathBackColor:nil pathFillColor:MAINThemeColor startAngle:-90 strokeWidth:4];
    self.progressView.increaseFromLast = YES;
    self.progressView.pointImage = [UIImage imageNamed:@"首页_圆点"];
    [self.allView addSubview:self.progressView];

//    self.progressView = [[ZJCircleProgressView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-149)/2.0, 34, 149, 149)];
//    // 背景色
//    self.progressView.trackBackgroundColor = RGB170;
//    self.progressView.headerImage = [UIImage imageNamed:@"首页_圆点"];
//    // 进度颜色
//    self.progressView.trackColor = RGB170;
//    //self.progressView.headerImage = [self drawImage];
//    // 开始角度位置
//    //    self.progressView.beginAngle =
//    // 自定义progressLabel的属性...
//    self.progressView.progressLabel.textColor = [UIColor clearColor];
//    //    self.progressView.progressLabel.hidden = YES;
//    [self.allView addSubview:self.progressView];
    
    UILabel * label = [myLjjTools createLabelWithFrame:CGRectMake(30, 30, 89, 46) andTitle:@"0元\n累计费用" andTitleFont:FontSize(15) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    label.numberOfLines = 0;
    [self.progressView addSubview:label];
    _totalMoneyLabel = label;
    
    UILabel * label1 = [myLjjTools createLabelWithFrame:CGRectMake(20,CGRectGetMaxY(label.frame)+23, 109, 15) andTitle:@"预计 0min后 到达" andTitleFont:FontSize(10) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [self.progressView addSubview:label1];
    _residueTimeLabel = label1;
    NSAttributedString * astr11 = [myLjjTools createStrLabelTextWith:@"预计 0min后 到达" and:@"0min后" andFont:FontSize(14) with:nil and:nil];
    label1.attributedText = astr11;
    
    UILabel * moneyLabel = [myLjjTools createLabelWithFrame:CGRectMake(SCREEN_WIDTH-86, 171, 70, 21) andTitle:@"¥费用明细" andTitleFont:FontSize(14) andTitleColor:MAINThemeOrgColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [moneyLabel addTapGuester:YES with:^{
        chargeDetailViewController * cha = [[chargeDetailViewController alloc]init];
        cha.moneyStr = self.moneyStr;
        cha.dataModel = self.dataModel;
        [[self viewController].navigationController pushViewController:cha animated:YES];
    }];
    [self.allView addSubview:moneyLabel];
    NSString *textStr = @"¥费用明细";
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    moneyLabel.attributedText = attribtStr;
    
    _endPathLabel = [myLjjTools createLabelWithFrame:CGRectMake(15, 213, (SCREEN_WIDTH-32)/2.0, 20) andTitle:@"已行驶里程:0km" andTitleFont:FontSize(15) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [self.allView addSubview:_endPathLabel];

    _lastPathLabel = [myLjjTools createLabelWithFrame:CGRectMake(15+(SCREEN_WIDTH-32)/2.0, 213, (SCREEN_WIDTH-32)/2.0, 20) andTitle:@"预计里程:0km" andTitleFont:FontSize(15) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentRight andBgColor:CLEARCOLOR];
    [self.allView addSubview:_lastPathLabel];
    
    UIImageView * imageView1 = [myLjjTools createImageViewWithFrame:CGRectMake(15, CGRectGetMaxY(_lastPathLabel.frame)+10, 8, 11) andImageName:@"我的_起点" andBgColor:nil];
    [self.allView addSubview:imageView1];
    UILabel * label11 = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+11, CGRectGetMaxY(_lastPathLabel.frame)+10, 12, 12) andTitle:@"起" andTitleFont:FontSize(12) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [self.allView addSubview:label11];
    
    _startLabel = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(label11.frame)+20, CGRectGetMaxY(_lastPathLabel.frame)+10, SCREEN_WIDTH-CGRectGetMaxX(label11.frame)-30, 30) andTitle:@"暂无" andTitleFont:FontSize(12) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    _startLabel.numberOfLines = 0;
    [self.allView addSubview:_startLabel];

    UIImageView * imageView2 = [myLjjTools createImageViewWithFrame:CGRectMake(15, CGRectGetMaxY(_startLabel.frame)+10, 8, 11) andImageName:@"我的_终点" andBgColor:nil];
    [self.allView addSubview:imageView2];
    UILabel * label22 = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView2.frame)+11, CGRectGetMaxY(_startLabel.frame)+10, 12, 12) andTitle:@"终" andTitleFont:FontSize(12) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [self.allView addSubview:label22];
    
    _endLabel = [self createLabelWithFrame:CGRectMake(CGRectGetMaxX(label22.frame)+20, CGRectGetMaxY(_startLabel.frame)+10, SCREEN_WIDTH-CGRectGetMaxX(label22.frame)-30, 30) andTitle:@"牛角沱立交牛角沱立交牛角沱立交牛角沱立交" andTitleFont:FontSize(12) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    _endLabel.numberOfLines = 0;
    [self.allView addSubview:_endLabel];
    
  //---------------------------------收起来的视图-----------------------------
    
    self.listView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 146) andBgColor:CLEARCOLOR];
    self.listView.hidden = YES;
    [self addSubview:self.listView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"小车动态" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2.0, 28, 100, 30)];
    webView.scalesPageToFit = YES;
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    [self.listView addSubview:webView];
    
    _allMonyLabel = [myLjjTools createLabelWithFrame:CGRectMake(40, CGRectGetMaxY(webView.frame)+10, SCREEN_WIDTH-80, 17) andTitle:@"累计费用  0元" andTitleFont:FontSize(15) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [self.listView addSubview:_allMonyLabel];
    NSAttributedString * astr = [myLjjTools createStrLabelTextWith:@"累计费用  0元" and:@"0元" andFont:FontSize(19) with:@"0元" and:MAINThemeOrgColor];
    _allMonyLabel.attributedText = astr;
    
     _endPathLabel1 = [myLjjTools createLabelWithFrame:CGRectMake(15, 104, (SCREEN_WIDTH-32)/2.0, 20) andTitle:@"已行驶里程  0km" andTitleFont:FontSize(15) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [self.listView addSubview:_endPathLabel1];
    NSAttributedString * astr1 = [myLjjTools createStrLabelTextWith:@"已行驶里程  0km" and:@"0km" andFont:FontSize(19) with:@"0km" and:MAINThemeOrgColor];
    _endPathLabel1.attributedText = astr1;
    
    _lastPathLabel1 = [myLjjTools createLabelWithFrame:CGRectMake(15+(SCREEN_WIDTH-32)/2.0, 104, (SCREEN_WIDTH-32)/2.0, 20) andTitle:@"预计里程  7520km" andTitleFont:FontSize(15) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentRight andBgColor:CLEARCOLOR];
    [self.listView addSubview:_lastPathLabel1];
    NSAttributedString * astr2 = [myLjjTools createStrLabelTextWith:@"预计里程  0km" and:@"0km" andFont:FontSize(19) with:@"0km" and:MAINThemeOrgColor];
    _lastPathLabel1.attributedText = astr2;


    UIButton * bottomBtn = [myLjjTools createButtonWithFrame:CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(self.frame)-12-64, 25, 25) andImage:[UIImage imageNamed:@"首页_下拉"] andSelecter:@selector(chooseClick:) andTarget:self];
    bottomBtn.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self addSubview:bottomBtn];

}

-(void)chooseClick:(UIButton*)btn{
    
    btn.selected = !btn.selected;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if(btn.selected){
            self.frame = CGRectMake(0, 64, SCREEN_WIDTH, 146);
            [btn setImage:[UIImage imageNamed:@"首页_下拉"] forState:UIControlStateNormal];
            btn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(self.frame)-12-64, 25, 25);
            self.allView.hidden = YES;
            self.listView.hidden = NO;
        }else{
            self.frame = CGRectMake(0, 64, SCREEN_WIDTH, 323);
            [btn setImage:[UIImage imageNamed:@"首页_上拉"] forState:UIControlStateNormal];
            btn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(self.frame)-12-64, 25, 25);
           
        }
        
    } completion:^(BOOL finished) {
       
        if(btn.selected){
          
        }else{
            self.allView.hidden = NO;
            self.listView.hidden = YES;
        }
      
    }];
    
    
}

-(ljjTopLabel *)createLabelWithFrame:(CGRect)rect andTitle:(NSString *)title andTitleFont:(UIFont *)titleFont andTitleColor:(UIColor *)titleColor andTextAlignment:(NSTextAlignment)alignment andBgColor:(UIColor *)bgColor{
    
    ljjTopLabel * label = [[ljjTopLabel alloc]init];
    if (rect.size.width) {
        label.frame = rect;
    }
    if (title) {
        label.text = title;
    }
    if (titleColor) {
        label.textColor = titleColor;
    }
    if (titleFont) {
        label.font = titleFont;
    }
    if (bgColor) {
        label.backgroundColor = bgColor;
    }
    if (alignment) {
        label.textAlignment = alignment;
    }
    return label;
}


- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
