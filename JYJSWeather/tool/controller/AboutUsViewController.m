//
//  AboutUsViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/19.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SoftwareVersionViewController.h"
#import "FeedbackViewController.h"


@interface AboutUsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableview;
@property (nonatomic , strong) NSMutableArray *array;

@end

@implementation AboutUsViewController
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [@[@"软件介绍", @"软件版本",@"反馈"] mutableCopy] ;
    }
    return _array;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    self.title = @"关于我们";
}
- (void)creatTableView
{
    self.tableview = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height) style:UITableViewStyleGrouped];

    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ABOUTUSTABLEVIEWCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ABOUTUSTABLEVIEWCELL"];
    }
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"软件版本"]) {
        SoftwareVersionViewController *softwareVC = [[SoftwareVersionViewController alloc]init];
        [self.navigationController pushViewController:softwareVC animated:YES];
    }
    if ([cell.textLabel.text isEqualToString:@"反馈"]) {
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc]init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }
}

@end
