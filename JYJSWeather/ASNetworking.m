//
//  ASNetworking.m
//  JYJS
//
//  Created by DEV-IOS-2 on 15/12/24.
//  Copyright © 2015年 DEV-IOS-2. All rights reserved.
//

#import "ASNetworking.h"

@interface ASNetworking ()
@property (nonatomic , copy) NSDictionary *parmaters;
@end

@implementation ASNetworking
+ (instancetype)ASNetURLconnectionWith:(NSString *)urlString type:(NSString *)type Parmaters:(NSDictionary *)parmaters FinishBlock:(void (^)(NSData * data))block;
{
    ASNetworking *asn = [[ASNetworking alloc]init];
    asn.parmaters = parmaters;
    [asn startWithURLstring:urlString type:type];
    asn.finishBlock = block;
    return asn;
                         
}
- (void)startWithURLstring:(NSString *)URLstring type:(NSString *)type
    {
        NSLog(@"URL:%@", URLstring);
        NSURL *url = [NSURL URLWithString:URLstring];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        if ([type isEqualToString:@"POST"]) {
          
            NSString *par = @"";
            for (NSString *key in self.parmaters) {
                if ([par length] == 0) {
                    par = [NSString stringWithFormat:@"%@=%@",key, [self.parmaters objectForKey:key]];
                }else
                {
                    par = [NSString stringWithFormat:@"%@&%@=%@", par, key, [self.parmaters objectForKey:key]];
                }
            }
            [request setHTTPMethod:type];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[par dataUsingEncoding:NSUTF8StringEncoding]];
            
        } else {
            
            [request setHTTPMethod:@"GET"];
        }
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                NSData *dd = [NSData dataWithData:data];
                self.finishBlock(dd);
            }else{
                NSLog(@"请求失败:%@", error);
            }
            
        }];
        [dataTask resume];
}



@end
