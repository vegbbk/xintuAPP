//
//  touSuMessageViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "touSuMessageViewController.h"
#import "CustomTextVeiw.h"
#import "nextTousuTableViewController.h"
#import "complaintModel.h"
#import "moneyNoEnoughView.h"
#import "jifenCZViewController.h"
@interface touSuMessageViewController ()<typeSelectDelegate,gotoChargeMoneyDelegate>{

    UILabel * _titleLabel;

    NSString * compaType;//投诉类型
}
@property (nonatomic,strong)CustomTextVeiw * writeText;
@end

@implementation touSuMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     NSString * titleStr  = nil;
    NSString * infoStr;
    if(_typeNumber==1){self.title = @"投诉反馈";titleStr = @"  投诉类型";infoStr = @"请输入您要投诉的内容";}
    if(_typeNumber==2){self.title = @"取消订单";titleStr = @"  取消类型";infoStr = @"请输入您取消订单的原因";}
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleLabel  = [myLjjTools createLabelWithFrame:CGRectMake(0, 14+64, SCREEN_WIDTH, 50) andTitle:titleStr andTitleFont:FontSize(17) andTitleColor:textMainColor andTextAlignment:NSTextAlignmentLeft andBgColor:WHITEColor];
    _titleLabel.userInteractionEnabled = YES;
    WEAKSELF
    [_titleLabel addTapGuester:YES with:^{
        [weakSelf selectAction];
    }];
    [self.view addSubview:_titleLabel];
    _writeText = [[CustomTextVeiw alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+15, SCREEN_WIDTH, 160)];
    _writeText.backgroundColor = WHITEColor;
    _writeText.customPlaceholder = infoStr;
    [self.view addSubview:_writeText];

    UIButton * Actionbutton = [myLjjTools createButtonWithFrame:CGRectMake(67, CGRectGetMaxY(_writeText.frame)+62, SCREEN_WIDTH-67*2, 36) andTitle:@"提交" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(doneAction) andTarget:self];
    Actionbutton.layer.cornerRadius = 4.0;
    Actionbutton.clipsToBounds = YES;
    [self.view addSubview:Actionbutton];
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    
    UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    releaseButton.frame = CGRectMake(0, 0, 25, 25);
    [releaseButton setBackgroundImage:[UIImage imageNamed:@"我的_电话"] forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(takePhone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
}
#pragma mark ----------选择投诉类型----------------
-(void)selectAction{

    NSString * url = @"";
    if(_typeNumber==1){
        url = HTTP_URLIP(get_CompainType);
    }else if(_typeNumber==2){
        url = HTTP_URLIP(cancel_Reason);
    }
    [HttpRequest postWithURL:url params:nil andNeedHub:YES success:^(NSDictionary *responseObject) {
        NSMutableArray * dataArr = [NSMutableArray array];
        for(NSDictionary * dict in responseObject[@"data"]){
            complaintModel * model = [[complaintModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [dataArr addObject:model];
        }
        nextTousuTableViewController * next = [[nextTousuTableViewController alloc]init];
        next.dataArr = dataArr;
        next.delegate =self;
        [self.navigationController pushViewController:next animated:YES];

    } failure:^(NSError *error) {
        
    }];

}
#pragma mark ---------余额支付----------------
-(void)balanceOnlyClick{
    
    moneyNoEnoughView * no = [[moneyNoEnoughView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    no.delegate = self;
    [self.view addSubview:no];
    
}
#pragma mark -----------去充值-----------
-(void)gotoChargeAction{
    
    jifenCZViewController * czjf = [[jifenCZViewController alloc]init];
    czjf.typeFrom = 2;
    [self.navigationController pushViewController:czjf animated:YES];
    
}

-(void)selectSureType:(complaintModel *)model{

    _titleLabel.text = [NSString stringWithFormat:@"   %@",model.typeName];
    compaType = model.complaintID;
}

#pragma mark ----------投诉----------------
-(void)doneAction{

    if(_writeText.text.length==0){
    
       ToastWithTitle(@"内容不能为空哦");
        return;
    }
    if(!compaType){
        ToastWithTitle(@"类型不能为空哦");
        return;
    }
    NSString * url = @"";
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    if(_typeNumber==1){
        url = HTTP_URLIP(add_Compain);
        [parameters setObject:_writeText.text forKey:@"compainContent"];
        [parameters setObject:compaType forKey:@"compainType"];
    }else if(_typeNumber==2){
        url = HTTP_URLIP(cancel_Order);
       // [parameters setObject:self.orderId forKey:@"strokeId"];
        SET_OBJRCT(@"strokeId", self.orderId)
        SET_OBJRCT(@"cancelType", compaType)
        SET_OBJRCT(@"cancelReason", _writeText.text)
    }
      [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:url params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        
        if([unKnowToStr(responseObject[@"status"]) isEqualToString:@"balance"]){
            [self balanceOnlyClick];
        }else{
        if(_typeNumber==1){
        ToastWithTitle(@"投诉成功,请等待我们的反馈");
        }else{
        ToastWithTitle(@"取消行程成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"routeLIstFreshLJJ" object:self userInfo:nil];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];


}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)takePhone{

    [myLjjTools directPhoneCallWithPhoneNum:@"88888888"];

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
