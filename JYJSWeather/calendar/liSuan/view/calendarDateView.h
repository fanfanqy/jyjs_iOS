//
//  calendarDateView.h
//  FaLv
//
//  Created by han on 15/3/4.
//  Copyright (c) 2015年 xjkjmac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calendarDBModel.h"

//日期
@interface calendarDateView : UIButton

@property (nonatomic,strong)UIImageView * paddingOne;

@property (nonatomic,strong)UILabel * Gregorian;//公历
@property (nonatomic,strong)UILabel * dateLabel;//公历日期
@property (nonatomic,strong)UILabel * weekLabel;//星期label
@property (nonatomic,strong)UILabel * lunar;//农历
@property (nonatomic,strong)UILabel * lunarLabel;//农历label
@property (nonatomic,strong)UILabel * lDateLabel;//黄历日期
@property (nonatomic,strong)UILabel * xingSu;//星宿
@property (nonatomic,strong)UILabel * chong_animal;//冲哪个动物
@property (nonatomic,strong)UIView * jiShi;//吉时
@property (nonatomic,strong)UIView * xiongShi;//凶时


-(void)calendarDateViewReloadData:(calendarDBModel *)model  year:(int)strYear month:(int)strMonth day:(int)strDay;

@end
