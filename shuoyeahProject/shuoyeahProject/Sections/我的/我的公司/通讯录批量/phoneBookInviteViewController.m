//
//  phoneBookInviteViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/6.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "phoneBookInviteViewController.h"
#import "XHJAddressBook.h"
#import "PersonCell.h"

@interface phoneBookInviteViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableShow;
    XHJAddressBook *_addBook;
    NSMutableArray * _selectArr;
}
@property(nonatomic,strong)NSMutableArray *listContent;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) PersonModel *people;

@end

@implementation phoneBookInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"通讯录批量导入";
    [self createRight];
    _sectionTitles=[NSMutableArray new];
    _selectArr = [NSMutableArray new];
    _tableShow=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableShow.delegate=self;
    _tableShow.dataSource=self;
    [self.view addSubview:_tableShow];
    _tableShow.sectionIndexBackgroundColor=[UIColor clearColor];
    _tableShow.sectionIndexColor = [UIColor blackColor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self initData];
        dispatch_sync(dispatch_get_main_queue(), ^
                      {
                          [self setTitleList];
                          [_tableShow reloadData];
                      });
    });

    // Do any additional setup after loading the view.
}
#pragma mark ---------------------选择------------------------
-(void)createRight{
    UIBarButtonItem * item = [myLjjTools createRightNavItem:@"确认" andFont:FontSize(15) andSelecter:@selector(sureSelectClick) andTarget:self];
    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark -----------------------确认邀请人-----------------
-(void)sureSelectClick{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate phoneBookInviteAction:_selectArr];
}

-(void)setTitleList
{
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[theCollation sectionTitles]];
    NSMutableArray * existTitles = [NSMutableArray array];
    for(int i=0;i<[_listContent count];i++)//过滤 就取存在的索引条标签
    {
        PersonModel *pm=_listContent[i][0];
        for(int j=0;j<_sectionTitles.count;j++)
        {
            if(pm.sectionNumber==j)
                [existTitles addObject:self.sectionTitles[j]];
        }
    }
    [self.sectionTitles removeAllObjects];
    self.sectionTitles =existTitles;
    
}
-(NSMutableArray*)listContent
{
    if(_listContent==nil)
    {
        _listContent=[NSMutableArray new];
    }
    return _listContent;
}
-(void)initData
{
    _addBook=[[XHJAddressBook alloc]init];
    self.listContent=[_addBook getAllPerson];
    if(_listContent==nil)
    {
        NSLog(@"数据为空或通讯录权限拒绝访问，请到系统开启");
        return;
    }
    
}

//几个  section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_listContent count];
    
}
//对应的section有多少row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[_listContent objectAtIndex:(section)] count];
    
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
//section的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(self.sectionTitles==nil||self.sectionTitles.count==0)
        return nil;
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"uitableviewbackground"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    NSString *sectionStr=[self.sectionTitles objectAtIndex:(section)];
    [label setText:sectionStr];
    [contentView addSubview:label];
    return contentView;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfer=@"addressCell";
    PersonCell *personcell=(PersonCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
    if(personcell==nil)
    {
        personcell=[[PersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfer];
    }
    
    NSArray *sectionArr=[_listContent objectAtIndex:indexPath.section];
    _people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
    [personcell setData:_people];
    if([_selectArr containsObject:_people]){
        personcell.tximgStr = @"我的_充值_选中";
    }else{
        personcell.tximgStr = @"我的_充值_未选中";
    }
    return personcell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // NSString *key = [self.listContent objectAtIndex:indexPath.section];
    NSArray *sectionArr=[_listContent objectAtIndex:indexPath.section];
    self.people = (PersonModel *)[sectionArr objectAtIndex:indexPath.row];
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([_selectArr containsObject:self.people])
    {
        [_selectArr removeObject:self.people];
    }
    else
    {
        [_selectArr addObject:self.people];
    }
    
    [_tableShow reloadData];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIApplication *app = [UIApplication sharedApplication];
    if (buttonIndex == 1)
    {
        [app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
    }else if (buttonIndex == 2)
    {
        
    }
}



//开启右侧索引条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
    
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
