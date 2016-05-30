//
//  IndexTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "IndexTableViewCell.h"
#import "IndexViewController.h"
#import "LimitNumberVC.h"



@implementation IndexTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dress = [[IndexButton alloc]init];
        [self.contentView addSubview:self.dress];
        self.dress.iconImageView.image = [UIImage imageNamed:@"T-shirt - Assistor.png"];
        self.dress.index.text = @"穿衣";
        [self.dress addTarget:self action:@selector(index:) forControlEvents:UIControlEventTouchUpInside];
        
        self.washCar = [[IndexButton alloc]init];
        [self.contentView addSubview:self.washCar];
        self.washCar.iconImageView.image = [UIImage imageNamed:@"洗车图标 - Assistor.png"];
        self.washCar.index.text = @"洗车";
        [self.washCar addTarget:self action:@selector(index:) forControlEvents:UIControlEventTouchUpInside];
        
        self.limitNumber = [[IndexButton alloc]init];
        [self.contentView addSubview:self.limitNumber];
        self.limitNumber.iconImageView.image = [UIImage imageNamed:@"限行 - Assistor.png"];
        self.limitNumber.index.text = @"限号车牌";
        [self.limitNumber addTarget:self action:@selector(limitNumberAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.ultraviolet = [[IndexButton alloc]init];
        [self.contentView addSubview:self.ultraviolet];
        self.ultraviolet.iconImageView.image = [UIImage imageNamed:@"紫外线- Assistor.png"];
        self.ultraviolet.index.text = @"紫外线";
        [self.ultraviolet addTarget:self action:@selector(index:) forControlEvents:UIControlEventTouchUpInside];
        
        self.dress.title.text = @"暖";
        self.washCar.title.text = @"不宜";
        self.limitNumber.title.text = @"4-6";
        self.ultraviolet.title.text = @"最弱";

    }
    return self;
}
- (void)setArray:(NSMutableArray *)array
{
    if (_array != array) {
        _array = array;
        
        // 对指数进行赋值
//        self.dress.title.text = @"暖";
//        self.washCar.title.text = @"不宜";
//        self.limitNumber.title.text = @"4-6";
//        self.ultraviolet.title.text = @"最弱";
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    self.dress.frame = CGRectMake(0, 0, frame.size.width/2, frame.size.height/2);
    self.washCar.frame = CGRectMake(0, frame.size.height/2, frame.size.width/2, frame.size.height/2);
    self.limitNumber.frame = CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height/2);
    self.ultraviolet.frame = CGRectMake(frame.size.width/2, frame.size.height/2, frame.size.width/2, frame.size.height/2);
}

- (void)index:(IndexButton *)button
{
    IndexViewController * indexVC = [[IndexViewController alloc]initWithNibName:@"IndexViewController" bundle:nil];
    indexVC.title = button.index.text;
    [self.viewControllerDelegate.navigationController pushViewController:indexVC animated:YES];
}
- (void)limitNumberAction:(IndexButton *)button
{
    
    LimitNumberVC * limitNumberVC = [[LimitNumberVC alloc]initWithNibName:@"LimitNumberVC" bundle:nil];
    limitNumberVC.title = button.index.text;
    [self.viewControllerDelegate.navigationController pushViewController:limitNumberVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
