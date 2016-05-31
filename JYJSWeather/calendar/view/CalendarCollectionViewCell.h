//
//  CalendarCollectionViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *right_up_image;
@property (weak, nonatomic) IBOutlet UILabel        *date;
@property (weak, nonatomic) IBOutlet UILabel        *lunarCalendar; // 阴历
@property (weak, nonatomic) IBOutlet UILabel        *week;
@property (weak, nonatomic) IBOutlet UIImageView    *ruyiBar; // 如意栏
@property (weak, nonatomic) IBOutlet UILabel        *goodOccasion; // 吉时,时辰(丙申年 壬辰月 癸酉日 丁巳时)
@property (weak, nonatomic) IBOutlet UILabel        *doSomething; // 理发 精进于佛法,最好

@property (weak, nonatomic) IBOutlet UILabel *approprite;

@property (weak, nonatomic) IBOutlet UILabel *avoid;

@property (weak, nonatomic) IBOutlet UILabel        *memorialDay; // 各种佛祖生日

@property (weak, nonatomic) IBOutlet UILabel        *collision; // 冲撞
@property (weak, nonatomic) IBOutlet UILabel        *goodTime; // 吉时
@property (weak, nonatomic) IBOutlet UILabel        *fierceTime; // 凶时


@end
