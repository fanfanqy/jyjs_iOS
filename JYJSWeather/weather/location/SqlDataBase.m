//
//  SqlDataBase.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/18.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "SqlDataBase.h"
#import "FMDatabase.h"
#import "DBModel.h"

@implementation SqlDataBase
{
    FMDatabase *_database;
    NSLock *_lock;
    NSFileManager *fileManager;
}
- (instancetype)init
{
    if (self = [super init]) {
        //对线程锁对象初始化
        _lock = [[NSLock alloc] init];
        fileManager = [NSFileManager defaultManager];
        [self configDatabase];
    }
    return self;
}
// 初始化数据库,并且建表
- (void)configDatabase
{
    //加锁
    [_lock lock];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseDoc = [rootPath stringByAppendingPathComponent:@"FaLv"];
    NSString *databasePath = [databaseDoc stringByAppendingPathComponent:[NSString stringWithFormat:FALVCALENDARDB]];
    
    NSLog(@"path:%@",databasePath);
    _database = [FMDatabase databaseWithPath:databasePath];
    BOOL a = [_database open];
    NSLog(@"success");
    //解锁
    [_lock unlock];
}
//添加数据
- (void)insertData:(id )model
{
    //加锁
    [_lock lock];
    
    NSString *sql = nil;
    BOOL is = YES;
    //对表添加数据
    sql =[NSString stringWithFormat:@"insert into cityList(cityPinyin,country_name,lat,lon,cityCC,isCC) values(?,?,?,?,?,?)"];
    
    is = [_database executeUpdate:sql,[model valueForKey:@"cityPinyin"],[model valueForKey:@"country_name"],[model valueForKey:@"lat"],[model valueForKey:@"lon"],[model valueForKey:@"cityCC"],[model valueForKey:@"isCC"]];
    
    if (!is) {
        NSLog(@"2%@", _database.lastErrorMessage);
    }
    //解锁
    [_lock unlock];
}

