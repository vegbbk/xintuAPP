//
//  collectDressLJJTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/11.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "collectDressLJJTableViewCell.h"
#import "dressSelctCollectionViewCell.h"

@interface collectDressLJJTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSInteger _pageNum;
}
@property (nonatomic,strong)NSMutableArray * dataArr;
@end
@implementation collectDressLJJTableViewCell
static NSString * const reuseIdentifier = @"dressColloctID";
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //布局
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //根据自己的需求设置宽高
    [flowLayout setItemSize:CGSizeMake(SCREEN_WIDTH/3.0, 66)];
    //竖直滑动
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //内边距，列、行间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    _dataArr = [NSMutableArray array];
    _pageNum = 1;
    [self.colloctView setCollectionViewLayout:flowLayout];
    //注册（xib）
    [self.colloctView registerNib:[UINib nibWithNibName:@"dressSelctCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    //代理、数据源（也可以拖线）
    self.colloctView.delegate = self;
    self.colloctView.dataSource = self;
    self.colloctView.showsVerticalScrollIndicator = FALSE;
    self.colloctView.showsHorizontalScrollIndicator = FALSE;
    [self loadDressData:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshData) name:@"dressLJJfreshID" object:nil];

    // Initialization code
}
-(void)freshData{
    [self loadDressData:YES];
}

-(void)loadDressData:(BOOL)isfirst{
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:[GVUserDefaults standardUserDefaults].userId forKey:@"userId"];
    [parameters setObject:intToStr(_pageNum) forKey:@"pageNumber"];
    [parameters setObject:@"20" forKey:@"pageSize"];
    [HttpRequest postWithURL:HTTP_URLIP(get_AddressList) params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        if (isfirst) {
            [_dataArr removeAllObjects];
        }
        for(NSDictionary * dictt in responseObject[@"data"][@"list"]){
            dressInfoLJJModel *model = [[dressInfoLJJModel alloc]init];
            [model setValuesForKeysWithDictionary:dictt];
            [_dataArr addObject:model];
        }
        [self.colloctView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   
//    NSInteger number= (_dataArr.count+1)/3;
//    if((_dataArr.count+1)%3>0){
//        number = number+1;
//    }
//    return number;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    NSInteger number= (_dataArr.count+1)/3;
//    if((_dataArr.count+1)%3>0){
//        number = number+1;
//    }
//    if (section==number-1) {
//        if ((_dataArr.count+1)%3==0) {
//            return 3;
//        }else{
//         return (_dataArr.count+1)%3;
//        }
//    }else{
//    return 3;
//    }
    return _dataArr.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    dressSelctCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(indexPath.row==_dataArr.count){
        [cell loadData];
    }else{
        dressInfoLJJModel * model = _dataArr[indexPath.row];
        cell.headImage.image = [UIImage imageNamed:PicHeadLifeArr[model.addIcon.integerValue]];
        cell.nameLabel.text = model.addName;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==_dataArr.count){
        [self.delegate selectCommonDress];
    }else{
         dressInfoLJJModel * model = _dataArr[indexPath.row];
        [self.delegate selectDress:model];
    }


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
