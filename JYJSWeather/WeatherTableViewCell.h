//
//  WeatherTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface WeatherTableViewCell : BaseTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *array;
@end
