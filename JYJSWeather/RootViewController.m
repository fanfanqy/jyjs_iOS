//
//  RootViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "RootViewController.h"
#import "ToolVC.h"
#import "DBModel.h"
#import "Image_Model.h"
#import "AppDelegate.h"
#import "WallpaperVC.h"
#import "SqlDataBase.h"
#import "ASNetworking.h"
#import "WeatherModel.h"
#import "LocationController.h"
#import "WeatherTableViewCell.h"
#import "WallpaperTableViewCell.h"
#import "CalendarTableViewCell.h"
#import "NarrowWeatherTableViewCell.h"
#import "NarrowCalendarTableViewCell.h"
#import "CityTitleCollectionViewCell.h"

#import <CoreLocation/CoreLocation.h>

#define SH [UIScreen mainScreen].bounds.size.height
#define SW [UIScreen mainScreen].bounds.size.width
#define RefreshDelayInterval 1.1

typedef enum {
   AutoScrollUp,
   AutoScrollDown
} AutoScroll;

#define moduleNumber 3 // 模块数量

@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate, UIScrollViewDelegate ,CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
   NSString * weatherKey;
   NSString * calendarKey;
   NSString * wallpaperkey;
}
@property (nonatomic, strong) CLGeocoder          * geocoder;
@property (retain)            CLLocationManager   * locationManager;
@property (nonatomic, strong) UITableView         * table;
@property (strong, nonatomic) NSMutableArray      * weatherArray;              // 天气数据
@property (strong, nonatomic) NSMutableDictionary * dictionary;                //cell 的一些信息
@property (strong, nonatomic) NSMutableArray      * cellNameArray;             // 模块顺序
@property (strong, nonatomic) UIImageView         * navigationImageView;
@property (strong, nonatomic) UIImageView         * headBackImageView;
@property (nonatomic, strong) CADisplayLink       * displayLink;

/**
 *  press 变量记录,是否点按开始,点按开始,刷新tabview 数据,以模块方式进行展示
 */
@property (nonatomic,assign) BOOL                   press;
@property (nonatomic,assign) BOOL                   isBegan;
@property (nonatomic, assign) AutoScroll            autoScroll;
@property (nonatomic, strong) UIImageView         * cellImageView;
@property (nonatomic, strong) UIView              * leftView;
@property (nonatomic, strong) UIView              * mainView;
@property (nonatomic, strong) ToolVC              * leftViewController;
@property (nonatomic, strong) UIView              * navigationBackView;       // 渐变导航栏背景view
@property (nonatomic, strong) UIButton            * leftButton;               // 左侧抽屉按钮
@property (nonatomic, strong) UIButton            * rightButton;              // 右侧分享按钮
@property (nonatomic, strong) UICollectionView    * titleCollectionView;      //导航栏上面滚动城市
@property (nonatomic, strong) NSMutableArray      * wallpaperArray_big;       // 壁纸大图数组
@property (nonatomic, strong) NSMutableArray      * wallpaperArray_little;    // 壁纸缩略图数组

@end

@implementation RootViewController
static NSIndexPath  *fromIndexPath = nil;//点按cell
static NSIndexPath  *sourceIndexPath = nil; //目标cell
- (instancetype)init
{
   self = [super init];
   if (self) {
      self.cityArray = [NSMutableArray array];
      self.userCityArray = [NSMutableArray array];
      self.locationCityModel = [[DBModel alloc]init];
      self.locationCityModel.cityCC = LocationCity;
      self.wallpaperArray_big = [NSMutableArray array];
      self.wallpaperArray_little = [NSMutableArray array];
      self.weatherArray = [NSMutableArray array];
      self.cellNameArray = [NSMutableArray array];
      
      weatherKey = @"天气";
      calendarKey = @"日历";
      wallpaperkey = @"壁纸";
      
   }
   return self;
}
- (void)saveUserDefaults:(NSMutableArray *)array ToKey:(NSString *)key
{
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   [userDefaults setObject:array forKey:key];
}

- (NSMutableArray *)readUserDefaultsWithKey:(NSString *)key
{
   NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
   NSMutableArray *array = [ NSMutableArray arrayWithArray:[userDefaultes arrayForKey:key]];
   return array;
}
- (void)saveUserDefaults
{
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   [userDefaults setObject:self.userCityArray forKey:@"userCityArray"];
}

