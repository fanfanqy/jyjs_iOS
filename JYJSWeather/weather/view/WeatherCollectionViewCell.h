//
//  WeatherCollectionViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mirror; // 准提镜
@property (weak, nonatomic) IBOutlet UILabel *nowtemp; // 当前温度
@property (weak, nonatomic) IBOutlet UILabel *date; // 日期
@property (weak, nonatomic) IBOutlet UILabel *week; // 星期
@property (weak, nonatomic) IBOutlet UILabel *max_mintemp; // 最大最小温度
@property (weak, nonatomic) IBOutlet UILabel *weather_txt; // 天气描述
@property (weak, nonatomic) IBOutlet UIImageView *pollution; // 污染
@property (weak, nonatomic) IBOutlet UIImageView *person; // 人物
@end
