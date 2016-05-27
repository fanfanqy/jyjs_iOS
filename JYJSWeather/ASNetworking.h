//
//  ASNetworking.h
//  JYJS
//
//  Created by DEV-IOS-2 on 15/12/24.
//  Copyright © 2015年 DEV-IOS-2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASNetworking : NSObject

@property (nonatomic, strong)void (^finishBlock)(NSData * data);

+ (instancetype)ASNetURLconnectionWith:(NSString *)urlString type:(NSString *)type Parmaters:(NSDictionary *)parmaters FinishBlock:(void (^)(NSData * data))block;
- (void)handleWallPaperListWith:(NSString *)urlString minWidth:(NSInteger)minWidth maxWidth:(NSInteger)maxWidth minHeight:(NSInteger)minHeight maxHeight:(NSInteger)maxHeight hash:(NSInteger)hash token:(NSString *)token dateUtc:(NSDate *)dateUtc FinishBlock:(void (^)(NSData * data))block;
- (void)handleWallPaperList;
@end
