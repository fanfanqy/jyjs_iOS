//
//  XBControl.m
//  历算
//
//  Created by han on 14/12/3.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import "XBControl.h"

@implementation XBControl

+(UIView *)createViewWithFrame:(CGRect)frame backColor:(UIColor *)color
{
    UIView * view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:font];
    return label;
} 

+(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+(UIImageView *)createDivisionWithFrame:(CGRect)frame
{
    UIImageView * image = [[UIImageView alloc] initWithFrame:frame];
    image.image = [UIImage imageNamed:@"LiSuanPadding"];
    return image;
}
@end
