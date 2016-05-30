//
//  SoftwareVersionViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/20.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "SoftwareVersionViewController.h"

@interface SoftwareVersionViewController ()

@property (nonatomic , strong) UILabel * software;

@end

@implementation SoftwareVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"软件版本";
    [self softwareVersion];
}



//软件版本
- (void)softwareVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [NSString stringWithFormat:@"当前软件版本为:%@",infoDic[@"CFBundleShortVersionString"]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"软件版本" message:currentVersion preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
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
