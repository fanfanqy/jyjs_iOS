//
//  CityNameTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/27.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "CityNameTableViewCell.h"
@implementation CityNameTableViewCell
CGFloat labelwidth = 80;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cityName = [[UILabel alloc]init];
        [self.contentView addSubview:self.cityName];
        
        self.comment = [[UILabel alloc]init];
        [self.contentView addSubview:self.comment];
        self.comment.textColor = [UIColor grayColor];

    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.comment.text isEqual:nil]) {
        self.cityName.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        self.comment.frame = CGRectMake(0, 0, 0, 0);
    }else{
        self.cityName.frame = CGRectMake(0, 0, self.contentView.frame.size.width-labelwidth, self.contentView.frame.size.height);
        self.comment.frame = CGRectMake(self.cityName.frame.size.width, 0, labelwidth, self.contentView.frame.size.height);
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
