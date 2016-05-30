//
//  timeCell.m
//  历算
//
//  Created by han on 14/12/5.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "timeCell.h"
#import "XBControl.h"

@implementation timeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _timeLabel = [XBControl createLabelWithFrame:CGRectMake(PADDING , 3, ScreenWidth * 0.5 - 3 * PADDING, 14) text:nil textColor:TEXTCOLORBLACK font:12];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _caiLabel = [XBControl createLabelWithFrame:CGRectMake((ScreenWidth * 0.5 + 7), 3,CALENDARBTNPADDING * 2 ,20) text:nil textColor:UIColorFromRGB(0xb3b3b3) font:14];
        _caiLabel.backgroundColor = [UIColor clearColor];

        _xiLabel = [XBControl createLabelWithFrame:CGRectMake((ScreenWidth * 0.5 + 7) + CALENDARBTNPADDING * 2, 3, CALENDARBTNPADDING * 2, 20) text:nil textColor:UIColorFromRGB(0xb3b3b3) font:14];
        _xiLabel.backgroundColor = [UIColor clearColor];
        _jiXiongLabel = [XBControl createLabelWithFrame:CGRectMake((ScreenWidth * 0.5 + 7) + CALENDARBTNPADDING * 4, 3, CALENDARBTNPADDING * 2, 20) text:nil textColor:UIColorFromRGB(0xb3b3b3) font:14];
        _jiXiongLabel.backgroundColor = [UIColor clearColor];
        if (SystemVersion >= 6.0) {
            _timeLabel.textAlignment = NSTextAlignmentCenter;
            _caiLabel.textAlignment = NSTextAlignmentCenter;
            _xiLabel.textAlignment = NSTextAlignmentCenter;
            _jiXiongLabel.textAlignment = NSTextAlignmentCenter;

        }else {
            _timeLabel.textAlignment = NSTextAlignmentCenter;
            _caiLabel.textAlignment = NSTextAlignmentCenter;
            _xiLabel.textAlignment = NSTextAlignmentCenter;
            _jiXiongLabel.textAlignment = NSTextAlignmentCenter;
        }
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_caiLabel];
        [self.contentView addSubview:_xiLabel];
        [self.contentView addSubview:_jiXiongLabel];
    }
    return self;
   
}

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
