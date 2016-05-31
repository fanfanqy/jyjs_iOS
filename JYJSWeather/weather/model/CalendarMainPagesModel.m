//
//  CalendarMainPagesModel.m
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/5/30.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "CalendarMainPagesModel.h"

@implementation CalendarMainPagesModel

{
    FMDatabase * _db;
    FMDatabase * _zangLiDb;
    NSMutableArray *_calendarModelArray;
    NSMutableArray *_calendarZangliArray;
}

-(instancetype)initWithReceiveData{
    if (self = [super init]) {
        [self receiveData];
    }
    return self;
}

-(void)receiveData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _db = [WanNianLiDate getDataBase];
            NSString * path = [[NSBundle mainBundle] pathForResource:@"zangli" ofType:@"db"];
            _zangLiDb = [[FMDatabase alloc] initWithPath:path];
            [_zangLiDb open];
            [self initArray];
            [self readDataFromDB];
        });
    });

}

-(void)initArray{
    _calendarModelArray = [NSMutableArray array];
    _calendarZangliArray = [NSMutableArray array];
    _solarStrArray = [NSMutableArray array];
    _lunarStrArray = [NSMutableArray array];
    _weekStrArray = [NSMutableArray array];
    _FestivalStrArray = [NSMutableArray array];
    _JiNianStrArray = [NSMutableArray array];
    _HaircutStrArray = [NSMutableArray array];
    _YiStrArray = [NSMutableArray array];
    _JiStrArray = [NSMutableArray array];
    _ReligionFestivalStrArray = [NSMutableArray array];
    _ChongAnimalStrArray = [NSMutableArray array];
    _LuckyhourStrArray = [NSMutableArray array];
    _badhouStrArray = [NSMutableArray array];
    self.jianFa = @{@"初一":@"生命短",@"初二":@"病多,麻烦多",@"初三":@"变成富裕人家",@"初四":@"怀业增广,气色好",@"初五":@"增长财物",@"初六":@"气色转衰",@"初七":@"易招闲言，麻烦多",@"初八":@"长寿",@"初九":@"易遇年轻女子",@"初十":@"增长快乐",@"十一":@"增长出世间的智慧与世间的聪明",@"十二":@"招病,生命危险",@"十三":@"精进于佛法，最好",@"十四":@"东西增多",@"十五":@"增上福报",@"十六":@"得病",@"十七":@"容易失明,皮肤变绿",@"十八":@"丢失财物",@"十九":@"佛法增长",@"二十":@"容易挨饿，不好",@"二十一":@"易招传染病",@"二十二":@"病情加重",@"二十三":@"家族富裕",@"二十四":@"遇传染病",@"二十五":@"得沙眼，出迎风泪",@"二十六":@"得安乐",@"二十七":@"吉祥",@"二十八":@"易发生打架",@"二十九":@"掉魂,声音变哑",@"三十":@"预见被争讼及死人",@"十月初八":@"忏净罪孽",@"十一月初八":@"忏净罪孽",@"十二月二十五":@"增长智慧"};
}

