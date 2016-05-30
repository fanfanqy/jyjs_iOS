//
//  AppDelegate.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/2/25.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "WanNianLiDate.h"
#import "ToolVC.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

    [WanNianLiDate getDataBase];
    [self initNetwork];
    // 状态栏字体白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    RootViewController *rtVC = [[RootViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rtVC];
    
    self.window.rootViewController = nav;
    return YES;
}
- (void)initNetwork{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.baidu.com";
    _hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [_hostReachability startNotifier];
}

-(void)reachabilityChanged:(NSNotification *)noti{
    Reachability* curReach = [noti object];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    NSLog(@"netStatusAPP:%lu",netStatus);
    _reachableCount++;
    if (_reachableCount == 2) {
        _reachableCount = 0;
        return;
    }
    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络已断开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
