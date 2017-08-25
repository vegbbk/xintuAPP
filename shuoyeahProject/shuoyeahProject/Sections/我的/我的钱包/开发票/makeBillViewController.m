//
//  makeBillViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "makeBillViewController.h"
#import "billByRouteListViewController.h"
#define heiView  50
@interface makeBillViewController (){

    UIButton *_rightDoneButton;
    UIScrollView * _scroll;
    UITextField * _addressText;//地址
    NSString *  _byAmountOrOrders;//按金额开还是按行程开
    UITextField * _cityText;//城市
    UITextField * _content;//发票内容
    UITextField * _phonenumber;//电话号码
    UITextField * _recipients;//收件人
    UITextField * _title;//发票抬头
}

@end

@implementation makeBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开发票";
    [self createUI];
    [self createRightBtn];
    [self createMoney];
      // Do any additional setup after loading the view.
}

-(void)createRightBtn{

    _rightDoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _rightDoneButton.frame = CGRectMake(0, 0, 40, 20);
    _rightDoneButton.hidden = YES;
    [_rightDoneButton setTitle:@"确定" forState:normal];
    [_rightDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightDoneButton.titleLabel.font = FontSize(15);
    // [releaseButton setBackgroundColor:MAINThemeColor];
    [_rightDoneButton addTarget:self action:@selector(DoneAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightDoneButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

}

-(void)DoneAction{
    
    if(_addressText.text.length==0){
        ToastWithTitle(@"地址不能为空");
        return;
    }
    if(_byAmountOrOrders.length==0){
        ToastWithTitle(@"请选择开发票方法");
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
    if([JudgeSummaryLJJ valiMobile:_phonenumber.text].length>0){
        ToastWithTitle([JudgeSummaryLJJ valiMobile:_phonenumber.text]);
        return;
    }
    if(_recipients.text.length==0){
        ToastWithTitle(@"收件人不能为空");
        return;
    }
    if(_title.text.length==0){
        ToastWithTitle(@"发票抬头不能为空");
        return;
    }

    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:_addressText.text forKey:@"address"];
    [parameters setObject:_amount forKey:@"amount"];
    [parameters setObject:_byAmountOrOrders forKey:@"byAmountOrOrders"];
    [parameters setObject:_cityText.text forKey:@"city"];
    [parameters setObject:_content.text forKey:@"content"];
    [parameters setObject:_phonenumber.text forKey:@"phonenumber"];
    [parameters setObject:_recipients.text forKey:@"recipients"];
    [parameters setObject:_title.text forKey:@"title"];
    SET_OBJRCT(@"orderIds", self.orderIDSStr)
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(receipt_apply) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        
        ToastWithTitle(@"开票成功,请等待收件");
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];


}

-(void)createUI{

    UILabel * label = [myLjjTools createLabelWithFrame:CGRectMake(10, 110, SCREEN_WIDTH-20, 15) andTitle: [NSString stringWithFormat:@"本次最高可开%.2lf元",self.amount.floatValue] andTitleFont:FontSize(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentCenter andBgColor:CLEARCOLOR];
    label= [myLjjTools createLabelTextWithView:label andwithChangeColorTxt:@"1600.00" withColor:MAINThemeColor];
    [self.view addSubview:label];
    
    UIButton * moneyBtn = [myLjjTools createButtonWithFrame:CGRectMake(15, 167, (SCREEN_WIDTH-35)/2.0, 46) andTitle:@"+ 按金额添加" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(moneyClick) andTarget:self];
    [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:4 with:moneyBtn];
    
    UIButton * routeBtn = [myLjjTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(moneyBtn.frame)+5, 167, (SCREEN_WIDTH-35)/2.0, 46) andTitle:@"+ 按行程添加" andTitleColor:MAINThemeColor andBgColor:WHITEColor andSelecter:@selector(routeClick) andTarget:self];
    routeBtn.layer.borderColor = MAINThemeColor.CGColor;
    routeBtn.layer.borderWidth = 1;
    routeBtn.layer.cornerRadius = 4.0;
    routeBtn.clipsToBounds = YES;
 //   [myLjjTools roundingCorners:UIRectCornerAllCorners cornerRadius:4 with:routeBtn];
    
    [self.view addSubview:moneyBtn];
    [self.view addSubview:routeBtn];

}

#pragma -------------按金额开票---------------
-(void)moneyClick{

    if(self.amount.integerValue==0){
        ToastWithTitle(@"没开票金额");
        return;
    }
    _rightDoneButton.hidden = NO;
    _scroll.hidden = NO;
    _byAmountOrOrders = @"1";
}
#pragma -------------按行程开票---------------
-(void)routeClick{

    _rightDoneButton.hidden = YES;
    _scroll.hidden = YES;
     _byAmountOrOrders = @"2";
    billByRouteListViewController * bill = [[billByRouteListViewController alloc]init];
    [self.navigationController pushViewController:bill animated:YES];

}

-(void)createMoney{

     _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 242, SCREEN_WIDTH, SCREEN_HEIGHT-242)];
    _scroll.scrollEnabled = YES;
    _scroll.hidden = YES;
    _scroll.backgroundColor = BACKLJJcolor;
    [self.view addSubview:_scroll];

    UIView * backView = [myLjjTools createViewWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 350) andBgColor:WHITEColor];
    [_scroll addSubview:backView];
    
    UILabel * label1 = [myLjjTools createLabelWithFrame:CGRectMake(16, 19, 80, 15) andTitle:@"发票内容:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label1];
    UITextField * textTitle = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+10, 15, SCREEN_WIDTH-30-CGRectGetMaxX(label1.frame)-10, 20)];
    textTitle.font = FontSize(15);
    textTitle.placeholder = @"请输入内容";
    [backView addSubview:textTitle];
    _content= textTitle;
    UIView * oneLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:oneLineView];
    
    UILabel * label2 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(oneLineView.frame)+19, 80, 15) andTitle:@"发票金额:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label2];
    UITextField * textMoney = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame)+10,CGRectGetMaxY(oneLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label2.frame)-10, 20)];
    textMoney.font = FontSize(15);
    textMoney.userInteractionEnabled = NO;
    textMoney.text = self.amount;
    [backView addSubview:textMoney];
    UIView * twoLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 2*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:twoLineView];

    UILabel * label3 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(twoLineView.frame)+19, 80, 15) andTitle:@"发票抬头:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label3];
    UITextField * textHead = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame)+10, CGRectGetMaxY(twoLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label3.frame)-10, 20)];
    textHead.font = FontSize(15);
    textHead.placeholder = @"请输入公司名或个人";
    [backView addSubview:textHead];
    _title = textHead;
    UIView * threeLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 3*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:threeLineView];

    UILabel * label4 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(threeLineView.frame)+19, 80, 15) andTitle:@"开票城市:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label4];
    UITextField * textCity = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame)+10, CGRectGetMaxY(threeLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label4.frame)-10, 20)];
    textCity.font = FontSize(15);
    textCity.placeholder = @"请输入城市名";
    [backView addSubview:textCity];
    _cityText = textCity;
    UIView * fourLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 4*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:fourLineView];

    UILabel * label5 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(fourLineView.frame)+19, 90, 15) andTitle:@"收件人姓名:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label5];
    UITextField * textName = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label5.frame)+10, CGRectGetMaxY(fourLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label5.frame)-10, 20)];
    textName.font = FontSize(15);
    textName.placeholder = @"请输入收件人姓名";
    [backView addSubview:textName];
    _recipients = textName;
    UIView * fiveLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 5*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:fiveLineView];
    
    UILabel * label6 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(fiveLineView.frame)+19, 80, 15) andTitle:@"联系方式:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label6];
    UITextField * textWay = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label6.frame)+10, CGRectGetMaxY(fiveLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label6.frame)-10, 20)];
    textWay.font = FontSize(15);
    textWay.placeholder = @"请输入手机号";
    [backView addSubview:textWay];
    _phonenumber = textWay;
    UIView * sixLineView = [myLjjTools createViewWithFrame:CGRectMake(0, 6*50, SCREEN_WIDTH-30, 1) andBgColor:LINECOLOR];
    [backView addSubview:sixLineView];
    
    UILabel * label7 = [myLjjTools createLabelWithFrame:CGRectMake(16, CGRectGetMaxY(sixLineView.frame)+19, 80, 15) andTitle:@"收件地址:" andTitleFont:MAINtextFont(15) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentLeft andBgColor:CLEARCOLOR];
    [backView addSubview:label7];
    UITextField * textDress = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label7.frame)+10, CGRectGetMaxY(sixLineView.frame)+15, SCREEN_WIDTH-30-CGRectGetMaxX(label7.frame)-10, 20)];
    textDress.font = FontSize(15);
    textDress.placeholder = @"请输入地址";
    [backView addSubview:textDress];
    _addressText = textDress;
     _scroll.contentSize=CGSizeMake(SCREEN_WIDTH,400);
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
