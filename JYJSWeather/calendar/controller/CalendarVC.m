//
//  CalendarVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "CalendarVC.h"
#import "Datetime.h"
#import "WanNianLiDate.h"
#import "calendarDBModel.h"
#import "PickerView.h"
#import "wanNianLiTool.h"

#import "liSuanCalendarView.h"
#import "UIImage+ChangeSize.h"
//#import "CalendarDateView.h"
#import "AlmanacView.h"
#define BUDDHAIMAGEWIDTH 350
#define BUDDHAIMAGEHEIGHT 460

@interface CalendarVC ()<lisuanCalendarViewDelegate,pickerViewDelegate>
{
    FMDatabase * _db;
    PickerView * _datepicker;//时间选择器作用:快速定位到某一个日期
    int isPush ;
}
@property (nonatomic,strong)liSuanCalendarView * calendarView;//日历
@property (nonatomic,strong)AlmanacView *view;//黄历

//@property (nonatomic,strong)calendarDateView * dateView;
@property (nonatomic,strong)NSMutableArray * calendarArray;
@property (nonatomic,strong)NSMutableArray * zangLiArray;
@property (nonatomic,strong)UIScrollView * scrView;
@property (nonatomic,assign) int strMonth;
@property (nonatomic,assign) int strYear;
@property (nonatomic,assign) int strDay;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)UIButton * today;
@property (nonatomic,strong)UIButton *updateBtn;

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    
    self.calendarArray = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
//            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay ]; // 最下方时辰(删)
            _db = [WanNianLiDate getDataBase];
            [self createScrollView];
//            [self createDateView]; // 最上方 藏历 公历
            [self createCalendarView];
        });
    });
}
-(void)createScrollView
{
    self.scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scrView.showsHorizontalScrollIndicator = NO;
    _scrView.showsVerticalScrollIndicator = NO;
    _scrView.bounces = NO;
    _scrView.delegate = self;
    _scrView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    [self.view addSubview:_scrView];
    self.scrView.backgroundColor = [UIColor blueColor];
    
}
- (void)setNavigationBar
{
//    UIButton *leftBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [leftBarButton setImage:[UIImage imageNamed:@"箭头 - Assistor.png"] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBarButton];
//    leftBarButton.imageView.frame = CGRectMake(0, 0, leftBarButton.frame.size.width/2, leftBarButton.frame.size.height/2);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏 - Assistor.png"] forBarMetrics:UIBarMetricsDefault];
    UIButton *titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.navigationItem.titleView = titleButton;
    [titleButton addTarget:self action:@selector(dateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 10, 18);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"箭头 - Assistor.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackLastController) forControlEvents:UIControlEventTouchUpInside];

    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    todayButton.frame = CGRectMake(0, 0, 23, 23);
    [todayButton setBackgroundImage:[UIImage imageNamed:@"今 - Assistor.png"] forState:UIControlStateNormal];
    [todayButton addTarget:self action:@selector(backTodayAction) forControlEvents:UIControlEventTouchUpInside];
    todayButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIBarButtonItem *todayButtonItem = [[UIBarButtonItem alloc]initWithCustomView:todayButton];

    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backButtonItem,todayButtonItem, nil];
  
    
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
    // 计算星期几
//    blockNr = [Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth];
//    [self.calendarView reloadDataWithDate:_strDay andMonth:_strMonth andYear:_strYear andIsSelected:YES ];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay];
        });
    });
}
#pragma mark 返回上一级试图
- (void)goBackLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 日历View
-(void)createCalendarView
{
    _strYear = [[Datetime GetYear] intValue];
    _strMonth = [[Datetime GetMonth] intValue];
    _strDay = [[Datetime GetDay] intValue];
   UIImage * nomal = [UIImage imageNamed:@"底图（上） - Assistor.png"];//  btnBackGround
//    CGFloat w = nomal.size.width * 0.5;
//    CGFloat h = nomal.size.height * 0.5;
//    
//    nomal = [nomal scaleToSize:nomal size:CGSizeMake(ScreenWidth, 14.5 * CALENDARBTNPADDING)];// 背景图片
//    UIImage *image = [nomal resizableImageWithCapInsets:UIEdgeInsetsMake(h,w,h,w) resizingMode:UIImageResizingModeStretch];
    _calendarView = [[liSuanCalendarView alloc] initWithFrame:CGRectMake(CALENDARBTNPADDING * 0.5,CALENDARBTNPADDING * 0.3, ScreenWidth-CALENDARBTNPADDING, 13 * CALENDARBTNPADDING + 3)];
//    _calendarView.backgroundColor = UIColorFromRGB(0xfafafa);// 背景颜色
    _calendarView.opaque = NO;
    _calendarView.delegate = self;
    /**
     创建一个视图作为背景
     */
    _today = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth+4)];
    [_today setBackgroundImage:nomal forState:UIControlStateNormal];
    _today.adjustsImageWhenHighlighted = NO;
    [_today addSubview:_calendarView];
    [_scrView addSubview:_today];




