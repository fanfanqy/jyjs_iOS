//
//  CalendarCollectionViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "CalendarCollectionViewCell.h"

#define ruyibar_left 45.36
#define yi_ji_image_width 23.66
#define yi_ji_image_height 26.33


@interface CalendarCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *yi_image;
@property (weak, nonatomic) IBOutlet UIImageView *ji_image;

@end

@implementation CalendarCollectionViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"主页图- Assistor"];
    [self.contentView addSubview:imageView];
    [self.contentView insertSubview:imageView belowSubview:_yi_image];

    [self.goodTime sizeToFit];
    [self.fierceTime sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
















@end
