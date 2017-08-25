//
//  companyAuthTableViewCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/29.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "companyAuthTableViewCell.h"
@interface companyAuthTableViewCell()
@property (nonatomic, weak) UILabel *cellTitle;
@end
@implementation companyAuthTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UILabel *cellTitle=[[UILabel alloc]init];
        [cellTitle setBackgroundColor:[UIColor clearColor]];
        [cellTitle setTextColor:rgb(40, 40, 40)];
        [cellTitle setFont:[UIFont systemFontOfSize:15]];
        cellTitle.textAlignment=NSTextAlignmentLeft;
        [self addSubview:cellTitle];
        cellTitle.frame=CGRectMake(widSize(15), (heiSize(52.0)-20)/2.0,80, 20);
        self.cellTitle=cellTitle;
        
        UITextField *cellImg=[[UITextField alloc] init];
        cellImg.frame=CGRectMake(CGRectGetMaxX(cellTitle.frame)+4, (heiSize(52.0)-20)/2.0, SCREEN_WIDTH-CGRectGetMaxX(cellTitle.frame)-4-widSize(15), 20);
        cellImg.textAlignment = NSTextAlignmentRight;
        cellImg.font = [UIFont systemFontOfSize:15];
        cellImg.textColor = rgb(170, 170, 170);
        self.infoStr=cellImg;
        [self addSubview:cellImg];
        
        UILabel *lineView=[[UILabel alloc]init];
        lineView.frame=CGRectMake(widSize(15), heiSize(51.0),SCREEN_WIDTH-widSize(15), 1);
        [lineView setBackgroundColor:LINECOLOR];
        [self addSubview:lineView];
       
    

    }
    return self;
}


- (void)setTitleName:(NSString *)titleName
{
    self.cellTitle.text=titleName;
    
}

@end
