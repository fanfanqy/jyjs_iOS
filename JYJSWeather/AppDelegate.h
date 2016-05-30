//
//  AppDelegate.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/2/25.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkMonitor.h"
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Reachability *hostReachability;
@property (nonatomic, readonly) NSInteger reachableCount;
@end

