//
//  IndexTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"


@interface IndexTableViewCell : UITableViewCell

@property (nonatomic , strong) IndexButton *dress; // 穿衣

@property (nonatomic , strong) IndexButton *washCar; // 洗车

@property (nonatomic , strong) IndexButton *limitNumber; // 限号

@property (nonatomic , strong) IndexButton *ultraviolet; // 紫外线

@property (nonatomic , strong) NSMutableArray *array;
@property (nonatomic , strong) UIViewController *viewControllerDelegate;

@end
