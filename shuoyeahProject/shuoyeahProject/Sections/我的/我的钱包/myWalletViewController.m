//
//  myWalletViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "myWalletViewController.h"
#import "MineCell.h"
#import "billViewController.h"
#import "jifenCZViewController.h"
#import "discountCouponListViewController.h"
#import "consumeHistoryViewController.h"
#import "chargeRecordListViewController.h"
#import "walletLJJModel.h"
@interface myWalletViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UILabel * _balanceLabel;//余额
    UILabel * _companyNameLabel;//公司名

}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation myWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    [self createUI];
    [self createTabel];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self loadData];

}

-(void)createUI{



}

-(void)loadData{

    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [parameters setObject:[GVUserDefaults standardUserDefaults].loginType forKey:@"assignment"];
    if([GVUserDefaults standardUserDefaults].loginType.integerValue==1){
    [parameters setObject:[GVUserDefaults standardUserDefaults].companyId forKey:@"companyId"];
    }
    [HttpRequest postWithURL:HTTP_URLIP(get_Balance) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        walletLJJModel * model = [[walletLJJModel alloc]init];
        [model setValuesForKeysWithDictionary:responseObject[@"data"]];
        _balanceLabel.text = [NSString stringWithFormat:@"%.2lf元",model.balance.floatValue];
        if([GVUserDefaults standardUserDefaults].loginType.integerValue==1){
        _companyNameLabel.text = model.name;
        }else{
        _companyNameLabel.text = @"账户余额";
        }
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark ----------------------------tableView----------------------------------
-(void)createTabel{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView  setSeparatorColor:LINECOLOR];
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
    return 1;
    }else{
        return 4;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section==0){
    
        NSString *ID = @"myWalletCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            _companyNameLabel = [[UILabel alloc]init];
            _companyNameLabel.frame = CGRectMake(15,heiSize(29), SCREEN_WIDTH-125, heiSize(20));
            _companyNameLabel.text = @"未知";
            _companyNameLabel.textColor = rgb(40, 40, 40);
            [cell addSubview:_companyNameLabel];
            
            _balanceLabel = [[UILabel alloc]init];
            _balanceLabel.frame = CGRectMake(15, CGRectGetMaxY(_companyNameLabel.frame)+heiSize(20), SCREEN_WIDTH-125, 20);
            _balanceLabel.text = @"暂无";
            _balanceLabel.textColor = MAINThemeColor;
            [cell addSubview:_balanceLabel];
            
            UIButton * rechargeButton = [myLjjTools createButtonWithFrame:CGRectMake(SCREEN_WIDTH-15-90,heiSize(60), 90, 30) andTitle:@"马上充值" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(rechargeButtonClick) andTarget:self];
            rechargeButton.layer.cornerRadius = 4.0;
            rechargeButton.clipsToBounds = YES;
            [cell addSubview:rechargeButton];

        }
        return cell;
    
    }else{
    
        NSString *ID = @"myWallet";
        MineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[MineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:15];
            cell.detailTextLabel.textColor=rgb(40, 40, 40);
            //cell.detailTextLabel.numberOfLines=2;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if(indexPath.row==0){
            cell.imageName = @"我的_dollar";
            cell.titleStr = @"优惠券";
            //cell.detailTextLabel.text = @"0张";
        }else if(indexPath.row==1){
            cell.imageName = @"我的_file";
            cell.titleStr = @"发票";
           // cell.detailTextLabel.text = @"0张";
        }else if(indexPath.row==2){
            cell.imageName = @"我的_消费记录";
            cell.titleStr = @"消费记录";
           
        }else if(indexPath.row==3){
            cell.imageName = @"我的_充值记录";
            cell.titleStr = @"充值记录";
         
        }
        return cell;
    
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        
        return heiSize(110.0);
        
    }else{
        
        return heiSize(60.0);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section==1&&indexPath.row==1){//发票
        billViewController * bill = [[billViewController alloc]init];
        [self.navigationController pushViewController:bill animated:YES];
    }else if(indexPath.section==1&&indexPath.row==0){//优惠券
        discountCouponListViewController * disc = [[discountCouponListViewController alloc]init];
        [self.navigationController pushViewController:disc animated:YES];
    }else if(indexPath.section==1&&indexPath.row==2){//消费记录
        consumeHistoryViewController * consume = [[consumeHistoryViewController alloc]init];
        [self.navigationController pushViewController:consume animated:YES];
    }else if(indexPath.section==1&&indexPath.row==3){//充值记录
        chargeRecordListViewController * chargeRecord = [[chargeRecordListViewController alloc]init];
        [self.navigationController pushViewController:chargeRecord animated:YES];
    }
    
}

#pragma mark ----充值------------------
-(void)rechargeButtonClick{

    jifenCZViewController * czjf = [[jifenCZViewController alloc]init];
    czjf.typeFrom=1;
    [self.navigationController pushViewController:czjf animated:YES];

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
