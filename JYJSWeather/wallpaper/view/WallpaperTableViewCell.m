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
#import "Image_Model.h"
#import "UIImageView+WebImage.h"


#define Image_height 354.0
#define Image_width 360.0

@interface WallpaperTableViewCell ()

@end

@implementation WallpaperTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.array = [NSMutableArray array];
        self.otherArray = [NSMutableArray array];
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self.contentView addSubview:self.collectionView];
 
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [self.collectionView registerClass:[WallpaperCollectionViewCell class] forCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.pagingEnabled = YES;
        
        // footerImage 主页壁纸模块下方的小图
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.otherCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
        [self.contentView addSubview:self.otherCollectionView];
        self.otherCollectionView.backgroundColor = [UIColor greenColor];
        self.otherCollectionView.delegate = self;
        self.otherCollectionView.dataSource = self;

        [self.otherCollectionView registerClass:[WallpaperCollectionViewCell class] forCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELLlittle"];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = [UIScreen mainScreen].bounds;
    self.collectionView.frame = CGRectMake(0, 0, frame .size.width, self.contentView.frame.size.height);
    UICollectionViewFlowLayout *flow  = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flow.itemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    flow.minimumLineSpacing = 0;
    
    
    CGFloat height = Image_height/Image_width * self.contentView.frame.size.width/4.0;
    self.otherCollectionView.frame = CGRectMake(0, self.contentView.frame.size.height - height, self.contentView.frame.size.width, height);
    UICollectionViewFlowLayout *flowLayout  = (UICollectionViewFlowLayout *)self.otherCollectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(self.contentView.frame.size.width/4.0, height);
    flowLayout.minimumLineSpacing = 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionView]) {
        return self.array.count;
    } else {
        return self.otherArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NarrrowWallpaperCollectionViewCell * cell = nil;
    if ([collectionView isEqual:self.collectionView]) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELL" forIndexPath:indexPath];
        cell.imageview.image = [UIImage imageNamed:@"4.png"];
        Image_Model * model = [self.array objectAtIndex:indexPath.row];
        NSLog(@"%@", model.url);
        NSString * str = [NSString stringWithFormat:@"%@?token=%@&url=%@", wallPaperImage,Token,model.url];
        NSURL * url = [NSURL URLWithString:str];
        [cell.imageview setImageWithURL:url placeholderImage:nil];

    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WALLPAPERCOLLECTIONVIEWCELLlittle" forIndexPath:indexPath];
        cell.imageview.image = [UIImage imageNamed:@"little_4.png"];
        Image_Model * model = [self.otherArray objectAtIndex:indexPath.row];
        NSString * str = [NSString stringWithFormat:@"%@?token=%@&url=%@", wallPaperImage,Token,model.url];
        NSURL * url = [NSURL URLWithString:str];
        
        [cell.imageview setImageWithURL:url placeholderImage:nil];


    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallpaperVC *wallpaper = [[WallpaperVC alloc]init];
    wallpaper.pictureArray = self.array;
    [self.viewControllerDelegate.navigationController pushViewController:wallpaper animated:YES];
}
@end
