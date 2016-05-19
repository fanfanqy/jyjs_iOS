//
//  RootViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "RootViewController.h"
#import "WeatherTableViewCell.h"
#import "NarrowWeatherTableViewCell.h"
#import "CalendarTableViewCell.h"
#import "NarrowCalendarTableViewCell.h"
#import "WallpaperVC.h"
#import "ToolVC.h"
#import "WallpaperTableViewCell.h"
#import "LocationController.h"
#import "ASNetworking.h"
#import "WeatherModel.h"
#import "AppDelegate.h"
#define SH [UIScreen mainScreen].bounds.size.height
#define SW [UIScreen mainScreen].bounds.size.width
#define RefreshDelayInterval 1.1

typedef enum {
   AutoScrollUp,
   AutoScrollDown
} AutoScroll;

#define moduleNumber 3 // 模块数量

@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate>

@property (nonnull , strong) UITableView *table;
@property (strong, nonatomic) NSMutableArray      * weatherArray; // 天气数据
@property (strong, nonatomic) NSMutableDictionary *dictionary; //cell 的一些信息
@property (strong, nonatomic) NSMutableArray *cellNameArray; // 模块顺序
@property (strong, nonatomic) UIImageView *navigationImageView;
@property (strong, nonatomic) UIImageView *headBackImageView;
@property (nonatomic, strong) CADisplayLink *displayLink;
/**
 *  press 变量记录,是否点按开始,点按开始,刷新tabview 数据,以模块方式进行展示
 */
@property(nonatomic,assign)BOOL press;
@property(nonatomic,assign)BOOL isBegan;
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, assign) AutoScroll autoScroll;
@property (nonatomic, strong) UIView * leftView;
@property (nonatomic, strong) UIView * mainView;
@property (nonatomic, strong) ToolVC *leftViewController;
@end

@implementation RootViewController
static NSIndexPath  *fromIndexPath = nil;//点按cell
static NSIndexPath  *sourceIndexPath = nil; //目标cell

- (NSMutableArray *)cellNameArray
{
   if (!_cellNameArray) {
      _cellNameArray = [@[@"天气", @"日历", @"壁纸"] mutableCopy] ;
   }
   return _cellNameArray;
}

