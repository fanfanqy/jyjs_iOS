//
//  liSuanCalendarView.m
//  
//
//  Created by han on 15/3/6.
//
//

#import "liSuanCalendarView.h"
#import "Datetime.h"
#import "DateSource.h"
#import "ConvertLunarOrSolar.h"
#define TOPBUTTONHEIGHT 20
@interface  liSuanCalendarView(){
    int _strYear;
    int _strMonth;
    int _strDay;
    NSMutableArray * _dayArray;
    NSMutableArray * _lunarDayArray;
    NSMutableArray * _selectedDayArray;
    int blockNr;
    NSMutableArray * colorArray;
    NSMutableArray * lunarColorArray;
    UILabel * _dayLabel;

    BOOL selected;//这个决定是否
    BOOL isAnimating;
    UIImageView *animationView_A;
    UIImageView *animationView_B;
    /**
     * 日历图片边上的那个Label的数据
     */
    int selectedYear;
    int selectedMonth;
    int selectedDay;
    
    NSInteger indexDay;
}
@end
@implementation liSuanCalendarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];
//        UIImage * todayImage = [UIImage imageNamed:@"LiSuantoday.png"];
//
//        UIButton *todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [todayBtn setImage:[UIImage imageNamed:@"today"] forState:UIControlStateHighlighted];
//        [todayBtn setImage:[UIImage imageNamed:@"todayHighit"] forState:0];
//        [todayBtn addTarget:self action:@selector(backTodayAction)
//       forControlEvents:UIControlEventTouchUpInside];
//        todayBtn.frame = CGRectMake(ScreenWidth * 0.5 - 35, 5, todayImage.size.width * 0.5, todayImage.size.height * 0.5);
//        [self addSubview:todayBtn];
//        
//        //距今天多少天的label
//        CGFloat width = ScreenWidth * 0.4;
//        _dayLabel = [XBControl createLabelWithFrame:CGRectMake(todayBtn.frame.origin.x - PADDING - width, 12.5, width, 14) text:@"今天" textColor:UIColorFromRGB(0x303030) font:TEXTNUMBERFOUR];
//        _dayLabel.backgroundColor = [UIColor clearColor];
//        
//        _dayLabel.font = [UIFont boldSystemFontOfSize:TEXTNUMBERFOUR];
//        
//        _dayLabel.textAlignment = NSTextAlignmentRight;
//        
//        [self addSubview:_dayLabel];
//        
//        //日期按钮
//        _dateBtn = [XBControl createBtnWithFrame:CGRectMake(todayBtn.frame.origin.x + todayBtn.frame.size.width + PADDING *0.5, 5, ScreenWidth * 0.4, 27) title:nil image:nil target:self action:@selector(dateBtnClick)];
//        
//        _dateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:TEXTNUMBERFOUR];
//
//        [_dateBtn setTitleColor:UIColorFromRGB(0x303030) forState:UIControlStateNormal];
//        
//        [_dateBtn setImage:[UIImage imageNamed:@"date"] forState:UIControlStateNormal];
//        [_dateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -_dateBtn.frame.size.width*0.1, 0 , 0)];
//        
//        [self addSubview:_dateBtn];
        //存储字体颜色的数组
        colorArray = [[NSMutableArray alloc] init];
        lunarColorArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self numRows] * 7; i++) {
            [colorArray addObject:UIColorFromRGB(0x303030)];
        }
//        //得到当前的 年 月 日
//        _strYear = [[Datetime GetYear] intValue];
//        _strMonth = [[Datetime GetMonth] intValue];
//        _strDay = [[Datetime GetDay] intValue];
//        /**
//         *  得到待办和生日在数据库中的存储
//         */
//        [self relodDaiBanAndBirthdayFromDB];
        
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
    blockNr = [Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth];
    [self reloadDataWithDate:_strDay andMonth:_strMonth andYear:_strYear andIsSelected:YES ];
    
}
-(void)dateBtnClick
{
    if ([self.delegate respondsToSelector:@selector(dateBtnClick)]) {
        [self.delegate dateBtnClick];
    }
}
/**
 *  计算某个月在日历中占几行
 *
 *  @return 返回行数
 */
