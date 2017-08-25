//
//  LJJAlertPromView.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/20.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "LJJAlertPromView.h"

@implementation LJJAlertPromView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame with:(NSInteger)number{

    self = [super initWithFrame:frame];
    if(self){
    
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        switch (number) {
            case 1:
                  [self setUpView];
                break;
            case 4:
                [self createWrite];
                break;
            case 2:
                [self createSetion];
                break;

            case 3:
                [self selectSection];
                break;

            default:
                break;
        }
      
    
    }
    return self;
}

#pragma mark ------------选择邀请方式-----------------------

-(void)setUpView{

    CGFloat wid = SCREEN_WIDTH-widSize(27)*2;
    CGFloat high = heiSize(193);
    UIView * aletView = [myLjjTools createViewWithFrame:CGRectMake(widSize(27), heiSize(165), wid, high) andBgColor:[UIColor whiteColor]];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:8.0 with:aletView];
    [self addSubview:aletView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, wid-40,heiSize(60))];
    _titleLabel.text = @"选择您要邀请员工的方式";
    _titleLabel.textColor = BlackColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [aletView addSubview:_titleLabel];
    
    UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(0, heiSize(60),wid, 3) andImageName:@"" andBgColor:MAINThemeOrgColor];
    [aletView addSubview:imageView];
    
//    UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake((SCREEN_WIDTH-wid)/2.0+30, CGRectGetMaxY(aletView.frame)-15, wid-60, 30) andTitle:@"立即报班" andTitleColor:WHITEColor andBgColor:rgb(251, 97, 18) andSelecter:@selector(btnClick) andTarget:self];
//    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:15.0 with:btn];
//    [self addSubview:btn];
//    
//    UIButton * closeBtn = [myLjjTools createButtonWithFrame:CGRectMake((SCREEN_WIDTH-wid)/2.0+wid-15, (SCREEN_HEIGHT - high)/2.0-15, 30, 30) andImage:[UIImage imageNamed:@"测试测试.jpeg"] andSelecter:@selector(close) andTarget:self];
//    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:15.0 with:closeBtn];
//    [self addSubview:closeBtn];
    
    UILabel * phoneBookLabel = [[UILabel alloc]initWithFrame:CGRectMake(widSize(16), CGRectGetMaxY(imageView.frame)+3, wid-widSize(16),heiSize(60))];
    phoneBookLabel.text = @"从通讯录批量邀请";
    phoneBookLabel.textColor = BlackColor;
    phoneBookLabel.textAlignment = NSTextAlignmentLeft;
    phoneBookLabel.font = FontSize(15);
    [aletView addSubview:phoneBookLabel];
    [phoneBookLabel addTapGuester:YES with:^{
    
        if(![JudgeSummaryLJJ applicationhasAccessToAddressBook]){
            ToastWithTitle(@"请打开通讯录权限");
        }
        [self.delegate selectPhoneBook];
        [self close];
    }];
    
    UIImageView * imageView1 = [myLjjTools createImageViewWithFrame:CGRectMake(0, CGRectGetMaxY(phoneBookLabel.frame),wid, 1) andImageName:@"" andBgColor:LINECOLOR];
    [aletView addSubview:imageView1];
    
    UILabel * writeLabel = [[UILabel alloc]initWithFrame:CGRectMake(widSize(16),CGRectGetMaxY(imageView1.frame)+1, wid-widSize(16),heiSize(60))];
    writeLabel.text = @"手动输入员工信息";
    writeLabel.textColor = BlackColor;
    writeLabel.textAlignment = NSTextAlignmentLeft;
    writeLabel.font = FontSize(15);
    [aletView addSubview:writeLabel];
    [writeLabel addTapGuester:YES with:^{
        
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createWrite];
       
    }];
    
    [self createCloseBtn];

}




#pragma mark ------------邀请员工-----------------------