- (NSMutableDictionary *)dictionary
{
   if (!_dictionary) {
      _dictionary = [@{
                       @"天气":@{@"header_height":@"500",
                         @"narrow_height":@"150",
                         @"header_class":@"WeatherTableViewCell",
                         @"header_identifier":@"WEATHERTABLEVIEWCELL",
                         @"narrow_class":@"NarrowWeatherTableViewCell",
                         @"narrow_identifier":@"NARROWWEATHERTABLEVIEWCELL"
                           },
                       
                      @"日历":@{@"header_height":@"600",
                        @"narrow_height":@"300",
                        @"header_class":@"CalendarTableViewCell",
                        @"header_identifier":@"CALENDARTABLEVIEWCELL",
                        @"narrow_class":@"NarrowCalendarTableViewCell",
                     @"narrow_identifier":@"NARROWCALENDARTABLEVIEWCELL"
                        },
                       @"壁纸":@{@"header_height":@"500",
                         @"narrow_height":@"150",
                         @"header_class":@"WallpaperTableViewCell",
                         @"header_identifier":@"WALLPAPERTABLEVIEWCELL",
                         @"narrow_class":@"NarrowWallpaperTableViewCell",
                         @"narrow_identifier":@"NARROWWALLPAPERTABLEVIEWCELL"

                         }} mutableCopy];
   }
   return _dictionary;
}
#pragma mark 抽屉试图
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
   NSLog(@"bounds:%f,%f",self.view.frame.origin.x,self.view.frame.origin.y);
   [self.view addSubview:self.mainView];
   self.mainView.backgroundColor = [UIColor whiteColor];
}
- (void)creatTable
{

   self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
   _table.showsHorizontalScrollIndicator = NO;
   _table.showsVerticalScrollIndicator = NO;
   UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
   [_table addGestureRecognizer:longPress];
   [self.mainView addSubview:self.table];
   self.table.delegate = self;
   self.table.dataSource = self;
   
}
#pragma mark - 抽屉效果
// 返回根视图
- (void)goToRootViewController:(UIButton *)sender
{
   if (sender.selected) {
      [self setmainViewX:0];
   } else {
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
     self.weatherArray = [NSMutableArray array];
   [self initLeftView];
   [self initMainView];
   [self setNavigationIteam];
    [self creatTable];
   [self handleData];

}
- (void)handleData
{
   // 请求天气数据
   [ASNetworking ASNetURLconnectionWith:WeatherUrl type:@"GET" Parmaters:nil FinishBlock:^(NSData *data) {
      if (data != nil) {
         NSLog(@"请求成功");
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];

         NSLog(@"%@", dic);

         NSArray *array = [[[dic objectForKey:@"forecast"] objectForKey:@"simpleforecast"]objectForKey:@"forecastday"];

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
            model.wind = [[dictionary objectForKey:@"maxwind"] objectForKey:@"dir"];
            model.directionOfwind = @"无";
            model.humidity = [[dictionary objectForKey:@"avehumidity"] integerValue];
            [self.weatherArray addObject:model];
         }

         NSLog(@"%lu", (unsigned long)self.weatherArray.count);
         // 今天的当前天气
         WeatherModel * model = [self.weatherArray objectAtIndex:0];
         model.nowtemp = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"current_observation"] objectForKey:@"temp_c"]];
         dispatch_async(dispatch_get_main_queue(), ^{


         });

      }else{
         NSLog(@"请求失败");
      }

   }];
   // 请求壁纸数据
   
}

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
      if (indexPath.row == 0) {
         className = [[self.dictionary objectForKey:moduleName] objectForKey:@"header_class"];
         identifier = [[self.dictionary objectForKey:moduleName] objectForKey:@"header_identifier"];
      }else{
         className = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_class"];
         identifier = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_identifier"];
      }
      if (!cell) {
         Class class = NSClassFromString(className);
         cell = [[class alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
      }

   }else{
            if (!cell) {
               className = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_class"];
               identifier = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_identifier"];
               Class class = NSClassFromString(className);
               cell = [[class alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if (indexPath.row == fromIndexPath.item) {
               cell.contentView.alpha = 0.5;

            }else{
               cell.contentView.alpha = 1.0;
            }

   }
   cell.viewControllerDelegate = self;
   return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

   if (!_press) {
      if (indexPath.row == 0) {
            if ([_cellNameArray[indexPath.row] isEqualToString:@"天气"]) {
               return 500;
            }else if ([_cellNameArray[indexPath.row] isEqualToString:@"日历"] ){
               return 600;
            }else if ([_cellNameArray[indexPath.row] isEqualToString:@"壁纸"] ){
               return 500;
            }

      }else{
            if ([_cellNameArray[indexPath.row] isEqualToString:@"天气"]) {
               return 150;
            }else if ([_cellNameArray[indexPath.row] isEqualToString:@"日历"] ){
               return 300;
            }else if ([_cellNameArray[indexPath.row] isEqualToString:@"壁纸"] ){
               return 150;
            }
      }
   }else{
         if ([_cellNameArray[indexPath.row] isEqualToString:@"天气"]) {
            return 150;
         }else if ([_cellNameArray[indexPath.row] isEqualToString:@"日历"] ){
            return 300;
         }else if ([_cellNameArray[indexPath.row] isEqualToString:@"壁纸"] ){
            return 150;
         }
   }
   return 0.1;
}

- (void)setNavigationIteam
{
   UIImageView *navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
   self.navigationImageView = navigationImageView;
   self.navigationController.automaticallyAdjustsScrollViewInsets = NO;

   [self applyTransparentBackgroundToTheNavigationBar:1.0];

   UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 65)];
   view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"晴 - 主页Assistor.png"]];
   [self.mainView addSubview:view];

   UIImage *leftimage = [UIImage imageNamed:@"用户 （白） - Assistor.png"];
   UIButton *leftButton = [[UIButton alloc]init];
   leftButton.frame = CGRectMake(0, 0, 33, 24.7);
   [leftButton setImage:leftimage forState:UIControlStateNormal];
   [leftButton addTarget:self action:@selector(goToRootViewController:) forControlEvents:UIControlEventTouchUpInside];
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];

   UIImage *rightimage = [UIImage imageNamed:@"分享 - （白）Assistor.png"];
   UIButton *rightButton = [[UIButton alloc]init];
   rightButton.frame = CGRectMake(0, 0, 18, 24);
   [rightButton setImage:rightimage forState:UIControlStateNormal];
   [rightButton addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];

#pragma mark 待修改1
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

// 定位
- (void)location
{
   LocationController *location = [[LocationController alloc]init];
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

#pragma mark 长按拖动
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
            [_cellImageView removeFromSuperview];

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
