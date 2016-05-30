//
//  WeatherInsidePagesVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "WeatherInsidePagesVC.h"
#import "BaseTableViewCell.h"
#import "WeatherTableViewCell.h"
#import "WeekTableViewCell.h"
#import "IndexTableViewCell.h"




@interface WeatherInsidePagesVC ()<UITableViewDelegate, UITableViewDataSource, WeekTableViewCellDelegate>

@property (nonatomic , strong) UITableView *table;
@property (nonatomic , strong) NSMutableArray *heightForRowArr;


@end

@implementation WeatherInsidePagesVC
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}
- (NSMutableArray *)heightForRowArr
{
    if (!_heightForRowArr) {
        _heightForRowArr = [@[@"500", @"360", @"150"]mutableCopy];
    }
    return _heightForRowArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTable];
}
- (void)handleSunTimesInPeriod
{
//    @"http://192.168.10.6:800/service/sq/wellpaper.asmx/getWellPaperList?token='asdf1234'&hash=999&updatedDateUtc='2016/05/07'&minWidth=1&maxWidth=10000&minHeight=1&maxHeight=10000"
    
    NSDictionary * dic = @{@"token":Token,
                           @"lat":@"30.22999954",
                           @"lon":@"120.16999817",
                           @"data":@"'2016/6/1'",
                           @"period":@"10"
                           };
    
    
}
- (void)creatTable
{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
  
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        WeatherTableViewCell * cell = nil;
        
        cell = [[WeatherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WEATHERTABLEVIEWCELL"];
        cell.viewControllerDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.array = self.array;
        return cell;

    } else if (indexPath.row == 1){
        WeekTableViewCell * cell = nil;

        cell = [[WeekTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WEEKTABLEVIEWCELL"];

        cell.viewControllerDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.array = self.array;
        cell.delegate = self;
        
        return cell;


    }else{
        IndexTableViewCell *cell = nil;
        cell = [[IndexTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"INDEXTABLEVIEWCELL"];
        cell.viewControllerDelegate = self;
        return cell;

    }


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[self.heightForRowArr objectAtIndex:indexPath.row] floatValue];
    return height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * cellIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    WeatherTableViewCell * cell = [self.table cellForRowAtIndexPath:cellIndexpath];
    cell.collectionView.contentOffset = CGPointMake(indexPath.row * self.view.frame.size.width, 0);
}

@end
