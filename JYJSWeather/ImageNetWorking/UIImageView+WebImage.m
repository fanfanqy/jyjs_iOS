//
//  UIImageView+WebImage.m
//  TestGet
//
//  Created by DEV-IOS-2 on 16/5/25.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "ImageNetWorking.h"


@implementation UIImageView (WebImage)

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    
    NSString * fileName = url.absoluteString;
    NSArray * array = [fileName componentsSeparatedByString:@"url="];
    fileName = [array lastObject];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [a lastObject];
    path = [NSString stringWithFormat:@"%@/images", path];
    path = [NSString stringWithFormat:@"%@/%@", path,fileName];
    
    NSLog(@"path = %@", path);
    
    BOOL isHasFile=[manager fileExistsAtPath:path];
    if (isHasFile) {
        NSData * data = [self getimageWithUrl:url]; //为真表示已经请求过这个文件,可以直接读取
        [self setImageData:data];
        NSLog(@"请求过这个图片");
    }else{
        //没有请求过这个图片
        NSLog(@"未请求过");
        [self handleImageWithUrl:url];
    }
}
// 从网络获取图片
- (void)handleImageWithUrl:(NSURL *)url
{
    NSLog(@"%@", url.absoluteString);
    [ImageNetWorking handleImageWithURL:url FinishBlock:^(NSData *data) {
        [self saveImageWithUrl:url ImageData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self setImageData:data];
            
        });

    }];
}
// 将图片存入本地
- (void)saveImageWithUrl:(NSURL *)url ImageData:(NSData *)data
{
    NSString * fileName = url.absoluteString;
    NSArray * array = [fileName componentsSeparatedByString:@"url="];
    fileName = [array lastObject];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [a lastObject];
    path = [NSString stringWithFormat:@"%@/images", path];
    
    BOOL isHasFile=[manager fileExistsAtPath:path];
    if (!isHasFile) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [NSString stringWithFormat:@"%@/%@", path,fileName];
    
    [data writeToFile:path atomically:YES];
}
// 从本地读取图片
- (NSData *)getimageWithUrl:(NSURL *)url
{
    NSString * fileName = url.absoluteString;
    NSArray * array = [fileName componentsSeparatedByString:@"url="];
    fileName = [array lastObject];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *a = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [a lastObject];
    path = [NSString stringWithFormat:@"%@/images", path];
    path = [NSString stringWithFormat:@"%@/%@", path,fileName];

    NSData * data = [NSData dataWithContentsOfFile:path];
    return data;

}

- (void)setImageData:(NSData *)data
{
    self.image = [UIImage imageWithData:data];
}

@end