-(NSMutableArray *)searchWithString:(NSString *)searchString andIsCC:(BOOL)isPinyin{
    [_lock lock];
    NSString *sql = nil;
    //    注意：name like ‘西门’,相当于是name = ‘西门’。
    //    name like ‘%西%’,为模糊搜索，搜索字符串中间包含了’西’，左边可以为任意字符串，右边可以为任意字符串，的字符串。
    //    但是在 stringWithFormat:中%是转义字符，两个%才表示一个%。
    if (isPinyin) {
        sql = [NSString stringWithFormat:@"select * from cityList where cityCC like '%%%@%%'",searchString];
    }else{
        sql = [NSString stringWithFormat:@"select * from cityList where cityPinyin like '%%%@%%'",searchString];
    }
    NSLog(@"sql:%@",sql);
    FMResultSet *set = [_database executeQuery:sql];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (set) {
        NSLog(@"successset1");
        while (set.next) {
            //            *cityPinyin;
            //            *country_name;
            //            *lat;
            //            *lon;
            //            *cityCC;//Chinese character
            NSLog(@"successset2");
            DBModel *model = [[DBModel alloc]init];
            model.cityPinyin = [set stringForColumn:@"cityPinyin"];
            NSLog(@" model.cityPinyin:%@", model.cityPinyin);
            model.country_name = [set stringForColumn:@"country_name"];
            model.lat = [set stringForColumn:@"lat"];
            model.lon = [set stringForColumn:@"lon"];
            model.cityCC = [set stringForColumn:@"cityCC"];
            model.isCC = [set intForColumn:@"isCC"];
            [array addObject:model];
        }
    }else{
        NSLog(@"3%@", _database.lastErrorMessage);
        [_lock unlock];
        return nil;
    }
    [_lock unlock];
    return array;
}
- (NSMutableArray *)searchAllSaveCity
{
    [_lock lock];
    NSString *sql = nil;
    //    注意：name like ‘西门’,相当于是name = ‘西门’。
    //    name like ‘%西%’,为模糊搜索，搜索字符串中间包含了’西’，左边可以为任意字符串，右边可以为任意字符串，的字符串。
    //    但是在 stringWithFormat:中%是转义字符，两个%才表示一个%。
    
    sql = [NSString stringWithFormat:@"select * from saveCity"];
    NSLog(@"sql:%@",sql);
    FMResultSet *set = [_database executeQuery:sql];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (set) {
        NSLog(@"successset1");
        while (set.next) {
            //            *cityPinyin;
            //            *country_name;
            //            *lat;
            //            *lon;
            //            *cityCC;//Chinese character
            NSLog(@"successset2");
            DBModel *model = [[DBModel alloc]init];
            model.cityPinyin = [set stringForColumn:@"cityPinyin"];
            NSLog(@" model.cityPinyin:%@", model.cityPinyin);
            model.country_name = [set stringForColumn:@"country_name"];
            model.lat = [set stringForColumn:@"lat"];
            model.lon = [set stringForColumn:@"lon"];
            model.cityCC = [set stringForColumn:@"cityCC"];
            model.isCC = [set intForColumn:@"isCC"];
            [array addObject:model];
        }
    }else{
        NSLog(@"从数据库查找存储的城市%@", _database.lastErrorMessage);
        [_lock unlock];
        return nil;
    }
    [_lock unlock];
    return array;
}
- (void)deleateCityFromSaveCity:(DBModel *)model
{
    //加锁
    [_lock lock];
    
    NSString *sql = nil;
    BOOL is = YES;
    //对表添加数据
    sql =[NSString stringWithFormat:@"delete from saveCity where cityCC = '%@'", model.cityCC];
    
    is = [_database executeUpdate:sql,[model valueForKey:@"cityPinyin"],[model valueForKey:@"country_name"],[model valueForKey:@"lat"],[model valueForKey:@"lon"],[model valueForKey:@"cityCC"],[model valueForKey:@"isCC"]];
    
    if (!is) {
        NSLog(@"2%@", _database.lastErrorMessage);
    }
    //解锁
    [_lock unlock];
}
- (void)saveCityToDB:(DBModel *)model
{
    //加锁
    [_lock lock];
    
    NSString *sql = nil;
    BOOL is = YES;
    //对表添加数据
    sql =[NSString stringWithFormat:@"insert into saveCity(cityPinyin,country_name,lat,lon,cityCC,isCC) values(?,?,?,?,?,?)"];
    
    is = [_database executeUpdate:sql,[model valueForKey:@"cityPinyin"],[model valueForKey:@"country_name"],[model valueForKey:@"lat"],[model valueForKey:@"lon"],[model valueForKey:@"cityCC"],[model valueForKey:@"isCC"]];
    
    if (!is) {
        NSLog(@"2%@", _database.lastErrorMessage);
    }
    //解锁
    [_lock unlock];
}
- (DBModel *)searchWithCityName:(NSString *)cityName
{
    [_lock lock];
    NSString *sql = nil;
    //    注意：name like ‘西门’,相当于是name = ‘西门’。
    //    name like ‘%西%’,为模糊搜索，搜索字符串中间包含了’西’，左边可以为任意字符串，右边可以为任意字符串，的字符串。
    //    但是在 stringWithFormat:中%是转义字符，两个%才表示一个%。
    
    sql = [NSString stringWithFormat:@"select * from cityList where cityPinyin = '%@'", cityName];
    NSLog(@"sql:%@",sql);
    FMResultSet *set = [_database executeQuery:sql];
    DBModel * resultModel = [[DBModel alloc]init];
    if (set.next) {
        
        NSLog(@"successset2");
        resultModel.cityPinyin = [set stringForColumn:@"cityPinyin"];
        resultModel.country_name = [set stringForColumn:@"country_name"];
        resultModel.lat = [set stringForColumn:@"lat"];
        resultModel.lon = [set stringForColumn:@"lon"];
        resultModel.cityCC = [set stringForColumn:@"cityCC"];
        resultModel.isCC = [set intForColumn:@"isCC"];
        
        
    }else{
        NSLog(@"从数据库查找存储的城市%@", _database.lastErrorMessage);
        [_lock unlock];
        return nil;
    }
    [_lock unlock];
    return resultModel;
    
}
- (DBModel *)searchOneCity:(DBModel *)model
{
    [_lock lock];
    NSString *sql = nil;
    //    注意：name like ‘西门’,相当于是name = ‘西门’。
    //    name like ‘%西%’,为模糊搜索，搜索字符串中间包含了’西’，左边可以为任意字符串，右边可以为任意字符串，的字符串。
    //    但是在 stringWithFormat:中%是转义字符，两个%才表示一个%。
    
    sql = [NSString stringWithFormat:@"select * from saveCity where cityCC = '%@'", model.cityCC];
    NSLog(@"sql:%@",sql);
    FMResultSet *set = [_database executeQuery:sql];
    DBModel * resultModel = [[DBModel alloc]init];
    if (set.next) {
        
        NSLog(@"successset2");
        resultModel.cityPinyin = [set stringForColumn:@"cityPinyin"];
        resultModel.country_name = [set stringForColumn:@"country_name"];
        resultModel.lat = [set stringForColumn:@"lat"];
        resultModel.lon = [set stringForColumn:@"lon"];
        resultModel.cityCC = [set stringForColumn:@"cityCC"];
        resultModel.isCC = [set intForColumn:@"isCC"];
        
        
    }else{
        NSLog(@"从数据库查找存储的城市%@", _database.lastErrorMessage);
        [_lock unlock];
        return nil;
    }
    [_lock unlock];
    return resultModel;
}
@end
