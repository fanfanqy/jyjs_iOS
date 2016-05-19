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




@interface WeatherInsidePagesVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView *table;
@property (nonatomic , strong) NSMutableArray *heightForRowArr;


@end

@implementation WeatherInsidePagesVC

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
- (void)creatTable
{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
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
        BaseTableViewCell*    cell = nil;
        
        cell = [[WeatherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WEATHERTABLEVIEWCELL"];
        cell.viewControllerDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } else if (indexPath.row == 1){
        BaseTableViewCell*    cell = nil;

        cell = [[WeekTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WEEKTABLEVIEWCELL"];

        cell.viewControllerDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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


@end
