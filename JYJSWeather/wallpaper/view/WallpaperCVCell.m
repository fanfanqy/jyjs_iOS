//
//  WallpaperCVCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/3/4.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "WallpaperCVCell.h"

@implementation WallpaperCVCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.wallpaper = [[UIImageView alloc]init];
        [self.contentView addSubview:self.wallpaper];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.wallpaper.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

@end
