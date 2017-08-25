//
//  billRecordTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "billRecordTableViewCell.h"
@interface billRecordTableViewCell()

@property (nonatomic, weak) UILabel * titleLabel;
@property (nonatomic, weak) UILabel * billNumLabel;
@property (nonatomic, weak) UILabel * billCityLabel;
@property (nonatomic, weak) UILabel * billShouLabel;
@property (nonatomic, weak) UILabel * billContactLabel;
@property (nonatomic, weak) UILabel * billDressLabel;
@property (nonatomic, weak) UILabel * billCompanyLabel;
@property (nonatomic, weak) UILabel * billTimeLabel;
@end

@implementation billRecordTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    // UIView * backView = [myLjjTools createViewWithFrame: andBgColor:nil];
    UIImageView * backImg = [myLjjTools createImageViewWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 363) andImage:[UIImage imageNamed:@"我的_发票记录框"] andBgColor:nil];
    [self addSubview:backImg];
    
    CGFloat widImg = backImg.frame.size.width;
    // CGFloat heiImg = backImg.frame.size.height;
    
     UILabel * titleLabel = [myLjjTools createLabelWithFrame:CGRectMake(10, 24, widImg-20, 16) andTitle:@"" andTitleFont:FontSize(17) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [backImg addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel * billNumLabel = [myLjjTools createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+30, widImg-90, 36) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    billNumLabel.numberOfLines = 0;
    [backImg addSubview:billNumLabel];
    self.billNumLabel = billNumLabel;
    
    UILabel * billCityLabel = [myLjjTools createLabelWithFrame:CGRectMake(widImg-90, CGRectGetMaxY(titleLabel.frame)+30, 80, 36) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    billCityLabel.numberOfLines = 0;
    [backImg addSubview:billCityLabel];
    self.billCityLabel = billCityLabel;
    
    UILabel * billCompanyLabel = [myLjjTools createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(billCityLabel.frame)+6, widImg-20, 26) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    billCompanyLabel.numberOfLines = 0;
    [backImg addSubview:billCompanyLabel];
    self.billCompanyLabel = billCompanyLabel;
    
     UILabel * billTimeLabel = [myLjjTools createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(billCompanyLabel.frame)+2, widImg-20, 26) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    billTimeLabel.numberOfLines = 0;
    [backImg addSubview:billTimeLabel];
    self.billTimeLabel = billTimeLabel;
    
    UILabel * billShouLabel = [myLjjTools createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(billCompanyLabel.frame)+47, widImg-20, 36) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    billShouLabel.numberOfLines = 0;
    [backImg addSubview:billShouLabel];
    self.billShouLabel = billShouLabel;
    
    UILabel * billContactLabel = [myLjjTools createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(billShouLabel.frame)+17, widImg-20, 36) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    billContactLabel.numberOfLines = 0;
    [backImg addSubview:billContactLabel];
    self.billContactLabel = billContactLabel;
    
    UILabel * billDressLabel = [myLjjTools createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(billContactLabel.frame)+17, widImg-20, 36) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    billDressLabel.numberOfLines = 0;
    [backImg addSubview:billDressLabel];
    self.billDressLabel = billDressLabel;
    
}

-(void)setMakeTimeBill:(NSString *)makeTimeBill{

    self.billTimeLabel.text = [NSString stringWithFormat:@"开票时间:%@",makeTimeBill];
    
    self.billTimeLabel = [myLjjTools createLabelTextWithView:self.billTimeLabel  andwithChangeColorTxt:@"开票时间" withColor:RGB170];
}

-(void)setMoneyStr:(NSString *)moneyStr{

    self.titleLabel.text = [NSString stringWithFormat:@"¥%@ 服务费",moneyStr];

}

-(void)setOrderNumStr:(NSString *)orderNumStr{

    self.billNumLabel.text = [NSString stringWithFormat:@"发票号码:\n%@",orderNumStr];
    self.billNumLabel = [myLjjTools createLabelTextWithView:self.billNumLabel  andwithChangeColorTxt:orderNumStr withColor:BlackColor];

}

-(void)setCityStr:(NSString *)cityStr{

    self.billCityLabel.text = [NSString stringWithFormat:@"开票城市:\n%@",cityStr];
   self.billCityLabel = [myLjjTools createLabelTextWithView:self.billCityLabel  andwithChangeColorTxt:cityStr withColor:BlackColor];
}

-(void)setDressStr:(NSString *)dressStr{

    self.billDressLabel.text = [NSString stringWithFormat:@"配送地址:\n%@",dressStr];
    self.billDressLabel = [myLjjTools createLabelTextWithView:self.billDressLabel  andwithChangeColorTxt:dressStr withColor:BlackColor];
    
}

-(void)setPhoneStr:(NSString *)phoneStr{

    self.billContactLabel.text = [NSString stringWithFormat:@"联系方式:\n%@",phoneStr];
    self.billContactLabel = [myLjjTools createLabelTextWithView:self.billContactLabel  andwithChangeColorTxt:phoneStr withColor:BlackColor];

}

-(void)setCompanyStr:(NSString *)companyStr{

    self.billCompanyLabel.text = [NSString stringWithFormat:@"发票抬头:%@",companyStr];
    self.billCompanyLabel = [myLjjTools createLabelTextWithView:self.billCompanyLabel  andwithChangeColorTxt:companyStr withColor:BlackColor];
}

-(void)setReceiveStr:(NSString *)receiveStr{

    self.billShouLabel.text = [NSString stringWithFormat:@"收件人:\n%@",receiveStr];
    self.billShouLabel = [myLjjTools createLabelTextWithView:self.billShouLabel  andwithChangeColorTxt:receiveStr withColor:BlackColor];

}

@end
