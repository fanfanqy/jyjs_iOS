//
//  Image_Model.h
//  TestGet
//
//  Created by DEV-IOS-2 on 16/5/25.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image_Model : NSObject
@property (nonatomic , strong) NSString * thumbUrl;
@property (nonatomic , assign) NSInteger iD;
@property (nonatomic , assign) NSInteger nameHash;
@property (nonatomic , strong) NSString * name;
@property (nonatomic , strong) NSDate * publishDateUtc;
@property (nonatomic , strong) NSDate * createDateUtc;
@property (nonatomic , strong) NSString * url;
@property (nonatomic , assign) NSInteger width;
@property (nonatomic , assign) NSInteger height;
@property (nonatomic , assign) BOOL isPortrait;
@property (nonatomic , strong) NSString * type;
@property (nonatomic , strong) NSString * categories;
@property (nonatomic , strong) NSString * itdescription;
@property (nonatomic , strong) id Labels;
@property (nonatomic , assign) NSInteger stat_Download;
@property (nonatomic , assign) NSInteger stat_Rate;
@property (nonatomic , assign) NSInteger stat_Vote;
@end
