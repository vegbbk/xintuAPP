//
//  driverInfoLJJViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/30.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "driverInfoLJJViewController.h"
#import "driverInfoLJJTableViewCell.h"
#import "JZAlbumViewController.h"
#import "driverInfoModel.h"
#import "chatIMInfoViewController.h"
#import "driveNameAndUrlModel.h"
@interface driverInfoLJJViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UIImageView * avtarImg;//头像
    UILabel * userNameLabel;//名字
    UILabel * _infoLabel;
    UIButton* colloctButton;//收藏
    NSArray * titleArr;
    NSString * isCollect;
    NSString * driveCollectID;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)driverInfoModel * dataInfoModel;
@end

@implementation driverInfoLJJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"司机详情";
    titleArr = @[@"驾照",@"评分",@"接单量",@"实名认证",@"违章情况",@"健康证明"];
    [self createTable];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    
    NSLog(@"%@",self.driverId);
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
   // [parameters setObject:self.driverId forKey:@"driverId"];
    SET_OBJRCT(@"driverId", self.driverId);
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [HttpRequest postWithURL:HTTP_URLIP(get_DriverDetail) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        if([responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
        _dataInfoModel = [[driverInfoModel alloc]init];
        [_dataInfoModel setValuesForKeysWithDictionary:responseObject[@"data"][@"driver"]];
        _dataInfoModel.driverStrokeCounts = unKnowToStr(responseObject[@"data"][@"persons"]);
        isCollect = unKnowToStr(responseObject[@"data"][@"isCollect"]);
        driveCollectID = unKnowToStr(responseObject[@"data"][@"colId"]);
        [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark -------------创建table--------------------
-(void)createTable{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView  setSeparatorColor:LINECOLOR];
    _tableView.backgroundColor = BACKLJJcolor;
    [_tableView registerNib:[UINib nibWithNibName:@"driverInfoLJJTableViewCell" bundle:nil] forCellReuseIdentifier:@"driverInfoLJJcell"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 15;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
    
        return 1;
    }else{
    return 6;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){
        
        NSString *ID = @"myDataViewController1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            avtarImg=[[UIImageView alloc] init];
            avtarImg.frame=CGRectMake((SCREEN_WIDTH-85)/2.0, 22, 85, 85);
            avtarImg.layer.masksToBounds=YES;
            avtarImg.layer.cornerRadius=85/2.0;
            //avtarImg.layer.borderColor = rgb(194, 194, 194).CGColor;
           // avtarImg.layer.borderWidth = 1;
            [cell addSubview:avtarImg];
            
//            UIButton * chatBtn = [myLjjTools createButtonWithFrame:CGRectMake(CGRectGetMaxX(avtarImg.frame)+4, 22, 25, 25) andImage:[UIImage imageNamed:@"我的_messenge"] andSelecter:@selector(chatWithDriver) andTarget:self];
//            chatBtn.contentMode = UIViewContentModeScaleAspectFit;
//            [cell addSubview:chatBtn];
            
            userNameLabel=[[UILabel alloc]init];
            [userNameLabel setBackgroundColor:[UIColor clearColor]];
            [userNameLabel setTextColor:textMainColor];
            [userNameLabel setFont:[UIFont systemFontOfSize:17]];
            userNameLabel.textAlignment=NSTextAlignmentCenter;
            userNameLabel.frame = CGRectMake(40, CGRectGetMaxY(avtarImg.frame)+13 ,SCREEN_WIDTH-80, 16);
            [cell addSubview:userNameLabel];
            
            _infoLabel=[[UILabel alloc]init];
            [_infoLabel setBackgroundColor:[UIColor clearColor]];
            [_infoLabel setTextColor:rgb(170, 170, 170)];
            [_infoLabel setFont:[UIFont systemFontOfSize:fontSizeLJJ]];
            _infoLabel.textAlignment=NSTextAlignmentCenter;
            _infoLabel.text = @"45岁  5年驾龄";
            _infoLabel.hidden = YES;
            _infoLabel.frame = CGRectMake(40, CGRectGetMaxY(userNameLabel.frame)+7 ,SCREEN_WIDTH-80, 14);
            [cell addSubview:_infoLabel];
            
             colloctButton = [myLjjTools createButtonWithFrame:CGRectMake(SCREEN_WIDTH-50,6, 40, 40) andTitle:@"已收藏" andTitleColor:MAINThemeOrgColor andBgColor:WHITEColor andSelecter:@selector(colloctButtonClick) andTarget:self];
            [colloctButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [colloctButton setImage:[UIImage imageNamed:@"我的_已收藏"] forState:UIControlStateNormal];
            colloctButton.imageRect = CGRectMake(8, 0, 24, 24);
            colloctButton.titleRect = CGRectMake(0, 26, 40, 12);
            [cell addSubview:colloctButton];

        }
        _infoLabel.text = [NSString stringWithFormat:@"%@岁     %@年驾龄",_dataInfoModel.driverAge,_dataInfoModel.driverDrage];
         userNameLabel.text = _dataInfoModel.driverName;
         [avtarImg sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(_dataInfoModel.driverHeadImg)] placeholderImage:[UIImage imageNamed:defaultHeadName]];
        if([isCollect isEqualToString:@"1"]){
            [colloctButton setTitle:@"已收藏" forState:UIControlStateNormal];
            [colloctButton setImage:[UIImage imageNamed:@"我的_已收藏"] forState:UIControlStateNormal];
        }else{
            [colloctButton setTitle:@"未收藏" forState:UIControlStateNormal];
            [colloctButton setImage:[UIImage imageNamed:@"我的_为收藏"] forState:UIControlStateNormal];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
      
       driverInfoLJJTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"driverInfoLJJcell" forIndexPath:indexPath];
       cell.titleLabel.text = titleArr[indexPath.row];
        
        switch (indexPath.row+1) {
            case 1:
                cell.infoLabel.text = unKnowToStr(_dataInfoModel.driverCardNumber);
                cell.infoLabel.hidden = NO;
                cell.ImageView.hidden = YES;
                break;
            case 2:
                 if(_dataInfoModel.driverScore){
                 cell.infoLabel.text = [NSString stringWithFormat:@"%@分",_dataInfoModel.driverScore];
                 }else{
                 cell.infoLabel.text = @"0分";
                 }
                 cell.infoLabel.hidden = NO;
                 cell.ImageView.hidden = YES;
                 cell.starOne.hidden = NO;
                 cell.starTwo.hidden = NO;
                 cell.starThree.hidden = NO;
                 cell.starFour.hidden = NO;
                 cell.starFive.hidden = NO;
                if(_dataInfoModel.driverScore.integerValue>0){
                    cell.starOne.image = [UIImage imageNamed:@"我的_星星_up"];
                }else{
                    cell.starOne.image = [UIImage imageNamed:@"我的_星星_d"];
                }
                if(_dataInfoModel.driverScore.integerValue>1){
                    cell.starTwo.image = [UIImage imageNamed:@"我的_星星_up"];
                }else{
                    cell.starTwo.image = [UIImage imageNamed:@"我的_星星_d"];
                }

                if(_dataInfoModel.driverScore.integerValue>2){
                    cell.starFive.image = [UIImage imageNamed:@"我的_星星_up"];
                }else{
                    cell.starFive.image = [UIImage imageNamed:@"我的_星星_d"];
                }

                if(_dataInfoModel.driverScore.integerValue>3){
                    cell.starFour.image = [UIImage imageNamed:@"我的_星星_up"];
                }else{
                    cell.starFour.image = [UIImage imageNamed:@"我的_星星_d"];
                }

                if(_dataInfoModel.driverScore.integerValue>4){
                    cell.starThree.image = [UIImage imageNamed:@"我的_星星_up"];
                }else{
                    cell.starThree.image = [UIImage imageNamed:@"我的_星星_d"];
                }
                break;
            case 3:
                 cell.infoLabel.text = [NSString stringWithFormat:@"%@单",_dataInfoModel.driverStrokeCounts];
                 cell.infoLabel.hidden = NO;
                 cell.ImageView.hidden = YES;

                break;
            case 4:
                if(_dataInfoModel.driverAcountStatus.integerValue==1){
                 cell.infoLabel.text = @"已认证";
                }else{
                 cell.infoLabel.text = @"未认证";
                }
                 cell.infoLabel.hidden = NO;
                 cell.ImageView.hidden = YES;

                break;
            case 5:
                 cell.infoLabel.hidden = YES;
                 cell.ImageView.hidden = NO;
                 cell.backIMGview.hidden = NO;
                 [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(_dataInfoModel.driverIDAImg)] placeholderImage:[UIImage imageNamed:defaultHeadName]];
                break;
            case 6:
                 cell.infoLabel.hidden = YES;
                 cell.ImageView.hidden = NO;
                 cell.backIMGview.hidden = NO;
                 [cell.ImageView sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(_dataInfoModel.driverHeathImg)] placeholderImage:[UIImage imageNamed:defaultHeadName]];
                break;
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if(indexPath.section==0){
        return 171;
    }else{
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==4){
    
        JZAlbumViewController * jza = [[JZAlbumViewController alloc]init];
        jza.imgArr = [NSMutableArray arrayWithArray:@[HTTP_URLIP(_dataInfoModel.driverIDAImg),HTTP_URLIP(_dataInfoModel.driverIDBImg)]];
        [self.navigationController presentViewController:jza animated:YES completion:nil];
    
    }else if(indexPath.row==5){
    
        if(_dataInfoModel.driverHeathImg){
        JZAlbumViewController * jza = [[JZAlbumViewController alloc]init];
        jza.imgArr = [NSMutableArray arrayWithArray:@[HTTP_URLIP(_dataInfoModel.driverHeathImg)]];
        [self.navigationController presentViewController:jza animated:YES completion:nil];
        }
    }
    
}
#pragma mark -------收藏----------------
-(void)colloctButtonClick{

   if([isCollect isEqualToString:@"1"]){
       
       NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
       [parameters setObject:self.driverId forKey:@"driverId"];
       [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
       [HttpRequest postWithURL:HTTP_URLIP(get_DriverDetail) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
           if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
            driveCollectID = unKnowToStr(responseObject[@"data"][@"colId"]);
             [self cancelColloctDriver];
           }
       } failure:^(NSError *error) {
           
       }];      
       
    }else{
        
        [self colloctDriver];
       
    }

}

-(void)colloctDriver{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [parameters setObject:self.driverId forKey:@"driverId"];
    [HttpRequest postWithURL:HTTP_URLIP(collect_Driver) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        [colloctButton setTitle:@"已收藏" forState:UIControlStateNormal];
        [colloctButton setImage:[UIImage imageNamed:@"我的_已收藏"] forState:UIControlStateNormal];
        isCollect = @"1";
        [self.delegate colloctActionFreshData:_dataModel];
    } failure:^(NSError *error) {
        
    }];
   
}

-(void)cancelColloctDriver{
   
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    if(driveCollectID){
    [parameters setObject:driveCollectID forKey:@"colId"];
    }
    [HttpRequest postWithURL:HTTP_URLIP(remove_UserCollect) params:parameters andNeedHub:NO success:^(NSDictionary *responseObject) {
        [colloctButton setTitle:@"未收藏" forState:UIControlStateNormal];
        [colloctButton setImage:[UIImage imageNamed:@"我的_为收藏"] forState:UIControlStateNormal];
         isCollect = @"0";
        [self.delegate colloctActionFreshData:_dataModel];
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark ----------聊天------------
-(void)chatWithDriver{

    chatIMInfoViewController * info = [[chatIMInfoViewController alloc]initWithConversationChatter:@"xintuDR15215107031" conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:info animated:YES];

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