//    [self createYiJiView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay];
        });
    });
}

#pragma mark - 黄历View
-(void)createAlmanacView{

}

#pragma mark - 刷新数据
-(void)reloadDataWithYear:(int)newYear month:(int)newMonth day:(int)newDay andIsSelected:(BOOL)isSelected
{
    self.strDay = newDay;
    self.strMonth = newMonth;
    self.strYear = newYear;
    [self readDataFromDb];
//    calendarDBModel * model  = _calendarArray[self.strDay - 1];
    _calendarView.calendarArray = _calendarArray;
    
    
    /* 刷新titleButton*/
    UIButton *titlebutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 165, 21)];
    titlebutton.titleLabel.font = [UIFont fontWithName:@"Kaiti" size:20];
    [titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", self.strYear,self.strMonth] forState:UIControlStateNormal];
    [titlebutton setBackgroundImage:[UIImage imageNamed:@"下拉 箭头 - Assistor.png"] forState:UIControlStateNormal];
    titlebutton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 11);
    titlebutton.imageEdgeInsets = UIEdgeInsetsMake(0, -11, 0, 0);
    self.navigationItem.titleView = titlebutton;
    /**
     *  刷新dateView的数据
     */
//    [_dateView calendarDateViewReloadData:model  year:_strYear month:_strMonth day:_strDay];
//    
//    if (isSelected) {
//        
//        int lunarIndex;
//        if (model.lMonth.intValue == 0) {
//            lunarIndex = [[[model.lMonth componentsSeparatedByString:@"闰"] objectAtIndex:1] intValue] - 1;
//        }else {
//            lunarIndex = [model.lMonth intValue] - 1;
//        }
//        NSMutableArray * strArr = [[NSMutableArray alloc] init];
//        strArr = (NSMutableArray *)[wanNianLiTool getShiChenJiXiong:model.dayZhu];//根据日柱得到吉凶的数组
//        _btnView.dataArray = strArr;
//        [_btnView.timeTableView reloadData];
//        /**
//         *  @param gdb 宜
//         */
//        FMResultSet * gdb = [_db executeQuery:[NSString stringWithFormat:@"select * from gdb where gid=%@",model.gd]];
//        NSMutableString * muYiStr = [[NSMutableString alloc] init];
//        while ([gdb next]) {
//            NSString * yi = [gdb stringForColumn:@"val"];
//            NSArray * arr = [yi componentsSeparatedByString:@","];
//            for (NSString * str in arr) {
//                [muYiStr appendFormat:@"%@ ",str];
//            }
//            if (muYiStr.length > 22) {
//                NSRange range = {0,23};
//                muYiStr = (NSMutableString *)[muYiStr substringWithRange:range];
//            }
//            _yiJiView.YiLabel.text = muYiStr;
//        }
//        /**
//         *  忌
//         */
//        FMResultSet * bdb = [_db executeQuery:[NSString stringWithFormat:@"select * from bdb where bid=%@",model.bd]];
//        
//        NSMutableString * muJiStr = [[NSMutableString alloc] init];
//        while ([bdb next]) {
//            NSString * ji = [bdb stringForColumn:@"val"];
//            NSArray * arr = [ji componentsSeparatedByString:@","];
//            for (NSString * str in arr) {
//                [muJiStr appendFormat:@"%@ ",str];
//            }
//            if (muJiStr.length > 22) {
//                NSRange range = {0,23};
//                muJiStr = [muJiStr substringWithRange:range];
//            }
////            _yiJiView.JiLabel.text = muJiStr;
//        }
        /**
         *  刷新宜忌上边的节日和节气数据
         */
