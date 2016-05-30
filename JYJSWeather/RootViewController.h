//
//  RootViewController.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DBModel;

@interface RootViewController : UIViewController
@property (nonatomic, strong) DBModel             * locationCityModel;
@property (strong, nonatomic) NSMutableArray      * cityArray; // 城市名称
@property (strong, nonatomic) NSMutableArray      * userCityArray;
@property (nonatomic,assign)BOOL isRefreshing;

@end
