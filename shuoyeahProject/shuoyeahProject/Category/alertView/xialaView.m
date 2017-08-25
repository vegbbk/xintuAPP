//
//  xialaView.m
//  shuoyeahProject
//
//  Created by shuoyeah on 16/8/11.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "xialaView.h"

@implementation xialaView{
    NSArray *province;
    
}

-(id)initWithFrame:(CGRect)frame witharr:(NSArray*)array{
    self = [super initWithFrame:frame];
    if (self) {
        province = array;
        self.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:0.4];
        self.uitable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 150) style:UITableViewStylePlain];
        //self.uitable.backgroundColor = CLEARCOLOR;
        self.uitable.delegate = self;
        self.uitable.dataSource = self;
        [self addSubview:self.uitable];
    }
    return self;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 0.1;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

  
        return 2;


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return province.count;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *ID = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.backgroundColor = BACKLJJcolor;
    sectionListModel * model = province[indexPath.row];
    cell.textLabel.text = model.departName;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate xialachooseRetuDataWith:province[indexPath.row]];
    [self removeFromSuperview];
    
}

@end
