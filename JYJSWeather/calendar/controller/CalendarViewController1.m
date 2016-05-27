//
//  CalendarViewController1.m
//  Calendar
//
//  Created by DEVP-IOS-03 on 16/4/12.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import "CalendarViewController1.h"
#import "Datetime.h"
#import "WanNianLiDate.h"
#import "calendarDBModel.h"
#import "PickerView.h"
#import "wanNianLiTool.h"
#import "calendarDateView.h"
#import "calendarYiJiView.h"
#import "calendarBtnView.h"
#import "liSuanCalendarView.h"
#import "AlmanacView.h"
#import "WeekView.h"
#import "NarrowCalendarView.h"
#import "ZangLiModel.h"
#define BUDDHAIMAGEWIDTH 350
#define BUDDHAIMAGEHEIGHT 460

@interface CalendarViewController1 ()<calendarBtnViewDelegate,lisuanCalendarViewDelegate,pickerViewDelegate,NarrowCalendarViewDelegate,UIScrollViewDelegate>
{
    FMDatabase * _db;
    FMDatabase * _zangLiDb;
    PickerView * _datepicker;//时间选择器作用:快速定位到某一个日期
    int isPush ;
}
@property (nonatomic,strong)UIButton *titlebutton;
@property (nonatomic,strong)liSuanCalendarView * calendarView;//日历
@property (nonatomic,strong)calendarYiJiView * yiJiView;//宜忌
@property (nonatomic,strong)calendarBtnView * btnView;
@property (nonatomic,strong)calendarDateView * dateView;
@property (nonatomic,strong)UIView * buddleView;
@property (nonatomic,strong)NSMutableArray * calendarArray;
@property (nonatomic,strong)NSMutableArray * narrowCalendarArray;
@property (nonatomic,strong)NSMutableArray * zangLiArray;
@property (nonatomic,strong)UIScrollView * scrView;
@property (nonatomic,assign) int strMonth;
@property (nonatomic,assign) int strYear;
@property (nonatomic,assign) int strDay;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)UIButton * today;
@property (nonatomic,strong)UIButton *updateBtn;
@property (nonatomic,strong)AlmanacView *almanacView;
@property (nonatomic,strong) WeekView *weekView;
@property (nonatomic,strong) NarrowCalendarView *narrowCalendarView;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)UIButton *downBackgroundBtn;
@property (nonatomic,strong) UIButton *downButton;
@property (nonatomic,assign)BOOL isNarrow;
@property (nonatomic,assign)BOOL isShowNarrow;
@property (nonatomic,assign)int  isFirst;
@end

@implementation CalendarViewController1

