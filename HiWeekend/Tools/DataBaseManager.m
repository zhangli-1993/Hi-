//
//  DataBaseManager.m
//  HiWeekend
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "DataBaseManager.h"
#import <sqlite3.h>
@interface DataBaseManager ()
{
    NSString *dataBasePath; //数据库创建路径
}
@end

@implementation DataBaseManager
//创建一个静态单例对象（DataBaseManager）
static DataBaseManager *dbManager = nil;

+ (DataBaseManager *)sharedInstance{
    //如果为空，就去创建一个
    if (dbManager == nil) {
        dbManager = [[DataBaseManager alloc] init];
    }
    return dbManager;
}
static sqlite3 *dataBase = nil;
//创建数据库
- (void)createDataBase{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    dataBasePath = [documentPath stringByAppendingPathComponent:@"/city.sqlite"];
    NSLog(@"%@", dataBasePath);
}

//打开数据库
- (void)openDataBase{
    if (dataBase != nil) {
        return;
    }
    [self createDataBase];
    int result = sqlite3_open([dataBasePath UTF8String], &dataBase);
    if (result == SQLITE_OK) {
        ZLLog(@"数据库打开成功");
        [self createDataBaseTable];
    } else {
        ZLLog(@"数据库打开失败失败");
    }
}

- (void)createDataBaseTable{
    NSString *sql = @"create table CityModel (number integer primary key autoincrement, cityname text not null, cityid text not null)";
    char *error = nil;
    sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &error);
}


- (void)closeDataBase{
    int result = sqlite3_close(dataBase);
    if (result == SQLITE_OK) {
        dataBase = nil;
        ZLLog(@"关闭成功");
    } else {
        ZLLog(@"关闭失败");
    }
}
- (void)insertIntoNew:(SelectCityModel *)model{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    //sql语句
    NSString *sql = @"insert Into CityModel (cityname, cityid) values (?, ?)";
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        //绑定name
        sqlite3_bind_text(stmt, 1, [model.cityName UTF8String], -1, NULL);
        //绑定id
        sqlite3_bind_text(stmt, 2, [model.cityId UTF8String], -1, NULL);
        //执行
        sqlite3_step(stmt);
        
    } else {
        ZLLog(@"sql语句有问题");
    }
    //删除释放掉
    sqlite3_finalize(stmt);

}
- (void)deleteModel{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"delete from CityModel";
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        sqlite3_step(stmt);
        ZLLog(@"删除成功");
    } else {
        ZLLog(@"删除失败");
    }
    sqlite3_finalize(stmt);
}
- (SelectCityModel *)selectCityModel{
    [self openDataBase];
    sqlite3_stmt *stmt = nil;
    NSString *sql = @"select *from CityModel";
    int result = sqlite3_prepare_v2(dataBase, [sql UTF8String], -1, &stmt, NULL);
    SelectCityModel *model = [[SelectCityModel alloc]init];
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSString *cityname = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            NSString *cityid = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            model.cityName = cityname;
            model.cityId = cityid;
        }
    } else {
        ZLLog(@"查询失败");
    }
    sqlite3_finalize(stmt);
    return model;

}
@end
