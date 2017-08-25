//
//  billRecordTableViewCell.h
//  shuoyeahProject
//
//  Created by liujianji on 17/3/31.
//  Copyright © 2017年 shuoyeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface billRecordTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *orderNumStr;//发票号码
@property (nonatomic, copy) NSString *moneyStr;//金额
@property (nonatomic, copy) NSString *cityStr;//城市
@property (nonatomic, copy) NSString *companyStr;//公司
@property (nonatomic, copy) NSString *receiveStr;//收件人
@property (nonatomic, copy) NSString *phoneStr;//收件联系方式
@property (nonatomic, copy) NSString *dressStr;//地址
@property (nonatomic, copy) NSString *makeTimeBill;//开票时间
@end
