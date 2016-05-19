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
#define BUDDHAIMAGEWIDTH 350
#define BUDDHAIMAGEHEIGHT 460

@interface CalendarViewController1 ()<UITableViewDelegate,UITableViewDataSource,calendarBtnViewDelegate,lisuanCalendarViewDelegate,pickerViewDelegate>
{
    FMDatabase * _db;
    PickerView * _datepicker;//时间选择器作用:快速定位到某一个日期
    int isPush ;
}

@property (nonatomic,strong)liSuanCalendarView * calendarView;//日历
@property (nonatomic,strong)calendarYiJiView * yiJiView;//宜忌
@property (nonatomic,strong)calendarBtnView * btnView;
@property (nonatomic,strong)calendarDateView * dateView;
@property (nonatomic,strong)UIView * buddleView;
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

@implementation CalendarViewController1

- (void)viewDidLoad {
    
    [super  viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending ) {
        self.edgesForExtendedLayout = NO;
    }

    self.calendarArray = [[NSMutableArray alloc] init];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay ];
            _db = [WanNianLiDate getDataBase];
            [self createScrollView];
            [self createDateView];
            [self createCalendarView];
        });
    });

}

-(void)createScrollView
{
    self.scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight+2 + 44)];
    _scrView.showsHorizontalScrollIndicator = NO;
    _scrView.showsVerticalScrollIndicator = NO;
    _scrView.bounces = NO;
    _scrView.delegate = self;
    _scrView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    [self.view addSubview:_scrView];
}

#pragma mark - 日期View
-(void)createDateView
{
    UIImage * nomal = [UIImage imageNamed:@"redkuang"];//  btnBackGround
    CGFloat w = nomal.size.width * 0.5;
    CGFloat h = nomal.size.height * 0.5;
    UIImage *image = [nomal resizableImageWithCapInsets:UIEdgeInsetsMake(h,w,h,w) resizingMode:UIImageResizingModeStretch];
    _dateView = [[calendarDateView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.4)];
    [_dateView setBackgroundImage:image forState:UIControlStateNormal];
    _dateView.adjustsImageWhenDisabled = NO;
    _dateView.enabled = NO;
    [self.scrView addSubview:_dateView];
}

#pragma mark - 日历View
-(void)createCalendarView
{
    _strYear = [[Datetime GetYear] intValue];
    _strMonth = [[Datetime GetMonth] intValue];
    _strDay = [[Datetime GetDay] intValue];
    UIImage * nomal = [UIImage imageNamed:@"redkuang"];//  btnBackGround
    CGFloat w = nomal.size.width * 0.5;
    CGFloat h = nomal.size.height * 0.5;
    UIImage *image = [nomal resizableImageWithCapInsets:UIEdgeInsetsMake(h,w,h,w) resizingMode:UIImageResizingModeStretch];
    _calendarView = [[liSuanCalendarView alloc] initWithFrame:CGRectMake(CALENDARBTNPADDING * 0.5,CALENDARBTNPADDING * 0.3, ScreenWidth-CALENDARBTNPADDING, 13 * CALENDARBTNPADDING + 3)];
    _calendarView.backgroundColor = UIColorFromRGB(0xfafafa);
    _calendarView.opaque = NO;
    _calendarView.delegate = self;
    /**
     创建一个按钮作为背景
     */
    _today = [[UIButton alloc] initWithFrame:CGRectMake(0, _dateView.frame.origin.y + _dateView.frame.size.height + 20, ScreenWidth, 14.5 * CALENDARBTNPADDING )];
    [_today setBackgroundImage:image forState:UIControlStateNormal];
    _today.adjustsImageWhenHighlighted = NO;
    [_today addSubview:_calendarView];
    [_scrView addSubview:_today];

    [self createYiJiView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay];
        });
    });
}

#pragma mark - 宜忌View
-(void)createYiJiView
{
    UIImage * nomal = [UIImage imageNamed:@"redkuang"];//  btnBackGround
    CGFloat w = nomal.size.width * 0.5;
    CGFloat h = nomal.size.height * 0.5;
    UIImage *image = [nomal resizableImageWithCapInsets:UIEdgeInsetsMake(h,w,h,w) resizingMode:UIImageResizingModeStretch];
    self.yiJiView = [[calendarYiJiView alloc] initWithFrame:CGRectMake(0, _today.frame.origin.y + self.calendarView.frame.size.height, ScreenWidth, ScreenHeight * 0.3)];
    _yiJiView.enabled = NO;
    _yiJiView.adjustsImageWhenDisabled = NO;
    [_yiJiView setBackgroundImage:image forState:UIControlStateNormal];
    [_scrView addSubview:self.yiJiView];

     [self createBtnView];
}

-(void)createBtnView
{
    self.btnView = [[calendarBtnView alloc] initWithFrame:CGRectMake(0, self.yiJiView.frame.origin.y + self.yiJiView.frame.size.height, ScreenWidth, 150 + 0.6 * PADDING)];
    self.btnView.delegate = self;
    [_scrView addSubview:_btnView];
}

