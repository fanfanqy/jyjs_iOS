//
//  calendarDateView.m
//  FaLv
//
//  Created by han on 15/3/4.
//  Copyright (c) 2015年 xjkjmac01. All rights reserved.
//

#import "calendarDateView.h"
#import "wanNianLiTool.h"
#import "DateSource.h"
#import "XBControl.h"
@implementation calendarDateView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        //公历的label
        self.Gregorian = [XBControl createLabelWithFrame:CGRectMake(PADDING,20, ScreenWidth * 0.1, 14) text:@"公历" textColor:UIColorFromRGB(0xd20000) font:15];
        _Gregorian.backgroundColor = [UIColor clearColor];
        [self addSubview:_Gregorian];

        //日期
        self.dateLabel = [XBControl createLabelWithFrame:CGRectMake(_Gregorian.frame.origin.x + _Gregorian.frame.size.width + PADDING * 0.5, 20, ScreenWidth * 0.23, 14) text:@"2014-12-02" textColor:UIColorFromRGB(0x303030) font:TEXTNUMBERFIVE];
        _dateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_dateLabel];
        
        //星期
        self.weekLabel = [XBControl createLabelWithFrame:CGRectMake(_dateLabel.frame.origin.x + _dateLabel.frame.size.width, 20, ScreenWidth * 0.1, 14) text:@"周二" textColor:UIColorFromRGB(0x303030) font:TEXTNUMBERFIVE];
        [self addSubview:_weekLabel];
        _weekLabel.backgroundColor = [UIColor clearColor];
        
        //农历
        self.lunar = [XBControl createLabelWithFrame:CGRectMake(_weekLabel.frame.origin.x + _weekLabel.frame.size.width + PADDING * 0.5, 20, ScreenWidth * 0.1, 14) text:@"农历" textColor:UIColorFromRGB(0xd20000) font:15];
        _lunar.backgroundColor = [UIColor clearColor];
        [self addSubview:_lunar];

        //农历日期
        self.lunarLabel = [XBControl createLabelWithFrame:CGRectMake(_lunar.frame.origin.x + _lunar.frame.size.width, 20, ScreenWidth * 0.3, 14) text:@"马年六月十九" textColor:UIColorFromRGB(0x303030) font:TEXTNUMBERFIVE];
        _lunarLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_lunarLabel];

        //黄历日期
        CGFloat dateY = _Gregorian.frame.origin.y + _Gregorian.frame.size.height + PADDING * 0.5;
        self.lDateLabel = [XBControl createLabelWithFrame:CGRectMake(PADDING , dateY, ScreenWidth * 0.5, 14) text:@"某某年 某某月 某某日 某某时" textColor:UIColorFromRGB(0x303030) font:TEXTNUMBERFIVE];
        _lDateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_lDateLabel];

        //星宿
        self.xingSu = [XBControl createLabelWithFrame:CGRectMake(_lunarLabel.frame.origin.x, dateY, 36, 14) text:@"水壁平" textColor:UIColorFromRGB(0x303030) font:TEXTNUMBERFIVE];
        _xingSu.backgroundColor = [UIColor clearColor];
        [self addSubview:_xingSu];

        //冲动物
        self.chong_animal = [XBControl createLabelWithFrame:CGRectMake(_xingSu.frame.origin.x + _xingSu.frame.size.width + 5, dateY, ScreenWidth * 0.1, 14) text:@"冲鸡" textColor:UIColorFromRGB(0x303030) font:TEXTNUMBERFIVE];
        _chong_animal.backgroundColor = [UIColor clearColor];
        [self addSubview:_chong_animal];

        //吉时
        CGFloat jishiY = _lDateLabel.frame.origin.y + _lDateLabel.frame.size.height +  3;
        self.jiShi = [XBControl createViewWithFrame:CGRectMake(PADDING, jishiY, ScreenWidth * 0.43, 14) backColor:[UIColor clearColor]];
        for (int i = 0; i < 7; i++) {
            if (i == 0) {
                UILabel * label = [XBControl createLabelWithFrame:CGRectMake(0, 0, PADDING * 1.5, 14) text:@"吉时:" textColor:UIColorFromRGB(0xb3b3b3) font:11];
                label.backgroundColor = [UIColor clearColor];
                [_jiShi addSubview:label];
            }else {
                UILabel * label = [XBControl createLabelWithFrame:CGRectMake(i * (PADDING* 0.9) + PADDING , 0, PADDING * 0.6, 14) text:@"一" textColor:UIColorFromRGB(0xd20000) font:TEXTNUMBERFIVE];
                label.backgroundColor = [UIColor clearColor];
                [_jiShi addSubview:label];
            }
        }
        [self addSubview:_jiShi];

        //凶时
        self.xiongShi = [XBControl createViewWithFrame:CGRectMake(_jiShi.frame.origin.x + _jiShi.frame.size.width + PADDING , jishiY, ScreenWidth * 0.43, 14) backColor:[UIColor clearColor]];
        for (int i = 0; i < 7; i++) {
            
            if (i == 0) {
                UILabel * label = [XBControl createLabelWithFrame:CGRectMake(0, 0, PADDING * 1.5, 14) text:@"凶时:" textColor:UIColorFromRGB(0xb3b3b3) font:11];
                label.backgroundColor = [UIColor clearColor];
                
                [_xiongShi addSubview:label];
            }else {
                UILabel * label = [XBControl createLabelWithFrame:CGRectMake(i * (PADDING* 0.9) + PADDING , 0, PADDING * 0.6, 14) text:@"一" textColor:UIColorFromRGB(0x303030) font:TEXTNUMBERFIVE];
                label.backgroundColor = [UIColor clearColor];
                
                [_xiongShi addSubview:label];
            }
        }
        [self addSubview:_xiongShi];
    }
    return self;
}

