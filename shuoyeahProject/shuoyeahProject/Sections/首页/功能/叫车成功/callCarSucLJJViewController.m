//
//  callCarSucLJJViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "callCarSucLJJViewController.h"
#import "chatIMInfoViewController.h"
#import "touSuMessageViewController.h"
#import "FYLPageViewController.h"
@interface callCarSucLJJViewController ()<UITableViewDelegate,UITableViewDataSource>{

    NSArray * titleArr;

}
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation callCarSucLJJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"预约成功";
    self.navigationItem.leftBarButtonItem = [self itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    titleArr = @[@"订单号",@"出发地",@"目的地",@"预约时间",@"是否往返",@"往返时间"];
    self.navigationController.navigationBar.translucent = YES;
    [self createTabel];
    // Do any additional setup after loading the view.
}

- (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[self imageWithName:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithName:highIcon] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 10, 20);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (UIImage *)imageWithName:(NSString *)name
{
    if (iOS7) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        UIImage *image = [UIImage imageNamed:newName];
        if (image == nil) { // 没有_os7后缀的图片
            image = [UIImage imageNamed:name];
        }
        return image;
    }
    
    // 非iOS7
    return [UIImage imageNamed:name];
}


- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark ----------------------------tableView----------------------------------
-(void)createTabel{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:LINECOLOR];
    _tableView.backgroundColor = BACKLJJcolor;
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==0){
    
        return 125;
    
    }else{
    
        return 50;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

      return 100;

}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) andBgColor:WHITEColor];
    UIButton * seeBtn = [myLjjTools createButtonWithFrame:CGRectMake(15, 20, (SCREEN_WIDTH-40)/2.0, 36) andTitle:@"查看行程" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(seeRouteClick) andTarget:self];
    seeBtn.layer.cornerRadius = 4.0;
    seeBtn.clipsToBounds = YES;
    [footView addSubview:seeBtn];
    UIButton * cancelBtn = [myLjjTools createButtonWithFrame:CGRectMake(25+(SCREEN_WIDTH-40)/2.0, 20, (SCREEN_WIDTH-40)/2.0, 36) andTitle:@"取消" andTitleColor:MAINThemeColor andBgColor:WHITEColor andSelecter:@selector(cancelRouteClick) andTarget:self];
    cancelBtn.layer.cornerRadius = 4.0;
    cancelBtn.clipsToBounds = YES;
    cancelBtn.layer.borderColor = MAINThemeColor.CGColor;
    cancelBtn.layer.borderWidth = 1;
    [footView addSubview:cancelBtn];

    return footView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *ID = [NSString stringWithFormat:@"callSucID%ld",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.textLabel.font = FontSize(15);
        cell.textLabel.textColor =RGB170;
        cell.detailTextLabel.font = FontSize(15);
        cell.detailTextLabel.textColor = BlackColor;
        
        if(indexPath.row==0){
        
            UIImageView * headImg = [myLjjTools createImageViewWithFrame:CGRectMake((SCREEN_WIDTH-70)/2.0, 15, 70, 70) andImageName:@"user" andBgColor:nil];
            [headImg sd_setImageWithURL:[NSURL URLWithString:_dataModel.userHeadImg] placeholderImage:[UIImage imageNamed:@"user"]];
            headImg.layer.cornerRadius = 35;
            headImg.clipsToBounds = YES;
            [cell.contentView addSubview:headImg];
            UILabel * nameLabel = [myLjjTools createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(headImg.frame)+5, SCREEN_WIDTH-20, 20) andTitle:@"张师傅" andTitleFont:FontSize(17) andTitleColor:BlackColor andTextAlignment:NSTextAlignmentCenter andBgColor:nil];
            [cell.contentView addSubview:nameLabel];
            
            UIButton * button = [myLjjTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame)+5, 20, 30, 30) andImage:[UIImage imageNamed:@"我的_messenge"] andSelecter:@selector(callIMClick) andTarget:self];
            button.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:button];
            
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row==0){
    
    
    }else{
    cell.textLabel.text = titleArr[indexPath.row-1];
        switch (indexPath.row) {
            case 1:
                cell.detailTextLabel.text = _dataModel.strokeSn;
                break;
            case 2:
                cell.detailTextLabel.text = _dataModel.startAddress;
                break;
            case 3:
                cell.detailTextLabel.text = _dataModel.endAddress;
                break;
            case 4:
                cell.detailTextLabel.text = [logicDone timeIntChangeToStr:_dataModel.startTime];
                break;
            case 5:
                cell.detailTextLabel.text = _dataModel.isRound.integerValue?@"是":@"否";
                break;
            case 6:
                cell.detailTextLabel.text = [logicDone timeIntChangeToStr:_dataModel.roundTime];
                break;
    
            default:
                break;
        }
    
    }
    return cell;
}

#pragma mark -------查看行程-------------
-(void)seeRouteClick{
    
    FYLPageViewController * route = [[FYLPageViewController alloc]init];
    route.title = @"我的行程";
    [self.navigationController pushViewController:route animated:YES];
    
}
#pragma mark -------取消行程-------------
-(void)cancelRouteClick{
    
    touSuMessageViewController * cancel = [touSuMessageViewController new];
    cancel.typeNumber = 2;
    cancel.orderId = _dataModel.strokeId;
    [self.navigationController pushViewController:cancel animated:YES];
   
//    touSuMessageViewController * cancel = [touSuMessageViewController new];
//    cancel.typeNumber = 2;
//    [self.navigationController pushViewController:cancel animated:YES];

}
#pragma mark -------聊天-------------
-(void)callIMClick{

    chatIMInfoViewController * chatInfo = [[chatIMInfoViewController alloc]init];
    [self.navigationController pushViewController:chatInfo animated:YES];

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
