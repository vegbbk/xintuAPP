//
//  chargeDetailViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/12.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "chargeDetailViewController.h"
#define LULI 50
@interface chargeDetailViewController (){

    UILabel * _totalMoney;
    UILabel * _startLabel;
    UILabel * _routeLabel;
    UILabel * _routeMoneyLabel;
    UILabel * _timeLebl;
    UILabel * _timeMoneyLabel;//等时费
    UILabel * _oneLabel;//
    UILabel * _leastFee;//
    NSString * _moneyStr;
    UILabel * _timeFreeLabel;//时长费
    UILabel * _nightFreeLabel;//夜间费
}

@end

@implementation chargeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"费用明细";
    self.view.backgroundColor = WHITEColor;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(routing:) name:@"routingMoneyNotiLJJ" object:nil];
    // Do any additional setup after loading the view.
}

-(void)createUI{

    
    _totalMoney = [myLjjTools createLabelWithFrame:CGRectMake(0, 50+64, SCREEN_WIDTH, 20) andTitle:[NSString stringWithFormat:@"%.2lf元",_moneyStr.floatValue] andTitleFont:FontSize(19) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    [self.view addSubview:_totalMoney];
    
    UIView * lineView = [myLjjTools createViewWithFrame:CGRectMake(80, CGRectGetMaxY(_totalMoney.frame)+10, SCREEN_WIDTH-160, 1) andBgColor:LINECOLOR];
    [self.view addSubview:lineView];
    NSArray * arr;
    if(_dataModel.feeType.integerValue==2){
     arr = @[@"起步价",@"里程费",@"时长费",@"一口价",@"最低消费",@"动态加价"];
    }else{
     arr = @[@"起步价",@"里程费",@"时长费",@"一口价",@"最低消费",@"动态加价"];
    }
    
    for(NSInteger i=0;i<arr.count;i++){
    
        UILabel * label1 = [myLjjTools createLabelWithFrame:CGRectMake(LULI, CGRectGetMaxY(lineView.frame)+16+20*i, (SCREEN_WIDTH-LULI*2)/2.0, 20) andTitle:arr[i] andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    
        UILabel * label11 = [myLjjTools createLabelWithFrame:CGRectMake(LULI+(SCREEN_WIDTH-LULI*2)/2.0, CGRectGetMaxY(lineView.frame)+16+20*i, (SCREEN_WIDTH-LULI*2)/2.0, 20) andTitle:@"00.00元" andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentRight andBgColor:CLEARCOLOR];
        if(i==0){
            _startLabel = label11;_startLabel.text= [NSString stringWithFormat:@"%.2lf元",_dataModel.startFee.floatValue];
        }
        if(i==1){_routeLabel = label1;_routeMoneyLabel = label11;_routeMoneyLabel.text= [NSString stringWithFormat:@"%.2lf元",_dataModel.milageFee.floatValue];}
        if(i==3){_oneLabel = label11;
            
            if(_dataModel.feeType.floatValue==2){
            _oneLabel.text = @"0.00元";
            }else{
            _oneLabel.text= [NSString stringWithFormat:@"%.2lf元",_moneyStr.floatValue];
            }
        
        }
        if(i==4){_leastFee = label11;_leastFee.text= [NSString stringWithFormat:@"%.2lf元",_dataModel.leastFee.floatValue];}
        if(i==5){_timeLebl = label1;_timeMoneyLabel = label11;_timeMoneyLabel.text= [NSString stringWithFormat:@"%.2lf倍",_dataModel.dyMultiple.floatValue];
            if(_dataModel.dyMultiple.floatValue!=0.0){
                _timeLebl.hidden = NO;
                _timeMoneyLabel.hidden = NO;
            }else{
                _timeLebl.hidden = YES;
                _timeMoneyLabel.hidden = YES;
            }
        }
        if(i==2){
            _timeFreeLabel = label11;_timeFreeLabel.text = [NSString stringWithFormat:@"%.2lf元",_dataModel.timeFee.floatValue];
        }
        [self.view addSubview:label11];
        [self.view addSubview:label1];
    }


}

-(void)routing:(NSNotification*)noti{

    NSDictionary * dict = noti.userInfo[@"notiMoney"];
    NSLog(@"----------------------------------------------------------%@",dict);
    routingingModel * model = [[routingingModel alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    _totalMoney.text = [NSString stringWithFormat:@"%.2lf元",model.totalFee.floatValue];
    _startLabel.text= [NSString stringWithFormat:@"%.2lf元",model.startFee.floatValue];
    _routeMoneyLabel.text= [NSString stringWithFormat:@"%.2lf元",model.milageFee.floatValue];
    _timeMoneyLabel.text= [NSString stringWithFormat:@"%.2lf倍",model.dyMultiple.floatValue];
    if(_dataModel.dyMultiple.floatValue!=0.0){
        _timeLebl.hidden = NO;
        _timeMoneyLabel.hidden = NO;
    }else{
        _timeLebl.hidden = YES;
        _timeMoneyLabel.hidden = YES;
    }
    _timeFreeLabel.text = [NSString stringWithFormat:@"%.2lf元",model.timeFee.floatValue];
    if(_dataModel.feeType.floatValue==2){
        _oneLabel.text = @"0.00元";
    }else{
        _oneLabel.text= [NSString stringWithFormat:@"%.2lf元",model.totalFee.floatValue];
    }
     _leastFee.text= [NSString stringWithFormat:@"%.2lf元",_dataModel.leastFee.floatValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
