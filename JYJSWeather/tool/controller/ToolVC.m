//
//  ToolVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/11.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "ToolVC.h"
#import "LocationController.h"
#import "AboutUsViewController.h"


@interface ToolVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic , strong) UITableView *table;
@property (nonatomic , strong) NSMutableArray *textArray;
@end

@implementation ToolVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textArray = [NSMutableArray arrayWithObjects:@"城市管理", @"壁纸管理", @"优先使用国外气象源", @"关于我们", nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTableView];
}
- (void)creatTableView
{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LeftWidth, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    UILabel *appTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    appTitle.text = @"APP名称";
    self.table.tableHeaderView = appTitle;
    appTitle.textAlignment = NSTextAlignmentCenter;
    appTitle.textColor = [UIColor grayColor];
    appTitle.backgroundColor = [UIColor whiteColor];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TOOLVCCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TOOLVCCELL"];
    }
    cell.textLabel.text = [self.textArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 2) {
        UISwitch * switchView = [[UISwitch alloc]initWithFrame:CGRectMake(LeftWidth - 50, 0, 40, cell.contentView.frame.size.height)];
        [cell addSubview:switchView];
        switchView.on = YES;
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)switchAction:(UISwitch *)switchView
{
 
    if (switchView.on) {
        NSLog(@"国外气象源");
    } else {
        NSLog(@"国内气象源");
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"系统设置";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"城市管理"]) {
        LocationController *locationVC = [[LocationController alloc]init];
        [self.delegate.navigationController pushViewController:locationVC animated:YES];
    }
    if ([cell.textLabel.text isEqualToString:@"关于我们"]) {
        AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
        [self.delegate.navigationController pushViewController:aboutUs animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
