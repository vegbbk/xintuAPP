//
//  pullDownView.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/4/20.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "pullDownView.h"

@implementation pullDownView

-(id)initWithFrame:(CGRect)frame with:(NSInteger)indexNum with:(CGFloat)titleHIGHT  with:(CGFloat)heighFloat{

    self = [super initWithFrame:frame];
    if (self) {
        _titleHIGHT = titleHIGHT;
        _heighFloat =heighFloat;
        _indexNum = indexNum;
         _isSingle = YES;
        [self createListView];

    }
    return self;


}
#pragma mark -----------接送机选择--------------------
-(void)createSegment{
    _buttonsArr = [NSMutableArray array];
    NSArray * titleArr = @[@"接机",@"送机"];
    _topView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, _titleHIGHT) andBgColor:WHITEColor];
    [self addSubview:_topView];
    
    for(int i = 0;i<2;i++){
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH/2.0*i, 0, SCREEN_WIDTH/2.0, 50);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setBackgroundColor:CLEARCOLOR];
        button.titleLabel.font = FontSize(17);
        button.tag = 222+i;
        if(i==0){
            [button setTitleColor:MAINThemeColor forState:UIControlStateNormal];
        }else{
            [button setTitleColor:BlackColor forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:button];
        [_buttonsArr addObject:button];
        if(i==0){
            _lineView = [myLjjTools createViewWithFrame:CGRectMake(SCREEN_WIDTH/2.0*i+20, 50, SCREEN_WIDTH/2.0-40, 1) andBgColor:MAINThemeColor];
            [_topView addSubview:_lineView];
        }
    }
    
}
// 选中按钮
- (void)btnClick:(UIButton *)btn
{
    NSUInteger i = btn.tag-222;
    for(UIButton * butt in _buttonsArr){
        
        [butt setTitleColor:BlackColor forState:UIControlStateNormal];
        
    }
    [btn setTitleColor:MAINThemeColor forState:UIControlStateNormal];
    
    _lineView.frame = CGRectMake(SCREEN_WIDTH/2.0*i+20, 50, SCREEN_WIDTH/2.0-40, 1);
    
}


-(void)createListView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = CLEARCOLOR;
    [self addSubview:_tableView];
    [_tableView  setSeparatorColor:LINECOLOR];
    _bottomBtn = [myLjjTools createButtonWithFrame:CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25) andImage:[UIImage imageNamed:@"首页_下拉"] andSelecter:@selector(chooseClick:) andTarget:self];
    [self addSubview:_bottomBtn];
}



