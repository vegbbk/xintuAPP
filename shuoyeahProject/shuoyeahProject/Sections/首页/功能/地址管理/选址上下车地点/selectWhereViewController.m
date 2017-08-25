//
//  selectWhereViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "selectWhereViewController.h"
#import "collectDressLJJTableViewCell.h"
#import "addDressLJJViewController.h"
#import "dressInfoLJJModel.h"
#import "dressManageLJJViewController.h"
@interface selectWhereViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,selectCommonDressDelegate,AMapSearchDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)AMapSearchAPI*search;
@property (nonatomic, strong) NSMutableArray *tips;
@property (nonatomic,strong)NSMutableArray * dressArr;
@end

@implementation selectWhereViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tips = [NSMutableArray array];
    _dressArr = [NSMutableArray array];
    [self createTabel];
    [self createRightBtn];
}
#pragma mark --------加载常用地址----------

-(void)createRightBtn{

    UIBarButtonItem * item = [myLjjTools createRightNavItem:@"常用地址管理" andFont:FontSize(17) andSelecter:@selector(dressManage) andTarget:self];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)dressManage{

    dressManageLJJViewController * dress = [[dressManageLJJViewController alloc]init];
    [self.navigationController pushViewController:dress animated:YES];

}

-(void)searchLocation:(NSString*)string{

    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = string;
    request.city                =  [GVUserDefaults standardUserDefaults].cityNameLocation;
    request.requireExtension    = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;

    [self.search AMapPOIKeywordsSearch:request];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{

    

}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
     [self.tips setArray:response.pois];
     [self.tableView reloadData];
    //解析response获取POI信息，具体解析见 Demo
}
#pragma mark ----------------------------tableView----------------------------------
-(void)createTabel{
    
    UIView * searchView = [myLjjTools createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46) andBgColor:WHITEColor];
    [self.view addSubview:searchView];
    UITextField * search = [[UITextField alloc]initWithFrame:CGRectMake(15, 12, SCREEN_WIDTH-30, 30)];
    search.background = [UIImage imageNamed:@"首页_地址_搜索框"];
    search.delegate = self;
    [search addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    search.returnKeyType = UIReturnKeyDone;
    [search becomeFirstResponder];
    if(self.typeNum==1){
    search.placeholder = @"你在哪儿?";
    }else{
    search.placeholder = @"你要去什么地方?";
    }
    search.font = FontSize(15);
    UIView * view = [myLjjTools createViewWithFrame:CGRectMake(0, 0, 43, 20) andBgColor:CLEARCOLOR];
    UIImageView * image = [myLjjTools createImageViewWithFrame:CGRectMake(23, 0, 20, 20) andImageName:@"我的_搜索放大镜" andBgColor:nil];
    [view addSubview:image];
    search.leftViewMode = UITextFieldViewModeAlways;
    search.leftView = view;
    [searchView addSubview:search];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, SCREEN_HEIGHT-46) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"collectDressLJJTableViewCell" bundle:nil] forCellReuseIdentifier:@"colloctDressCellID"];
    
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    [self searchLocation:theTextField.text];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    return YES;

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tips.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.row==0){
    
        collectDressLJJTableViewCell * colloct = [tableView dequeueReusableCellWithIdentifier:@"colloctDressCellID" forIndexPath:indexPath];
        colloct.delegate = self;
        return colloct;
    }else{
    
        NSString *ID = @"myDressHistoryID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.imageView.image = [UIImage imageNamed:@"首页_选择上车_location"];
            cell.textLabel.font = FontSize(14);
        }
         AMapTip *tip = self.tips[indexPath.row-1];
        NSString *str1 = [NSString stringWithFormat:@"%@  %@",tip.name,tip.address];
        NSRange range = [str1 rangeOfString:tip.address];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
        //设置单位长度内的内容显示成色
        [str addAttribute:NSForegroundColorAttributeName value:rgb(121, 121, 121) range:range];
        cell.textLabel.attributedText = str;
    
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
 //       NSInteger number= (_dressArr.count+1)/3;
//        if((_dressArr.count+1)%3>0){
//            number = number+1;
//        }
        return 75.0;
    }else{
        
        return 40.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapTip *tip = self.tips[indexPath.row-1];
   // NSString * placeStr = [NSString stringWithFormat:@"%lf,%lf",tip.location.longitude,tip.location.latitude];
    [self.delegate selectWhereSureClick:tip.name with:tip.location with:self.typeNum];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----------选择常用地址代理------------------
-(void)selectCommonDress{

    addDressLJJViewController * add = [[addDressLJJViewController alloc]init];
    add.typeNum = 1;
    [self.navigationController pushViewController:add animated:YES];

}

-(void)selectDress:(dressInfoLJJModel *)model{
    
    NSArray * arr = [model.lnglat componentsSeparatedByString:@","];
    if(arr.count==2){
    AMapGeoPoint* point =  [AMapGeoPoint locationWithLatitude:[arr[1] floatValue] longitude:[arr[0] floatValue]];
    [self.delegate selectWhereSureClick:model.address with:point with:self.typeNum];
    [self.navigationController popViewControllerAnimated:YES];
    }
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
