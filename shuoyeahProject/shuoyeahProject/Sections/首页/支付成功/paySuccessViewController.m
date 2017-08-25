//
//  paySuccessViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/12.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "paySuccessViewController.h"
#import "StarView.h"
#import "commentTypeListModel.h"
#import "commentStokeModel.h"
#import "touSuMessageViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface paySuccessViewController ()<starDelegate,UIScrollViewDelegate>{

     CGFloat numberOne;
     NSMutableDictionary * dicOne;
     CGFloat numberTwo;
     NSMutableDictionary * dicTWo;
     CGFloat numberThree;
     NSMutableDictionary * dicThree;
     CGFloat numberFour;
     NSMutableDictionary * dicFour;
     CGFloat numberFive;
     NSMutableDictionary * dicFive;
     CGFloat numberSix;
     NSMutableDictionary * dicSix;
     CGFloat numberSeven;
     NSMutableDictionary * dicSeven;
     CGFloat numberEight;
     NSMutableDictionary * dicEight;
     CGFloat numberNine;
     NSMutableDictionary * dicNine;
     CGFloat numberTen;
     NSMutableDictionary * dicTen;
     NSMutableArray * dataArr;
     CGFloat highLengh;
     commentStokeModel * dataModel;
}
@property (nonatomic,strong)UIScrollView * scroll;
@end

@implementation paySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled=NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"行程评价";
    dataArr = [NSMutableArray array];
    dicOne = [NSMutableDictionary dictionary];
    dicTWo = [NSMutableDictionary dictionary];
    dicFour = [NSMutableDictionary dictionary];
    dicFive = [NSMutableDictionary dictionary];
    dicSix = [NSMutableDictionary dictionary];
    dicSeven = [NSMutableDictionary dictionary];
    dicEight = [NSMutableDictionary dictionary];
    dicNine = [NSMutableDictionary dictionary];
    dicTen = [NSMutableDictionary dictionary];
    dicThree = [NSMutableDictionary dictionary];
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineViewLJJ.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.lineViewLJJ.frame)-10)];
    _scroll.backgroundColor = CLEARCOLOR;
    _scroll.scrollEnabled = YES;
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    self.navigationItem.leftBarButtonItem = [self itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    self.complainBtn.layer.cornerRadius = 4.0;
    self.complainBtn.clipsToBounds = YES;
  //    StarView *starView1 = [[StarView alloc] initWithFrame:CGRectMake(2, 2, 200, 20) EmptyImage:@"首页_评分_五角星" StarImage:@"首页_评分_五角星亮"];
//    starView1.tag = 2;
//    starView1.delegate = self;
//    StarView *starView2 = [[StarView alloc] initWithFrame:CGRectMake(2, 2, 200, 20) EmptyImage:@"首页_评分_五角星" StarImage:@"首页_评分_五角星亮"];
//    starView2.tag = 3;
//    starView2.delegate = self;
 //   [self.view addSubview:starView];
//    [self.threeStarView addSubview:starView1];
//    [self.fourStarView addSubview:starView2];

    [self loadData];
    // Do any additional setup after loading the view from its nib.
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

-(void)loadData{
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    SET_OBJRCT(@"orderSn", self.orderSn)
    [HttpRequest postWithURL:HTTP_URLIP(get_StrokeDetail) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        
        for(NSDictionary*dic in responseObject[@"data"][@"comment"]){
            commentTypeListModel * model = [[commentTypeListModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [dataArr addObject:model];
        }
        dataModel = [[commentStokeModel alloc]init];
        [dataModel setValuesForKeysWithDictionary:responseObject[@"data"][@"stroke"]];
        [self createUI];
        [self loadStar:dataModel.driverScore.floatValue];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:HTTP_URLIP(dataModel.driverHeadImg)] placeholderImage:[UIImage imageNamed:@"user"]];
        self.nameLabel.text = dataModel.driverName;
        self.infoLabel.text = dataModel.driverPhone;
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2lf",dataModel.orderActPay.floatValue];
    } failure:^(NSError *error) {
        
    }];

}