-(void)calendarDateViewReloadData:(calendarDBModel *)model  year:(int)strYear month:(int)strMonth day:(int)strDay
{
    NSArray * monthArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    self.dateLabel.text = [NSString stringWithFormat:@"%d-%d-%d",strYear,strMonth,strDay];
    self.weekLabel.text = [NSString stringWithFormat:@"周%@",model.weekName];
    NSString * lunarMonth;
    int lunarIndex;
    if (model.lMonth.intValue == 0) {
        lunarIndex = [[[model.lMonth componentsSeparatedByString:@"闰"] objectAtIndex:1] intValue] - 1;
        lunarMonth = [NSString stringWithFormat:@"闰%@",[monthArray objectAtIndex:lunarIndex]];
    }else {
        lunarIndex = [model.lMonth intValue] - 1;
        lunarMonth = [monthArray objectAtIndex:lunarIndex];
    }
    self.lunarLabel.text = [NSString stringWithFormat:@"%@年%@月%@",model.lYearName,lunarMonth,model.lDayName];

   

    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * string = [formatter stringFromDate:[NSDate date]];
    NSString * time = [[string componentsSeparatedByString:@" "] objectAtIndex:1];
    int hour = [[[time componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
    int hourNum = [DateSource getShiChen:hour];
    int dayNum = [DateSource getDayIndex:model.dayZhu];
    NSString * shiChen = [wanNianLiTool getTimeFromArrayIndex:hourNum andIndex:dayNum];
    self.lDateLabel.text = [NSString stringWithFormat:@"%@年 %@月 %@日 %@",model.yearZhu,model.monthZhu,model.dayZhu,shiChen];
    self.xingSu.text = [NSString stringWithFormat:@"%@%@%@",model.wxDay,model.dayErShiBaXingSu,model.dayShierJianXing];
    self.chong_animal.text = [NSString stringWithFormat:@"冲%@",model.chongAnimal];
    
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
    for (int i = 1; i <7; i++) {
        UILabel * jiLabel = self.jiShi.subviews[i];
        jiLabel.text = jiArr[i - 1];
        if ([jiLabel.text isEqualToString:oldHour]) {
            jiLabel.textColor = UIColorFromRGB(0xd20000);
        }else {
            jiLabel.textColor = UIColorFromRGB(0xb3b3b3);
        }
        UILabel * xiongLabel = self.xiongShi.subviews[i];
        xiongLabel.text = xiongArr[i - 1];
        if ([xiongLabel.text isEqualToString:oldHour]) {
            xiongLabel.textColor = UIColorFromRGB(0xd20000);
        }else {
            xiongLabel.textColor = UIColorFromRGB(0xb3b3b3);
        }
    }
}
-(void)changeZangLiFrame:(CGFloat)y
{
    CGRect gregorian = self.Gregorian.frame;
    gregorian.origin.y = y;
    self.Gregorian.frame = gregorian;
    
    CGRect date = self.dateLabel.frame;
    date.origin.y = y;
    self.dateLabel.frame = date;
    
    CGRect week = self.weekLabel.frame;
    week.origin.y = y;
    self.weekLabel.frame = week;
    
    CGRect lunarL = self.lunarLabel.frame;
    lunarL.origin.y = y;
    self.lunarLabel.frame = lunarL;
    
    CGRect lunar = self.lunar.frame;
    lunar.origin.y = y;
    self.lunar.frame = lunar;
    
    CGRect frame = self.lDateLabel.frame;
    frame.origin.y = self.Gregorian.frame.origin.y + self.Gregorian.frame.size.height + PADDING * 0.5;
    self.lDateLabel.frame = frame;
    
    CGRect xingSu = self.xingSu.frame;
    xingSu.origin.y = self.Gregorian.frame.origin.y + self.Gregorian.frame.size.height + PADDING*0.5;
    self.xingSu.frame = xingSu;
    
    CGRect chongAnimal = self.chong_animal.frame;
    chongAnimal.origin.y = self.Gregorian.frame.origin.y + self.Gregorian.frame.size.height + PADDING *0.5;
    self.chong_animal.frame = chongAnimal;
    
}
@end
