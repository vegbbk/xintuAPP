//
//  oneTableViewController.m
//  IMshuoyeah
//
//  Created by shuoyeah on 16/4/5.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "oneTableViewController.h"

@interface oneTableViewController ()
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation oneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _dataArr = [NSMutableArray array];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self loadData];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)loadData{

    NSMutableDictionary * parameters=[NSMutableDictionary dictionary];
    NSString * urlStr;
    if(self.number==1){
        urlStr = HTTP_URLIP(get_Industry);
    }else if(self.number==2){
        urlStr = HTTP_URLIP(get_Job);
        [parameters setObject:self.industryId forKey:@"industryId"];
    }
    [HttpRequest postWithURL:urlStr params:parameters andNeedHub:YES success:^(NSDictionary *responseObject) {
        for(NSDictionary*dict in responseObject[@"data"]){
            jobAndIndustModel * model = [[jobAndIndustModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArr addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    jobAndIndustModel * model = _dataArr[indexPath.row];
    if(self.number==1){
    cell.textLabel.text = model.industryName;
    }else if(self.number==2){
    cell.textLabel.text = model.jobName;
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    // Configure the cell...
  //  NSLog(@"%@",_dataArr[indexPath.row][@"region_name"]);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    jobAndIndustModel * model = _dataArr[indexPath.row];
    [self.delegate selectHZClick:model with:self.number];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
