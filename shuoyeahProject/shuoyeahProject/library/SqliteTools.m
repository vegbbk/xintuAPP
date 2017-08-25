//
//  SqliteTools.m
//  LimitFree
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 Sure. All rights reserved.
//

#import "SqliteTools.h"

@implementation SqliteTools
//1、创建数据库
- (instancetype)init{
    if (self = [super init]) {
        //1、沙盒目录路径
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/XinTuApp.rdb"];
        
        //2、创建
        _database = [[FMDatabase alloc]initWithPath:path];
        
        //3、判断是否创建成功
        if ([_database open]) {
            NSLog(@"数据库创建成功");
        }else{
            NSLog(@"数据库创建失败");
        }
        
        //4、创建表 只收藏app名称与app图标 appId
        NSString * createSql = @"CREATE TABLE IF NOT EXISTS AppTable (appName varchar(256),appImage varchar(256),appID varchar(256))";
        
        BOOL isSuc = [_database executeUpdate:createSql];
        
        if (isSuc) {
            NSLog(@"创建表成功");
        }else{
            NSLog(@"创建表失败");
        }
    }
    return self;
}
//2、将数据库创建形式转换为单例形式
+ (instancetype)sharedSqliteTools{
    //单例作用：在程序的生命周期中，无论使用单例的形式创建一个对象多少次，使用的均为同一对象。
    static SqliteTools * tools = nil;
    //判断是否已经存在该对象，如果不存在才来创建，如果存在，直接返回上次创建的对象
    if (tools == nil) {
        tools = [[SqliteTools alloc]init];
    }
    return tools;
}
//3、收藏的方法
- (void)insertAppModel:(driveNameAndUrlModel *)model{
    //获取所需存储的数据
    NSString * appName = model.driverName;
    
    NSString * appImage = model.driverHeadImg;
    
    NSString * appID= model.driverHXID;
    //增加的SQL语句
    NSString * insertSql = @"INSERT INTO AppTable (appName,appImage,appID) values(?,?,?)";
    
    BOOL isSuc = [_database executeUpdate:insertSql,appName,appImage,appID];

    if (isSuc) {
        NSLog(@"收藏成功");
    }else{
        NSLog(@"收藏失败");
    }
}
//4、判断是否已经收藏过
- (BOOL)isExistAppWithappID:(NSString *)appID{
    //数据库的查操作
    NSString * selectSql = @"SELECT * FROM AppTable WHERE appID = ?";
    
    FMResultSet * set = [_database executeQuery:selectSql,appID];
    
    //判断是否可以找到值
    if ([set next]) {
        return YES;//已经收藏过
    }else{
        return NO;//未收藏
    }
}

//4、判断是否已经收藏过
-(driveNameAndUrlModel*)isExistAppWithName:(NSString *)appID{
    //数据库的查操作
    NSString * selectSql = @"SELECT * FROM AppTable WHERE appID = ?";
    FMResultSet * set = [_database executeQuery:selectSql,appID];
    //判断是否可以找到值
    if ([set next]) {
        driveNameAndUrlModel * model = [[driveNameAndUrlModel alloc]init];
        model.driverName = [set stringForColumn:@"appName"];
        model.driverHeadImg = [set stringForColumn:@"appImage"];
        
        return model;//
    }else{
        return nil;//
    }
}

#pragma mark 更改数据
- (void)updateData:(driveNameAndUrlModel*)model{
    /*
     NSString * name = @"古力娜扎我";
     
     int newUid = 99;
     */
    
    //UPDATE 表名 SET 需要更新的字段 = ? WHERE 查找的字段条件 = ?
    NSString * updateSql = @"UPDATE AppTable SET appName = ? WHERE appID = ?";
    NSString * updateSql1 = @"UPDATE AppTable SET appImage = ? WHERE appID = ?";
    BOOL isSuc = [_database executeUpdate:updateSql,model.driverName,model.driverHXID];
    [_database executeUpdate:updateSql1,model.driverHeadImg,model.driverHXID];
    if (isSuc) {
        NSLog(@"更改成功");
    }else{
        NSLog(@"更改失败");
    }
}


- (NSArray*)showAllApp{
    NSString * selectSql = @"SELECT * FROM AppTable";
    
    FMResultSet * set = [_database executeQuery:selectSql];
    
    NSMutableArray * array = [NSMutableArray array];
    
    while ([set next]) {
        driveNameAndUrlModel * model = [[driveNameAndUrlModel alloc]init];
        model.driverName = [set stringForColumn:@"appName"];
        model.driverHeadImg = [set stringForColumn:@"appImage"];
        //存储数据模型
        [array addObject:model];
    }
    return array;
}

@end