#pragma mark - 点击展开时辰
-(void)calendarBtnView:(calendarBtnView *)btnView timeTableViewChange:(BOOL)isTableView
{
    if (isTableView) {
        btnView.isTableView = NO;
        CGRect frame = btnView.timeBtn.frame;
        frame.size.height = 300;
        btnView.timeBtn.frame = frame;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect btnFrame = btnView.frame;
            btnFrame.size.height = btnView.timeBtn.frame.size.height + btnView.timeBtn.frame.origin.y;
            btnView.frame = btnFrame;
            _scrView.contentSize = CGSizeMake(ScreenWidth, _btnView.frame.origin.y + _btnView.frame.size.height+ topTabbrHeight + UITabBarHeight );
            _scrView.contentOffset = CGPointMake(0, _btnView.frame.origin.y + _btnView.frame.size.height - ScreenHeight + topTabbrHeight);
            btnView.timeTableView.hidden = NO;
            UIImageView * image = (UIImageView *)[btnView viewWithTag:10];
            image.image = [UIImage imageNamed:@"close0"];
        } completion:^(BOOL finished) {

        }];
    }else {
        btnView.isTableView = YES;
        [UIView animateWithDuration:0.5 animations:^{
              _scrView.contentSize = CGSizeMake(ScreenWidth, _btnView.frame.origin.y + 50 + btnView.timeBtn.frame.origin.y + topTabbrHeight + UITabBarHeight);
        } completion:^(BOOL finished) {
            btnView.timeTableView.hidden = YES;
            CGRect frame = btnView.timeBtn.frame;
            frame.size.height = 50;
            btnView.timeBtn.frame = frame;
            CGRect btnFrame = btnView.frame;
            btnFrame.size.height = btnView.timeBtn.frame.size.height + btnView.timeBtn.frame.origin.y;
            btnView.frame = btnFrame;
            UIImageView * image = (UIImageView *)[btnView viewWithTag:10];
            image.image = [UIImage imageNamed:@"open0"];

        }];
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
    NSString *dateString = [NSString stringWithFormat:@"%@ UTC",_calendarView.dateBtn.currentTitle];
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
    NSArray * dateArr = [dateString componentsSeparatedByString:@"-"];
    [self reMoveTimePickerToCalendarWatch];
    if ([dateArr[0] intValue] > 2049) {
        return;
    }
    self.strYear = [[dateArr objectAtIndex:0] intValue];
    self.strMonth = [[dateArr objectAtIndex:1] intValue];
    self.strDay = [[dateArr objectAtIndex:2] intValue];
    [_calendarView markDataWithYear:self.strYear month:self.strMonth day:self.strDay];

}
#pragma mark - 移除时间选择器
-(void)reMoveTimePickerToCalendarWatch{
    [[self.view viewWithTag:1000] removeFromSuperview];
}

#pragma mark - 刷新数据
-(void)reloadDataWithYear:(int)newYear month:(int)newMonth day:(int)newDay andIsSelected:(BOOL)isSelected
{
    self.strDay = newDay;
    self.strMonth = newMonth;
    self.strYear = newYear;
    [self readDataFromDb];
    calendarDBModel * model  = _calendarArray[self.strDay - 1];
    _calendarView.calendarArray = _calendarArray;

    /**
     *  刷新dateView的数据
     */
    [_dateView calendarDateViewReloadData:model  year:newYear month:newMonth day:newDay];
  
    if (isSelected) {

    int lunarIndex;
    if (model.lMonth.intValue == 0) {
            lunarIndex = [[[model.lMonth componentsSeparatedByString:@"闰"] objectAtIndex:1] intValue] - 1;
    }else {
            lunarIndex = [model.lMonth intValue] - 1;
    }
    NSMutableArray * strArr = [[NSMutableArray alloc] init];
    strArr = (NSMutableArray *)[wanNianLiTool getShiChenJiXiong:model.dayZhu];//根据日柱得到吉凶的数组
    _btnView.dataArray = strArr;
    [_btnView.timeTableView reloadData];
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
        _yiJiView.YiLabel.text = muYiStr;
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
        _yiJiView.JiLabel.text = muJiStr;
    }
    /**
     *  刷新宜忌上边的节日和节气数据
     */
    [_yiJiView reloadDataOfYiJiView:model];
    [self reloadFrame];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self reMoveTimePickerToCalendarWatch];
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

#pragma mark - 数据刷新后要重置各个空间的frame

-(void)reloadFrame
{
        CGRect jiShi = _dateView.jiShi.frame;
        jiShi.origin.y = _dateView.chong_animal.frame.origin.y + _dateView.chong_animal.frame.size.height + 0.5 * PADDING;
        _dateView.jiShi.frame = jiShi;

        CGRect xiongShi = _dateView.xiongShi.frame;
        xiongShi.origin.y = _dateView.chong_animal.frame.origin.y + _dateView.chong_animal.frame.size.height + 0.5 * PADDING;
        _dateView.xiongShi.frame = xiongShi;

        CGRect date = _dateView.frame;
        CGRect status = [[UIApplication sharedApplication] statusBarFrame];
        date.size.height = _dateView.jiShi.frame.origin.y + _dateView.jiShi.frame.size.height + PADDING;
//        date.origin.y = ScreenHeight - date.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - status.size.height;
        _dateView.frame = date;

        CGRect today = _today.frame;
        today.origin.y = _dateView.frame.origin.y + _dateView.frame.size.height + PADDING * 0.3;
        _today.frame = today;

        CGRect yiji = _yiJiView.frame;
        yiji.origin.y = _today.frame.origin.y + _today.frame.size.height+ PADDING * 0.3;
        _yiJiView.frame = yiji;
        CGRect btn = _btnView.frame;
        btn.origin.y = _yiJiView.frame.origin.y + _yiJiView.frame.size.height + PADDING * 0.3;
        _btnView.frame = btn;
        _scrView.contentSize = CGSizeMake(ScreenWidth, _btnView.frame.origin.y + _btnView.frame.size.height+ topTabbrHeight + UITabBarHeight);
}

-(void)dealloc
{
    _btnView.timeTableView.delegate = nil;
    _btnView.delegate = nil;
    _calendarView.delegate = nil;
    [_db close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

