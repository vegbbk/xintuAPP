//
//  GVUserDefaults+ljjSaveUserData.h
//  shuoyeahProject
//
//  Created by liujianji on 16/11/22.
//  Copyright © 2016年 shuoyeah. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (ljjSaveUserData)
@property (nonatomic, weak) NSString *userName;//用户名
@property (nonatomic, weak) NSString *cityNameLocation;//当前城市名称
@property (nonatomic , copy) NSString              * userIndustry;
@property (nonatomic , copy) NSString              * userBirthDay;
@property (nonatomic , copy) NSString              * userPhone;
@property (nonatomic , copy) NSString              * userSex;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * userAcountStatus;
@property (nonatomic , copy) NSString              * userJob;
@property (nonatomic , copy) NSString              * userAddTime;
@property (nonatomic , copy) NSString              * userSignature;
@property (nonatomic , copy) NSString              * passAmin;//mima1
@property (nonatomic , copy) NSString              * userHeadImg;
@property (nonatomic , copy) NSString              *companyId;
@property (nonatomic , copy) NSString              *companyName;
@property (nonatomic , copy) NSString              *isAdmin;
@property (nonatomic , copy) NSString              *loginType;
@property (nonatomic , copy) NSString * userHXAccount;
@property (nonatomic , copy) NSString * userHXPassword;

@property (nonatomic , copy) NSString * DriverHXAccount;
@property (nonatomic , copy) NSString * DriverHXHeadImg;

@property (nonatomic) NSInteger integerValue;
@property (nonatomic) BOOL LOGINSUC;
@property (nonatomic) float floatValue;

@end