- (void)viewDidLoad {
    
    [super  viewDidLoad];
    _isNarrow = NO;
    _isFirst = 0;
    _isShowNarrow = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending ) {
        self.edgesForExtendedLayout = NO;
    }
    [self setNavigationBar];
    self.calendarArray = [[NSMutableArray alloc] init];
    self.narrowCalendarArray = [[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _db = [WanNianLiDate getDataBase];
            NSString * path = [[NSBundle mainBundle] pathForResource:@"zangli" ofType:@"db"];
            _zangLiDb = [[FMDatabase alloc] initWithPath:path];
            [_zangLiDb open];
            [self createScrollView];
            [self createToday];
            [self createWeekView];
            [self createCalendarView];
            [self createAlmanacView];
        });
    });

}
- (void)setNavigationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏 - Assistor.png"] forBarMetrics:UIBarMetricsDefault];

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

    /* 刷新titleButton*/
    _titlebutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 165, 21)];
    _titlebutton.titleLabel.font = [UIFont fontWithName:@"Kaiti" size:20];
    [_titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", self.strYear,self.strMonth] forState:UIControlStateNormal];
    _titleStr = [NSString stringWithFormat:@"%d-%d-%d", self.strYear,self.strMonth,self.strDay];
    [_titlebutton addTarget:self action:@selector(dateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_titlebutton setImage:[UIImage imageNamed:@"下拉 箭头 - Assistor.png"] forState:UIControlStateNormal];
    _titlebutton.titleEdgeInsets = UIEdgeInsetsMake(0, -11, 0, 11);
    _titlebutton.imageEdgeInsets = UIEdgeInsetsMake(0, _titlebutton.frame.size.width-31, 0, 20);
    self.navigationItem.titleView = _titlebutton;

}

-(void)createScrollView
{
    self.scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    _scrView.showsHorizontalScrollIndicator = NO;
    _scrView.showsVerticalScrollIndicator = NO;
    _scrView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底图 - Assistor.png"]];
    _scrView.bounces = NO;
    _scrView.delegate = self;
    _scrView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    [self.view addSubview:_scrView];
}
//上部分背景图
-(void)createToday{
    /**
     创建一个按钮作为背景
     */
    UIImage * nomal = [UIImage imageNamed:@"底图（上） - Assistor.png"];//;//  btnBackGround
    _today = [[UIButton alloc] initWithFrame:CGRectMake(0, -2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT, ScreenWidth, 14.8 * CALENDARBTNPADDING )];
    [_today setImage:nomal  forState:UIControlStateNormal];
    _today.adjustsImageWhenHighlighted = NO;
    [_scrView addSubview:_today];
}

#pragma mark - 星期View
-(void)createWeekView{
    _weekView = [[WeekView alloc]init];
    _weekView.frame = CGRectMake(0, 0, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
   _weekView.backgroundColor = [UIColor clearColor];//全透明
//    _weekView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底图（上） - Assistor.png"]];
    [self.view addSubview:_weekView];
}

#pragma mark - 缩略日历试图
-(void)createNarrowCalendarView{
     _narrowCalendarView = [[NarrowCalendarView alloc]initWithFrame:CGRectMake(0, -1*(CALENDARBTNPADDING+TOPBUTTONHEIGHT), ScreenWidth, 2.0*CALENDARBTNPADDING)];
    _narrowCalendarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底图（上） - Assistor.png"]];
    _narrowCalendarView.delegate = self;
    _narrowCalendarView.opaque = NO;
    _downButton = [[UIButton alloc]initWithFrame:CGRectMake(0.5*ScreenWidth-10, _narrowCalendarView.frame.origin.y+_narrowCalendarView.frame.size.height, 20, 10)];
    [_downButton setImage:[UIImage imageNamed:@"open0"] forState:UIControlStateNormal];
    [_downButton addTarget:self action:@selector(showCalendarView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_narrowCalendarView];
    [self.view addSubview:_downButton];
}

#pragma mark - 日历View
-(void)createCalendarView
{
    _isNarrow = NO;
    _strYear = [[Datetime GetYear] intValue];
    _strMonth = [[Datetime GetMonth] intValue];
    _strDay = [[Datetime GetDay] intValue];
    _calendarView = [[liSuanCalendarView alloc] initWithFrame:CGRectMake(CALENDARBTNPADDING * 0.5,2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+TOPBUTTONHEIGHT, ScreenWidth-CALENDARBTNPADDING, 13 * CALENDARBTNPADDING)];
    _calendarView.opaque = NO;
    _calendarView.backgroundColor = [UIColor clearColor];
    _calendarView.delegate = self;
    [_today addSubview:_calendarView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay andIsSwipe:NO];
        });
    });
}
#pragma mark 变化后的坐标需要改变
-(void)showToday{
    UIImage * nomal = [UIImage imageNamed:@"底图（上） - Assistor.png"];//;//  btnBackGround
    _today = [[UIButton alloc] initWithFrame: CGRectMake(0, -8*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT, ScreenWidth, 14.8 * CALENDARBTNPADDING )];
    [_today setImage:nomal  forState:UIControlStateNormal];
    _today.adjustsImageWhenHighlighted = NO;
    [_scrView addSubview:_today];

}

-(void)showAndCreateCalendarView{
     _calendarView = [[liSuanCalendarView alloc] initWithFrame:CGRectMake(CALENDARBTNPADDING * 0.5, 2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+TOPBUTTONHEIGHT, ScreenWidth-CALENDARBTNPADDING, 13 * CALENDARBTNPADDING)];
    _calendarView.opaque = NO;
    _calendarView.backgroundColor = [UIColor clearColor];
    _calendarView.delegate = self;
    [_today addSubview:_calendarView];
    NSLog(@"%s,_strYear,_strMonth,_strDay:%d,%d,%d",__func__,_strYear,_strMonth,_strDay);
    [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay andIsSwipe:NO];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay andIsSwipe:NO];
