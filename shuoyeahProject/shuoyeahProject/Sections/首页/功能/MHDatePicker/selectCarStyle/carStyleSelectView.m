//
//  carStyleSelectView.m
//  shuoyeahProject
//
//  Created by liujianji on 17/4/10.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "carStyleSelectView.h"
#import "carStyleTableViewCell.h"
#define picArr  @[@"首页_选择车型_豪华车型",@"首页_选择车型_经济车型",@"首页_选择车型_商务车型",@"首页_选择车型_奢华车型",@"首页_选择车型_舒适车型"]
@implementation carStyleSelectView{
    NSArray *styleArr;
    NSInteger selectNum;
}

-(id)initWithFrame:(CGRect)frame witharr:(NSArray*)array{
    self = [super initWithFrame:frame];
    if (self) {
        styleArr = array;
        UIView * lineView =[myLjjTools createViewWithFrame:CGRectMake(10, heiSize(100)-1, frame.size.width-20, 1) andBgColor:WHITEColor];
        [self addSubview:lineView];
        UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *vew = [[UIVisualEffectView alloc]initWithEffect:blur];
        vew.frame = frame;
        [self addSubview:vew];
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        self.uitable = [[UITableView alloc]initWithFrame:CGRectMake(0, heiSize(100), frame.size.width, SCREEN_HEIGHT-2*heiSize(100)) style:UITableViewStyleGrouped];
        self.uitable.backgroundColor = CLEARCOLOR;
        self.uitable.delegate = self;
        self.uitable.dataSource = self;
       // self.uitable.scrollEnabled = NO;
        [self addSubview:self.uitable];
        [self.uitable registerNib:[UINib nibWithNibName:@"carStyleTableViewCell" bundle:nil] forCellReuseIdentifier:@"carStyleCellID"];
        
        UIButton * closeBtn = [myLjjTools createButtonWithFrame:CGRectMake((frame.size.width-widSize(30))/2.0, frame.size.height-heiSize(70) , widSize(30), widSize(30)) andImage:[UIImage imageNamed:@"我的_公司_关闭按钮"] andSelecter:@selector(close) andTarget:self];
        [self addSubview:closeBtn];
 
        
    }
    return self;
    
    
}

-(void)close{

    [UIView animateWithDuration:0.6 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
 

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  60.0;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return styleArr.count;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    carStyleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"carStyleCellID" forIndexPath:indexPath];
    [cell loadDatawith:NO];
    cell.backgroundColor = CLEARCOLOR;
    carStyleModel * model = styleArr[indexPath.row];
    cell.headImage.image = [UIImage imageNamed:picArr[indexPath.row%5]];
    cell.styleLabel.text = model.typeName;
    cell.detailLabel.text = model.typeCarName;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectNum = indexPath.row;
    [self.uitable reloadData];
    carStyleModel * model = styleArr[indexPath.row];
    [self.delegate carStylechoose:model];
    [self close];
    
}

@end