//        [_yiJiView reloadDataOfYiJiView:model];
//        [self reloadFrame];
//    }
}
#pragma mark - 从数据库读取数据
-(void)readDataFromDb
{
    NSString * starDate;
    NSString * endDate;
    [_calendarArray removeAllObjects];
    int day = [Datetime GetNumberOfDayByYera:_strYear andByMonth:_strMonth];//天数
    //eg:现实数据是2016-4-13,数据库中日期键会是2016-04-13
    if (_strMonth < 10) {
        starDate = [NSString stringWithFormat:@"%d0%d0%d",_strYear,_strMonth,1];
        endDate = [NSString stringWithFormat:@"%d0%d%d",_strYear,_strMonth,day];
    }else{
        starDate = [NSString stringWithFormat:@"%d%d0%d",_strYear,_strMonth,1];
        endDate = [NSString stringWithFormat:@"%d%d%d",_strYear,_strMonth,day];
    }
    
    /**
     *  数据库 calendar 中查看每个键的信息
     */
    FMResultSet * setDb = [_db executeQuery:[NSString stringWithFormat:@"select * from calendar where id between '%@' and '%@'",starDate,endDate]];
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
        [_calendarArray addObject:model];
    }
}




#pragma mark - 时间标题点击事件
-(void)dateBtnClick{
    [self AddTimePickerToCalendarWatch];
    [self initDatePicker];
    [_datepicker onYinYangBtnClick:_datepicker.yinBtn];
    [_datepicker onYinYangBtnClick:_datepicker.yangBtn];
}

#pragma mark - datePicker初始化
-(void)initDatePicker
{
    UIButton *titlebutton = (UIButton *)self.navigationItem.titleView;
    NSString *dateString = [NSString stringWithFormat:@"%@ UTC",titlebutton.titleLabel.text];
    NSLog(@"dateString:%@",dateString);
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd zzz"];
    NSDate* date = [formatter dateFromString:dateString];
    [_datepicker initDate:date calendarType:0];
}
#pragma mark - 添加时间选择器
-(void)AddTimePickerToCalendarWatch{
    
    _datepicker = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _datepicker.delegate = self;
    _datepicker.pickerViewCount = PickerViewCount3;
    
    [self.view.window addSubview:_datepicker];
    [UIView animateWithDuration:0.25 animations:^{
        _datepicker.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}
#pragma mark - 移除时间选择器
-(void)reMoveTimePickerToCalendarWatch{
    [[self.view viewWithTag:1000] removeFromSuperview];
}
#pragma mark - 时间选择器的确定和返回按钮
-(void)pickerViewDelegateWithDateString:(NSString *)dateString
{
    NSArray * dateArr = [dateString componentsSeparatedByString:@"-"];
    [self reMoveTimePickerToCalendarWatch];
    if ([dateArr[0] intValue] > 2049) {
        return;
    }
    self.strYear = [[dateArr objectAtIndex:0] intValue];
    self.strMonth = [[dateArr objectAtIndex:1] intValue];
    self.strDay = [[dateArr objectAtIndex:2] intValue];
    [_calendarView markDataWithYear:self.strYear month:self.strMonth day:self.strDay];
    
    UIButton *titlebutton = (UIButton *)self.navigationItem.titleView;
    [titlebutton setTitle:[NSString stringWithFormat:@"%d-%d-%d", self.strYear,self.strMonth, self.strDay] forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
