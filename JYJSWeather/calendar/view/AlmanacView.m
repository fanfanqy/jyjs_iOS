//
//  CalendarDateView.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/18.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "AlmanacView.h"
#import "DateSource.h"
#import "wanNianLiTool.h"
#import "Datetime.h"
@implementation AlmanacView

- (id)initWithCoder:(NSCoder*)coder
{
    if (self = [super initWithCoder:coder]) {
         self.jianFa = @{@"初一":@"生命短",@"初二":@"病多,麻烦多",@"初三":@"变成富裕人家",@"初四":@"怀业增广,气色好",@"初五":@"增长财物",@"初六":@"气色转衰",@"初七":@"易招闲言，麻烦多",@"初八":@"长寿",@"初九":@"易遇年轻女子",@"初十":@"增长快乐",@"十一":@"增长出世间的智慧与世间的聪明",@"十二":@"招病,生命危险",@"十三":@"精进于佛法，最好",@"十四":@"东西增多",@"十五":@"增上福报",@"十六":@"得病",@"十七":@"容易失明,皮肤变绿",@"十八":@"丢失财物",@"十九":@"佛法增长",@"二十":@"容易挨饿，不好",@"二十一":@"易招传染病",@"二十二":@"病情加重",@"二十三":@"家族富裕",@"二十四":@"遇传染病",@"二十五":@"得沙眼，出迎风泪",@"二十六":@"得安乐",@"二十七":@"吉祥",@"二十八":@"易发生打架",@"二十九":@"掉魂,声音变哑",@"三十":@"预见被争讼及死人",@"十月初八":@"忏净罪孽",@"十一月初八":@"忏净罪孽",@"十二月二十五":@"增长智慧"};
    }
    return self;
}

