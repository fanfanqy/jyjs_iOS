//
//  UIImageView+WebImage.h
//  TestGet
//
//  Created by DEV-IOS-2 on 16/5/25.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebImage)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
