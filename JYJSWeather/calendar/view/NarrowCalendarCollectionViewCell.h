//
//  NarrowCalendarCollectionViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NarrowCalendarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *luckyImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunarCalendarLabel;
@property (weak, nonatomic) IBOutlet UILabel *haircutLabel;
@property (weak, nonatomic) IBOutlet UILabel *appropriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *avoidLabel;
@property (weak, nonatomic) IBOutlet UILabel *memorialDayLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xingxiuLabel;
@property (weak, nonatomic) IBOutlet UILabel *chongAnimalLabel;
@property (weak, nonatomic) IBOutlet UILabel *festivalLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *badtimeLabel;

@end