-(void)reloadDataOfYiJiView:(calendarDBModel *)model andZangLiModel:(ZangLiModel *)zangliModel year:(int)strYear month:(int)strMonth day:(int)strDay{
    /**
     *  吉凶平
     *  UIImageView *LuckyImageView;
     */

#pragma mark 待修改
//    _LuckyImageView

    /**
     *  阳历日子
     *  UILabel *SolarLabel;
     */
    _SolarLabel.text = [NSString stringWithFormat:@"%d/%d/%d",strYear,strMonth,strDay];
    /**
     *  农历日子 UILabel *LunarLabel
     */
    NSArray * monthArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    NSString * lunarMonth;
    int lunarIndex;
    if (model.lMonth.intValue == 0) {
        lunarIndex = [[[model.lMonth componentsSeparatedByString:@"闰"] objectAtIndex:1] intValue] - 1;
        lunarMonth = [NSString stringWithFormat:@"闰%@",[monthArray objectAtIndex:lunarIndex]];
    }else {
        lunarIndex = [model.lMonth intValue] - 1;
        lunarMonth = [monthArray objectAtIndex:lunarIndex];
    }
//    _LunarLabel.text = [NSString stringWithFormat:@"%@年%@月%@",model.lYearName,lunarMonth,model.lDayName];
     _LunarLabel.text = [NSString stringWithFormat:@"%@月%@",lunarMonth,model.lDayName];
    /**
     *  星期四 UILabel *WeekLabel
     */
    _WeekLabel.text = [NSString stringWithFormat:@"星期%@",model.weekName];
    /**
     *  节气或节日 UILabel *FestivalLabel
     */
    _FestivalLabel.text = [NSString stringWithFormat:@"%@ %@",model.gongLiJieRi,model.nongLIjieRi];
    if (model.gongLiJieRi.length > 0) {
            if (model.nongLIjieRi.length > 0 ) {
                    _FestivalLabel.text = [NSString stringWithFormat:@"%@ %@",model.gongLiJieRi,model.nongLIjieRi];
            }else{
                    _FestivalLabel.text = [NSString stringWithFormat:@"%@ ",model.gongLiJieRi];
            }
    }else{
            if (model.nongLIjieRi.length>0) {
                _FestivalLabel.text = [NSString stringWithFormat:@"%@",model.nongLIjieRi];
            }else{
                _FestivalLabel.text = [NSString stringWithFormat:@"今天无节日"];
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
    int dayNum = [DateSource getDayIndex:model.dayZhu];
    NSString * shiChen = [wanNianLiTool getTimeFromArrayIndex:hourNum andIndex:dayNum];
    _JiNianLabel.text = [NSString stringWithFormat:@"%@年 %@月 %@日 %@",model.yearZhu,model.monthZhu,model.dayZhu,shiChen];
    /**
     *  理发 UILabel *HaircutLabel
     */
    NSString * zangLiDay;
    if (zangliModel.zm.length != 0) {
        if (zangliModel.zd.length > 3) {//如果藏历day是闰  去掉闰字留下日期作为字典查询
            NSRange range = {0,zangliModel.zd.length - 3};
            zangLiDay = [zangliModel.zd substringWithRange:range];
        }else {
            zangLiDay = zangliModel.zd;
        }
    }
    NSString * key = [NSString stringWithFormat:@"%@%@",zangliModel.zm,zangLiDay];
    if ([_jianFa objectForKey:key] != nil) {
        _HaircutLabel.text = [_jianFa objectForKey:key];
    }else {
        _HaircutLabel.text = [_jianFa objectForKey:zangLiDay];
    }

// 这2个数据需要放到外面
    /**
     *  宜 UILabel *YiLabel
     */
    /**
     *  忌 UILabel *JiLabel;
     */


    /**
     *  宗教节日 UILabel *ReligionFestivalLabel
     */
    CGSize textMax = CGSizeMake(ScreenWidth - 2 * PADDING, MAXFLOAT);
    CGSize textSize = [zangliModel.h sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:textMax];
    CGRect holidayLabelFrame = _ReligionFestivalLabel.frame;
    holidayLabelFrame.size.width = textSize.width;
    holidayLabelFrame.size.height = textSize.height;
    _ReligionFestivalLabel.frame = holidayLabelFrame;
    _ReligionFestivalLabel.text = zangliModel.h;

    /**
     * 28星宿和冲的动物
     UILabel *ChongAnimalLabel;
     */
    _ChongAnimalLabel.text = [NSString stringWithFormat:@"{%@%@%@ 冲%@}",model.wxDay,model.dayErShiBaXingSu,model.dayShierJianXing,model.chongAnimal];

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

    strArr = [wanNianLiTool getShiChenJiXiong:model.dayZhu];//根据日柱得到吉凶的数组

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
    NSString * oldHour = [wanNianLiTool getOldHour];
    NSString *luckyStr;
    NSString *badStr;
    luckyStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ ",jiArr[0],jiArr[1],jiArr[2],jiArr[3],jiArr[4],jiArr[5]];
     badStr = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ ",xiongArr[0],xiongArr[1],xiongArr[2],xiongArr[3],xiongArr[4],xiongArr[5]];
//    for (int i = 1; i <7; i++) {
//        [luckyStr stringByAppendingString:jiArr[i-1]];
//        luckyStr = [luckyStr stringByAppendingString:[NSString stringWithFormat:@"%@",jiArr[i-1]]];
//         badStr = [badStr stringByAppendingString:[NSString stringWithFormat:@"%@",xiongArr[i-1]]];
//         _LuckyhourLabel.text = jiArr[i - 1];
//        if ([_LuckyhourLabel.text isEqualToString:oldHour]) {
//            _LuckyhourLabel.textColor = UIColorFromRGB(0xd20000);
//        }else {
//            _LuckyhourLabel.textColor = UIColorFromRGB(0xaa4322);
//        }
//        _BadhourLabel.text = xiongArr[i - 1];
//        if ([_BadhourLabel.text isEqualToString:oldHour]) {
//            _BadhourLabel.textColor = UIColorFromRGB(0xd20000);
//        }else {
//            _BadhourLabel.textColor = UIColorFromRGB(0x33497a);
//        }
//    }
    NSLog(@"%@,%@",luckyStr,badStr);
     _LuckyhourLabel.text = luckyStr;
    _BadhourLabel.text = badStr;

}

@end