//        });
//    });
}

-(void)showCalendarView{
    _isFirst = 0;
    _isNarrow = NO;
    [self showToday];
    [self showAndCreateCalendarView];
    [_downButton removeFromSuperview];
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _narrowCalendarView.frame = CGRectMake(0, -2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT), ScreenWidth, 2.0*CALENDARBTNPADDING);
        _today.frame = CGRectMake(0, -2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT, ScreenWidth, 14.8 * CALENDARBTNPADDING );
         [_scrView setContentOffset:CGPointMake(0, 0)];
         _downBackgroundBtn.frame = CGRectMake(0, _today.frame.origin.y+_today.frame.size.height+7, ScreenWidth, ScreenHeight-64);
          _scrView.contentSize = CGSizeMake(ScreenWidth, _downBackgroundBtn.frame.origin.y + _downBackgroundBtn.frame.size.height);
    } completion:^(BOOL finished) {
        [_narrowCalendarView removeFromSuperview];
    }];
}

-(void)tap{
    //变成缩略状态
    _isShowNarrow = YES;
    [self createNarrowCalendarView];
    [_narrowCalendarView markDataWithYear:_strYear month:_strMonth day:_strDay];
    [self.view bringSubviewToFront:_weekView];
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            _narrowCalendarView.frame = CGRectMake(0, 1*(CALENDARBTNPADDING+TOPBUTTONHEIGHT), ScreenWidth, 2.0*CALENDARBTNPADDING);
//            _calendarView.frame = CGRectMake(CALENDARBTNPADDING * 0.5, -3*CALENDARBTNPADDING, ScreenWidth-CALENDARBTNPADDING, 13 * CALENDARBTNPADDING );
            _today.frame = CGRectMake(0, -8*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT, ScreenWidth, 14.8 * CALENDARBTNPADDING );
            _downButton.frame = CGRectMake(0.5*ScreenWidth-10, _narrowCalendarView.frame.origin.y+_narrowCalendarView.frame.size.height, 20, 10);
            [_scrView setContentOffset:CGPointMake(0, 10.0*CALENDARBTNPADDING-3.0*TOPBUTTONHEIGHT) ];
            _downBackgroundBtn.frame = CGRectMake(0, 3*CALENDARBTNPADDING+TOPBUTTONHEIGHT, ScreenWidth, ScreenHeight-3*CALENDARBTNPADDING-64-TOPBUTTONHEIGHT);
            _scrView.contentSize = CGSizeMake(ScreenWidth, _downBackgroundBtn.frame.origin.y + _downBackgroundBtn.frame.size.height-13);
        } completion:^(BOOL finished) {
            [_calendarView removeFromSuperview];
            [_today removeFromSuperview];
        }];
        }

