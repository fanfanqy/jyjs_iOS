//
//  calendarYiJiView.h
//  FaLv
//
//  Created by han on 15/3/5.
//  Copyright (c) 2015年 xjkjmac01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calendarDBModel.h"
/**
 *  宜忌
 */
@interface calendarYiJiView : UIButton
@property (nonatomic,strong)UIImageView * YiImage;//宜图片
@property (nonatomic,strong)UILabel * YiLabel;//宜
@property (nonatomic,strong)UIImageView * JiImage;//忌图片
@property (nonatomic,strong)UILabel * JiLabel;//忌
@property (nonatomic,strong)UILabel * solarDetailLabel;//节气
@property (nonatomic,strong)UILabel * solarLabel;
@property (nonatomic,strong)UILabel * festivalDetailLabel;//节日
@property (nonatomic,strong)UILabel * festivalLabel;
-(void)reloadDataOfYiJiView:(calendarDBModel *)model;
@end
