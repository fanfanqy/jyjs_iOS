//
//  WanNianLiDate.m
//  FaLv
//
//  Created by mac on 14-12-5.
//  Copyright (c) 2014年 xjkjmac01. All rights reserved.
//

#import "WanNianLiDate.h"
#import "ZipArchive.h"
@implementation WanNianLiDate

+ (FMDatabase*) getDataBase
{
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseDoc = [rootPath stringByAppendingPathComponent:@"FaLv"];
    NSString *databasePath = [databaseDoc stringByAppendingPathComponent:[NSString stringWithFormat:FALVCALENDARDB]];
    NSLog(@"databasePath:%@",databasePath);
    if(![[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        NSArray* arr = [FALVCALENDAR componentsSeparatedByString:@"."];
        databasePath = [[NSBundle mainBundle] pathForResource:[arr objectAtIndex:0] ofType:[arr objectAtIndex:1]];
        
        ZipArchive* zipFile = [[ZipArchive alloc] init];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            if([zipFile UnzipOpenFile:databasePath])
            {
                BOOL ret = [zipFile UnzipFileTo:databaseDoc overWrite:YES];
                if(ret)
                {
                     NSLog(@"解压成功");
                }else
                {
                    NSLog(@"解压失败");
                }
                [zipFile UnzipCloseFile];
            }
        });
    }
    
    FMDatabase* database=[FMDatabase databaseWithPath:databasePath];
    if (![database open]) {
        return nil;
    }
    return  database;
}


@end
