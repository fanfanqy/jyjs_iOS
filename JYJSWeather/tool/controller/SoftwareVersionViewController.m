//
//  SoftwareVersionViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/20.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "SoftwareVersionViewController.h"
#import "Help.h"
@interface SoftwareVersionViewController ()

@property (nonatomic , strong) UILabel * software;

@end

@implementation SoftwareVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"软件版本";
    Help *help = [[Help alloc]init];
    [help versionCheckUpdate];
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
