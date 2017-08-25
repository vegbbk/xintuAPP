//
//  phoneBookInviteViewController.h
//  shuoyeahProject
//
//  Created by liujianji on 17/4/6.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import "baseLJJViewController.h"
#import  "PersonModel.h"
@protocol phoneBookInviteDelegate <NSObject>
-(void)phoneBookInviteAction:(NSMutableArray*)bookArr;
@end
@interface phoneBookInviteViewController : baseLJJViewController
@property(nonatomic,assign)id<phoneBookInviteDelegate>delegate;
@end
