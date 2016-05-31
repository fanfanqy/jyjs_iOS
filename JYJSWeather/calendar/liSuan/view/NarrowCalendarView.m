//
//  NarrowCalendarView.m
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/5/24.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "NarrowCalendarView.h"
#import "Datetime.h"
#import "DateSource.h"
#import "ConvertLunarOrSolar.h"
@interface  NarrowCalendarView(){
NSMutableArray * _dayArray;
NSMutableArray * _lunarDayArray;

NSMutableArray * colorArray;
NSMutableArray * lunarColorArray;
UILabel * _dayLabel;


int selectedYear;
int selectedMonth;
int selectedDay;
NSString *fresh1Date;
NSString *fresh2Date;
BOOL selected;//这个决定是否
BOOL isAnimating;
UIImageView *animationView_A;
UIImageView *animationView_B;
NSInteger indexDay;
}
@end
@implementation NarrowCalendarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //存储字体颜色的数组
        colorArray = [[NSMutableArray alloc] init];
        lunarColorArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 7; i++) {
            [colorArray addObject:UIColorFromRGB(0x000000)];
        }

        //得到当前天在日历上的位置,以便初始时变为选中状态
        [self backTodayAction];
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandleSwipe:)];
        //对手势识别器进行属性设定
        [swipeLeft setNumberOfTouchesRequired:1];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeRight setNumberOfTouchesRequired:1];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        //把手势识别器加到view中去
        [self addGestureRecognizer:swipeLeft];
        [self addGestureRecognizer:swipeRight];
        //添加单击按钮
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectOneDay:)];
        [self addGestureRecognizer:tap];
        [tap requireGestureRecognizerToFail:swipeLeft];
        [tap requireGestureRecognizerToFail:swipeRight];
    }
    return self;
}
/**
 *  今天按钮点击事件,回到当前日期
 */
-(void)backTodayAction
{
    //得到当前的 年 月 日
    _strYear = [[Datetime GetYear] intValue];
    _strMonth = [[Datetime GetMonth] intValue];
    _strDay = [[Datetime GetDay] intValue];

    [self reloadDataWithDate:_strDay andMonth:_strMonth andYear:_strYear andIsSelected:YES ];
}

/**
 *  初始构建数据
 *
 *  @param year  <#year description#>
 *  @param month <#month description#>
 *  @param day   <#day description#>
 */
-(void)markDataWithYear:(int)year month:(int)month day:(int)day
{
    _strYear = year;
    _strMonth = month;
    _strDay = day;
    selectedDay = _strDay;
    selectedMonth = _strMonth;
    selectedYear = _strYear;
    [self reloadDataWithDate:_strDay andMonth:_strMonth andYear:_strYear andIsSelected:YES];
}