-(void)createWrite{

    CGFloat wid = SCREEN_WIDTH-widSize(27)*2;
    CGFloat high = 250;
    UIView * aletView = [myLjjTools createViewWithFrame:CGRectMake(widSize(27), heiSize(140), wid, high) andBgColor:[UIColor whiteColor]];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:8.0 with:aletView];
    [self addSubview:aletView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, wid-40,heiSize(60))];
    _titleLabel.text = @"输入员工信息";
    _titleLabel.textColor = BlackColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [aletView addSubview:_titleLabel];
    
    UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(0, heiSize(60),wid, 3) andImageName:@"" andBgColor:MAINThemeOrgColor];
    [aletView addSubview:imageView];

    UILabel * label5 = [myLjjTools createLabelWithFrame:CGRectMake(16,CGRectGetMaxY(imageView.frame)+15, 40, 15) andTitle:@"姓名" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [aletView addSubview:label5];
    _textName = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label5.frame)+10,CGRectGetMaxY(imageView.frame)+12, wid-30-CGRectGetMaxX(label5.frame)-10, 20)];
    _textName.font = FontSize(15);
    _textName.placeholder = @"请输入员工姓名";
    [aletView addSubview:_textName];
    UIView * fiveLineView = [myLjjTools createViewWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+44, wid-30, 1) andBgColor:LINECOLOR];
    [aletView addSubview:fiveLineView];
    
    UILabel * label6 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(fiveLineView.frame)+15, 40, 15) andTitle:@"电话" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [aletView addSubview:label6];
     _textWay = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label6.frame)+10, CGRectGetMaxY(fiveLineView.frame)+12, wid-30-CGRectGetMaxX(label6.frame)-10, 20)];
    _textWay.font = FontSize(15);
    _textWay.placeholder = @"请输入员工电话";
    [aletView addSubview:_textWay];
    UIView * sixLineView = [myLjjTools createViewWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+44*2, wid-30, 1) andBgColor:LINECOLOR];
    [aletView addSubview:sixLineView];
    
    UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake(16, CGRectGetMaxY(sixLineView.frame)+30,(wid-48)/2.0, 36) andTitle:@"提交" andTitleColor:WHITEColor andBgColor:rgb(251, 97, 18) andSelecter:@selector(submitClick) andTarget:self];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:4.0 with:btn];
    [aletView addSubview:btn];

    UIButton * btn1 = [myLjjTools createButtonWithFrame:CGRectMake(16*2+(wid-48)/2.0, CGRectGetMaxY(sixLineView.frame)+30,(wid-48)/2.0, 36) andTitle:@"提交并继续邀请" andTitleColor:MAINThemeColor andBgColor:WHITEColor andSelecter:@selector(btnAgainClick) andTarget:self];
    btn1.layer.cornerRadius = 4.0;
    btn1.layer.borderColor = MAINThemeColor.CGColor;
    btn1.layer.borderWidth =1;
    [aletView addSubview:btn1];
    
    [self createCloseBtn];

}
//提交
-(void)submitClick{
    
    if([JudgeSummaryLJJ valiMobile:_textWay.text].length>0){
    
        ToastWithTitle([JudgeSummaryLJJ valiMobile:_textWay.text]);
        return;
    }
    
    [self.delegate selectSubmitPeople:_textName.text with:_textWay.text];
    [self close];
    
}
//提交并继续
-(void)btnAgainClick{
   
    _textName.text = @"";
    _textWay.text = @"";
   [self.delegate selectSubmitGoOnPeople:_textName.text with:_textWay.text];
    
}

#pragma mark ------------选择部门-----------------------
-(void)selectSection{

    CGFloat wid = SCREEN_WIDTH-widSize(27)*2;
    CGFloat high = 240;
    UIView * aletView = [myLjjTools createViewWithFrame:CGRectMake(widSize(27), heiSize(140), wid, high) andBgColor:[UIColor whiteColor]];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:8.0 with:aletView];
    [self addSubview:aletView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, wid-40,heiSize(60))];
    _titleLabel.text = @"选择部门";
    _titleLabel.textColor = BlackColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [aletView addSubview:_titleLabel];
    
    UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(0, heiSize(60),wid, 3) andImageName:@"" andBgColor:MAINThemeOrgColor];
    [aletView addSubview:imageView];

    UILabel * label5 = [myLjjTools createLabelWithFrame:CGRectMake(16,CGRectGetMaxY(imageView.frame)+30, 40, 15) andTitle:@"部门" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [aletView addSubview:label5];
    _sectionListLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label5.frame)+10,CGRectGetMaxY(imageView.frame)+27, wid-30-CGRectGetMaxX(label5.frame)-10, 20)];
    _sectionListLabel.text = @"请选择部门";
    _sectionListLabel.font = FontSize(15);
    _sectionListLabel.textColor = rgb(125, 125, 125);
    _sectionListLabel.textColor = BlackColor;
    _sectionListLabel.textAlignment = NSTextAlignmentLeft;
    _sectionListLabel.numberOfLines = 0;
    [aletView addSubview:_sectionListLabel];
    WEAKSELF
    [_sectionListLabel addTapGuester:YES with:^{
        
        NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
        [parameters setObject:[GVUserDefaults standardUserDefaults].companyId forKey:@"companyId"];
     
        [HttpRequest postWithURL:HTTP_URLIP(get_AllDepartment) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
            NSMutableArray * arr = [NSMutableArray array];
            for(NSDictionary * dict in responseObject[@"data"]){
                sectionListModel * model = [[sectionListModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [arr addObject:model];
            }
            weakSelf.sectionView = [[xialaView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label5.frame)+10, CGRectGetMaxY(weakSelf.sectionListLabel.frame), wid-30-CGRectGetMaxX(label5.frame)-10, 150) witharr:arr];
            weakSelf.sectionView.delegate = weakSelf;
            weakSelf.sectionView.tag = 123;
            [aletView addSubview:weakSelf.sectionView];

        } failure:^(NSError *error) {
            
        }];
    }];

    UIView * fiveLineView = [myLjjTools createViewWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+59, wid-30, 1) andBgColor:LINECOLOR];
    [aletView addSubview:fiveLineView];

    UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake(40, CGRectGetMaxY(fiveLineView.frame)+60,wid-80, 36) andTitle:@"提交" andTitleColor:WHITEColor andBgColor:rgb(251, 97, 18) andSelecter:@selector(sumBtnClick) andTarget:self];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:4.0 with:btn];
    [aletView addSubview:btn];
    
     [self createCloseBtn];
}


