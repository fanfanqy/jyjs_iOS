//
//  WeatherModel.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/18.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (nonatomic , copy) NSString * nowtemp; // 当前温度
@property (nonatomic , copy) NSString * maxtemp; // 最高温度
@property (nonatomic , copy) NSString * mintemp; // 最低温度

@property (nonatomic , assign) NSInteger year; //年
@property (nonatomic , assign) NSInteger month; // 月
@property (nonatomic , assign) NSInteger day; // 日

@property (nonatomic , copy) NSString * week; //星期
@property (nonatomic , copy) NSString * weather_txt; // 天气描述
@property (nonatomic , copy) NSString * pollution; // 污染
@property (nonatomic , copy) NSString * mirror; // 准提镜
@property (nonatomic , copy) NSString * wind; // 风力
@property (nonatomic , copy) NSString * directionOfwind; // 风向
@property (nonatomic , assign) NSInteger humidity; //湿度
@property (nonatomic , copy) NSString * icon;

@end