-(void)drawRect:(CGRect)rect{
      _dayArray = [Datetime GetDayArrayByYear:_strYear andMonth:_strMonth andDay:_strDay];
    NSLog(@"_dayArray:%@",_dayArray);
        _lunarDayArray = (NSMutableArray *)[Datetime GetLunarDayArrayByYear:_strYear andMonth:_strMonth andDay:_strDay];
        [self selectColor];
//    NSLog(@"_lunarDayArray:%@",_lunarDayArray);
//    for (NSString *str in _lunarDayArray) {
//         NSLog(@"_lunarDayArray:%@",str);
//    }
        NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
        [style setAlignment:NSTextAlignmentCenter];
        CGContextRef context = UIGraphicsGetCurrentContext();
        /**
         *  画出日历主体
         */
        CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
        for (int i = 0; i < 7; i++) {
            int targetDate = [_dayArray[i] intValue];
            int targetColumn = i%7;
            int targetX = targetColumn * 2 * CALENDARBTNPADDING+ 0.5 * CALENDARBTNPADDING+0.5 * CALENDARBTNPADDING;
            int targetY = 0.1*CALENDARBTNPADDING;
            CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
#pragma mark 圈圈待修改
            if(selected && _strDay  == [_dayArray[i] intValue]) {
                UIImage * today = [UIImage imageNamed:@"圈 - Assistor.png"];
                [today drawInRect:CGRectMake(targetX -0.4 * CALENDARBTNPADDING, targetY , CALENDARBTNPADDING * 1.9,CALENDARBTNPADDING * 1.9 ) blendMode:kCGBlendModeNormal alpha:1.0];
            }

            if (targetDate != 0) {
                //zhouxuewen /藏历日历字体大小
                UIFont * fontName1;
                UIFont * fontName2;
                UIFont * fontName3;
                UIFont * fontName4;
                fontName1 = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERONE];
                fontName2 = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERFOUR];//14号
                fontName3 = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERFIVE];//8号
                fontName4 = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERLEAST];//12号

                NSString *date = [NSString stringWithFormat:@"%i",targetDate];
                NSString * lunar = [NSString stringWithFormat:@"%@",_lunarDayArray[i]];
                //7月1日做特殊处理，显示  建党节
                if ([[lunar substringToIndex:2] isEqualToString:@"香港"]) {
                    lunar = @"建党节";
                }
                /* 长度大于3的做省略显示处理 */
                if (lunar.length>=5) {
                     lunar = [NSString stringWithFormat:@"%@",[lunar substringToIndex:5]];
                    [lunar drawInRect:CGRectMake(targetX - 0.5 * CALENDARBTNPADDING, targetY+1.1*CALENDARBTNPADDING  , CALENDARBTNPADDING * 2, CALENDARBTNPADDING * 0.5) withAttributes:@{NSFontAttributeName:fontName3,NSForegroundColorAttributeName:lunarColorArray[i],NSParagraphStyleAttributeName:style}];
                }else if (lunar.length>=4){
                    [lunar drawInRect:CGRectMake(targetX - 0.5 * CALENDARBTNPADDING, targetY+1.1*CALENDARBTNPADDING  , CALENDARBTNPADDING * 2, CALENDARBTNPADDING * 0.5) withAttributes:@{NSFontAttributeName:fontName4,NSForegroundColorAttributeName:lunarColorArray[i],NSParagraphStyleAttributeName:style}];
                }
                else{
                    //节日,节气
                    [lunar drawInRect:CGRectMake(targetX - 0.5 * CALENDARBTNPADDING, targetY+CALENDARBTNPADDING  , CALENDARBTNPADDING * 2, CALENDARBTNPADDING * 0.7) withAttributes:@{NSFontAttributeName:fontName2,NSForegroundColorAttributeName:lunarColorArray[i],NSParagraphStyleAttributeName:style}];
                }
                [date drawInRect:CGRectMake(targetX, targetY + 2 , CALENDARBTNPADDING , CALENDARBTNPADDING * 0.8) withAttributes:@{NSFontAttributeName:fontName1,NSForegroundColorAttributeName:colorArray[i],NSParagraphStyleAttributeName:style}];
                UIColor *dataColor = colorArray[i];
                [dataColor set];
                UIColor *lunarColor = lunarColorArray[i];
                [lunarColor set];
            }
        }
}
#pragma mark 左滑动,右滑动
/**
  *  左滑动作事件
  *
  *  @param gestureRecognizer 左滑手势
  */
