//
//  Datetime.m
//  CalendarTest
//
//  Created by mac on 13-8-27.
//  Copyright (c) 2013年 caobo. All rights reserved.
//

#import "Datetime.h"
#import "LunarCalendar.h"
#import "JBCalendar.h"
@implementation Datetime
//所有年列表
+(NSArray *)GetAllYearArray{
    NSMutableArray * monthArray = [[NSMutableArray alloc]init];
    for (int i = 1901; i<2050; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [monthArray addObject:days];
    }
    return monthArray;
}

//所有月列表
+(NSArray *)GetAllMonthArray{
    NSMutableArray * monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<13; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [monthArray addObject:days];
    }
    return monthArray;
}

//以YYYY.MM.dd格式输出年月日
+(NSString*)getDateTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

//以YYYY年MM月dd日格式输出年月日
+(NSString*)GetDateTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
     NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)GetLunarDateTime{
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = [[self GetYear] intValue],date.month =[[self GetMonth] intValue],date.day = [[self GetDay] intValue];
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    NSString * lunar = [[NSString alloc]initWithFormat:
                           @"%@%@年%@%@",lunarCalendar.YearHeavenlyStem,lunarCalendar.YearEarthlyBranch,lunarCalendar.MonthLunar,lunarCalendar.DayLunar];
    return lunar;
}

//获取指定年份指定月份的星期排列表
+(NSMutableArray *)GetDayArrayByYear:(int) year andMonth:(int) month{
    NSMutableArray * dayArray1 = [[NSMutableArray alloc]init];
    for (int i = 0; i< 42; i++) {
        NSString * days;
        if (i <= [self GetTheWeekOfDayByYera:year andByMonth:month]-1) {
            if (month==1) {
                year--;
                month=12;
                //跨年
                days = [NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:year andByMonth:month]-([self GetTheWeekOfDayByYera:year andByMonth:month]-i)+1];
            }else{
             days = [NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:year andByMonth:(month-1)]-([self GetTheWeekOfDayByYera:year andByMonth:month]-i)+1];
            }
            [dayArray1 addObject:days];
        }else if ((i>[self GetTheWeekOfDayByYera:year andByMonth:month]-1)&&(i<[self GetTheWeekOfDayByYera:year andByMonth:month]+[self GetNumberOfDayByYera:year andByMonth:month])){
                days = [NSString stringWithFormat:@"%d",i-[self GetTheWeekOfDayByYera:year andByMonth:month]+1];
                [dayArray1 addObject:days];
        }else {
            //这里是根据 i 和"上个月"算的
            days = [NSString stringWithFormat:@"%d",i-[self GetNumberOfDayByYera:year andByMonth:month]-[self GetTheWeekOfDayByYera:year andByMonth:month]+1];
            [dayArray1 addObject:days];
        }
    }
    return dayArray1;
}

//获取指定年份指定月份指定日子的一周排列,数组中只有day 
+(NSMutableArray *)GetDayArrayByYear:(int) year andMonth:(int) month andDay:(int) day{
    NSMutableArray * dayArray2 = [[NSMutableArray alloc]init];
    //某一天是周几
    int index1 = [self GetTheWeekOfDayByYera:year andByMonth:month andByDay:day];//6
    //月首日是周几
    int index = [self GetTheWeekOfDayByYera:year andByMonth:month];//0
    for (int i = 0; i< 7; i++) {
        if (i<index1) {
            if ((day - index1+i)>0) {//大于1号
                [dayArray2 addObject:[NSString stringWithFormat:@"%d",day-index1+i]];
            }else{
                if (month==1) {
                    year--;
                    month=12;
                    [dayArray2 addObject:[NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:year andByMonth:month]-(index-i)+1]];
                }else{
                [dayArray2 addObject:[NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:year andByMonth:(month-1)]-(index-i)+1]];
                }
            }
        }else {
            if (day+(i-index1)<=[self GetNumberOfDayByYera:year andByMonth:month]) {
                [dayArray2 addObject:[NSString stringWithFormat:@"%d",day+i-index1]];
            }else{
                int index2 = 0;
                if (month==12) {
                    index2 = [self GetTheWeekOfDayByYera:year++ andByMonth:1];
                }else{
                    index2 = [self GetTheWeekOfDayByYera:year andByMonth:(month+1)];
                }
                [dayArray2 addObject:[NSString stringWithFormat:@"%d",i-index2+1]];
            }
        }
    }
    return dayArray2;
}