#pragma mark - 黄历View
-(void)createAlmanacView{
    _downBackgroundBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _today.frame.origin.y+_today.frame.size.height+7, ScreenWidth, ScreenHeight-64)];
    [_downBackgroundBtn setImage:[UIImage imageNamed:@"底图（下） - Assistor.png"] forState:UIControlStateNormal];
    _almanacView = [[[NSBundle mainBundle]loadNibNamed:@"AlmanacView" owner:self options:nil]lastObject];
    _almanacView.frame = CGRectMake(0, 0, ScreenWidth, 477);
    _almanacView.backgroundColor = [UIColor clearColor];
    [_downBackgroundBtn addSubview:_almanacView];
    [_scrView addSubview:_downBackgroundBtn];

     _scrView.contentSize = CGSizeMake(ScreenWidth,  _almanacView.frame.origin.y+_almanacView.frame.size.height);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    UIImage * nomal = [UIImage imageNamed:@"底图（上） - Assistor.png"];
    _weekView.backgroundColor = [UIColor colorWithPatternImage:nomal];
        //
    if (!_isNarrow) {
        if (scrollView.contentOffset.y <= TOPBUTTONHEIGHT) {
            _weekView.backgroundColor = [UIColor clearColor];
        }
    }
    if (!_isNarrow) {
        if (scrollView.contentOffset.y >=(12.8*CALENDARBTNPADDING-1.5*TOPBUTTONHEIGHT-(CALENDARBTNPADDING+TOPBUTTONHEIGHT))) {
            [self.view bringSubviewToFront:_weekView];
            _weekView.frame = CGRectMake(0, -(scrollView.contentOffset.y-(12.8*CALENDARBTNPADDING-1.5*TOPBUTTONHEIGHT-(CALENDARBTNPADDING+TOPBUTTONHEIGHT))), ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
        }else{
            _weekView.frame = CGRectMake(0, 0, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
        }
    }

}

/**
 *  今天按钮点击事件,回到当前日期
 */
-(void)backTodayAction
{
    if (_isNarrow) {
        [_narrowCalendarView backTodayAction];
    }else{
    _strYear = [[Datetime GetYear] intValue];
    _strMonth = [[Datetime GetMonth] intValue];
    _strDay = [[Datetime GetDay] intValue];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay andIsSwipe:YES];
        });
    });
    }
}
#pragma mark - 返回上一级
-(void)goBackLastController{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *dateString = [NSString stringWithFormat:@"%@ UTC",_titleStr];
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

#pragma mark - 时间选择器的确定和返回按钮
-(void)pickerViewDelegateWithDateString:(NSString *)dateString
{
    _isFirst = 0;
    NSArray * dateArr = [dateString componentsSeparatedByString:@"-"];
    [self reMoveTimePickerToCalendarWatch];
    if ([dateArr[0] intValue] > 2049) {
        return;
    }
    self.strYear = [[dateArr objectAtIndex:0] intValue];
    self.strMonth = [[dateArr objectAtIndex:1] intValue];
    self.strDay = [[dateArr objectAtIndex:2] intValue];
    if (_isNarrow) {
        [_narrowCalendarView markDataWithYear:_strYear month:_strMonth day:_strDay];
    }else{
    [_calendarView markDataWithYear:self.strYear month:self.strMonth day:self.strDay andIsSwipe:NO];
    }
}

#pragma mark - 移除时间选择器
-(void)reMoveTimePickerToCalendarWatch{
    [[self.view viewWithTag:1000] removeFromSuperview];
}


#pragma mark NarrowCalendarViewDelegate
-(void)reloadNarrowCalendarDataWithYear:(int)newYear month:(int)newMonth day:(int)newDay andIsSelected:(BOOL)isSelected{

    self.strDay = newDay;
    self.strMonth = newMonth;
    self.strYear = newYear;
    #pragma mark - 从数据库读取数据
    [_narrowCalendarArray removeAllObjects];
    NSArray *array = [Datetime GetDayDicByYear:_strYear andMonth:_strMonth andDay:_strDay];
    NSMutableArray *arrayTemp  = [NSMutableArray array];
    for (int j=0; j<7; j++) {
        int year = [array[0][j] intValue];
        int month = [array[1][j] intValue];
        int day = [array[2][j] intValue];
        NSString *monthStr = nil;
        NSString *dayStr = nil;
        NSString *dateStr = nil;
        if (month < 10) {
            monthStr = [NSString stringWithFormat:@"0%d",month];
        }else{
            monthStr = [NSString stringWithFormat:@"%d",month];
        }
        if (day<10) {
            dayStr = [NSString stringWithFormat:@"0%d",day];
        }else{
            dayStr = [NSString stringWithFormat:@"%d",day];
        }
        dateStr = [NSString stringWithFormat:@"%d%@%@",year,monthStr,dayStr];
        [arrayTemp addObject:dateStr];
    }

    FMResultSet * setDb = [_db executeQuery:[NSString stringWithFormat:@"select * from calendar where id between '%@' and '%@'",arrayTemp[0],[arrayTemp lastObject]]];
    while ([setDb next]) {
        calendarDBModel * model = [[calendarDBModel alloc] init];
        model.ID = [setDb stringForColumn:@"id"];
        model.lid = [setDb stringForColumn:@"lid"];
        model.week = [setDb stringForColumn:@"week"];
        //            NSLog(@"model.week:%@",model.week);
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
        [_narrowCalendarArray addObject:model];
    }

    calendarDBModel * model;
     ZangLiModel * zangliModel;
    for (int i=0; i<_narrowCalendarArray.count; i++) {
        model = _narrowCalendarArray[i];
        if ( [model.week isEqualToString:[NSString stringWithFormat:@"%d",[Datetime GetTheWeekOfDayByYera:newYear andByMonth:newMonth andByDay:newDay]]]) {
            break;
        }
    }
    _narrowCalendarView.narrowCalendarArray = _narrowCalendarArray;
    /* 刷新titleButton*/
    [_titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", self.strYear,self.strMonth] forState:UIControlStateNormal];
    _titleStr = [NSString stringWithFormat:@"%d-%d-%d", self.strYear,self.strMonth,self.strDay];

    NSString * zangliSql;
    if (self.strMonth < 10) {
        if (self.strDay < 10) {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d0%d0%d",_strYear,_strMonth,_strDay];
        }else {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d0%d%d",_strYear,_strMonth,_strDay];
        }
    }else {
        if (_strDay < 10) {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d%d0%d",_strYear,_strMonth,_strDay];
        }else {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d%d%d",_strYear,_strMonth,_strDay];
        }
    }
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
    }
    if (isSelected ) {
        /**
         *  @param gdb 宜
         */
        FMResultSet * gdb = [_db executeQuery:[NSString stringWithFormat:@"select * from gdb where gid=%@",model.gd]];
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
            _almanacView.YiLabel.text = muYiStr;
            _almanacView.YiLabel.numberOfLines = 0;
        }

        /**
         *  忌
         */
        FMResultSet * bdb = [_db executeQuery:[NSString stringWithFormat:@"select * from bdb where bid=%@",model.bd]];

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
            _almanacView.YiLabel.text = muJiStr;
            _almanacView.YiLabel.numberOfLines = 0;
        }

        /**
         *  刷新宜忌上边的节日和节气数据
         */
        [_almanacView reloadDataOfYiJiView:(calendarDBModel *)model andZangLiModel:(ZangLiModel *)zangliModel year:_strYear month:_strMonth day:_strDay];

    }