- (void)readUserDefaults
{
   NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
   self.userCityArray = [ NSMutableArray arrayWithArray:[userDefaultes arrayForKey:@"userCityArray"]];
}
- (NSMutableDictionary *)dictionary
{
   if (!_dictionary) {
      _dictionary = [@{
                       weatherKey:@{@"header_height":@"500",
                         @"narrow_height":@"150",
                         @"header_class":@"WeatherTableViewCell",
                         @"header_identifier":@"WEATHERTABLEVIEWCELL",
                         @"narrow_class":@"NarrowWeatherTableViewCell",
                         @"narrow_identifier":@"NARROWWEATHERTABLEVIEWCELL"
                           },
                       
                      calendarKey:@{@"header_height":@"600",
                        @"narrow_height":@"300",
                        @"header_class":@"CalendarTableViewCell",
                        @"header_identifier":@"CALENDARTABLEVIEWCELL",
                        @"narrow_class":@"NarrowCalendarTableViewCell",
                     @"narrow_identifier":@"NARROWCALENDARTABLEVIEWCELL"
                        },
                       wallpaperkey:@{@"header_height":@"500",
                         @"narrow_height":@"150",
                         @"header_class":@"WallpaperTableViewCell",
                         @"header_identifier":@"WALLPAPERTABLEVIEWCELL",
                         @"narrow_class":@"NarrowWallpaperTableViewCell",
                         @"narrow_identifier":@"NARROWWALLPAPERTABLEVIEWCELL"

                         }} mutableCopy];
   }
   return _dictionary;
}
#pragma mark 视图初始化
- (void)initLeftView
{
   self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LeftWidth, self.view.frame.size.height)];
   [self.view addSubview:self.leftView];
   self.leftView.backgroundColor = [UIColor whiteColor];

   self.leftViewController = [[ToolVC alloc]init];
   [self.leftView addSubview:self.leftViewController.view];
   _leftViewController.view.frame = _leftView.frame;
   _leftViewController.delegate = self;
}

- (void)initMainView
{
   self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
   [self.view addSubview:self.mainView];
   self.mainView.backgroundColor = [UIColor whiteColor];
}
- (void)creatTable
{

   self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
   _table.showsHorizontalScrollIndicator = NO;
   _table.showsVerticalScrollIndicator = NO;
   UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
   [_table addGestureRecognizer:longPress];
   [self.mainView addSubview:self.table];
   self.table.delegate = self;
   self.table.dataSource = self;
   
   UIView * vv = [[UIView alloc]initWithFrame:CGRectMake(100, -100, 100, 100)];
   [self.table addSubview:vv];
   vv.backgroundColor = [UIColor redColor];
   
   
   self.navigationBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
   [self.mainView addSubview:self.navigationBackView];
   self.navigationBackView.backgroundColor = [UIColor grayColor];
   self.navigationBackView.alpha = 0;
   
}
#pragma mark - 抽屉效果
// 返回根视图
- (void)goToRootViewController:(UIButton *)sender
{
   if (sender.selected) {
      self.mainView.userInteractionEnabled = YES;
      [self setmainViewX:0];
   } else {
      self.mainView.userInteractionEnabled = NO;
      [self setmainViewX:LeftWidth];
   }
   sender.selected = !sender.selected;

}
//设置最大侧滑
- (void)setmainViewX:(CGFloat)endX
{

   CGRect frame = self.mainView.frame;
   frame.origin.x = endX;

   CGRect naviFrame = self.navigationController.navigationBar.frame;
   naviFrame.origin.x = endX;

   [UIView animateWithDuration:0.2 animations:^{
      self.mainView.frame = frame;
      self.navigationController.navigationBar.frame = naviFrame;
   }];

}
- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   CGRect frame = self.mainView.frame;
   frame.origin.x = 0;
   self.mainView.frame=frame;
   CGRect naviFrame = self.navigationController.navigationBar.frame;
   naviFrame.origin.x = 0;
   self.navigationController.navigationBar.frame = naviFrame;
   ////去掉背景图片,去掉底部线条
   self.navigationImageView.hidden = YES;

   // 防止在tool界面直接跳转到第三个界面后,返回root,点击抽屉按钮,按钮迟钝
   self.leftButton.selected = NO;
   self.mainView.userInteractionEnabled = YES;

   [self.titleCollectionView reloadData];
   

}

- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   CGRect naviFrame = self.navigationController.navigationBar.frame;
   naviFrame.origin.x = 0;
   self.navigationController.navigationBar.frame = naviFrame;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
   self.cellNameArray = [self readUserDefaultsWithKey:@"moduleNameArray"];
   if (self.cellNameArray.count == 0) {
      NSMutableArray * array = [@[wallpaperkey ,weatherKey,calendarKey] mutableCopy];
      [self saveUserDefaults:array ToKey:@"moduleNameArray"];
      self.cellNameArray = array;
   }

   [self initLeftView];
   [self initMainView];
   [self setNavigationIteam];
    [self creatTable];
   [self handleData];

}
#pragma mark - 加载数据
- (void)handleData
{
   // 请求天气数据
   [self handleWeatherData];
   // 请求壁纸数据
   [self handleWallpaperData];

   // 城市数据
   [self handleCityData];

}
// 藏历数据
- (void)handleCaldsfData
{
   
}
- (NSMutableArray *)sortOutDataWith:(NSArray *)array
{
   NSMutableArray * testArray = [NSMutableArray array];
   for (NSDictionary * dictionary in array) {
      Image_Model * model = [[Image_Model alloc]init];
      model.thumbUrl = [dictionary objectForKey:@"ThumbUrl"];
      model.iD = [[dictionary objectForKey:@"ID"] integerValue];
      model.nameHash = [[dictionary objectForKey:@"NameHash"] integerValue];
      model.name = [dictionary objectForKey:@"Name"];
      model.publishDateUtc = [dictionary objectForKey:@"PublishDateUtc"];
      model.createDateUtc = [dictionary objectForKey:@"CreateDateUtc"];
      model.url = [dictionary objectForKey:@"Url"];
      model.width = [[dictionary objectForKey:@"Width"] integerValue];
      model.height = [[dictionary objectForKey:@"Height"]integerValue];
      model.isPortrait = [dictionary objectForKey:@"IsPortrait"];
      model.type = [dictionary objectForKey:@"__type"];
      model.categories = [dictionary objectForKey:@"Categories"];
      model.itdescription = [dictionary objectForKey:@"Description"];
      model.Labels = [dictionary objectForKey:@"Labels"];
      model.stat_Download = [[[dictionary objectForKey:@"Stat"] objectForKey:@"Download"]integerValue];
      model.stat_Rate = [[[dictionary objectForKey:@"Stat"] objectForKey:@"Rate"]integerValue];
      model.stat_Vote = [[[dictionary objectForKey:@"Stat"] objectForKey:@"Vote"]integerValue];
      [testArray addObject:model];
   }
   return testArray;
}
// 请求壁纸数据
- (void)handleWallpaperData
{
   // 请求壁纸大数据
   ASNetworking * asn_big = [[ASNetworking alloc]init];
   [asn_big handleWallPaperListWith:WallPaperList minWidth:WallPaper_width maxWidth:WallPaper_width minHeight:WallPaper_height maxHeight:WallPaper_height hash:0 token:Token dateUtc:nil FinishBlock:^(NSData *data) {
      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
      NSArray *array = [dic objectForKey:@"d"];
      self.wallpaperArray_big = [self sortOutDataWith:array];
      NSLog(@"大壁纸个数%lu", (unsigned long)self.wallpaperArray_big.count);
      dispatch_async(dispatch_get_main_queue(), ^{
         NSLog(@"开始刷新");
         [self.table reloadData];
         
      });
      
   }];
   
   // 请求壁纸缩略图数据
   ASNetworking * asn_little = [[ASNetworking alloc]init];
   [asn_little handleWallPaperListWith:WallPaperList minWidth:narrowImage_width maxWidth:narrowImage_width minHeight:narrowImage_height maxHeight:narrowImage_height hash:0 token:Token dateUtc:nil FinishBlock:^(NSData *data) {
      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
      
      NSArray *array = [dic objectForKey:@"d"];
      self.wallpaperArray_little = [self sortOutDataWith:array];
      NSLog(@"缩略壁纸个数%lu", (unsigned long)self.wallpaperArray_little.count);
      dispatch_async(dispatch_get_main_queue(), ^{
         NSLog(@"开始刷新");
         [self.table reloadData];
         
      });
      
   }];

}
// 请求天气数据
- (void)handleWeatherData
{
   NSString * url = [NSString stringWithFormat:WeatherUrl,30.22999954,120.16999817];
   
   [ASNetworking ASNetURLconnectionWith:url type:@"GET" Parmaters:nil FinishBlock:^(NSData *data) {
      if (data != nil) {
         NSLog(@"请求成功");
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
         
         NSArray *array = [[[dic objectForKey:@"forecast"] objectForKey:@"simpleforecast"]objectForKey:@"forecastday"];
         
         
         NSMutableArray * testArray = [NSMutableArray array];
         for (NSDictionary * dictionary in array) {
            WeatherModel * model = [[WeatherModel alloc]init];
            model.nowtemp = nil;
            model.maxtemp = [[dictionary objectForKey:@"high"] objectForKey:@"celsius"];
            model.mintemp = [[dictionary objectForKey:@"low"] objectForKey:@"celsius"];
            model.year = [[[dictionary objectForKey:@"date"]objectForKey:@"year"] integerValue];
            model.month = [[[dictionary objectForKey:@"date"]objectForKey:@"month"] integerValue];
            model.day = [[[dictionary objectForKey:@"date"]objectForKey:@"day"] integerValue];
            model.week = [[dictionary objectForKey:@"date"]objectForKey:@"weekday"];
            model.weather_txt = [dictionary objectForKey:@"conditions"];
            model.mirror = [dictionary objectForKey:@"icon"]; // 准提镜
            model.icon = [dictionary objectForKey:@"icon"];
            model.pollution = @"未找到"; // 污染
            model.wind = @"无";
            model.directionOfwind = [[dictionary objectForKey:@"maxwind"] objectForKey:@"dir"];
            model.humidity = [[dictionary objectForKey:@"avehumidity"] integerValue];
            [testArray addObject:model];
         }
         
         [self.weatherArray removeAllObjects];
         self.weatherArray = testArray;
         NSLog(@"天气数据个数%lu", (unsigned long)self.weatherArray.count);
         // 今天的当前天气
         WeatherModel * model = [self.weatherArray objectAtIndex:0];
         model.nowtemp = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"current_observation"] objectForKey:@"temp_c"]];
         dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"开始刷新");
            [self.table reloadData];
            
         });
         
      }else{
         NSLog(@"请求失败");
      }
      
   }];
}
#pragma mark - 定位获取城市信息等
- (void)handleCityData
{
   // 先从userdefault中读取城市顺序,在从数据库中读取城市信息,比较排序,如果有我的定位,则定位开始,先用self.locationCityModel 占位
   [self readUserDefaults];
   SqlDataBase *sqldata = [[SqlDataBase alloc]init];
   NSArray * arr = [sqldata searchAllSaveCity];
//   NSString * str = [self.userCityArray firstObject];
   for (NSString * cityname in self.userCityArray) {
      // 如果已选择城市中含有当前定位城市
      if ([cityname isEqualToString:LocationCity]) {
         
         [self.cityArray addObject:self.locationCityModel];
         // 如果当前已经定位过了,locationCityModel中有内容,则不再定位
         if (!self.locationCityModel.cityPinyin) {
            NSLog(@"开始定位");
            [self startLocation];
         }else{
            NSLog(@"定位过,不再定位");
         }
      }
      for (DBModel *model in arr) {
         // 按顺序给城市排序
         if ([cityname isEqualToString:model.cityCC]) {
            [self.cityArray addObject:model];
            
         }
      }
   }
   
}

