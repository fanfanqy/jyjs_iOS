//
//  WeekView.m
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/5/20.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "WeekView.h"
@implementation WeekView

-(void)drawRect:(CGRect)rect
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    CGContextRef context = UIGraphicsGetCurrentContext();
    /**
     星期列表label
     */
    NSMutableArray* array = [[NSMutableArray alloc]initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    for (int i = 0; i < 7; i++) {

        CGContextSetFillColorWithColor(context,
                                       [UIColor blackColor].CGColor);
        for (int i =0; i<[array count]; i++) {
            NSString *weekdayValue = (NSString *)[array objectAtIndex:i];
            UIColor *weekdayValueColor = UIColorFromRGB(0x000000);
            [weekdayValueColor set];
            [weekdayValue drawInRect:CGRectMake(i*CALENDARBTNPADDING * 2 + 0.5 * CALENDARBTNPADDING+0.5 * CALENDARBTNPADDING,  TOPBUTTONHEIGHT, CALENDARBTNPADDING, CALENDARBTNPADDING) withFont:[UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERFOUR] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        }
    }
}

@end