-(void)chooseClick:(UIButton*)btn{
    
    btn.selected = !btn.selected;
    [UIView animateWithDuration:0.5 animations:^{
        
        if(btn.selected){
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _heighFloat);
            self.frame = CGRectMake(0, _titleHIGHT, SCREEN_WIDTH, _heighFloat);
            _tableView.scrollEnabled = YES;
            [_bottomBtn setImage:[UIImage imageNamed:@"首页_上拉"] forState:UIControlStateNormal];
            _bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
            _isUnfold = YES;
        }else{
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
             self.frame = CGRectMake(0, _titleHIGHT, SCREEN_WIDTH, 80);
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            _tableView.scrollEnabled = NO;
            [_bottomBtn setImage:[UIImage imageNamed:@"首页_下拉"] forState:UIControlStateNormal];
            _bottomBtn.frame = CGRectMake((SCREEN_WIDTH-25)/2.0, CGRectGetMaxY(_tableView.frame)-12, 25, 25);
            _isUnfold = NO;
        }
        
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * strID = [NSString stringWithFormat:@"mybussCellID%ld",indexPath.row];
    NSString *ID = strID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        if(indexPath.row==1){
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 9, 13) andImageName:@"首页_地址" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            WEAKSELF
            _startTextField = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+11, 10, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-20, 20) andTitle:@"你在哪儿?" andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
            [_startTextField addTapGuester:YES with:^{
                [weakSelf.delegate selectStartPlace];
            }];
             [cell.contentView addSubview:_startTextField];
            
        }else if(indexPath.row==2){
            
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 9, 13) andImageName:@"首页_地址" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            
            _endTextField = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+11, 10, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-20, 20) andTitle:@"你要去在哪儿?" andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
            [cell.contentView addSubview:_endTextField];
            WEAKSELF
            [_endTextField addTapGuester:YES with:^{
                [weakSelf.delegate selectEndPlace];
            }];
        }else if(indexPath.row==3){
            
            _singleBtn = [[headCateButton alloc]initWithFrame:CGRectMake(15, 0, 70, 40)];
            _singleBtn.btnLab.text = @"单程";
            _singleBtn.btnImageView.image = [UIImage imageNamed:@"首页_往返"];
            [cell.contentView addSubview:_singleBtn];
            [_singleBtn addTarget:self action:@selector(selectSinDou:) forControlEvents:UIControlEventTouchUpInside];
            _doubleBtn = [[headCateButton alloc]initWithFrame:CGRectMake(15+CGRectGetMaxX(_singleBtn.frame)+5, 0, 70, 40)];
            _doubleBtn.btnLab.text = @"往返";
            _doubleBtn.btnLab.textColor = RGB170;
            _doubleBtn.btnImageView.image = [UIImage imageNamed:@"首页_单程"];
            [cell.contentView addSubview:_doubleBtn];
            [_doubleBtn addTarget:self action:@selector(selectSinDou:) forControlEvents:UIControlEventTouchUpInside];
        }else if(indexPath.row==4){
            
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 12, 13) andImageName:@"首页_时间" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            
            UILabel * label = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, 10, 80, 20) andTitle:@"出发时间:" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
            [cell.contentView addSubview:label];
            
            _startLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 10, SCREEN_WIDTH-CGRectGetMaxX(label.frame), 20) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
            _startLabel.userInteractionEnabled = YES;
            [cell.contentView addSubview:_startLabel];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startClick)];
            [_startLabel addGestureRecognizer:tap];
            
        }else if(indexPath.row==5){
            
            _returnImg = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 12, 13) andImageName:@"首页_时间" andBgColor:nil];
            _returnImg.hidden = YES;
            [cell.contentView addSubview:_returnImg];
            
            _returnTimeLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(_returnImg.frame)+5, 10, 80, 20) andTitle:@"返回时间:" andTitleFont:FontSize(15) andTitleColor:RGB170 andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
            _returnTimeLabel.hidden = YES;
            [cell.contentView addSubview:_returnTimeLabel];
            
            _returnLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(_returnTimeLabel.frame), 10, SCREEN_WIDTH-CGRectGetMaxX(_returnTimeLabel.frame), 20) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
            _returnLabel.userInteractionEnabled = YES;
            [cell.contentView addSubview:_returnLabel];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(returnClick)];
            _returnLabel.hidden = YES;
            [_returnLabel addGestureRecognizer:tap];
            
        }else if(indexPath.row==6){
            
            UIButton * selectCar = [UIButton buttonWithType:UIButtonTypeCustom];
            selectCar.frame = CGRectMake(widSize(56), heiSize(15), 60, 50);
            [selectCar setImage:[UIImage imageNamed:@"首页_选择车型_奢华车型"] forState:UIControlStateNormal];
            [selectCar setTitle:@"豪华车型" forState:UIControlStateNormal];
            selectCar.titleLabel.font = FontSize(14);
            [selectCar setTitleColor:RGB170 forState:UIControlStateNormal];
            selectCar.imageRect = CGRectMake(0, 0, 60, 25);
            selectCar.titleRect = CGRectMake(0, 34, 60, 15);
            [selectCar addTarget:self action:@selector(selectCarStyle) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:selectCar];
            
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(CGRectGetMaxX(selectCar.frame)+widSize(42), 30, 11, 21) andImageName:@"iconfont-fanhui-拷贝-7" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            
            _freeMoneyLabel = [[UILabel alloc]init];
            _freeMoneyLabel.text = @"约190元";
            _freeMoneyLabel.numberOfLines = 0;
            _freeMoneyLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame), 12, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-26, 28);
            _freeMoneyLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:_freeMoneyLabel];
            WEAKSELF
            [_freeMoneyLabel addTapGuester:YES with:^{
                [weakSelf jumpToFreeInfo];
            }];
            
            UILabel * label1 = [[UILabel alloc]init];
            label1.text = @"优惠券已抵扣10元";
            label1.numberOfLines = 0;
            label1.font = FontSize(12);
            label1.frame = CGRectMake(CGRectGetMaxX(imageView.frame), 40, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-26, 28);
            label1.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label1];
            [label1 addTapGuester:YES with:^{
                [weakSelf jumpToFreeInfo];
            }];
            UIImageView * imageViewOne = [myLjjTools createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-26, 30, 11, 21) andImageName:@"iconfont-fanhui-拷贝-7" andBgColor:nil];
            [cell.contentView addSubview:imageViewOne];
            
        }else if(indexPath.row==7){
            
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 9, 13) andImageName:@"首页_司机" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            
            _driverLabel = [[UILabel alloc]init];
            _driverLabel.text = @"挑选司机";
            _driverLabel.numberOfLines = 0;
            _driverLabel.font = FontSize(15);
            _driverLabel.textColor = MAINThemeOrgColor;
            _driverLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame)+3, 10, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-10, 20);
            [cell.contentView addSubview:_driverLabel];
            
            [_driverLabel addTapGuester:YES with:^{
                
                
                
            }];
            
        }else if(indexPath.row==8){
            
            UIImageView * imageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 9, 13) andImageName:@"首页_编辑" andBgColor:nil];
            [cell.contentView addSubview:imageView];
            
            _otherText = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+3, 10, SCREEN_WIDTH-CGRectGetMaxX(imageView.frame)-10, 20)];
            _otherText.placeholder = @"是否有其他要求?";
            _otherText.font = FontSize(15);
            [cell.contentView addSubview:_otherText];
            
        }else if(indexPath.row==9){
            
            UIButton * sureCarBtn = [myLjjTools createButtonWithFrame:CGRectMake(67, 22, SCREEN_WIDTH-67*2, 36) andTitle:@"确认用车" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(sureCarClick) andTarget:self];
            sureCarBtn.layer.cornerRadius = 4.0;
            [cell.contentView addSubview:sureCarBtn];
        }else if(indexPath.row==0){
            
            _plainImageView = [myLjjTools createImageViewWithFrame:CGRectMake(16, 14, 9, 13) andImageName:@"首页_地址" andBgColor:nil];
            _plainImageView.hidden = YES;
            [cell.contentView addSubview:_plainImageView];
            
            _flightText = [myLjjTools createTextFieldFrame:CGRectMake(CGRectGetMaxX(_plainImageView.frame)+11, 10, SCREEN_WIDTH-CGRectGetMaxX(_plainImageView.frame)-20, 20) andPlaceholder:@"请输入航班" andTextColor:BlackColor andTextFont:FontSize(15) andReturnType:UIReturnKeyDone];
            _flightText.hidden = YES;
            [cell.contentView addSubview:_flightText];
            
            
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==6){
        return 80;
    }else if(indexPath.row==9){
        return 80;
    }else if(indexPath.row==5){
        
        if(_isSingle){
            return 0.0;
        }else{
            return 40.0;
        }
        
    }else if(indexPath.row==0){
        
        if(!_isUnfold){
            
            _plainImageView.hidden = YES;
            _flightText.hidden = YES;
            return 0.0;
        }else{
            if(self.indexNum==2){
                
                _plainImageView.hidden = YES;
                _flightText.hidden = YES;
                return 0.0;
            }else{
                _plainImageView.hidden = NO;
                _flightText.hidden = NO;
                
                return 40.0;
            }
        }
        
    }else{
        return 40.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark --------------------时间-----------------
- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}
-(void)startClick{
    
    MHDatePicker *_selectTimePicker = [[MHDatePicker alloc] init];
    __weak typeof(self) weakSelf = self;
    [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        _startLabel.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"];
    }];
}