- (void)startLocation
{
   self.locationManager = [[CLLocationManager alloc]init];
   self.locationManager.delegate = self;
   if (![CLLocationManager locationServicesEnabled]) {
      NSLog(@"定位服务尚未打开");
      return;
   }
   //如果没有授权则请求用户授权
   if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
      NSLog(@"shahsasha");
   }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
      NSLog(@"tantanatan");
   }
   [_locationManager requestWhenInUseAuthorization];
   
   //设置代理
   _locationManager.delegate=self;
   //设置定位精度
   _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
   //    //定位频率,每隔多少米定位一次
   //    CLLocationDistance distance=10;//十米定位一次
   //    _locationManager.distanceFilter=distance;
   //启动跟踪定位
   [_locationManager startUpdatingLocation];
   self.geocoder=[[CLGeocoder alloc]init];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   CLLocation *location=[locations firstObject];
   [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
      if (error) {
         NSLog(@"出错啦%@",error);
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
         [alert show];
         return;
      }
      CLPlacemark *placemark=[placemarks firstObject];
      NSString * url = [NSString stringWithFormat:WeatherUrlForOneCity, placemark.location.coordinate.latitude,placemark.location.coordinate.longitude];
      [ASNetworking ASNetURLconnectionWith:url type:@"GET" Parmaters:nil FinishBlock:^(NSData *data) {
         if (data != nil) {
            NSLog(@"请求成功");
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            NSDictionary *dictionary = [dic objectForKey:@"location"];
            
            NSString *citiname = [dictionary objectForKey:@"city"];
            NSArray *cityNameArr = [citiname componentsSeparatedByString:@" "];
            NSString * cityName = [cityNameArr firstObject];
            //                NSString * cityName = @"Hangzhou";
            
            SqlDataBase *sqldata = [[SqlDataBase alloc]init];
            DBModel * model = [sqldata searchWithCityName:cityName];
            dispatch_async(dispatch_get_main_queue(), ^{
               if (model.cityCC) {
                  self.locationCityModel = model;
                  [self saveUserDefaults];
                  [self.cityArray removeAllObjects];
                  [self handleData];
                  [self.titleCollectionView reloadData];
               } else {
                  NSLog(@"未找到当前定位城市");
               }
            });
            
         }else{
            NSLog(@"请求失败");
         }
      }];
      NSLog(@"当前城市信息:%@",[placemark.addressDictionary objectForKey:@"City"]);
      [self.locationManager stopUpdatingLocation];
      
   }];
   
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
   [alert show];
   
   NSLog(@"error.localizedDescription:%@",error.localizedDescription);
}


