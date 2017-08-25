//
//  studentListOrderViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 2017/5/15.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "studentListOrderViewController.h"
#import "routeLJJTableViewCell.h"
#import "routeInfoViewController.h"
#import "driverAndStudentMapViewController.h"
#import "routingInfoNewTableViewCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface studentListOrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSTimer *_timer;
     int _number;
     CGSize _size;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)routeListLJJModel * driModel;
@property (nonatomic,strong)UIImageView * headDriverImg;
@property (nonatomic,strong)UILabel * DriverNameLabel;
@property (nonatomic,strong)UILabel * phoneLabel;
@property (nonatomic,strong)UIImageView * statuImg;
@property (nonatomic,strong)UILabel * nameLabel;
@end

@implementation studentListOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"学生单";
    [self createTable];
    [self loadData];
    _number = 0;
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = [self itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //    如果不想让其他页面的导航栏变为透明 需要重置
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=YES;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    if(_timer){
     [_timer invalidate];
     _timer = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
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
{   [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loadData{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    SET_OBJRCT(@"strokeId", _strokeId);
    SET_OBJRCT(@"userId", [GVUserDefaults standardUserDefaults].userId)
    [HttpRequest postWithURL:HTTP_URLIP(@"stroke/getStuStrokeDetial") params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        if([responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
        _driModel = [[routeListLJJModel alloc]init];
        [_driModel setValuesForKeysWithDictionary:responseObject[@"data"]];
        [self.tableView reloadData];
        [_headDriverImg sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(_driModel.driverHeadImg)] placeholderImage:[UIImage imageNamed:defaultHeadName]];
        _DriverNameLabel.text = _driModel.driverName;
        _phoneLabel.text = _driModel.driverPhone;
        switch (_driModel.status.integerValue) {
            case 1:
                _statuImg.image = [UIImage imageNamed:@"未出行"];
                break;
            case 0:
                _statuImg.image = [UIImage imageNamed:@"我的_已取消"];
                break;
            case 2:
                _statuImg.image = [UIImage imageNamed:@"行程中2222"];
                break;
            case 3:
                _statuImg.image = [UIImage imageNamed:@"我的_已完成"];
                break;
            default:
                break;
        }
        }
        _size = [_driModel.studentName sizeWithAttributes:@{NSFontAttributeName:FontSize(15)}];
        if(_size.width>SCREEN_WIDTH-160){
         _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark -------------创建table--------------------
-(void)createTable{
    
    UIImageView * hedImg = [myLjjTools createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  160) andImageName:@"矩形-29" andBgColor:nil];
    [self.view addSubview:hedImg];
    
    _headDriverImg = [myLjjTools createImageViewWithFrame:CGRectMake(16, 70, 80, 80) andImageName:@"user" andBgColor:nil];
    _headDriverImg.layer.cornerRadius = 40;
    _headDriverImg.clipsToBounds = YES;
    [hedImg addSubview:_headDriverImg];
    
    _DriverNameLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(_headDriverImg.frame)+15, 85, SCREEN_WIDTH-57-24-CGRectGetMaxX(_headDriverImg.frame)-15, 20) andTitle:@"" andTitleFont:FontSize(17) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [hedImg addSubview:_DriverNameLabel];
    
    _phoneLabel = [myLjjTools createLabelWithFrame:CGRectMake(CGRectGetMaxX(_headDriverImg.frame)+15, CGRectGetMaxY(_DriverNameLabel.frame)+18,  SCREEN_WIDTH-57-24-CGRectGetMaxX(_headDriverImg.frame)-15, 20) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:WHITEColor andTextAlignment:NSTextAlignmentLeft andBgColor:nil];
    [hedImg addSubview:_phoneLabel];
    
    _statuImg = [myLjjTools createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-57-24, 71, 57, 57) andImageName:@"" andBgColor:nil];
    [hedImg addSubview:_statuImg];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(hedImg.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(hedImg.frame)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView  setSeparatorColor:LINECOLOR];
    _tableView.backgroundColor = BACKLJJcolor;
    [_tableView registerNib:[UINib nibWithNibName:@"routingInfoNewTableViewCell" bundle:nil] forCellReuseIdentifier:@"routingInfoNewID"];
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        return 1;
    }else{
        return 4;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section==1){
        return 120;
    }else{
        return 0.1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(section==1){
        UIView * view = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,heiSize(120)) andBgColor:CLEARCOLOR];
        UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake(widSize(50), heiSize(20), SCREEN_WIDTH-widSize(100), heiSize(40)) andTitle:@"查看司机位置" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(lookPlaceClick) andTarget:self];
        btn.layer.cornerRadius = 4.0;
        btn.clipsToBounds = YES;
        [view addSubview:btn];
        return view;
    }else{
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        
        routingInfoNewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"routingInfoNewID" forIndexPath:indexPath];
        cell.timeLabel.hidden = YES;
        [cell laodDataFrom:_driModel];
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        cell.priceBtn.hidden = YES;
        return cell;
        
    }else{
        
        NSString *ID = @"routeInfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.textColor = rgb(170, 170, 170);
            cell.textLabel.font = FontSize(15);
            cell.detailTextLabel.font = FontSize(15);
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            if(indexPath.row==0){
                _nameLabel = [myLjjTools createLabelWithFrame:CGRectMake(100, 10, SCREEN_WIDTH-110, 30) andTitle:@"" andTitleFont:FontSize(15) andTitleColor:rgb(170, 170, 170) andTextAlignment:NSTextAlignmentRight andBgColor:nil];
                [cell addSubview:_nameLabel];
            }
        }
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"陪护人";
                if(IsStrEmpty(_driModel.caregiverName)){
                _driModel.caregiverName = @"";
                }
                if(IsStrEmpty(_driModel.caregiverPhone)){
                _driModel.caregiverPhone = @"";
                }
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",_driModel.caregiverName,_driModel.caregiverPhone];
                break;
            case 0:
                cell.textLabel.text = @"学生姓名";
                _nameLabel.text = _driModel.studentName;
                break;
            case 2:
                cell.textLabel.text = @"订单类型";
                switch (_driModel.schoolType.integerValue==1) {
                    case 1:
                         cell.detailTextLabel.text = @"上学";
                        break;
                    case 2:
                         cell.detailTextLabel.text = @"放学";
                        break;
                    default:
                        break;
                }
                break;
            case 3:
                cell.textLabel.text = @"用车时间";
                cell.detailTextLabel.text = [logicDone timeIntChangeToStr:_driModel.startTime];
                break;
            default:
                break;
        }
        return cell;
        
    }

}

-(void)timeFireMethod
{
    if (_number*0.5<_size.width + SCREEN_WIDTH-110) {
        _number++;
        _nameLabel.frame = CGRectMake(SCREEN_WIDTH - _number*0.5, 10, _size.width, 30);
    }else{
        _number = 0;
        _nameLabel.frame = CGRectMake(SCREEN_WIDTH - _number*0.5-100, 10, _size.width, 30);
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        return 120;
    }else{
        return 50.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)lookPlaceClick{

    driverAndStudentMapViewController * driver = [[driverAndStudentMapViewController alloc]init];
    driver.strokeId = _driModel.strokeId;
    [self.navigationController pushViewController:driver animated:YES];

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