-(void)xialachooseRetuDataWith:(sectionListModel *)model{

    _model = model;
    _sectionView = nil;
    [_sectionView removeFromSuperview];
    _sectionListLabel.text = model.departName;
    
}

//提交
-(void)sumBtnClick{
    if (_model) {
    [self removeFromSuperview];
    [self.delegate selectSubmitPeopleModel:_model];
    }else{
    [self.delegate selectSubmitPeopleModel:nil];
    [self removeFromSuperview];
    }
}
#pragma mark ---------创建部门---------------
-(void)createSetion{

    CGFloat wid = SCREEN_WIDTH-widSize(27)*2;
    CGFloat high = 240;
    UIView * aletView = [myLjjTools createViewWithFrame:CGRectMake(widSize(27), heiSize(140), wid, high) andBgColor:[UIColor whiteColor]];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:8.0 with:aletView];
    [self addSubview:aletView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, wid-40,heiSize(60))];
    _titleLabel.text = @"创建部门";
    _titleLabel.textColor = BlackColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [aletView addSubview:_titleLabel];
    
    UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(0, heiSize(60),wid, 3) andImageName:@"" andBgColor:MAINThemeOrgColor];
    [aletView addSubview:imageView];

    UILabel * label5 = [myLjjTools createLabelWithFrame:CGRectMake(16,CGRectGetMaxY(imageView.frame)+30, 40, 15) andTitle:@"部门" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [aletView addSubview:label5];
    _textName = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label5.frame)+10,CGRectGetMaxY(imageView.frame)+27, wid-30-CGRectGetMaxX(label5.frame)-10, 20)];
    _textName.font = FontSize(15);
    _textName.placeholder = @"请手动输入您想创建的部门";
    [aletView addSubview:_textName];
    UIView * fiveLineView = [myLjjTools createViewWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+59, wid-30, 1) andBgColor:LINECOLOR];
    [aletView addSubview:fiveLineView];
    
    UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake(92, CGRectGetMaxY(fiveLineView.frame)+45,wid-184, 36) andTitle:@"添加" andTitleColor:WHITEColor andBgColor:rgb(251, 97, 18) andSelecter:@selector(btnClick) andTarget:self];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:4.0 with:btn];
    [aletView addSubview:btn];

     [self createCloseBtn];
}

-(void)createCloseBtn{

   UIButton * closeBtn = [myLjjTools createButtonWithFrame:CGRectMake(widSize(163), SCREEN_HEIGHT-heiSize(146) , widSize(56), widSize(56)) andImage:[UIImage imageNamed:@"我的_公司_关闭按钮"] andSelecter:@selector(close) andTarget:self];
    [self addSubview:closeBtn];
    
}

-(void)close{

    [self HID];

}


-(void)btnClick{

    [self close];
    [self.delegate LJJAlertPromViewClick:_textName.text];
    
}


- (void)show {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .25;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        //_contentView.alpha = 1;
    }];
    
//    [UIView animateWithDuration:2 animations:^{
//      
//        self.frame = CGRectMake(self.frame.origin.x, -self.frame.origin.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
//        
//    } completion:^(BOOL finished) {
//        
//         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
//        
//    }];
    
    
}

-(void)HID{


    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];



}

@end