- (void)readDataFromDB{
    int strYear = [[Datetime GetYear] intValue];
    int strMonth = [[Datetime GetMonth] intValue];
    int strDay = [[Datetime GetDay] intValue];
    NSArray *arrayTemp =[Datetime GetTenDaysInFutureByYear:strYear andByMonth:strMonth andByDay:strDay ];
    //公历日期
    for (NSString *solarStr1 in arrayTemp) {
       [_solarStrArray addObject:solarStr1];
    }
    //从数据库读取数据
    FMResultSet * setDb = [_db executeQuery:[NSString stringWithFormat:@"select * from calendar where id between '%@' and '%@'",arrayTemp[0],[arrayTemp lastObject]]];
    NSLog(@" sql %@",[NSString stringWithFormat:@"select * from calendar where id between '%@' and '%@'",arrayTemp[0],[arrayTemp lastObject]]);
    while ([setDb next]) {
        calendarDBModel * model = [[calendarDBModel alloc] init];
        model.ID = [setDb stringForColumn:@"id"];
        model.lid = [setDb stringForColumn:@"lid"];
        model.week = [setDb stringForColumn:@"week"];
        model.weekName = [setDb stringForColumn:@"weekName"];
        model.lYear = [setDb stringForColumn:@"lYear"];
        model.lMonth = [setDb stringForColumn:@"lMonth"];
        model.lDay = [setDb stringForColumn:@"lDay"];
        model.lYearName = [setDb stringForColumn:@"lYearName"];
        model.lMonthName = [setDb stringForColumn:@"lMonthName"];
        model.lDayName = [setDb stringForColumn:@"lDayName"];
        model.yearZhu = [setDb stringForColumn:@"yearZhu"];
        model.monthZhu = [setDb stringForColumn:@"monthZhu"];
        model.dayZhu = [setDb stringForColumn:@"dayZhu"];
        model.wxYear = [setDb stringForColumn:@"wxYear"];
        model.wxMonth = [setDb stringForColumn:@"wxMonth"];
        model.wxDay = [setDb stringForColumn:@"wxDay"];
        model.jieQi = [setDb stringForColumn:@"jieQi"];
        model.jieQiTime = [setDb stringForColumn:@"jieQiTime"];
        model.dayShierJianXing = [setDb stringForColumn:@"dayShierJianXing"];
        model.dayErShiBaXingSu = [setDb stringForColumn:@"dayErShiBaXingSu"];
        model.dayAnimal = [setDb stringForColumn:@"dayAnimal"];
        model.chongAnimal = [setDb stringForColumn:@"chongAnimal"];
        model.gongLiJieRi = [setDb stringForColumn:@"gongLiJieRi"];
        model.nongLIjieRi = [setDb stringForColumn:@"nongLiJieRi"];
        model.gd= [setDb stringForColumn:@"gd"];
        model.bd = [setDb stringForColumn:@"bd"];
        model.pssd = [setDb stringForColumn:@"pssd"];
        [_calendarModelArray addObject:model];
    }

    ZangLiModel * zangliModel;
    NSString * zangliSql;
    zangliSql = [NSString stringWithFormat:@"select * from zangli where id between '%@' and '%@'",arrayTemp[0],[arrayTemp lastObject]];
    FMResultSet * zangLi = [_zangLiDb executeQuery:zangliSql];
    while ([zangLi next]) {
        zangliModel = [[ZangLiModel alloc] init];
        zangliModel._id = [zangLi stringForColumn:@"id"];
        zangliModel.zm = [[[zangLi stringForColumn:@"zm"] componentsSeparatedByString:@" "] firstObject];
        zangliModel.zd = [[[zangLi stringForColumn:@"zd"] componentsSeparatedByString:@" "] firstObject];
        zangliModel.zid = [zangLi stringForColumn:@"zid"];
        zangliModel.zyn = [zangLi stringForColumn:@"zyn"];
        zangliModel.zmn = [zangLi stringForColumn:@"zmn"];
        zangliModel.h = [zangLi stringForColumn:@"h"];
        zangliModel.pssd = [zangLi stringForColumn:@"pssd"];
        [_calendarZangliArray addObject:zangliModel];
    }
    for (calendarDBModel *dbModel in _calendarModelArray) {
        /**
         *  @param gdb 宜
         */
        FMResultSet * gdb = [_db executeQuery:[NSString stringWithFormat:@"select * from gdb where gid=%@",dbModel.gd]];
        NSMutableString * muYiStr = [[NSMutableString alloc] init];
        while ([gdb next]) {
            NSString * yi = [gdb stringForColumn:@"val"];
            NSArray * arr = [yi componentsSeparatedByString:@","];
            for (NSString * str in arr) {
                [muYiStr appendFormat:@"%@ ",str];
            }
            if (muYiStr.length > 22) {
                NSRange range = {0,23};
                muYiStr = (NSMutableString *)[muYiStr substringWithRange:range];
            }
            [_YiStrArray addObject:muYiStr];
        }

        /**
         *  忌
         */
        FMResultSet * bdb = [_db executeQuery:[NSString stringWithFormat:@"select * from bdb where bid=%@",dbModel.bd]];
        NSMutableString * muJiStr = [[NSMutableString alloc] init];
        while ([bdb next]) {
            NSString * ji = [bdb stringForColumn:@"val"];
            NSArray * arr = [ji componentsSeparatedByString:@","];
            for (NSString * str in arr) {
                [muJiStr appendFormat:@"%@ ",str];
            }
            if (muJiStr.length > 22) {
                NSRange range = {0,23};
                muJiStr = [muJiStr substringWithRange:range];
            }
            [_JiStrArray addObject:muJiStr];
        }

        /**
         *  农历日子 UILabel *LunarLabel
         */
        NSArray * monthArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
        NSString * lunarMonth;
        int lunarIndex;
        if (dbModel.lMonth.intValue == 0) {
            lunarIndex = [[[dbModel.lMonth componentsSeparatedByString:@"闰"] objectAtIndex:1] intValue] - 1;
            lunarMonth = [NSString stringWithFormat:@"闰%@",[monthArray objectAtIndex:lunarIndex]];
        }else {
            lunarIndex = [dbModel.lMonth intValue] - 1;
            lunarMonth = [monthArray objectAtIndex:lunarIndex];
        }
        [_lunarStrArray addObject:[NSString stringWithFormat:@"%@月%@",lunarMonth,dbModel.lDayName]];

        /**
         *  星期四 UILabel *WeekLabel
         */
        [_weekStrArray addObject:[NSString stringWithFormat:@"星期%@",dbModel.weekName]];

        /**
         *  节气或节日 UILabel *FestivalLabel
         */
        NSString *festivalStr = nil;
        festivalStr = [NSString stringWithFormat:@"%@ %@",dbModel.gongLiJieRi,dbModel.nongLIjieRi];
        if (dbModel.gongLiJieRi.length > 0) {
            if (dbModel.nongLIjieRi.length > 0 ) {
                festivalStr = [NSString stringWithFormat:@"%@ %@",dbModel.gongLiJieRi,dbModel.nongLIjieRi];
            }else{
                festivalStr = [NSString stringWithFormat:@"%@ ",dbModel.gongLiJieRi];
            }
        }else{
            if (dbModel.nongLIjieRi.length>0) {
                festivalStr = [NSString stringWithFormat:@"%@",dbModel.nongLIjieRi];
            }else{
                festivalStr = [NSString stringWithFormat:@"今天无节日"];
            }
        }
        /**
         *  纪年 UILabel *JiNianLabel
         */
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString * string = [formatter stringFromDate:[NSDate date]];
        NSString * time = [[string componentsSeparatedByString:@" "] objectAtIndex:1];
        int hour = [[[time componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
        int hourNum = [DateSource getShiChen:hour];
        int dayNum = [DateSource getDayIndex:dbModel.dayZhu];
        NSString * shiChen = [wanNianLiTool getTimeFromArrayIndex:hourNum andIndex:dayNum];
        [_JiNianStrArray addObject:[NSString stringWithFormat:@"%@年 %@月 %@日 %@",dbModel.yearZhu,dbModel.monthZhu,dbModel.dayZhu,shiChen]];

        /**
         * 28星宿和冲的动物
         UILabel *ChongAnimalLabel;
         */
       [_ChongAnimalStrArray addObject:[NSString stringWithFormat:@"{%@%@%@ 冲%@}",dbModel.wxDay,dbModel.dayErShiBaXingSu,dbModel.dayShierJianXing,dbModel.chongAnimal]];

        /**
         *  吉时
         *  UILabel *LuckyhourLabel;
         */
        /**
         *  凶时
         *  UILabel *BadhourLabel;
         */
        //十二时辰数组
        NSArray * jiXiongName = @[@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥"];
        NSMutableArray * jiArr = [[NSMutableArray alloc] init];//存储吉时的数组
        NSMutableArray * xiongArr = [[NSMutableArray alloc] init];//存储凶时的数组
        NSMutableArray * strArr = [[NSMutableArray alloc] init];

        strArr = [wanNianLiTool getShiChenJiXiong:dbModel.dayZhu];//根据日柱得到吉凶的数组

        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < 12; i++) {
            [dic setObject:[strArr objectAtIndex:i] forKey:[jiXiongName objectAtIndex:i]];
        }
        for (int i = 0; i < 12; i++) {
            if ([[dic objectForKey:[jiXiongName objectAtIndex:i]]  isEqual: @1]) {
                [jiArr addObject:[jiXiongName objectAtIndex:i]];
            }else {
                [xiongArr addObject:[jiXiongName objectAtIndex:i]];
            }
        }
        NSString *luckyStr;
        NSString *badStr;
        luckyStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ ",jiArr[0],jiArr[1],jiArr[2],jiArr[3],jiArr[4],jiArr[5]];
        badStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ ",xiongArr[0],xiongArr[1],xiongArr[2],xiongArr[3],xiongArr[4],xiongArr[5]];
        NSLog(@"%@,%@",luckyStr,badStr);
        [_LuckyhourStrArray addObject:luckyStr];
        [_badhouStrArray addObject:badStr];
    }
    
    for (ZangLiModel * zangliModel1 in _calendarZangliArray) {
        /**
         *  理发 UILabel *HaircutLabel
         */
        NSString * zangLiDay;
        if (zangliModel1.zm.length != 0) {
            if (zangliModel1.zd.length > 3) {//如果藏历day是闰  去掉闰字留下日期作为字典查询
                NSRange range = {0,zangliModel1.zd.length - 3};
                zangLiDay = [zangliModel1.zd substringWithRange:range];
            }else {
                zangLiDay = zangliModel1.zd;
            }
        }
        NSString * key = [NSString stringWithFormat:@"%@%@",zangliModel1.zm,zangLiDay];
        if ([_jianFa objectForKey:key] != nil) {
            [_HaircutStrArray addObject: [_jianFa objectForKey:key]];
        }else {
            [_HaircutStrArray addObject: [_jianFa objectForKey:zangLiDay]];
        }

        /**
         *  宗教节日 UILabel *ReligionFestivalLabel
         */
        [_ReligionFestivalStrArray addObject:zangliModel.h];

    }


}



@end