-(int)numRows {
    int lastBlock = [Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth]+([Datetime GetNumberOfDayByYera:_strYear andByMonth:_strMonth]);
    int chu = lastBlock / 7;
    int yu = lastBlock % 7;
    if (yu == 0) {
        return chu;
    }else{
        return chu + 1;
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    [[UIColor blueColor] setFill];
//    UIRectFill(rect);
    
    _dayArray = (NSMutableArray *)[Datetime GetDayArrayByYear:_strYear andMonth:_strMonth];
    _lunarDayArray = (NSMutableArray *)[Datetime GetLunarDayArrayByYear:_strYear andMonth:_strMonth];

    [self selectColor:blockNr + _strDay];
    int row = [self numRows];
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    CGContextRef context = UIGraphicsGetCurrentContext();
    /**
     星期列表label
     */
    NSMutableArray* array = [[NSMutableArray alloc]initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    for (int i = 0; i < 7; i++) {
        
        CGContextSetFillColorWithColor(context,
                                       [UIColor blackColor].CGColor);
        for (int i =0; i<[array count]; i++) {
            NSString *weekdayValue = (NSString *)[array objectAtIndex:i];
            UIColor *weekdayValueColor = UIColorFromRGB(0xb3b3b3);// 星期颜色
            [weekdayValueColor set];
            [weekdayValue drawInRect:CGRectMake(i*CALENDARBTNPADDING * 2 + 0.5 * CALENDARBTNPADDING, CALENDARBTNPADDING , CALENDARBTNPADDING, CALENDARBTNPADDING) withFont:[UIFont systemFontOfSize:TEXTNUMBERLEAST] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        }
    }
    /**
     *  画出日历主体
     */
    CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
    for (int i = 0; i < row * 7; i++) {
        int targetDate = [_dayArray[i] intValue];
        int targetColumn = i%7;
        int targetRow = i/7;
        int targetX = targetColumn * 2 * CALENDARBTNPADDING+ 0.5 * CALENDARBTNPADDING;
        int targetY = 2 *CALENDARBTNPADDING+ targetRow *CALENDARBTNPADDING*2 / row * 5 + TOPBUTTONHEIGHT;
       CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
        
        if(_strDay + blockNr == i + 1 && selected) {
                UIImage * today = [UIImage imageNamed:@"圈 - Assistor.png"];
                [today drawInRect:CGRectMake(targetX -0.4 * CALENDARBTNPADDING, targetY , CALENDARBTNPADDING * 1.8,CALENDARBTNPADDING * 1.8 ) blendMode:kCGBlendModeNormal alpha:1.0];
        }

        if (targetDate != 0) {
            if (([_dayArray[i] intValue] == [[Datetime GetDay] intValue]) &&(_strMonth == [[Datetime GetMonth] intValue] && (_strYear == [[Datetime GetYear] intValue]))) {
                
                //灰色的图片
                UIImage * image = [UIImage imageNamed:@"todayBackground"];
                [image drawInRect:CGRectMake(targetX -0.4 * CALENDARBTNPADDING, targetY, CALENDARBTNPADDING * 1.8,CALENDARBTNPADDING * 1.8)];
            }
            
            //红色的图片
            if (([_dayArray[i] intValue] == [[Datetime GetDay] intValue]) &&(_strMonth == [[Datetime GetMonth] intValue] && (_strYear == [[Datetime GetYear] intValue])) && _strDay + blockNr == i + 1){
                
                UIImage * image = [UIImage imageNamed:@"chonghe"];
                [image drawInRect:CGRectMake(targetX -0.4 * CALENDARBTNPADDING, targetY, CALENDARBTNPADDING * 1.8,CALENDARBTNPADDING * 1.8)];
            }
            
            
            //zhouxuewen /藏历日历字体大小
            UIFont * fontName;
            if (row == 4) {
                fontName = [UIFont systemFontOfSize:TEXTNUMBERLEAST];
            }else if (row == 5){
                fontName = [UIFont systemFontOfSize:TEXTNUMBERLEAST];
            }else{
                fontName = [UIFont systemFontOfSize:TEXTNUMBERLEAST];
            }
            
            NSString *date = [NSString stringWithFormat:@"%i",targetDate];
            NSString * lunar = [NSString stringWithFormat:@"%@",_lunarDayArray[i]];
            //7月1日做特殊处理，显示  建党节
            if ([[lunar substringToIndex:2] isEqualToString:@"香港"]) {
                lunar = @"建党节";
            }
            /* 长度大于3的做省略显示处理 */
            if (lunar.length>=4) {
                lunar = [NSString stringWithFormat:@"%@...",[lunar substringToIndex:2]];
            }
//            NSLog(@"%@  %@",date,lunar);
            
            [date drawInRect:CGRectMake(targetX, targetY + 2 , CALENDARBTNPADDING , CALENDARBTNPADDING * 0.8) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TEXTNUMBERTHREE],NSForegroundColorAttributeName:colorArray[i],NSParagraphStyleAttributeName:style}];
            
            if (([_dayArray[i] intValue] == [[Datetime GetDay] intValue]) &&(_strMonth == [[Datetime GetMonth] intValue] && (_strYear == [[Datetime GetYear] intValue]))) {
                        [date drawInRect:CGRectMake(targetX, targetY + 2 , CALENDARBTNPADDING , CALENDARBTNPADDING * 0.8) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TEXTNUMBERTHREE],NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:style}];
            }

            UIColor *dataColor = colorArray[i];
            [dataColor set];
        
            [lunar drawInRect:CGRectMake(targetX - 0.5 * CALENDARBTNPADDING, targetY+CALENDARBTNPADDING  , CALENDARBTNPADDING * 2, CALENDARBTNPADDING * 0.7) withAttributes:@{NSFontAttributeName:fontName,NSForegroundColorAttributeName:lunarColorArray[i],NSParagraphStyleAttributeName:style}];
            
            if (([_dayArray[i] intValue] == [[Datetime GetDay] intValue]) &&(_strMonth == [[Datetime GetMonth] intValue] && (_strYear == [[Datetime GetYear] intValue]))){
                
                [lunar drawInRect:CGRectMake(targetX - 0.5 * CALENDARBTNPADDING, targetY+CALENDARBTNPADDING  , CALENDARBTNPADDING * 2, CALENDARBTNPADDING * 0.7) withAttributes:@{NSFontAttributeName:fontName,NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:style}];// 被选中的农历颜色
            }
            
            UIColor *lunarColor = lunarColorArray[i];
            [lunarColor set];

            }
        }
}


