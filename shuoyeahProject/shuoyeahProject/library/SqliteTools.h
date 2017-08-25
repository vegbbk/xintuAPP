//
//  SqliteTools.h
//  LimitFree
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 Sure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "driveNameAndUrlModel.h"
#import "FMDatabase.h"
@interface SqliteTools : NSObject
//声明数据库属性
@property (nonatomic,strong)FMDatabase * database;

/**创建数据库与表（单例形式）*/
+ (instancetype)sharedSqliteTools;
/**收藏数据*/
- (void)insertAppModel:(driveNameAndUrlModel*)model;
/**查看所有数据*/
- (NSArray*)showAllApp;
/**用于判断该应用是否已经收藏过*/
- (BOOL)isExistAppWithAppID:(NSString*)appID;
- (driveNameAndUrlModel*)isExistAppWithName:(NSString *)appName;
- (void)updateData:(driveNameAndUrlModel*)model;
@end
