//
//  WallpaperTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "WallpaperTableViewCell.h"
#import "NarrrowWallpaperCollectionViewCell.h"
#import "WallpaperCollectionViewCell.h"
#import "WallpaperVC.h"

#define Image_height 354.0
#define Image_width 360.0

@interface WallpaperTableViewCell ()

@end

@implementation WallpaperTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundArray = [NSMutableArray array];
        self.footerArray = [NSMutableArray array];
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.backgroundCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self.contentView addSubview:self.backgroundCollectionView];
        self.backgroundCollectionView.backgroundColor = [UIColor redColor];
        self.backgroundCollectionView.delegate = self;
        self.backgroundCollectionView.dataSource = self;
        
        [self.backgroundCollectionView registerClass:[WallpaperCollectionViewCell class] forCellWithReuseIdentifier:@"WALLPAPERTABLEVIEWCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.backgroundCollectionView.pagingEnabled = YES;
        
        // footerImage 主页壁纸模块下方的小图
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.footerCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        [self.contentView addSubview:self.footerCollectionView];
        self.footerCollectionView.backgroundColor = [UIColor whiteColor];
        self.footerCollectionView.delegate = self;
        self.footerCollectionView.dataSource = self;

        [self.footerCollectionView registerClass:[WallpaperCollectionViewCell class] forCellWithReuseIdentifier:@"WALLPAPERTABLEVIEWCELLlittle"];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = [UIScreen mainScreen].bounds;
    self.backgroundCollectionView.frame = CGRectMake(0, 0, frame .size.width, self.contentView.frame.size.height);
    UICollectionViewFlowLayout *flow  = (UICollectionViewFlowLayout *)self.backgroundCollectionView.collectionViewLayout;
    flow.itemSize = CGSizeMake(self.backgroundCollectionView.frame.size.width, self.backgroundCollectionView.frame.size.height);
    flow.minimumLineSpacing = 0;
    
    
    CGFloat height = Image_height/Image_width * self.contentView.frame.size.width/4.0;
    self.footerCollectionView.frame = CGRectMake(0, self.contentView.frame.size.height - height, self.contentView.frame.size.width, height);
    UICollectionViewFlowLayout *flowLayout  = (UICollectionViewFlowLayout *)self.footerCollectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.contentView.frame.size.width/4.0, height);
    flowLayout.minimumLineSpacing = 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return wallpaperInfoNumber;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NarrrowWallpaperCollectionViewCell * cell = nil;
    if ([collectionView isEqual:self.backgroundCollectionView]) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WALLPAPERTABLEVIEWCELL" forIndexPath:indexPath];
        cell.imageview.image = [UIImage imageNamed:@"4.png"];
        NSLog(@"%lu", indexPath.row);
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WALLPAPERTABLEVIEWCELLlittle" forIndexPath:indexPath];
        cell.imageview.image = [UIImage imageNamed:@"little_4.png"];
        NSLog(@"%lu", indexPath.row);

    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallpaperVC *wallpaper = [[WallpaperVC alloc]init];
    [self.viewControllerDelegate.navigationController pushViewController:wallpaper animated:YES];
}
@end
