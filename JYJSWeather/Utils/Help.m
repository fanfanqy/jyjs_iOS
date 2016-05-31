//
//  Help.m
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/5/30.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "Help.h"
#define APP_URL  @"https://itunes.apple.com/lookup?bundleId=com.falv.xjkj"
@interface Help()<UIAlertViewDelegate>

@end
@implementation Help
-(void)versionCheckUpdate{

NSURL *url = [NSURL URLWithString:APP_URL];
NSURLRequest *request = [NSURLRequest requestWithURL:url];
NSURLSession *session = [NSURLSession sharedSession];
NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更UI
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *results = [dic objectForKey:@"results"];
            NSDictionary *finalDic = [results firstObject];
            // 解析请求到的JSon
            // 获取APP下载地址
            NSString *trackViewUrl = [finalDic objectForKey:@"trackViewUrl"];
            NSLog(@"trackViewUrl:%@",trackViewUrl);
            // 获取官网APP的版本号
            NSString *str1 = [finalDic objectForKey:@"version"];
            //eg str1:2.1.1, str2:2.1.0
            NSString *versionStr1 = [str1 substringWithRange:NSMakeRange(0, 1)];
            NSString *versionStr2 = [str1 substringWithRange:NSMakeRange(2, 3)];

            // 将版本号字符串转换成float类型
            float versionStr1Float = [versionStr1 floatValue];
            float versionStr2Float = [versionStr2 floatValue];

            // 获取本地项目版本号
            // 拿到项目的infoPlist文件中所有内容
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            // 获取到当前工程版本号
            NSString *str2 = [infoDict objectForKey:@"CFBundleShortVersionString"];
            NSString *bundleVersionStr1 = [str2 substringWithRange:NSMakeRange(0, 1)];
            NSString *bundleVersionStr2 = [str2 substringWithRange:NSMakeRange(2, 3)];

            // 将版本号字符串转换成float类型
            float bundleVersionStr1Float = [bundleVersionStr1 floatValue];
            float bundleVersionStr2Float = [bundleVersionStr2 floatValue];
            NSLog(@"versionFloat:%f,%f,%f,%f",versionStr1Float,versionStr2Float,bundleVersionStr1Float,bundleVersionStr2Float);
            // 对比两处版本号
            if (versionStr1Float > bundleVersionStr1Float) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本可用,请安装更新" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"暂不更新",nil];
                alert.tag = 101;
                alert.delegate = self;
                [alert show];

            }else {
                if (versionStr2Float > bundleVersionStr2Float) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新版本可用,请安装更新" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"暂不更新",nil];
                    alert.tag = 101;
                    alert.delegate = self;
                    [alert show];


                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"版本已最新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    alert.tag = 102;
                    alert.delegate = self;
                    [alert show];
                }
            }

        });

    }
    else{
        NSLog(@"%@",error.description);
    }
}];
[task resume];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    NSLog(@"buttonIndex:%lu",buttonIndex);//0:更新,1:暂不更新
    NSLog(@"%lu",alertView.tag);
    if(alertView.tag==102){
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if(alertView.tag == 101){
    if(buttonIndex == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/qq/id444934666?mt=8"]];
    }else{
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    }
}

@end