-(void)leftHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (isAnimating) return;
    isAnimating = YES;
    UIImage *imageCurrentMonth = [self drawCurrentState];

    NSMutableArray *array = [Datetime GetThreeMonthArrayByYear:_strYear andMonth:_strMonth];
    if (([Datetime GetNumberOfDayByYera:_strYear andByMonth:_strMonth]-_strDay)>=7) {
        _strDay = _strDay+7;
    }else{
            int count = 0;
            for (int i=(int)array.count-1; i>=0; i--) {
                if ([array[i] intValue]== _strDay) {
                    count++;
                }
            }
            if (count == 1) {
                for (int i=(int)array.count-1; i>=0; i--) {
                    if ([array[i] intValue]== _strDay) {
                        _strDay = [array[i+7] intValue];
                    }
                }
            }else if (count == 2 || count == 3) {
                int countTemp = 0;
                for (int i=(int)array.count-1; i>=0; i--) {
                    if ([array[i] intValue]== _strDay) {
                        if (countTemp == 1) {
                             _strDay = [array[i+7] intValue];
                            break;
                        }
                        countTemp++;
                    }
                }
            }

            if (_strMonth==12) {
                _strYear++;
                _strMonth=1;
            }else{
                _strMonth++;
            }
    }

    BOOL isTemp = nil;

    isTemp = ( (_strDay==selectedDay)&& (_strMonth==selectedMonth) &&(_strYear == selectedYear))?YES:NO;
    //这里这句话,是为了实现整月左右滑动不进行选中,此时weekview 用在这里还是不行的,还想实现原来的效果,需要改变下顺序
    if (isTemp) {
        _strDay = selectedDay;
    }
    [self reloadDataWithDate:_strDay  andMonth:_strMonth andYear:_strYear andIsSelected:isTemp];
    NSLog(@"左边_strYear:%d,_strMonth:%d,_strDay:%d",_strYear,_strMonth,_strDay);

    UIImage * imagePreviousMonth = [self drawCurrentState];
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0,0 * CALENDARBTNPADDING , self.frame.size.width , self.frame.size.height )];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];

    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    animationView_A.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底图（上） - Assistor.png"]];
    animationView_B.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底图（上） - Assistor.png"]];

    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];

    animationView_A.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    animationView_B.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.35f
                     animations:^{
                         CGRect frameA = animationView_A.frame;
                         frameA.origin.x -= self.frame.size.width;
                         animationView_A.frame = frameA;

                         CGRect frameB = animationView_B.frame;
                         frameB.origin.x -= self.frame.size.width;
                         animationView_B.frame = frameB;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
}
/**
 *  右滑动作事件
 *
 *  @param gestureRecognizer 右滑手势
 */
