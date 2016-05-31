//
//  IndexButton.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//
/*
  天气内页界面下方,天气指数按钮
 */

#import <UIKit/UIKit.h>

@interface IndexButton : UIButton

@property (nonatomic , strong) UIImageView *iconImageView;
@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UILabel *index;


@end