/**
 *  左滑动作事件
 *
 *  @param gestureRecognizer 左滑手势
 */
-(void)leftHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (isAnimating) return;
    isAnimating = YES;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    _strMonth = _strMonth+1;
    if(_strMonth == 13){
        _strYear++;
        _strMonth = 1;
    }
    blockNr = [Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth];
    BOOL isTemp = nil;

    isTemp = ((_strMonth==selectedMonth) &&(_strYear == selectedYear))?YES:NO;
    if (isTemp) {
        _strDay = selectedDay;
    }
    [self reloadDataWithDate:_strDay  andMonth:_strMonth andYear:_strYear andIsSelected:isTemp];
    UIImage * imagePreviousMonth = [self drawCurrentState];
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 2 * CALENDARBTNPADDING + TOPBUTTONHEIGHT - 2, self.frame.size.width , self.frame.size.height - 2 * CALENDARBTNPADDING - TOPBUTTONHEIGHT + 2)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    
    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_A.backgroundColor = UIColorFromRGB(0xf6f6f6);
    animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    animationView_B.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    animationView_A.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 2 * CALENDARBTNPADDING - TOPBUTTONHEIGHT + 2);
    animationView_B.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - 2 * CALENDARBTNPADDING - TOPBUTTONHEIGHT + 2);
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

    _strMonth = _strMonth-1;
    if(_strMonth == 0){
        _strYear--;_strMonth = 12;
    }
    blockNr = [Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth];
    BOOL isTemp = nil;
    isTemp = ((_strMonth==selectedMonth) && (_strYear==selectedYear))?YES:NO;
    if (isTemp) {
        _strDay = selectedDay;
    }
    [self reloadDataWithDate:_strDay andMonth:_strMonth andYear:_strYear andIsSelected:isTemp];
    
    UIImage * imagePreviousMonth = [self drawCurrentState];
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 2 * CALENDARBTNPADDING + TOPBUTTONHEIGHT - 2, self.frame.size.width , self.frame.size.height - 2 * CALENDARBTNPADDING - TOPBUTTONHEIGHT + 2)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    
    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_A.backgroundColor = UIColorFromRGB(0xf6f6f6);
    animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    animationView_B.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    animationView_A.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 2 * CALENDARBTNPADDING - TOPBUTTONHEIGHT + 2);
    animationView_B.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - 2 * CALENDARBTNPADDING - TOPBUTTONHEIGHT + 2);
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
-(UIImage *)drawCurrentState {
    CGSize s = CGSizeMake(self.frame.size.width, self.frame.size.height - 2 * CALENDARBTNPADDING - TOPBUTTONHEIGHT + 2);
    UIGraphicsBeginImageContextWithOptions(s, NO, self.layer.contentsScale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -2 * CALENDARBTNPADDING - TOPBUTTONHEIGHT + 2);    // <-- shift everything up by 40px when drawing.
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
    int numRow = [self numRows];
    int day = [Datetime GetNumberOfDayByYera:_strYear andByMonth:_strMonth];
    //单击一天,计算出point所处日期的位置
    if ((touchPoint.y > CALENDARBTNPADDING * 2 + TOPBUTTONHEIGHT) && (touchPoint.y < 12 * CALENDARBTNPADDING+ TOPBUTTONHEIGHT) && (touchPoint.x > + 0.5 * CALENDARBTNPADDING) && (touchPoint.x <  ScreenWidth - CALENDARBTNPADDING)){
        
        float xLocation = touchPoint.x;
        float yLocation = touchPoint.y-CALENDARBTNPADDING * 2- TOPBUTTONHEIGHT;
        
        int column = floorf(xLocation/( 2 * CALENDARBTNPADDING));
        int row = floorf(yLocation/(CALENDARBTNPADDING*2 / numRow * 5));
        
        int block = (column+1)+row*7;
        int firstWeekDay = [Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth]; //-1 because weekdays begin at 1, not 0
        int date = block-firstWeekDay;
        if (date > 0 && date <= day) {
            _strDay = date;
            selectedDay = _strDay;
            selectedMonth = _strMonth;
            selectedYear  = _strYear;
           [self reloadDataWithDate:_strDay andMonth:_strMonth andYear:_strYear  andIsSelected:YES];
        }
        return;
    }
}
/**
 *  存储日历字体颜色的数组
 *  节日/气 替换农历
 *  @param num blockNr :选中日期在日历中的位置
 */