#pragma mark - tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return moduleNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   BaseTableViewCell*    cell = nil;
   NSString * moduleName = [self.cellNameArray objectAtIndex:indexPath.row];
   NSString * className = nil;
   NSString * identifier = nil;
   cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   cell.selectionStyle =UITableViewCellSelectionStyleNone;
   
   if (!_press) {
      cell.contentView.alpha = 1.0;
      // 非移动状态,获取当前cell的类型
      if (indexPath.row == 0) {
         className = [[self.dictionary objectForKey:moduleName] objectForKey:@"header_class"];
         identifier = [[self.dictionary objectForKey:moduleName] objectForKey:@"header_identifier"];
      }else{
         className = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_class"];
         identifier = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_identifier"];
      }
      cell = [tableView dequeueReusableCellWithIdentifier:identifier];
      // 创建cell
      if (!cell) {
         Class class = NSClassFromString(className);
         cell = [[class alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
      }
      // 对cell进行赋值
      if ([moduleName isEqualToString:weatherKey]) {
         cell.array = self.weatherArray;
         [cell.collectionView reloadData];
      }
      if ([moduleName isEqualToString:wallpaperkey]) {
         if (indexPath.row == 0) {
            
            cell.otherArray = self.wallpaperArray_little;
            cell.array = self.wallpaperArray_big;
            
            [cell.otherCollectionView reloadData];
            [cell.collectionView reloadData];
            
         } else {
            
            cell.otherArray = self.wallpaperArray_big;
            cell.array = self.wallpaperArray_little;
            [cell.collectionView reloadData];
            
         }
         
      }
      
   }else{
      className = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_class"];
      identifier = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_identifier"];
      cell = [tableView dequeueReusableCellWithIdentifier:identifier];
      if (!cell) {
         Class class = NSClassFromString(className);
         cell = [[class alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
      }
      
      if (indexPath.row == fromIndexPath.item) {
         cell.contentView.alpha = 0.5;
         
      }else{
         cell.contentView.alpha = 1.0;
      }
      // 对cell进行赋值
      if ([moduleName isEqualToString:weatherKey]) {
         cell.array = self.weatherArray;
         [cell.collectionView reloadData];
      }
      if ([moduleName isEqualToString:wallpaperkey]) {
         
            cell.otherArray = self.wallpaperArray_big;
            cell.array = self.wallpaperArray_little;
            [cell.collectionView reloadData];

      }
      
   }
   
   cell.viewControllerDelegate = self;
   return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

   if (!_press) {
      if (indexPath.row == 0) {
            if ([_cellNameArray[indexPath.row] isEqualToString:weatherKey]) {
               return 500;
            }else if ([_cellNameArray[indexPath.row] isEqualToString:calendarKey] ){
               return 600;
            }else if ([_cellNameArray[indexPath.row] isEqualToString:wallpaperkey] ){
               return 500;
            }

      }else{
            if ([_cellNameArray[indexPath.row] isEqualToString:weatherKey]) {
               return 150;
            }else if ([_cellNameArray[indexPath.row] isEqualToString:calendarKey] ){
               return 300;
            }else if ([_cellNameArray[indexPath.row] isEqualToString:wallpaperkey] ){
               return 150;
            }
      }
   }else{
         if ([_cellNameArray[indexPath.row] isEqualToString:weatherKey]) {
            return 150;
         }else if ([_cellNameArray[indexPath.row] isEqualToString:calendarKey] ){
            return 300;
         }else if ([_cellNameArray[indexPath.row] isEqualToString:wallpaperkey] ){
            return 150;
         }
   }
   return 0.1;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   // 当模块顺序已经固定好了, 上下滑动tableview,顶部类似navigationbar效果渐变
   if (!_press && [scrollView isEqual:self.table]) {

      if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 64) {
         self.navigationBackView.alpha = scrollView.contentOffset.y / 64;
      }
      if (scrollView.contentOffset.y <= 0) {
         self.navigationBackView.alpha = 0;
      }
      if (scrollView.contentOffset.y >= 64) {
         self.navigationBackView.alpha = 1;
      }
      
   }
   
}
#pragma mark - 导航栏
- (void)setNavigationIteam
{
   UIImageView *navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
   self.navigationImageView = navigationImageView;
   self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
   [self applyTransparentBackgroundToTheNavigationBar:1.0];


   UIImage *leftimage = [UIImage imageNamed:@"用户 （白） - Assistor.png"];
   self.leftButton = [[UIButton alloc]init];
   _leftButton.frame = CGRectMake(0, 0, 33, 24.7);
   [_leftButton setImage:leftimage forState:UIControlStateNormal];
   [_leftButton addTarget:self action:@selector(goToRootViewController:) forControlEvents:UIControlEventTouchUpInside];
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];

   UIImage *rightimage = [UIImage imageNamed:@"分享 - （白）Assistor.png"];
   self.rightButton = [[UIButton alloc]init];
   _rightButton.frame = CGRectMake(0, 0, 18, 24);
   [_rightButton setImage:rightimage forState:UIControlStateNormal];
   [_rightButton addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
   
   UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
   self.titleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 150, 44) collectionViewLayout:flow];
   self.navigationItem.titleView = _titleCollectionView;
   _titleCollectionView.delegate = self;
   _titleCollectionView.dataSource = self;
   _titleCollectionView.backgroundColor = [UIColor whiteColor];
   [_titleCollectionView registerClass:[CityTitleCollectionViewCell class] forCellWithReuseIdentifier:@"TITLECOLLECTIONVIEWCELL"];
   _titleCollectionView.pagingEnabled = YES;
   flow.itemSize = self.titleCollectionView.frame.size;
   flow.minimumLineSpacing = 0;
   flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   _titleCollectionView.backgroundColor = [UIColor clearColor];

#pragma mark 待修改1
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   CityTitleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TITLECOLLECTIONVIEWCELL" forIndexPath:indexPath];

   DBModel * model = [self.cityArray objectAtIndex:indexPath.row];
   cell.textLabel.text = model.cityCC;
   cell.backgroundColor = [UIColor redColor];
   return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return _cityArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   [self location];
   
   
}
// 导航栏全透明
- (void)applyTransparentBackgroundToTheNavigationBar:(CGFloat)opacity
{
   UIImage *transparentBackground;
   UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, self.navigationController.navigationBar.layer.contentsScale);
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetRGBFillColor(context, 1, 142, 107, opacity);
   UIRectFill(CGRectMake(0, 0, 1, 1));
   transparentBackground = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   id navigationBarAppearance = self.navigationController.navigationBar;
   [navigationBarAppearance setBackgroundImage:transparentBackground forBarMetrics:UIBarMetricsCompact];
}