//    [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay andIsSwipe:YES];

}

#pragma mark - 刷新数据
-(void)reloadDataWithYear:(int)newYear month:(int)newMonth day:(int)newDay andIsSelected:(BOOL)isSelected andIsSwipe:(BOOL)isSwipe
{
    self.strDay = newDay;
    self.strMonth = newMonth;
    self.strYear = newYear;
//    [self readDataFromDb];
    NSString * starDate;
    NSString * endDate;
     int day=0;
    [_calendarArray removeAllObjects];
    #pragma mark - 从数据库读取数据
    for (int i=0; i<3; i++) {
        NSMutableArray *array = [NSMutableArray array];
        int  year=0;
        int  month=0;
        if (i==0) {
            if (_strMonth != 1) {
                year = _strYear;
                month = _strMonth-1;
            }else{
                year = _strYear-1;
                month = 12;
            }
            day = [Datetime GetNumberOfDayByYera:year andByMonth:month];//天数
            if ([Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth] == 0) {
                day=1;
            }
            //eg:现实数据是2016-4-13,数据库中日期键会是2016-04-13
            if (month < 10) {

                starDate = [NSString stringWithFormat:@"%d0%d%d",year,month,1+day-[Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth]];
                endDate = [NSString stringWithFormat:@"%d0%d%d",year,month,day];
            }else{
                starDate = [NSString stringWithFormat:@"%d%d%d",year,month,1+day-[Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth]];
                endDate = [NSString stringWithFormat:@"%d%d%d",year,month,day];
            }

        }else if (i==1) {

            year = _strYear;
            month = _strMonth;
            day = [Datetime GetNumberOfDayByYera:_strYear andByMonth:_strMonth];//天数
            //eg:现实数据是2016-4-13,数据库中日期键会是2016-04-13
            if (month < 10) {
                starDate = [NSString stringWithFormat:@"%d0%d0%d",year,month,1];
                endDate = [NSString stringWithFormat:@"%d0%d%d",year,month,day];
            }else{
                starDate = [NSString stringWithFormat:@"%d%d0%d",year,month,1];
                endDate = [NSString stringWithFormat:@"%d%d%d",year,month,day];
            }
        }else if (i==2) {
            if (_strMonth != 12) {
                year = _strYear;
                month = _strMonth+1;
            }else{
                year = _strYear+1;
                month = 1;
            }
            day = [Datetime GetNumberOfDayByYera:_strYear andByMonth:_strMonth];//天数
            if ([Datetime GetTheWeekOfDayByYera:year andByMonth:month] == 0) {
                day=42;
            }
            //eg:现实数据是2016-4-13,数据库中日期键会是2016-04-13
            if (month < 10) {
                starDate = [NSString stringWithFormat:@"%d0%d0%d",year,month,1];
                if (42-day-1>=10) {
                    endDate = [NSString stringWithFormat:@"%d0%d%d",year,month,42-day];
                }
                else{
                    endDate = [NSString stringWithFormat:@"%d0%d0%d",year,month,42-day];
                }
            }else{
                starDate = [NSString stringWithFormat:@"%d%d0%d",year,month,1];
                if (42-day-1>=10) {
                    endDate = [NSString stringWithFormat:@"%d%d%d",year,month,42-day];
                }
                else{
                    endDate = [NSString stringWithFormat:@"%d%d0%d",year,month,42-day];
                }

            }
        }

        /**
         *  数据库 calendar 中查看每个键的信息
         */
        NSLog(@"starDate%@,endDate%@",starDate,endDate);
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
            [array addObject:model];
        }
        [_calendarArray addObject:array];
    }
    calendarDBModel * model;
    ZangLiModel * zangliModel;
    //防止数组越界,下面的星期用datetime 算
    if (isSelected) {
         model  = _calendarArray[1][newDay- 1];
    }
    _calendarView.calendarArray = _calendarArray;
    NSString * zangliSql;
    if (self.strMonth < 10) {
        if (self.strDay < 10) {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d0%d0%d",_strYear,_strMonth,_strDay];
        }else {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d0%d%d",_strYear,_strMonth,_strDay];
        }
    }else {
        if (_strDay < 10) {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d%d0%d",_strYear,_strMonth,_strDay];
        }else {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d%d%d",_strYear,_strMonth,_strDay];
        }
    }
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
    }

    /* 刷新titleButton*/
    [_titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", self.strYear,self.strMonth] forState:UIControlStateNormal];
    _titleStr = [NSString stringWithFormat:@"%d-%d-%d", self.strYear,self.strMonth,self.strDay];
#pragma mark 条件很复杂,选中,且是缩略,才更新数据
    if (isSelected) {
    /**
     *  @param gdb 宜
     */
    FMResultSet * gdb = [_db executeQuery:[NSString stringWithFormat:@"select * from gdb where gid=%@",model.gd]];
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
        _almanacView.YiLabel.text = muYiStr;
        _almanacView.YiLabel.numberOfLines = 0;
    }
        
    /**
     *  忌
     */
    FMResultSet * bdb = [_db executeQuery:[NSString stringWithFormat:@"select * from bdb where bid=%@",model.bd]];

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
        _almanacView.JiLabel.text = muJiStr;
        _almanacView.JiLabel.numberOfLines = 0;
    }

    /**
     *  刷新宜忌上边的节日和节气数据
     */
    [_almanacView reloadDataOfYiJiView:model andZangLiModel:zangliModel year:_strYear month:_strMonth day:_strDay];
    if (_isFirst>1 && _isNarrow == NO && !isSwipe) {
        _isNarrow = YES;
         [self tap];
    }else{
    _isFirst++;
    _scrView.contentSize = CGSizeMake(ScreenWidth, _downBackgroundBtn.frame.origin.y + _downBackgroundBtn.frame.size.height);
    }
    }
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self reMoveTimePickerToCalendarWatch];
}

-(void)dealloc
{
    _calendarView.delegate = nil;
    _narrowCalendarView.delegate = nil;
    [_db close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

