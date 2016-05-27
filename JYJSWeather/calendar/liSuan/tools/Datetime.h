//
//  Datetime.h
//  CalendarTest
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 caobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Datetime : NSObject
//所有年列表
+(NSArray *)GetAllYearArray;

//所有月列表
+(NSArray *)GetAllMonthArray;



//获取指定年份指定月份的星期排列表
+(NSArray *)GetDayArrayByYear:(int) year
                     andMonth:(int) month;
//获取指定年份指定月份的星期排列表(农历)
+(NSArray *)GetLunarDayArrayByYear:(int) year
                          andMonth:(int) month;

//获取指定年份指定月份指定日子的一周排列
+(NSMutableArray *)GetDayArrayByYear:(int) year andMonth:(int) month andDay:(int) day;
+(NSMutableArray *)GetDayDicByYear:(int) year andMonth:(int) month andDay:(int) day;
//根据传入某一天日期,获取这天前后共计一周的日子排列(农历)
+(NSMutableArray *)GetLunarDayArrayByYear:(int) year
                          andMonth:(int) month andDay:(int)day;

//获取某年某月某日的对应农历
+(NSString *)GetLunarDayByYear:(int) year
                      andMonth:(int) month
                        andDay:(int) day;

//获取指定年份指定月份的相邻2个月总共3个月的排列表
+(NSMutableArray *)GetThreeMonthArrayByYear:(int) year
                     andMonth:(int) month;
//具体某一天是周几
+(int)GetTheWeekOfDayByYera:(int)year andByMonth:(int)month andByDay:(int)day;
//以YYYY.MM.dd格式输出年月日
+(NSString*)getDateTime;

//以YYYY年MM月dd日格式输出年月日
+(NSString*)GetDateTime;

//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)GetLunarDateTime;

+(NSString *)GetYear;

+(NSString *)GetMonth;

+(NSString *)GetDay;

+(NSString *)GetHour;

+(NSString *)GetMinute;

+(NSString *)GetSecond;
//得到year年month月的天数
+(int)GetNumberOfDayByYera:(int)year andByMonth:(int)month;
//得到某月第一天是周几
+(int)GetTheWeekOfDayByYera:(int)year andByMonth:(int)month;
+(int)GetTheWeekOfDayByYera:(int)year andByMonth:(int)month andByDay:(int)day;
+ (NSDate *)dateFromString:(NSString *)dateString;






@end
