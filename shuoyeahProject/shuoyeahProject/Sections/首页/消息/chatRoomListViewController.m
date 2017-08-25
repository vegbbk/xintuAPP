//
//  chatRoomListViewController.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/13.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "chatRoomListViewController.h"
#import "chatRoomListTableViewCell.h"
#import "chatIMInfoViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface chatRoomListViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,EMChatManagerDelegate>
@end

@implementation chatRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    //[self createTabel];
    // Do any additional setup after loading the view.  chatRoomListCellID
}
- (void)messagesDidReceive:(NSArray *)aMessages{
   
     [self refresh];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}
-(void)refresh
{
    [self refreshAndSortView];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"我的_无记录"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"您还没和司机聊天哦";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                                 NSForegroundColorAttributeName: RGB170};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

//-(void)loadChatList{
//
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    NSArray* sorted = [conversations sortedArrayUsingComparator:
//                       ^(EMConversation *obj1, EMConversation* obj2){
//                           EMMessage *message1 = [obj1 latestMessage];
//                           EMMessage *message2 = [obj2 latestMessage];
//                           if(message1.timestamp > message2.timestamp) {
//                               return(NSComparisonResult)NSOrderedAscending;
//                           }else {
//                               return(NSComparisonResult)NSOrderedDescending;
//                           }
//                       }];
//    
//    
//    
//    [self.dataArray removeAllObjects];
//    for (EMConversation *converstion in sorted) {
//        EaseConversationModel *model = nil;
//        model = [[EaseConversationModel alloc] initWithConversation:converstion];
//        if (model) {
//            [self.dataArray addObject:model];
//        }
//    }
//    
//    [self.tableView reloadData];
//
//}

//#pragma mark ----------------------------tableView----------------------------------
//-(void)createTabel{
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.backgroundColor = WHITEColor;
//    [_tableView setSeparatorColor:LINECOLOR];
//    [self.view addSubview:_tableView];
//    [_tableView registerNib:[UINib nibWithNibName:@"chatRoomListTableViewCell" bundle:nil] forCellReuseIdentifier:@"chatRoomListCellID"];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        
//    }];
//    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
//        
//    }];
//    
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    return 10;
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 0.1;
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    
//    return 0.1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return 1;
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    chatRoomListTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"chatRoomListCellID" forIndexPath:indexPath];
//   // cell.backgroundColor = CLEARCOLOR;
//    return cell;
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 60;
//    
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    chatIMInfoViewController * info = [[chatIMInfoViewController alloc]initWithConversationChatter:@"13594369474" conversationType:EMConversationTypeChat];
//    [self.navigationController pushViewController:info animated:YES];
//}

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