-(void)loadStar:(CGFloat)lengthNum{
    
    if(lengthNum>=1){
        self.commentOne.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else{
        self.commentOne.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }
    if(lengthNum>=2){
        self.commentTwo.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else{
        self.commentTwo.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }
    if(lengthNum>=3){
        self.commentThree.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else{
        self.commentThree.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }
    if(lengthNum>=4){
        self.commentFour.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else{
        self.commentFour.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }
    if(lengthNum>=5){
        self.commentFive.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else{
        self.commentFive.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }
    
}

-(void)createUI{

    for(int i=0;i<dataArr.count;i++){
     
        commentTypeListModel * model = dataArr[i];
        UILabel * label = [myLjjTools createLabelWithFrame:CGRectMake(0, 30*i, SCREEN_WIDTH/2.0-10, 30) andTitle:model.commentType andTitleFont:FontSize(15) andTitleColor:[UIColor lightGrayColor] andTextAlignment:NSTextAlignmentRight andBgColor:nil];
        [_scroll addSubview:label];
        StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, 5+30*i, 200, 20) EmptyImage:@"首页_评分_五角星" StarImage:@"首页_评分_五角星亮"];
        starView.tag = i;
        starView.delegate = self;
        [_scroll addSubview:starView];
        
    }
    highLengh = 30*dataArr.count;
    UIButton * btn = [myLjjTools createButtonWithFrame:CGRectMake(60, highLengh+20, SCREEN_WIDTH-120, 40) andTitle:@"提交评价" andTitleColor:WHITEColor andBgColor:MAINThemeColor andSelecter:@selector(commitCommentClick) andTarget:self];
    [_scroll addSubview:btn];
    _scroll.contentSize=CGSizeMake(SCREEN_WIDTH,highLengh+50);

}

-(void)selectNumber:(NSInteger)number and:(NSInteger)tagNum{

    commentTypeListModel * model = dataArr[tagNum];
    NSLog(@"%ld",tagNum);
    switch (tagNum) {
        case 0:
            numberOne = number+1;
            [dicOne setObject:model.commentTypeID forKey:@"id"];
            [dicOne setObject:floaToStr(numberOne) forKey:@"value"];
            break;
        case 1:
            numberTwo = number+1;
            [dicTWo setObject:model.commentTypeID forKey:@"id"];
            [dicTWo setObject:floaToStr(numberTwo) forKey:@"value"];
            break;
        case 2:
            numberThree = number+1;
            [dicThree setObject:model.commentTypeID forKey:@"id"];
            [dicThree setObject:floaToStr(numberThree) forKey:@"value"];
            break;
        case 3:
            numberFour = number+1;
            [dicFour setObject:model.commentTypeID forKey:@"id"];
            [dicFour setObject:floaToStr(numberFour) forKey:@"value"];
            break;
        case 4:
            numberFive = number+1;
            [dicFive setObject:model.commentTypeID forKey:@"id"];
            [dicFive setObject:floaToStr(numberFive) forKey:@"value"];
            break;
        case 5:
            numberSix = number+1;
            [dicSix setObject:model.commentTypeID forKey:@"id"];
            [dicSix setObject:floaToStr(numberSix) forKey:@"value"];
            break;
        case 6:
            numberSeven = number+1;
            [dicSeven setObject:model.commentTypeID forKey:@"id"];
            [dicSeven setObject:floaToStr(numberSeven) forKey:@"value"];
            break;
        case 7:
            numberEight = number+1;
            [dicEight setObject:model.commentTypeID forKey:@"id"];
            [dicEight setObject:floaToStr(numberEight) forKey:@"value"];
            break;
        case 8:
            numberNine = number+1;
            [dicNine setObject:model.commentTypeID forKey:@"id"];
            [dicNine setObject:floaToStr(numberNine) forKey:@"value"];
            break;
        case 9:
            numberTen = number+1;
            [dicTen setObject:model.commentTypeID forKey:@"id"];
            [dicTen setObject:floaToStr(numberTen) forKey:@"value"];
            break;
               default:
            break;
    }
    
    [self startView:(numberOne+numberTwo+numberThree+numberFour+numberFive+numberSix+numberSeven+numberEight+numberNine+numberTen)/dataArr.count];
    
}

-(void)startView:(CGFloat)num{
//我的_星星_半颗
    if(num>0.9){
        _ZOneStar.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else if(num<=0.0){
        _ZOneStar.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }else {
        if(num>0){
        _ZOneStar.image = [UIImage imageNamed:@"我的_星星_半颗"];
        }
    }
    if(num>1.9){
        _ZtwoStar.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else if(num<=1.0){
        _ZtwoStar.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }else{
        if(num>1){
        _ZtwoStar.image = [UIImage imageNamed:@"我的_星星_半颗"];
        }
    }
    if(num>2.9){
        _ZthreeStar.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else if(num<=2){
        _ZthreeStar.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }else {
        if(num>2){
         _ZthreeStar.image = [UIImage imageNamed:@"我的_星星_半颗"];
        }
    }
    if(num>3.9){
        _ZfourStar.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else if(num<=3){
        _ZfourStar.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }else {
        if(num>3){
        _ZfourStar.image = [UIImage imageNamed:@"我的_星星_半颗"];
    }
    }
    if(num>4.9){
        _ZfiveStar.image = [UIImage imageNamed:@"首页_评分_五角星亮"];
    }else if(num<=4){
        _ZfiveStar.image = [UIImage imageNamed:@"首页_评分_五角星"];
    }else {
        if(num>4){
        _ZfiveStar.image = [UIImage imageNamed:@"我的_星星_半颗"];
        }
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

- (void)commitCommentClick{
    
    NSMutableArray * datDic = [NSMutableArray array];
    
    if(dicOne.count>0){
        [datDic addObject:dicOne];
    }
    if(dicTWo.count>0){
        [datDic addObject:dicTWo];
    }
    if(dicThree.count>0){
        [datDic addObject:dicThree];
    }
    if(dicFour.count>0){
        [datDic addObject:dicFour];
    }
    if(dicFive.count>0){
        [datDic addObject:dicFive];
    }
    if(dicSeven.count>0){
        [datDic addObject:dicSeven];
    }
    if(dicSix.count>0){
        [datDic addObject:dicSix];
    }
    if(dicEight.count>0){
        [datDic addObject:dicEight];
    }
    if(dicNine.count>0){
        [datDic addObject:dicNine];
    }
    if(dicTen.count>0){
        [datDic addObject:dicTen];
    }
    NSMutableDictionary * dddd = [NSMutableDictionary dictionary];
    [dddd setObject:datDic forKey:@"comment"];
    NSLog(@"------------------------------%@",dddd);
    NSString * jsStr = [self crazy_ObjectToJsonString:dddd];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    SET_OBJRCT(@"commentType", jsStr)
    [parameters setObject:floaToStr((numberOne+numberTwo+numberThree+numberFour+numberFive+numberSix+numberSeven+numberEight+numberNine+numberTen)/dataArr.count) forKey:@"overview"];
    SET_OBJRCT(@"strokeId",dataModel.strokeId)
    SET_OBJRCT(@"userId", [GVUserDefaults standardUserDefaults].userId)
    [HttpRequest postWithURL:HTTP_URLIP(add_Comment) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        ToastWithTitle(@"评价成功");
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"routingFreshDeleLJJ" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];

}

//字典或者数组 转换成json串
-(NSString *)crazy_ObjectToJsonString:(id)object{

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:nil
                                                         error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
    
}

- (IBAction)complainClick:(UIButton *)sender {
    
    touSuMessageViewController * tousu = [[touSuMessageViewController alloc]init];
    tousu.typeNumber = 1;
    [self.navigationController pushViewController:tousu animated:YES];

}
@end
