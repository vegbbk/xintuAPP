//
//  routeLJJTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "routeLJJTableViewCell.h"

@implementation routeLJJTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:35 with:self.headImageView];
    self.cancelOrderBtn.layer.cornerRadius=4;
    self.cancelOrderBtn.layer.borderColor = rgb(227, 62, 62).CGColor;
    self.cancelOrderBtn.layer.borderWidth=1;
    self.callDriverBtn = [myLjjTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+22, 23, 23, 22) andImage:[UIImage imageNamed:@"行程_call"] andSelecter:@selector(callBtnClick:) andTarget:self];
    self.callDriverBtn.hidden = YES;
    [self addSubview:self.callDriverBtn];
    self.callDriverBtn.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.stauteLabel.layer.cornerRadius = 4.0;
    self.stauteLabel.clipsToBounds = YES;
    
    self.chatWithDriverBtn.touchAreaInsets = UIEdgeInsetsMake(10, 16, 16, 0);
    self.takePhoneBtn.touchAreaInsets = UIEdgeInsetsMake(10, 0, 16, 10);
}
- (void)callBtnClick:(UIButton *)sender{
   
    if(self.phoneStr){
    [myLjjTools directPhoneCallWithPhoneNum:self.phoneStr];
    }else{
        ToastWithTitle(@"没有获取到司机号码");
    }
    
}

- (IBAction)chatBtnClick:(UIButton *)sender {
    
    [self.delegate chatWithDriverClick:self.indexPath];
}

- (IBAction)takePhoneClick:(UIButton *)sender {
    
    [self.delegate takePhoneWithDriver:self.indexPath];
}

-(void)loadDataFrom:(NSInteger)number withData:(routeListLJJModel *)model{

    if (number==1) {
        switch (model.orderPayStatus.integerValue) {
            case 0:
                self.cancelOrderBtn.hidden = YES;
                self.rightImg.hidden = NO;
                self.rightImg.image = [UIImage imageNamed:@"未出行1"];
                break;
            case 1:
                self.cancelOrderBtn.hidden = YES;
                self.rightImg.hidden = NO;
                self.rightImg.image = [UIImage imageNamed:@"未出行1"];
                break;
            case 2:
                self.cancelOrderBtn.hidden = YES;
                self.rightImg.hidden = NO;
                self.rightImg.image = [UIImage imageNamed:@"未出行1"];
                break;
            default:
                break;
        }
         self.stauteLabel.hidden = NO;
    }else if(number==0){
        self.cancelOrderBtn.hidden = YES;
        self.rightImg.hidden = NO;
        self.rightImg.image = [UIImage imageNamed:@"已取消1"];
         self.stauteLabel.hidden = NO;
    }else if(number==3){
        
        switch (model.orderPayStatus.integerValue) {
            case 1:
                self.cancelOrderBtn.hidden = YES;
                self.rightImg.hidden = NO;
                self.rightImg.image = [UIImage imageNamed:@"已完成112"];
                break;
            case 0:
                self.cancelOrderBtn.hidden = YES;
                self.rightImg.hidden = NO;
                self.rightImg.image = [UIImage imageNamed:@"待支付1"];
                break;
            default:
                break;
        }
     self.stauteLabel.hidden = NO;
    }else if(number==4){
        self.studentName.hidden = NO;
        self.studentNameLabel.hidden = NO;
        self.chatWithDriverBtn.hidden = YES;
        self.takePhoneBtn.hidden = YES;
       
        self.cancelOrderBtn.hidden = NO;
        self.rightImg.hidden = YES;
        self.driverCarIDLabel.hidden = YES;
        self.studentName.text = model.studentName;
        [self.cancelOrderBtn setTitle:@"查看司机位置" forState:UIControlStateNormal];
        self.cancelOrderBtn.titleLabel.font = FontSize(11);
    }else if(number==2){
        self.cancelOrderBtn.hidden = YES;
        self.rightImg.hidden = NO;
        self.rightImg.image = [UIImage imageNamed:@"行程中1"];
        self.stauteLabel.hidden = NO;
    }
    
    if(model.strokeType.integerValue==5){
        self.cancelOrderBtn.hidden = YES;
        self.rightImg.hidden = NO;
        self.rightImg.image = [UIImage imageNamed:@"学生单1"];
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(model.driverHeadImg)] placeholderImage:[UIImage imageNamed:defaultHeadName]];
    self.nameLabel.text = model.driverName;
    if(number==4||model.strokeType.integerValue==5){
    self.callDriverBtn.hidden = NO;
    self.timeLabel.text = [logicDone timeIntChangeToStr:model.startTime];
    if(!model.driverName){
        model.driverName = @"";
    }
    CGSize size = [myLjjTools countTxtWith:model.driverName andWithFont:FontSize(17) with:200];
    self.callDriverBtn.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+22+size.width, 30, 23, 22);
        if(!self.phoneStr){
            self.callDriverBtn.hidden = YES;
        }
    }else{
    self.timeLabel.text = [logicDone timeIntChangeToStr:model.startTime];
    }
    self.stauteLabel.text = @"暂无";
    if(!IsStrEmpty(model.strokeTypeName)){
        CGSize size = [myLjjTools countTxtWith:model.strokeTypeName andWithFont:FontSize(15) with:200];
        self.stauteLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+15, 12, size.width+8, 22);
        self.stauteLabel.text = model.strokeTypeName;
    }else{
        self.stauteLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+15, 12, 50, 22);
    }
    if(number==4){
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+15, 15, 120, 16);
    }else{
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.stauteLabel.frame)+4, 15, 120, 16);
    }
    self.driverCarIDLabel.text = [NSString stringWithFormat:@"%@ %@",model.carTypeName,model.carLicense];
    self.startLabel.text = [NSString stringWithFormat:@"起      %@",model.startAddress];
    self.finishLabel.text = [NSString stringWithFormat:@"终      %@",model.endAddress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cancelClick:(id)sender {
    
    [self.delegate cancelRouteClick:self.indexPath];
}
@end
