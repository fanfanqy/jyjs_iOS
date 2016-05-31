//
//  BaseTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell
@property (nonatomic , assign) NSInteger type;
@property (nonatomic , assign) CGFloat cellHeight;

@property (nonatomic , strong) UIViewController *viewControllerDelegate;

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UICollectionView * otherCollectionView;

@property (nonatomic , strong) NSMutableArray *array;
@property (nonatomic , strong) NSMutableArray *otherArray;

@end
