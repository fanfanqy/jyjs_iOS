//
//  IndexButton.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "IndexButton.h"
#define gap 20.0 // 间距
#define leading 35.0 // 视图距左右边框距离


@implementation IndexButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconImageView = [[UIImageView alloc]init];
        [self addSubview:self.iconImageView];
        
        self.title = [[UILabel alloc]init];
        [self addSubview:self.title];
        self.title.font = [UIFont systemFontOfSize:18];
        self.title.textAlignment = NSTextAlignmentRight;
        
        self.index = [[UILabel alloc]init];
        [self addSubview:self.index];
        self.index.font = [UIFont systemFontOfSize:16];
        self.index.textAlignment = NSTextAlignmentRight;
        
        self.title.textColor = [UIColor whiteColor];
        self.index.textColor = [UIColor whiteColor];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = [UIColor colorWithRed:97/255.0f green:184/255.0f blue:207/255.0f alpha:1];
    }
    return self;
}
// 子视图重新布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGSize size = self.iconImageView.image.size;
    CGFloat imaWidth = size.width / size.height * (frame.size.height - gap*2);
    self.iconImageView.frame = CGRectMake(leading,gap , imaWidth, frame.size.height - gap * 2);
    
    self.title.frame = CGRectMake(self.iconImageView.frame.origin.x + imaWidth, gap, frame.size.width - leading * 2 - self.iconImageView.frame.size.width, (frame.size.height - 2 * gap) / 2);
    
    self.index.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y + self.title.frame.size.height , self.title.frame.size.width, self.title.frame.size.height);
    
}

@end
