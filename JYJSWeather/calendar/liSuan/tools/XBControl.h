//
//  XBControl.h
//  历算
//
//  Created by han on 14/12/3.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XBControl : NSObject

+(UIView *)createViewWithFrame:(CGRect)frame backColor:(UIColor*)color;

+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(CGFloat)font;

+(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;
+(UIImageView *)createDivisionWithFrame:(CGRect)frame;
@end
