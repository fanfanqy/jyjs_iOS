//
//  CalendarMainPagesModel.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/5/30.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Datetime.h"
#import "calendarDBModel.h"
#import "ZangLiModel.h"
#import "DateSource.h"
#import "wanNianLiTool.h"
#import "WanNianLiDate.h"
typedef enum{
    LuckyImage,
    BadImage,
    CommonImage
}LuckyImageType;
@interface CalendarMainPagesModel : NSObject
/**
 *  吉凶平
 */
@property (assign, nonatomic)LuckyImageType *luckyImageType;
//阳历日子
@property (nonatomic , strong) NSMutableArray * solarStrArray;
/**
 *  农历日子
 */
@property (nonatomic , strong) NSMutableArray * lunarStrArray;
/**
 *  星期四
 */
@property (nonatomic , strong) NSMutableArray * weekStrArray;
/**
 *  节气或节日
 */
@property (nonatomic , strong) NSMutableArray * FestivalStrArray;

/**
 *  纪年
 */
@property (nonatomic , strong) NSMutableArray * JiNianStrArray;

/**
 *  理发
 */
@property (nonatomic , strong) NSMutableArray * HaircutStrArray;

/**
 *  宜
 */
@property (nonatomic , strong) NSMutableArray * YiStrArray;


/**
 *  忌
 */
@property (nonatomic , strong) NSMutableArray * JiStrArray;


/**
 *  宗教节日
 */
@property (nonatomic , strong) NSMutableArray * ReligionFestivalStrArray;

/**
 *  冲的动物
 */
@property (nonatomic , strong) NSMutableArray * ChongAnimalStrArray;

/**
 *  吉时
 */
@property (nonatomic , strong) NSMutableArray * LuckyhourStrArray;

/**
 *  凶时
 */
@property (nonatomic , strong) NSMutableArray * badhouStrArray;

@property (nonatomic,strong) NSDictionary *jianFa;
-(instancetype)initWithReceiveData;
@end
