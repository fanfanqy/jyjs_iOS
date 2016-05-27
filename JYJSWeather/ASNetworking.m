//
//  ASNetworking.m
//  JYJS
//
//  Created by DEV-IOS-2 on 15/12/24.
//  Copyright © 2015年 DEV-IOS-2. All rights reserved.
//

#import "ASNetworking.h"

@interface ASNetworking ()

@end

@implementation ASNetworking
+ (instancetype)ASNetURLconnectionWith:(NSString *)urlString type:(NSString *)type Parmaters:(NSDictionary *)parmaters FinishBlock:(void (^)(NSData * data))block;
{
    ASNetworking *asn = [[ASNetworking alloc]init];
    [asn startWithURLstring:urlString type:type parmaters:parmaters];
    asn.finishBlock = block;
    return asn;
                         
}
- (void)startWithURLstring:(NSString *)URLstring type:(NSString *)type parmaters:(NSDictionary *)parmaters
    {
        NSMutableURLRequest *request = nil;
        if ([type isEqualToString:@"POST"]) {
            NSLog(@"URL:%@", URLstring);
            NSURL *url = [NSURL URLWithString:URLstring];

            request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parmaters options:0 error:nil]];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        } else {
            
            NSString *par = @"";
            for (NSString *key in parmaters) {
                if ([par length] == 0) {
                    par = [NSString stringWithFormat:@"?%@=%@",key, [parmaters objectForKey:key]];
                }else
                {
                    par = [NSString stringWithFormat:@"%@&%@=%@", par, key, [parmaters objectForKey:key]];
                }
            }

            NSString * newUrlString = [NSString stringWithFormat:@"%@%@", URLstring, par];
            NSLog(@"URL:%@", newUrlString);
            NSURL *url = [NSURL URLWithString:newUrlString];
            
            request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"请求成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.finishBlock(data);
                    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"%@", string);
                });
            }else{
                NSLog(@"请求失败:%@", error);
            }
        }];
        [dataTask resume];

}

- (void)handleWallPaperListWith:(NSString *)urlString minWidth:(NSInteger)minWidth maxWidth:(NSInteger)maxWidth minHeight:(NSInteger)minHeight maxHeight:(NSInteger)maxHeight hash:(NSInteger)hash token:(NSString *)token dateUtc:(NSDate *)dateUtc FinishBlock:(void (^)(NSData * data))block
{
    self.finishBlock = block;
    if (!hash) {
        hash = 999;
    }
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    dateUtc = [NSDate dateWithTimeIntervalSince1970:date];
        // 返回的格林治时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // HH是24进制，hh是12进制
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date2 = [formatter dateFromString:@"1970-01-01"];
    NSString *string = [formatter stringFromDate:date2];
    
    NSString * par = [NSString stringWithFormat:@"%@?token='%@'&hash=%ld&updatedDateUtc='%@'&minWidth=%ld&maxWidth=%ld&minHeight=%ld&maxHeight=%ld",urlString, token, (long)hash, string,(long)minWidth,(long)maxWidth,(long)minHeight,(long)maxHeight];
    NSLog(@"%@", par);
    NSURL *url = [NSURL URLWithString:par];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"%@",request);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"壁纸列表请求完成");
            self.finishBlock(data);
        }else{
            NSLog(@"请求失败:%@", error);
        }
        
    }];
    [dataTask resume];
}

- (void)handleWallPaperList
{
    NSString * str = @"http://192.168.10.6:800/service/sq/wellpaper.asmx/getWellPaperList?token='asdf1234'&hash=999&updatedDateUtc='2016/05/07'&minWidth=1&maxWidth=10000&minHeight=1&maxHeight=10000";
    
    NSURL *url = [NSURL URLWithString:str];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"%@",request);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
            NSLog(@"%@", dic);
            
        }else{
            NSLog(@"请求失败:%@", error);
        }
        
    }];
    [dataTask resume];
}

@end
