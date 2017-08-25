//
//  billByRouteWhereViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/5.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "billByRouteWhereViewController.h"

@interface billByRouteWhereViewController (){

    UITextField * textName;
    UITextField * textWay;
    UITextField * textDress;
    UITextField * _content;
    UITextField * _title;
    UITextField * _cityText;
}

@end

@implementation billByRouteWhereViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开发票";
    [self createMoney];
    // Do any additional setup after loading the view.
}

-(void)createMoney{
    
    UIView * backView = [myLjjTools createViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) andBgColor:WHITEColor];
    [self.view addSubview:backView];
    
    UILabel * label1 = [myLjjTools createLabelWithFrame:CGRectMake(16, 19, 80, 15) andTitle:@"发票内容:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label1];
    UITextField * textTitle = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+10, 15, SCREEN_WIDTH-30-CGRectGetMaxX(label1.frame)-10, 20)];
    textTitle.font = FontSize(15);
    textTitle.placeholder = @"请输入内容";
    [backView addSubview:textTitle];
    _content= textTitle;
    UIView * oneLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:oneLineView];
    
    UILabel * label3 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(oneLineView.frame)+19, 80, 15) andTitle:@"发票抬头:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label3];
    UITextField * textHead = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame)+10, CGRectGetMaxY(oneLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label3.frame)-10, 20)];
    textHead.font = FontSize(15);
    textHead.placeholder = @"请输入公司名或个人";
    [backView addSubview:textHead];
    _title = textHead;
    UIView * threeLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 2*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:threeLineView];
    
    UILabel * label4 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(threeLineView.frame)+19, 80, 15) andTitle:@"开票城市:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label4];
    UITextField * textCity = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame)+10, CGRectGetMaxY(threeLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label4.frame)-10, 20)];
    textCity.font = FontSize(15);
    textCity.placeholder = @"请输入城市名";
    [backView addSubview:textCity];
    _cityText = textCity;
    UIView * fourLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 3*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:fourLineView];
    
    UILabel * label5 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(fourLineView.frame)+19, 90, 15) andTitle:@"收件人姓名:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label5];
    textName = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label5.frame)+10, CGRectGetMaxY(fourLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label5.frame)-10, 20)];
    textName.font = FontSize(15);
    textName.placeholder = @"请输入收件人姓名";
    [backView addSubview:textName];
    UIView * fiveLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 4*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:fiveLineView];
    
    UILabel * label6 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(fiveLineView.frame)+19, 80, 15) andTitle:@"联系方式:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label6];
    textWay = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label6.frame)+10, CGRectGetMaxY(fiveLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label6.frame)-10, 20)];
    textWay.font = FontSize(15);
    textWay.placeholder = @"请输入手机号";
    [backView addSubview:textWay];
    UIView * sixLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 5*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:sixLineView];
    
    UILabel * label7 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(sixLineView.frame)+19, 80, 15) andTitle:@"收件地址:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label7];
    textDress = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label7.frame)+10, CGRectGetMaxY(sixLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label7.frame)-10, 20)];
    textDress.font = FontSize(15);
    textDress.placeholder = @"请输入地址";
    [backView addSubview:textDress];
    
    UIView * sevenLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 6*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:sevenLineView];

    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(68, CGRectGetMaxY(sevenLineView.frame)+86, SCREEN_WIDTH-68*2, 35);
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.titleLabel.textColor = WHITEColor;
    [sureBtn setBackgroundColor:MAINThemeColor];
    sureBtn.layer.cornerRadius = 4.0;
    sureBtn.clipsToBounds = YES;
    [backView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)sureAction{
    
        if(textDress.text.length==0){
            ToastWithTitle(@"地址不能为空");
            return;
        }
        if([JudgeSummaryLJJ valiMobile:textWay.text].length>0){
            ToastWithTitle([JudgeSummaryLJJ valiMobile:textWay.text]);
            return;
        }
        if(textName.text.length==0){
            ToastWithTitle(@"收件人不能为空");
            return;
        }
        if(_cityText.text.length==0){
        ToastWithTitle(@"城市不能为空");
        return;
        }
        if(_content.text.length==0){
        ToastWithTitle(@"发票内容不能为空");
        return;
        }
        if(_title.text.length==0){
        ToastWithTitle(@"发票抬头不能为空");
        return;
        }
        NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
        SET_OBJRCT(@"content", _content.text)
        SET_OBJRCT(@"title", _title.text)
        SET_OBJRCT(@"city", _cityText.text)
        [parameters setObject:textDress.text forKey:@"address"];
        [parameters setObject:@"2" forKey:@"byAmountOrOrders"];
        [parameters setObject:textWay.text forKey:@"phonenumber"];
        [parameters setObject:textName.text forKey:@"recipients"];
        SET_OBJRCT(@"orderIds", self.orderStr);
        [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
        [HttpRequest postWithURL:HTTP_URLIP(receipt_apply) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
            ToastWithTitle(@"开票成功,请等待收件");
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"routeApplyLJJ" object:self userInfo:nil];
        } failure:^(NSError *error) {
            
        }];

}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];

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
