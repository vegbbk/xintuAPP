//
//  chargeSelectInfoView.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/12.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "chargeSelectInfoView.h"
#define LULI 30
@interface chargeSelectInfoView()
@property(nonatomic,strong)chageMoneyModel*moneyModel;
@property(nonatomic,strong)carStyleModel*carStyleModel;
@property(nonatomic,strong)NSArray * DataArr;
@end
@implementation chargeSelectInfoView
-(id)initWithFrame:(CGRect)frame with:(chageMoneyModel*)model withCar:(carStyleModel*)carModel withLengh:(NSArray *)otherData{
    self = [super initWithFrame:frame];
    if (self) {
        UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *vew = [[UIVisualEffectView alloc]initWithEffect:blur];
        vew.frame = frame;
        _moneyModel = model;
        _carStyleModel = carModel;
        _DataArr = otherData;
        //vew.alpha = 0.6;
        [self addSubview:vew];
        self.backgroundColor= RGBACOLOR(75, 75, 75, 0.8);
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake((SCREEN_WIDTH-61)/2.0,heiSize(102), 61, 21) andImageName:@"首页_选择车型_经济车型" andBgColor:nil];
    [self addSubview:imageView];
    
    UILabel * carNameLabel = [myLjjTools createLabelWithFrame:CGRectMake(30, CGRectGetMaxY(imageView.frame)+16, SCREEN_WIDTH-60, 42) andTitle:[NSString stringWithFormat:@"%@\n%@",_carStyleModel.typeName,_carStyleModel.typeCarName] andTitleFont:FontSize(14) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    carNameLabel.numberOfLines = 0;
    [self addSubview:carNameLabel];
    carNameLabel.attributedText = [myLjjTools createStrLabelTextWith:[NSString stringWithFormat:@"%@\n%@",_carStyleModel.typeName,_carStyleModel.typeCarName] and:[NSString stringWithFormat:@"%@",_carStyleModel.typeName] andFont:FontSize(17) with:nil and:nil];
    
    UIView * lineView = [myLjjTools createViewWithFrame:CGRectMake(60, CGRectGetMaxY(carNameLabel.frame)+heiSize(30), SCREEN_WIDTH-120, 1) andBgColor:WHITEColor];
    [self addSubview:lineView];

    UILabel * moneyLabel = [myLjjTools createLabelWithFrame:CGRectMake(80, CGRectGetMaxY(lineView.frame)+heiSize(42), SCREEN_WIDTH-160, 40) andTitle:[NSString stringWithFormat:@"约%.2lf元\n%@公里、%ld分钟",[_DataArr[0] floatValue] ,_DataArr[1],[_DataArr[2] integerValue]/60] andTitleFont:FontSize(12) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    moneyLabel.numberOfLines = 0;
    [self addSubview:moneyLabel];
    
    UILabel * moneyTruLabel = [myLjjTools createLabelWithFrame:CGRectMake(SCREEN_WIDTH-75,CGRectGetMaxY(lineView.frame)+heiSize(42)+20, 60, 15) andTitle:@"费用说明" andTitleFont:FontSize(14) andTitleColor:MAINThemeOrgColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [moneyTruLabel addTapGuester:YES with:^{
       
    }];
    [self addSubview:moneyTruLabel];
    NSString *textStr = @"费用说明";
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
    moneyTruLabel.attributedText = attribtStr;
    NSArray * arr;
    if(_moneyModel.dyMultiple||_moneyModel.dyMultiple.floatValue!=0.0){
        arr = @[@"起步费",@"时长费",@"里程费",@"动态加价"];
    }else{
        arr = @[@"起步费",@"时长费",@"里程费"];
    }

    for(int i = 0;i<arr.count;i++){
        
        UILabel * label1 = [myLjjTools createLabelWithFrame:CGRectMake(LULI, CGRectGetMaxY(moneyLabel.frame)+16+20*i, (SCREEN_WIDTH-LULI*2)/2.0, 20) andTitle:arr[i] andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
        
        UILabel * label11 = [myLjjTools createLabelWithFrame:CGRectMake(LULI+(SCREEN_WIDTH-LULI*2)/2.0, CGRectGetMaxY(moneyLabel.frame)+16+20*i, (SCREEN_WIDTH-LULI*2)/2.0, 20) andTitle:@"00.00元" andTitleFont:FontSize(15) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentRight andBgColor:CLEARCOLOR];
        switch (i) {
            case 0:
                label11.text = [NSString stringWithFormat:@"%.2lf元",_moneyModel.startFee.floatValue];
                break;
            case 1:
                label11.text = [NSString stringWithFormat:@"%.2lf元",_moneyModel.timeFee.floatValue];
                break;
            case 2:
                label11.text = [NSString stringWithFormat:@"%.2lf元",_moneyModel.milageFee.floatValue];
                break;
            case 3:
                label11.text = [NSString stringWithFormat:@"%@倍",_moneyModel.dyMultiple];
                break;
            default:
                break;
        }
       
        [self addSubview:label11];
        [self addSubview:label1];
        
    }

    UIButton * closeBtn = [myLjjTools createButtonWithFrame:CGRectMake((SCREEN_WIDTH-widSize(30))/2.0, SCREEN_HEIGHT-heiSize(70) , widSize(30), widSize(30)) andImage:[UIImage imageNamed:@"我的_公司_关闭按钮"] andSelecter:@selector(close) andTarget:self];
    [self addSubview:closeBtn];
    
}

-(void)close{
    
    [UIView animateWithDuration:0.6 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

    
}


@end