-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {

   if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
      return (UIImageView *)view;
   }
   for (UIView *subview in view.subviews) {
      UIImageView *imageView = [self findHairlineImageViewUnder:subview];
      if (imageView) {
         return imageView;
      }
   }
   return nil;
}

// 城市管理
- (void)location
{
   LocationController *location = [[LocationController alloc]init];
   location.locationCityModel = self.locationCityModel;
   [self.navigationController pushViewController:location animated:YES];
}

//分享按钮
- (void)shareBtnClick{
    NSLog(@" shareBtnClick");
   UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:@[@"杭州，周四，多云转阵雨，26°C/17°C，东风2-3级，AQI:92 良；周五，阵雨转中雨，21°C/17°C，东风2-3级，AQI:57 良；周六，中雨转阵雨，20°C/17°C，东风2-3级，AQI:55 良。--5月19日 10:45 发布(来自@天气通 免费下载http://t.cn/zYaipUu )",[self captureScrollView:_table]] applicationActivities:nil];
   [self presentViewController:avc animated:YES completion:nil];
   UIActivityViewControllerCompletionHandler myblock = ^(NSString *type,BOOL completed){
      NSLog(@"completed:%d type:%@",completed,type);
   };
   avc.completionHandler = myblock;
}

#pragma mark -长按拖动
-(void)longPressGestureRecognized:(UILongPressGestureRecognizer *)sender{
   UILongPressGestureRecognizer *longPress = sender;
   UIGestureRecognizerState state = longPress.state;
   CGPoint location = [longPress locationInView:_table];
   NSIndexPath *indexPath = [_table indexPathForRowAtPoint:location];
   switch (state) {
      case UIGestureRecognizerStateBegan: {

         _press = YES;
          _isBegan = YES;
         /*这里记录开始点按的位置*/
         sourceIndexPath = indexPath;
         fromIndexPath = indexPath;

         UITableViewCell *cell = [_table cellForRowAtIndexPath:indexPath];
         _cellImageView = [self customCellImageViewFromView:cell];
         _cellImageView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
         _cellImageView.alpha = 0.0;
         [_table addSubview:_cellImageView];
         [UIView animateWithDuration:0.25 animations:^{
            _cellImageView.frame = CGRectMake(cell.frame.origin.x, location.y, cell.frame.size.width, cell.frame.size.height);
            _cellImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            _cellImageView.alpha = 0.4;
            cell.alpha = 0.0;
         } completion:^(BOOL finished) {
            cell.hidden = YES;
            //这里刷新,是为了显示效果进行刷新,下层模块#,需要透明
            [_table reloadData];
         }];

         break;
      }

      case UIGestureRecognizerStateChanged: {
         //具体查看效果,因为点按的#(1,2,3等),大小需要保持不变,这个时候,不能用 origin.y 进行计算位置,不然手指不会处于模块#的位置,无法对齐
         CGPoint center = _cellImageView.center;
         center.y = location.y;
         _cellImageView.center = center;
         if ([self isScrollToEdge]){
            [self startTimerToScrollTableView];

         }else{
            [_displayLink invalidate];
         }

         if (indexPath && ![indexPath isEqual:sourceIndexPath]){
            // 移动cell
            [self.cellNameArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
            [_table moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
            sourceIndexPath = indexPath;
         }
         break;
      }

      default: {
         // 结束状态
         _press = NO;
         _isBegan = NO;
         // 停止滚动
         [_displayLink invalidate];

         UITableViewCell *cell = [_table cellForRowAtIndexPath:sourceIndexPath];
         UITableViewCell *cell1 = [_table cellForRowAtIndexPath:fromIndexPath];
         cell.hidden = NO;
         cell.alpha = 0.0;
         [UIView animateWithDuration:0.25 animations:^{
            _cellImageView.center = cell.center;
            _cellImageView.alpha = 0.0;
            cell.alpha = 1.0;
            cell1.alpha = 1.0;
         } completion:^(BOOL finished) {
            sourceIndexPath = nil;
            _cellImageView = nil;
            [self.cellImageView removeFromSuperview];

         }];

         [self performSelector:@selector(refresh) withObject:nil afterDelay:RefreshDelayInterval];
         break;
      }
   }
}

-(void)refresh{
   [_table reloadData];
}

-(BOOL)isScrollToEdge {
   //imageView拖动到tableView顶部，且tableView没有滚动到最上面
   if ((CGRectGetMaxY(self.cellImageView.frame)-10 > _table.contentOffset.y + _table.frame.size.height - _table.contentInset.bottom) && (_table.contentOffset.y-10 < _table.contentSize.height - _table.frame.size.height + _table.contentInset.bottom)) {
      self.autoScroll = AutoScrollDown;
      return YES;
   }

   //imageView拖动到tableView底部，且tableView没有滚动到最下面
   if ((self.cellImageView.frame.origin.y < _table.contentOffset.y + _table.contentInset.top) && (_table.contentOffset.y > -_table.contentInset.top)) {
      self.autoScroll = AutoScrollUp;
      return YES;
   }

   return NO;
}

-(void)startTimerToScrollTableView {
   [_displayLink invalidate];
   _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTableView)];
   [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)scrollTableView{
   //如果已经滚动到最上面或最下面，则停止定时器并返回,手势结束时候,定时器也要停止
   if ((_autoScroll == AutoScrollUp && _table.contentOffset.y <= -_table.contentInset.top)|| (_autoScroll == AutoScrollDown && _table.contentOffset.y >= _table.contentSize.height - _table.frame.size.height + _table.contentInset.bottom)) {
      [_displayLink invalidate];
      return;
   }
   /*改变tableView的contentOffset，实现自动滚动*/
   CGFloat height = _autoScroll == AutoScrollUp? -3 : 3;
   [_table setContentOffset:CGPointMake(0, _table.contentOffset.y + height)];
   _cellImageView.frame = CGRectMake(_cellImageView.frame.origin.x, _cellImageView.frame.origin.y+height, _cellImageView.frame.size.width, _cellImageView.frame.size.height);

   /*
    滚动tableView的同时也要执行交换操作,(这里用center 是防止获取 fromIndexPath丢失)
    */
   fromIndexPath = [_table indexPathForRowAtPoint:_cellImageView.center];
   if (fromIndexPath && ![sourceIndexPath isEqual:fromIndexPath]){
      [self.cellNameArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:sourceIndexPath.row];
      [_table moveRowAtIndexPath:sourceIndexPath toIndexPath:fromIndexPath];
      sourceIndexPath = fromIndexPath;
   }
}

- (UIImageView *)customCellImageViewFromView:(UIView *)inputView {
   //截出图片
   UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0.0);
   [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   //截图试图
   UIImageView *cellImageView = [[UIImageView alloc] initWithImage:image];
   cellImageView.layer.masksToBounds = NO;
   cellImageView.layer.shadowOffset = CGSizeMake(-9.0, 0.0);
   cellImageView.layer.shadowRadius = 3.0;
   cellImageView.layer.shadowOpacity = 2.5;
   return cellImageView;
}

-(UIImage*)captureView:(UIView *)theView{
   CGRect rect = theView.frame;
   if ([theView isKindOfClass:[UIScrollView class]]) {
      rect.size = ((UIScrollView *)theView).contentSize;
   }

   UIGraphicsBeginImageContext(rect.size);
   CGContextRef context = UIGraphicsGetCurrentContext();
   [theView.layer renderInContext:context];
   UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return img;
}
- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
   UIImage* image = nil;
   //0.0高质量
   UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 0.0);
   {
      CGPoint savedContentOffset = scrollView.contentOffset;
      CGRect savedFrame = scrollView.frame;
      scrollView.contentOffset = CGPointZero;
      scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

      [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
      image = UIGraphicsGetImageFromCurrentImageContext();

      scrollView.contentOffset = savedContentOffset;
      scrollView.frame = savedFrame;
   }
   UIGraphicsEndImageContext();

   if (image != nil) {
      return image;
   }
   return nil;
}


@end
