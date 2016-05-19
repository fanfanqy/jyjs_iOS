//
//  WallpaperTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface WallpaperTableViewCell : BaseTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView * backgroundCollectionView;

@property (nonatomic , strong) UICollectionView * footerCollectionView;

@property (nonatomic , strong) NSMutableArray *backgroundArray;

@property (nonatomic , strong) NSMutableArray *footerArray;

@end
