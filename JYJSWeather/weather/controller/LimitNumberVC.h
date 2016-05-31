//
//  LimitNumberVC.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  限号
 */
@interface LimitNumberVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray * array;
@property (weak, nonatomic) IBOutlet UILabel *number; // 限行车牌号
@property (weak, nonatomic) IBOutlet UILabel *week; // 星期
@property (weak, nonatomic) IBOutlet UILabel *limitTime; // 限行时间


@property (weak, nonatomic) IBOutlet UILabel *city; // 城市
@property (weak, nonatomic) IBOutlet UILabel *max_min_temp; // 最大最小温度
@property (weak, nonatomic) IBOutlet UILabel *weather_txt; // 天气描述
@property (weak, nonatomic) IBOutlet UILabel *wind; // 风向风力
@property (weak, nonatomic) IBOutlet UILabel *suntime; //日出日落时间

@end
