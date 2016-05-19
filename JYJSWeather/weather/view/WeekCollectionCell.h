//
//  WeekCollectionCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/11.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *date; // 日期
@property (weak, nonatomic) IBOutlet UIImageView *weather_image; // 天气图标
@property (weak, nonatomic) IBOutlet UILabel *weather_txt; // 天气描述文字
@property (weak, nonatomic) IBOutlet UILabel *maxtemp; // 最高温度
@property (weak, nonatomic) IBOutlet UIImageView *link_image; // 链接符
@property (weak, nonatomic) IBOutlet UILabel *mintemp; // 最低温度
@property (weak, nonatomic) IBOutlet UILabel *directionOfwind; // 风向
@property (weak, nonatomic) IBOutlet UILabel *sizeOfwind; //风力
@property (weak, nonatomic) IBOutlet UIImageView *pollution; // 污染

@end
