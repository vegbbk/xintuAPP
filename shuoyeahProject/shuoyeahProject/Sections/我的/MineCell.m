//
//  MineCell.m
//  lifeKnown
//
//  Created by GW on 16/3/15.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "MineCell.h"

@interface MineCell()

@property (nonatomic, weak) UIImageView *cellImg;
@property (nonatomic, weak) UILabel *cellTitle;

@end

@implementation MineCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *cellImg=[[UIImageView alloc] init];
        cellImg.frame=CGRectMake(15, (heiSize(60.0)-heiSize(22))/2.0, widSize(22), heiSize(22));
        cellImg.contentMode = UIViewContentModeScaleAspectFit;
        self.cellImg=cellImg;
        [self addSubview:cellImg];
        
        UILabel *cellTitle=[[UILabel alloc]init];
        [cellTitle setBackgroundColor:[UIColor clearColor]];
        [cellTitle setTextColor:rgb(74, 74, 74)];
        [cellTitle setFont:[UIFont systemFontOfSize:15]];
        cellTitle.textAlignment=NSTextAlignmentLeft;
        [self addSubview:cellTitle];
        cellTitle.frame=CGRectMake(15+CGRectGetMaxX(cellImg.frame), (heiSize(60.0)-20)/2.0,[UIScreen mainScreen].bounds.size.width-(15+CGRectGetMaxX(cellImg.frame))-100, 20);
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
