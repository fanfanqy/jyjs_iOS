//
//  ImageNetWorking.h
//  TestGet
//
//  Created by DEV-IOS-2 on 16/5/25.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageNetWorking : NSObject
@property (nonatomic, strong)void (^finishBlock)(NSData * data);
+ (instancetype)handleImageWithURL:(NSURL *)url FinishBlock:(void (^)(NSData * data))block;

@end