-(void)returnClick{
    
    MHDatePicker *_selectTimePicker = [[MHDatePicker alloc] init];
    __weak typeof(self) weakSelf = self;
    [_selectTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        _returnLabel.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"MM月dd日 HH:mm"];
    }];
    
}
#pragma mark --------------------确认用车-----------------
-(void)sureCarClick{

    [self.delegate sureCarClick];

}

#pragma mark ---------预估计费详情-----------------

-(void)jumpToFreeInfo{
    
    [self.delegate jumpToFreeInfo];
    
}

-(void)selectCarStyle{

    [self.delegate selectCarStyle];
    
}

#pragma mark --------------------选择往返单程-----------------
-(void)selectSinDou:(headCateButton*)btn{
    
    _doubleBtn.btnLab.textColor = RGB170;
    _doubleBtn.btnImageView.image = [UIImage imageNamed:@"首页_单程"];
    _singleBtn.btnLab.textColor = RGB170;
    _singleBtn.btnImageView.image = [UIImage imageNamed:@"首页_单程"];
    
    btn.btnLab.textColor = BlackColor;
    btn.btnImageView.image = [UIImage imageNamed:@"首页_往返"];
    
    if(btn==_singleBtn){
        
        _isSingle = YES;
        _returnImg.hidden = YES;
        _returnTimeLabel.hidden = YES;
        _returnLabel.hidden = YES;
        [self.tableView reloadData];
        
    }else{
        
        _isSingle = NO;
        _returnImg.hidden = NO;
        _returnTimeLabel.hidden = NO;
        _returnLabel.hidden = NO;
        [self.tableView reloadData];
    }
    
    
}


@end