-(void)selectColor:(int)num
{
    for (int i = 0; i < [self numRows] * 7; i++) {
        colorArray[i] = [UIColor blackColor]; //日历在未被选中的数字字体颜色
        lunarColorArray[i] = [UIColor blackColor]; // 日历在未被选中的数字下面的字体颜色
        int targetDate = [_dayArray[i] intValue];
        if (targetDate != 0) {
#pragma mark 崩溃地方
            calendarDBModel * model = _calendarArray[targetDate -1];

            /* 显示优先权：节气 > 阴历 > 阳历 */
//            if (model.gongLiJieRi.length > 0 && model.gongLiJieRi.length < 4) {
            if (model.gongLiJieRi.length > 0) {
                _lunarDayArray[i] = model.gongLiJieRi;
                //zhouxuewen /藏历今天日期下面公历节日label的颜色//未选中状态
                lunarColorArray[i] = UIColorFromRGB(0xd20000);
            }
//            if (model.nongLIjieRi.length > 0 && model.nongLIjieRi.length < 4) {
            if (model.nongLIjieRi.length > 0 ) {
                _lunarDayArray[i] = model.nongLIjieRi;
                lunarColorArray[i] = UIColorFromRGB(0xd20000);
            }
            
            if (model.jieQi.length != 0) {
                _lunarDayArray[i] = model.jieQi;
                lunarColorArray[i] = UIColorFromRGB(0xd20000);
            }
            
            if (i + 1 == num && selected) {
                colorArray[i] = UIColorFromRGB(0xd20000);
                lunarColorArray[i] = UIColorFromRGB(0xd20000);
                
            }
            
            //zhouxuewen   藏历字体颜色
            if (([_dayArray[i] intValue] == [[Datetime GetDay] intValue]) &&(_strMonth == [[Datetime GetMonth] intValue] && (_strYear == [[Datetime GetYear] intValue]))) {
                lunarColorArray[i] = [UIColor whiteColor];
            }
        }
    }
}

