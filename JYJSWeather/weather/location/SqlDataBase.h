//
//  SqlDataBase.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/18.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBModel;

@interface SqlDataBase : NSObject

- (void)insertData:(id )model;
// 根据输入搜索相应城市
-(NSMutableArray *)searchWithString:(NSString *)searchString andIsCC:(BOOL)isPinyin;

// 根据城市名称搜索相应城市信息
// 定位后,根据定位信息搜索当前城市
- (DBModel *)searchWithCityName:(NSString *)cityName;

// 搜索所有保存的城市
- (NSMutableArray *)searchAllSaveCity;
// 删除保存的城市
- (void)deleateCityFromSaveCity:(DBModel *)model;
// 保存想要查询天气的城市
- (void)saveCityToDB:(DBModel *)model;
// 根据条件,查询是否含有单个的城市
- (DBModel *)searchOneCity:(DBModel *)model;
@end