- (void)rightHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (isAnimating) return;
    isAnimating = YES;
    UIImage *imageCurrentMonth = [self drawCurrentState];

    NSMutableArray *array = [Datetime GetThreeMonthArrayByYear:_strYear andMonth:_strMonth];
    if (_strDay-7>0) {
        _strDay = _strDay-7;
    }else{
        int count = 0;
        for (int i=0; i<array.count; i++) {
            if ([array[i] intValue]== _strDay) {
                count++;
            }
        }
        if (count == 1) {
            for (int i=(int)array.count-1; i>=0; i--) {
                if ([array[i] intValue]== _strDay) {
                    _strDay = [array[i-7] intValue];
                }
            }
        }else if (count == 2 || count == 3) {
            int countTemp = 0;
            for (int i=(int)array.count-1; i>=0; i--) {
                if ([array[i] intValue]== _strDay) {
                    if (countTemp == 1) {
                        _strDay = [array[i-7] intValue];
                        break;
                    }
                     countTemp++;
                }
            }
        }

        if (_strMonth==1) {
            _strYear--;
            _strMonth=12;
        }else{
            _strMonth--;
        }
    }

    BOOL isTemp = nil;
    isTemp = ( (_strDay==selectedDay)&& (_strMonth==selectedMonth) &&(_strYear == selectedYear))?YES:NO;
    if (isTemp) {
        _strDay = selectedDay;
    }
    [self reloadDataWithDate:_strDay andMonth:_strMonth andYear:_strYear andIsSelected:isTemp];
     NSLog(@"右边:_strYear:%d,_strMonth:%d,_strDay:%d",_strYear,_strMonth,_strDay);

    UIImage * imagePreviousMonth = [self drawCurrentState];
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];

    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    animationView_A.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底图（上） - Assistor.png"]];
    animationView_B.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底图（上） - Assistor.png"]];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];

    animationView_A.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height );
    animationView_B.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.35f
                     animations:^{
                         CGRect frameA = animationView_A.frame;
                         frameA.origin.x += self.frame.size.width;
                         animationView_A.frame = frameA;

                         CGRect frameB = animationView_B.frame;
                         frameB.origin.x += self.frame.size.width;
                         animationView_B.frame = frameB;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];

}
#pragma mark 待修改
-(UIImage *)drawCurrentState {
    CGSize s = CGSizeMake(self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(s, NO, self.layer.contentsScale);
    CGContextRef c = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(c, 0, -0.1 * CALENDARBTNPADDING);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
/**
 *  点击日历按钮事件
 *
 *  @param tap 单击手势
 */
-(void)selectOneDay:(UITapGestureRecognizer *)tap{
    CGPoint touchPoint = [tap locationInView:self];
    NSArray *array = [Datetime GetDayDicByYear:_strYear andMonth:_strMonth andDay:_strDay andCountsDay:7];
    
      //单击一天,计算出point所处日期的位置
    if ((touchPoint.y > 0.1*CALENDARBTNPADDING ) && (touchPoint.y < 1.9 * CALENDARBTNPADDING) && (touchPoint.x > + 0.5 * CALENDARBTNPADDING) && (touchPoint.x <  ScreenWidth - CALENDARBTNPADDING)){
        float xLocation = touchPoint.x;
        int column = floorf(xLocation/( 2 * CALENDARBTNPADDING));

        for (int j=0; j<7; j++) {
            if (j==column) {
                int year = [array[0][j] intValue];
                int month = [array[1][j] intValue];
                int day = [array[2][j] intValue];
                _strDay = day;
                _strMonth = month;
                _strYear = year;
                break;
            }
        }
        selectedDay = _strDay;
        selectedMonth = _strMonth;
        selectedYear = _strYear;

        [self markDataWithYear:_strYear month:_strMonth day:_strDay];
        NSLog(@"selectedDate:%d,%d,%d",_strYear,_strMonth,_strDay);
        return;
    }
}

/**
 *  存储日历字体颜色的数组
 *  节日/气 替换农历
 *  @param num blockNr :选中日期在日历中的位置
 */

-(void)selectColor
{
        for (int i = 0; i <  7; i++) {
            calendarDBModel * model;
            colorArray[i] = UIColorFromRGB(0x000000); //日历在未被选中的数字字体颜色
            lunarColorArray[i] = UIColorFromRGB(0x000000); // 日历在未被选中的数字下面的字体颜色
            model = _narrowCalendarArray[i];//存放的是model
//            NSLog(@"gongLiJieRi:%@",model.gongLiJieRi);
//            NSLog(@"nongLIjieRi:%@",model.nongLIjieRi);
//            NSLog(@"jieQi:%@",model.jieQi);
            /* 显示优先权：节气 > 阴历 > 阳历 */
            if ([model.lDayName isEqualToString:@"初一"]) {
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
                _lunarDayArray[i] = [NSString stringWithFormat:@"%@月",lunarMonth];
                lunarColorArray[i] = UIColorFromRGB(0xd20000);
            }
            if (model.gongLiJieRi.length > 0) {
                _lunarDayArray[i] = model.gongLiJieRi;
                lunarColorArray[i] = UIColorFromRGB(0xd20000);
            }
            if (model.nongLIjieRi.length > 0 ) {
                _lunarDayArray[i] = model.nongLIjieRi;
                lunarColorArray[i] = UIColorFromRGB(0xd20000);
            }
            if (model.jieQi.length != 0) {
                _lunarDayArray[i] = model.jieQi;
                lunarColorArray[i] = UIColorFromRGB(0xd20000);
            }
        }
}

-(void)reloadDataWithDate:(int)date andMonth:(int)month andYear:(int)year andIsSelected:(BOOL)isSelected
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(reloadNarrowCalendarDataWithYear:month:day:andIsSelected:)]) {
                [self.delegate reloadNarrowCalendarDataWithYear:_strYear month:_strMonth day:_strDay andIsSelected:isSelected];
            }
//            NSLog(@"isSelected:%d",isSelected);
            //直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0.
            if (isSelected) {
                selected = YES;
            }
            else{
                selected = NO;
            }
            [self setNeedsDisplay];

        });
    });
}



@end