-(void)markDataWithYear:(int)year month:(int)month day:(int)day
{
    _strYear = year;
    _strMonth = month;
    _strDay = day;
    blockNr = [Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth];
    selectedYear = _strYear;
    selectedMonth = _strMonth;
    selectedDay = _strDay;
    [self reloadDataWithDate:_strDay andMonth:_strMonth andYear:_strYear andIsSelected:YES];
}

-(void)reloadDataWithDate:(int)date andMonth:(int)month andYear:(int)year andIsSelected:(BOOL)isSelected
{
    if (isSelected) {
        /**
         *  更新日历上方距今天多少天  跟当前选择日期的数据
         */
        NSString * newDate;
        NSString * newDate1;
        if (selectedDay < 10) {

            newDate = [NSString stringWithFormat:@"%d-%d-0%d",year,month,date];
            [_dateBtn setTitle:newDate forState:UIControlStateNormal];
             NSLog(@"%@",newDate);
        }else{
            newDate = [NSString stringWithFormat:@"%d-%d-%d",year,month,date];
            [_dateBtn setTitle:newDate forState:UIControlStateNormal];
             NSLog(@"%@",newDate);
        }
        if (date < 10) {

            newDate1 = [NSString stringWithFormat:@"%d-%d-0%d",year,month,date];
            [_dateBtn setTitle:newDate forState:UIControlStateNormal];
            NSLog(@"%@",newDate);
        }else{
            newDate1 = [NSString stringWithFormat:@"%d-%d-%d",year,month,date];
            [_dateBtn setTitle:newDate forState:UIControlStateNormal];
            NSLog(@"%@",newDate);
        }
        newDate = [DateSource getUTCFormateDate:newDate1];
        _dayLabel.text = newDate;
        //无用,可删
        if ([self.delegate respondsToSelector:@selector(updateBtnTitleWithArray:dateArr:year:month:day:)]){
            [self.delegate updateBtnTitleWithArray:_birArr dateArr:_dateArr year:year month:month day:date];
        }
    }
    /**
     *  从数据库读取新数据 更新整个界面数据
     *
     *  @param reloadDataWithYear:month:day: 根据选中日期更新数据
     */
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(reloadDataWithYear:month:day:andIsSelected:)]) {
                [self.delegate reloadDataWithYear:year month:month day:date andIsSelected:isSelected];
            }
            NSLog(@"isSelected:%d",isSelected);
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
