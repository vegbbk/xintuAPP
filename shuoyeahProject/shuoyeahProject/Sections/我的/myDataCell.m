//
//  myDataCell.m
//  shuoyeahProject
//
//  Created by liujianji on 17/3/29.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "myDataCell.h"
@interface myDataCell()

@property (nonatomic, weak) UIImageView *cellImg;
@property (nonatomic, weak) UILabel *cellTitle;

@end

@implementation myDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *cellImg=[[UIImageView alloc] init];
        cellImg.contentMode = UIViewContentModeScaleAspectFit;
        cellImg.frame=CGRectMake(widSize(15), (heiSize(50.0)-heiSize(17))/2.0, widSize(17), heiSize(17));
        self.cellImg=cellImg;
        [self addSubview:cellImg];
        
        UILabel *cellTitle=[[UILabel alloc]init];
        [cellTitle setBackgroundColor:[UIColor clearColor]];
        [cellTitle setTextColor:rgb(105, 104, 104)];
        [cellTitle setFont:[UIFont systemFontOfSize:15]];
        cellTitle.textAlignment=NSTextAlignmentLeft;
        [self addSubview:cellTitle];
        cellTitle.frame=CGRectMake(15+CGRectGetMaxX(cellImg.frame), (heiSize(50.0)-20)/2.0,[UIScreen mainScreen].bounds.size.width-(15+CGRectGetMaxX(cellImg.frame))-100, 20);
        self.cellTitle=cellTitle;
        
    }
    return self;
}

- (void)setImageName:(NSString *)imageName
{
    self.cellImg.image=[UIImage imageNamed:imageName];
}

- (void)setTitleStr:(NSString *)titleStr
{
    self.cellTitle.text=titleStr;
    
}

@end
