//
//  calendarYiJiView.m
//  FaLv
//
//  Created by han on 15/3/5.
//  Copyright (c) 2015年 xjkjmac01. All rights reserved.
//

#import "calendarYiJiView.h"

@implementation calendarYiJiView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        /**
         宜 部分
         */
        self.YiImage = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING * 0.65, 1.5 * PADDING, 20, 20)];
        _YiImage.image = [UIImage imageNamed:@"Yi.png"];
        [self addSubview:_YiImage];
//        self.YiLabel = [XBControl createLabelWithFrame:CGRectMake(_YiImage.frame.origin.x + 20 + 5, PADDING, ScreenWidth*0.5-_YiImage.frame.origin.x-25-5, 40)text:nil textColor:TEXTCOLORRED  font:13];
        self.YiLabel = [XBControl createLabelWithFrame:CGRectMake(_YiImage.frame.origin.x + 20 + 5, PADDING,130, 40)text:nil textColor:TEXTCOLORRED  font:13];

         NSLog(@"%@",[_YiLabel font]);
        NSLog(@"rect:%@", NSStringFromCGRect(self.YiLabel.frame));
        _YiLabel.backgroundColor = [UIColor clearColor];
        _YiLabel.numberOfLines = 0;
        [self addSubview:_YiLabel];

        /**
         忌 部分
         */
        self.JiImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 , 1.5 *PADDING, 20, 20)];
        _JiImage.image = [UIImage imageNamed:@"Ji.png"];
        [self addSubview:_JiImage];
        self.JiLabel = [XBControl createLabelWithFrame:CGRectMake(_JiImage.frame.origin.x + 20 + 5, PADDING, _YiLabel.frame.size.width, 40)text:nil textColor:UIColorFromRGB(0x72706b) font:13];
        NSLog(@"rect:%@", NSStringFromCGRect(self.YiLabel.frame));
        NSLog(@"%@",[_JiLabel font]);
        _JiLabel.numberOfLines = 0;
        _JiLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_JiLabel];

        /**
         *  节气部分
         *
         *  @param PADDING 间距
         *  @param 4       忌 Label的宽度的四分之一是节气Label宽度
         *  @param 20      节气Label高度
         *  @param solarLabel 节气标题
         *  @param solarDetailLabel 具体节气,eg:谷雨
        */
        self.solarLabel = [XBControl createLabelWithFrame:CGRectMake(PADDING, _YiLabel.frame.origin.y + _YiLabel.frame.size.height + 0.5 * PADDING, _JiLabel.frame.size.width / 4, 20) text:@"节气" textColor:UIColorFromRGB(0xd20000) font:13];
        _solarLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_solarLabel];
        self.solarDetailLabel = [XBControl createLabelWithFrame:CGRectMake(_solarLabel.frame.origin.x + _solarLabel.frame.size.width + 0.5 * PADDING, _YiLabel.frame.origin.y + _YiLabel.frame.size.height +0.5 * PADDING, _JiLabel.frame.size.width / 4 * 3, 20) text:@"夏至 18:22:16" textColor:UIColorFromRGB(0x303030) font:13];
        _solarDetailLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_solarDetailLabel];

        /**
         *  节日部分
         *  @param festivalLabel 节日标题
         *  @param festivalDetailLabel 节日详情,eg:国庆节
         */
        self.festivalLabel = [XBControl createLabelWithFrame:CGRectMake(_solarDetailLabel.frame.origin.x + _solarDetailLabel.frame.size.width + PADDING, _YiLabel.frame.origin.y + _YiLabel.frame.size.height + 0.5 * PADDING, _JiLabel.frame.size.width / 4, 20) text:@"节日" textColor:UIColorFromRGB(0xd20000) font:13];
        _festivalLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_festivalLabel];
        self.festivalDetailLabel = [XBControl createLabelWithFrame:CGRectMake(_festivalLabel.frame.origin.x + _festivalLabel.frame.size.width + 0.5 * PADDING, _YiLabel.frame.origin.y + _YiLabel.frame.size.height + 0.5* PADDING, _JiLabel.frame.size.width+40, 20) text:@"今天无节日" textColor:UIColorFromRGB(0x303030) font:13];
        _festivalDetailLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_festivalDetailLabel];
    }
    return self;
}

-(void)reloadDataOfYiJiView:(calendarDBModel *)model
{
    self.solarDetailLabel.text = [NSString stringWithFormat:@"%@ %@",model.jieQi,model.jieQiTime];
    self.festivalDetailLabel.text = [NSString stringWithFormat:@"%@ %@",model.gongLiJieRi,model.nongLIjieRi];
    if ([self.solarDetailLabel.text isEqualToString:@" "]) {
        self.solarLabel.hidden = YES;
        CGRect festivalFrame = self.festivalDetailLabel.frame;
        festivalFrame.origin.x = self.solarDetailLabel.frame.origin.x;
        [self.festivalDetailLabel setFrame:festivalFrame];
        CGRect frmae = self.festivalLabel.frame;
        frmae.origin.x = self.solarLabel.frame.origin.x;
        [self.festivalLabel setFrame:frmae];
    }else {
        self.solarLabel.hidden = NO;
        CGRect frmae = self.festivalLabel.frame;
        frmae.origin.x = self.solarDetailLabel.frame.origin.x + self.solarDetailLabel.frame.size.width + PADDING;
        [self.festivalLabel setFrame:frmae];
        CGRect festivalFrame = self.festivalDetailLabel.frame;
        festivalFrame.origin.x = self.festivalLabel.frame.origin.x + self.festivalLabel.frame.size.width + 0.5 * PADDING;
        [self.festivalDetailLabel setFrame:festivalFrame];
    }
    if ([self.festivalDetailLabel.text isEqualToString:@" "]) {
        self.festivalLabel.hidden = YES;
    }else {
        self.festivalLabel.hidden = NO;
    }
    
    if ([self.solarDetailLabel.text isEqualToString:@" "] && [self.festivalDetailLabel.text isEqualToString:@" "]) {
        CGRect frame = self.frame;
        frame.size.height = self.YiLabel.frame.origin.y + self.YiLabel.frame.size.height + PADDING;
        self.frame = frame;
    }else{
        CGRect frame = self.frame;
        frame.size.height = self.solarDetailLabel.frame.origin.y + self.solarDetailLabel.frame.size.height + PADDING;
        self.frame = frame;
    }
    
}

@end