+(NSMutableArray *)GetDayDicByYear:(int) year andMonth:(int) month andDay:(int) day andCountsDay:(int)countsDay;
{
     NSMutableArray * dayArrayDay = [[NSMutableArray alloc]init];
     NSMutableArray * dayArrayMonth = [[NSMutableArray alloc]init];
     NSMutableArray * dayArrayYear = [[NSMutableArray alloc]init];
     NSMutableArray * dayArray4 = [[NSMutableArray alloc]init];
    //某一天是周几
    int index1 = [self GetTheWeekOfDayByYera:year andByMonth:month andByDay:day];
    //月首日是周几
    int index = [self GetTheWeekOfDayByYera:year andByMonth:month];
    for (int i = 0; i< countsDay; i++) {
        if (i<index1) {
            if ((day - index1+i)>0) {//大于1号
                [dayArrayDay addObject:[NSString stringWithFormat:@"%d",day-index1+i]];
                [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",month]];
                [dayArrayYear addObject:[NSString stringWithFormat:@"%d",year]];
            }else{
                if (month==1) {
                    year--;
                    month=12;
                    [dayArrayDay addObject:[NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:year andByMonth:month]-(index-i)+1]];
                    [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",month]];
                    [dayArrayYear addObject:[NSString stringWithFormat:@"%d",year]];
                }else{
                    [dayArrayDay addObject:[NSString stringWithFormat:@"%d",[self GetNumberOfDayByYera:year andByMonth:(month-1)]-(index-i)+1]];
                    [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",month-1]];
                    [dayArrayYear addObject:[NSString stringWithFormat:@"%d",year]];
                }
            }
        }else {
            if (day+(i-index1)<=[self GetNumberOfDayByYera:year andByMonth:month]) {
                [dayArrayDay addObject:[NSString stringWithFormat:@"%d",day+i-index1]];
                [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",month]];
                [dayArrayYear addObject:[NSString stringWithFormat:@"%d",year]];
            }else{
                int index2 = 0;
                if (month==12) {
                    index2 = [self GetTheWeekOfDayByYera:year++ andByMonth:1];
                    [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",1]];
                }else{
                    index2 = [self GetTheWeekOfDayByYera:year andByMonth:(month+1)];
                     [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",month+1]];
                }
                [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i-index2+1]];
                [dayArrayYear addObject:[NSString stringWithFormat:@"%d",year]];
            }
        }
    }
    [dayArray4 addObject:dayArrayYear];
    [dayArray4 addObject:dayArrayMonth];
    [dayArray4 addObject:dayArrayDay];
    return dayArray4;
}


//根据传入某一天日期,获取这天前后共计一周的日子排列(农历)
+(NSMutableArray *)GetLunarDayArrayByYear:(int) year
                          andMonth:(int) month andDay:(int)day{
    NSMutableArray * dayArray4 = [NSMutableArray array];
    //某一天是周几
    int index1 = [self GetTheWeekOfDayByYera:year andByMonth:month andByDay:day];
    //月首日是周几
    int index = [self GetTheWeekOfDayByYera:year andByMonth:month];
    for (int i = 0; i< 7; i++) {
        if (i<index1) {
            if ((day - index1+i)>0) {//大于1号
                [dayArray4 addObject:[self GetLunarDayByYear:year andMonth:month andDay:day-index1+i]];
            }else{
                if (month==1) {
                    year--;
                    month=12;
                [dayArray4 addObject:[self GetLunarDayByYear:year andMonth:month andDay:([self GetNumberOfDayByYera:year andByMonth:month]-(index-i)+1)]];
                }else{

                    int day = [self GetNumberOfDayByYera:year andByMonth:(month-1)]-(index-i)+1;
                     [dayArray4 addObject:[self GetLunarDayByYear:year andMonth:(month-1) andDay:day]];

                }
            }
        }else {
            if (day-(i-index1)<=[self GetNumberOfDayByYera:year andByMonth:month]) {
                 [dayArray4 addObject:[self GetLunarDayByYear:year andMonth:month andDay:day+i-index1]];
            }else{

                int index2 = 0;
                if (month==12) {
                    index2 = [self GetTheWeekOfDayByYera:year++ andByMonth:1];
                }else{
                    index2 = [self GetTheWeekOfDayByYera:year andByMonth:(month+1)];
                }
                [dayArray4 addObject:[self GetLunarDayByYear:year andMonth:month andDay:i-index2+1]];

            }
        }
    }
//     NSLog(@"dayArray4:%@",dayArray4);
    return dayArray4;
}
//获取指定年份指定月份的相邻2个月总共3个月的排列表
+(NSMutableArray *)GetThreeMonthArrayByYear:(int) year
                                   andMonth:(int) month{
    NSMutableArray * dayArray3 = [[NSMutableArray alloc]init];
    int yearTemp = year;
    int monthTemp = month;
    int yearTemp1 = year;
    int monthTemp1 = month;
    if (monthTemp==1) {
        yearTemp--;monthTemp=12;
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]; i++) {
            [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }else {
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp  andByMonth:(monthTemp-1)]; i++) {
            [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }

    for (int i=0; i<[self GetNumberOfDayByYera:year andByMonth:month]; i++) {
        [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
    }

    if (monthTemp1==12) {
        yearTemp1++;monthTemp1=1;
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp1 andByMonth:monthTemp1]; i++) {
            [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }else{
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp1 andByMonth:monthTemp1+1]; i++) {
            [dayArray3 addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    return dayArray3;
    
}

+(NSMutableArray *)GetThreeMonthDicByYear:(int) year
                                   andMonth:(int) month{
    NSMutableArray * dayArray3 = [[NSMutableArray alloc]init];
    NSMutableArray * dayArrayYear = [[NSMutableArray alloc]init];
    NSMutableArray * dayArrayMonth = [[NSMutableArray alloc]init];
    NSMutableArray * dayArrayDay = [[NSMutableArray alloc]init];
    int yearTemp = year;
    int monthTemp = month;
    int yearTemp1 = year;
    int monthTemp1 = month;
    if (monthTemp==1) {
        yearTemp--;monthTemp=12;
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp andByMonth:monthTemp]; i++) {
            [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
             [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp]];
            [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];

        }
    }else {
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp  andByMonth:(monthTemp-1)]; i++) {
            [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
            [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp-1]];
            [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }

    for (int i=0; i<[self GetNumberOfDayByYera:year andByMonth:month]; i++) {
        [dayArrayYear addObject:[NSString stringWithFormat:@"%d",year]];
        [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",month]];
        [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];
    }

    if (monthTemp1==12) {
        yearTemp1++;monthTemp1=1;
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp1 andByMonth:monthTemp1]; i++) {
            [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
            [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp]];
            [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }else{
        for (int i=0; i<[self GetNumberOfDayByYera:yearTemp1 andByMonth:monthTemp1+1]; i++) {
            [dayArrayYear addObject:[NSString stringWithFormat:@"%d",yearTemp]];
            [dayArrayMonth addObject:[NSString stringWithFormat:@"%d",monthTemp+1]];
            [dayArrayDay addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    [dayArray3 addObject:dayArrayYear];
    [dayArray3 addObject:dayArrayMonth];
    [dayArray3 addObject:dayArrayDay];
    return dayArray3;
    
}

//获取指定年份指定月份的星期排列表(农历)
+(NSMutableArray *)GetLunarDayArrayByYear:(int) year andMonth:(int) month{
    NSMutableArray * dayArray5 = [[NSMutableArray alloc]init];
    for (int i = 0; i< 42; i++) {
        NSString * days;
        if (i <= [self GetTheWeekOfDayByYera:year andByMonth:month]-1) {
            if (month==1) {
                year--;
                month=12;
                days = [self GetLunarDayByYear:year andMonth:month andDay:([self GetNumberOfDayByYera:year andByMonth:month]-([self GetTheWeekOfDayByYera:year andByMonth:month]-i)+1)];
            }else{
            days = [self GetLunarDayByYear:year andMonth:(month-1) andDay:([self GetNumberOfDayByYera:year andByMonth:(month-1)]-([self GetTheWeekOfDayByYera:year andByMonth:month]-i)+1)];
            }
            [dayArray5 addObject:days];
        }else if ((i>[self GetTheWeekOfDayByYera:year andByMonth:month]-1)&&(i<[self GetTheWeekOfDayByYera:year andByMonth:month]+[self GetNumberOfDayByYera:year andByMonth:month])){
             days = [self GetLunarDayByYear:year andMonth:month andDay:(i-[self GetTheWeekOfDayByYera:year andByMonth:month]+1)];
            [dayArray5 addObject:days];
        }else {
            if (month==12) {
                year++;
                month=1;
                days = [self GetLunarDayByYear:year andMonth:month andDay:(i-[self GetNumberOfDayByYera:year andByMonth:month]-[self GetTheWeekOfDayByYera:year andByMonth:month]+1)];
            }else{
            days = [self GetLunarDayByYear:year andMonth:(month+1) andDay:(i-[self GetNumberOfDayByYera:year andByMonth:month]-[self GetTheWeekOfDayByYera:year andByMonth:month]+1)];
            }
            [dayArray5 addObject:days];
        }
    }
    return dayArray5;
}

//获取某年某月某日的对应农历日
+(NSString *)GetLunarDayByYear:(int) year
                      andMonth:(int) month
                        andDay:(int) day{
    JBCalendar* date = [[JBCalendar alloc]init];
    date.year = year,date.month = month,date.day = day;
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    NSString * lunarday = [[NSString alloc]initWithString:lunarCalendar.DayLunar];
//    NSLog(@"lunarday:%@",lunarday);
    return lunarday;
}

//具体某一天是周几
+(int)GetTheWeekOfDayByYera:(int)year andByMonth:(int)month andByDay:(int)day{
    int dayTemp = (day-1)%7+[self GetTheWeekOfDayByYera:year andByMonth:month];
    while (dayTemp>=7) {
        dayTemp = dayTemp%7;
    }
    return dayTemp;
}

//计算year年month月第一天是星期几，周日则为0
+(int)GetTheWeekOfDayByYera:(int)year
                 andByMonth:(int)month{
    int numWeek = ((year-1)+ (year-1)/4-(year-1)/100+(year-1)/400+1)%7;//numWeek为years年的第一天是星期几

    int numdays;
    
    if ((year%4==0&&year%100!=0)||(year%400==0)) {
        
        int br[12] = {0,31,60,91,121,152,182,213,244,274,305,335};
        
        numdays = (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))?(br[month-1]+1):(br[month-1]);//numdays为month月years年的第一天是这一年的第几天
        
    }else{
        
        int ar[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
        
        numdays = (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))?(ar[month-1]+1):(ar[month-1]);//numdays为month月years年的第一天是这一年的第几天
    }
    int dayweek = (numdays%7 + numWeek)%7;//month月第一天是星期几，周日则为0
    return dayweek;
}

//判断year年month月有多少天
+(int)GetNumberOfDayByYera:(int)year
                andByMonth:(int)month{
    int nummonth = 0;
    //判断month月有多少天
    if ((month == 1)|| (month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12)){
        
        nummonth = 31;
        
    }else if ((month == 4)|| (month == 6)||(month == 9)||(month == 11)){
        
        nummonth = 30;
        
    }else if ((year%4==0&&year%100!=0)||(year%400==0)){
        
        nummonth = 29;
        
    }else{
        
        nummonth = 28;
    }
    return nummonth;
}

//未来10天的日期情况,数组中是 年-月-日,组成的日期
+(NSMutableArray<NSString *>*)GetTenDaysInFutureByYear:(int)year andByMonth:(int)month andByDay:(int)day{
     NSMutableArray *array = [Datetime GetThreeMonthDicByYear:year andMonth:month];
     NSMutableArray *arrayTemp  = [NSMutableArray array];

    int count = 0;
    for (int i=(int)[array[2] count]-1; i>=0; i--) {
        if ([array[2][i] intValue]== day) {
            count++;
        }
    }

    if (count == 1) {
        for (int i=(int)[array[2] count]-1; i>=0; i--) {
            if ([array[2][i] intValue]== day) {
                for (int j=i; j<i+10; j++) {
                   
                        int year1 = [array[0][j] intValue];
                        int month1 = [array[1][j] intValue];
                        int day1 = [array[2][j] intValue];
                        NSString *monthStr = nil;
                        NSString *dayStr = nil;
                        NSString *dateStr = nil;
                        if (month1 < 10) {
                            monthStr = [NSString stringWithFormat:@"0%d",month1];
                        }else{
                            monthStr = [NSString stringWithFormat:@"%d",month1];
                        }
                        if (day1<10) {
                            dayStr = [NSString stringWithFormat:@"0%d",day1];
                        }else{
                            dayStr = [NSString stringWithFormat:@"%d",day1];
                        }
                        dateStr = [NSString stringWithFormat:@"%d%@%@",year1,monthStr,dayStr];
                        [arrayTemp addObject:dateStr];
                    
                }
            }
        }

    }else if (count == 2 || count == 3) {
    int countTemp = 0;
     for (int i=(int)[array[2] count]-1; i>=0; i--) {
        if ([array[2][i] intValue]== day) {
            if (countTemp == 1) {
                for (int j=i; j<i+10; j++) {
                    int year1 = [array[0][j] intValue];
                    int month1 = [array[1][j] intValue];
                    int day1 = [array[2][j] intValue];
                    NSString *monthStr = nil;
                    NSString *dayStr = nil;
                    NSString *dateStr = nil;
                    if (month1 < 10) {
                        monthStr = [NSString stringWithFormat:@"0%d",month1];
                    }else{
                        monthStr = [NSString stringWithFormat:@"%d",month1];
                    }
                    if (day1<10) {
                        dayStr = [NSString stringWithFormat:@"0%d",day1];
                    }else{
                        dayStr = [NSString stringWithFormat:@"%d",day1];
                    }
                    dateStr = [NSString stringWithFormat:@"%d%@%@",year1,monthStr,dayStr];
                    [arrayTemp addObject:dateStr];
                }
                break;
            }
            countTemp++;
        }
    }
    }

    return arrayTemp;
}

+(NSString *)GetYear{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetMonth{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];

    return date;
}

+(NSString *)GetDay{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetHour{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetMinute{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}

+(NSString *)GetSecond{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"ss"];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
    return date;
}
+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}
@end
