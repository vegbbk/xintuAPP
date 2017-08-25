//
//  PersonCell.m
//  BM
//
//  Created by yuhuajun on 15/7/13.
//  Copyright (c) 2015年 yuhuajun. All rights reserved.
//

#import "PersonCell.h"
#import "CDFInitialsAvatar.h"
@implementation PersonCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellviewbackground"]];
        
        _tximg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 20,20)];
        [self.contentView addSubview:_tximg];
        
        _txtName=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 160, 25)];
        _txtName.font=[UIFont fontWithName:@"STHeitiTC-Light" size:16];
        
        [self.contentView addSubview:_txtName];
        
        _phoneNum=[[UILabel alloc]initWithFrame:CGRectMake(70, 30, 160, 25)];
        _phoneNum.font=[UIFont fontWithName:@"STHeitiTC-Light" size:13];
        [self.contentView addSubview:_phoneNum];
        
 
    }
    return self;
}

-(void)setTximgStr:(NSString *)tximgStr{

    _tximg.image = [UIImage imageNamed:tximgStr];
}

-(void)setData:(PersonModel*)personDel;
{
    _txtName.text=personDel.phonename;
    _phoneNum.text=personDel.tel;

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
