//
//  NetWorkMonitor.m
//  SideSlip
//
//  Created by DEVP-IOS-03 on 16/5/16.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import "NetWorkMonitor.h"

@implementation NetWorkMonitor
@synthesize isHostReach = _isHostReach;
@synthesize networkKind = _networkKind;

- (NetworkKind)networkKind{
    BOOL isNetReachable = [self isNetworkReachable];
    return _networkKind;
}

- (BOOL)isHostReach
{
    _isHostReach = [_hostReach currentReachabilityStatus] != NotReachable;
    return _isHostReach;
}

+(NetWorkMonitor *)networkReachable{
    NetWorkMonitor *monitor = [[NetWorkMonitor alloc]init];
    return monitor;
}

-(instancetype)init{
    if (self = [super init]) {
       BOOL isNet = [self isNetworkReachable];
    }
    return self;
}

- (BOOL)isNetworkReachable{
    Reachability* curReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    _reachableCount++;
    switch (netStatus)
    {
        case NotReachable:{
            _networkKind = NONETWORK;
            if (1 == _reachableCount) {
                [self showNetworkAlertMessage];
            }
            return NO;
            break;
        }

        case ReachableViaWWAN:{
            _networkKind = NOWIFI;
            return YES;
            break;
        }
        case ReachableViaWiFi:{

            _networkKind = WIFI;
            return YES;
            break;
        }
    }
    if (_reachableCount == 2) {
        _reachableCount = 0;
    }

}

- (void)showNetworkAlertMessage{
    switch (_networkKind)
    {
        case NONETWORK:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络已断开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
            break;
        }

        case NOWIFI:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前连接为蜂窝移动网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];

            break;
        }
        case WIFI:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前连接为WIFI" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];

            break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    NSLog(@"确定按钮");
}

@end
