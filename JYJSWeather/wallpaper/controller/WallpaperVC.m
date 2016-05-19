//
//  WallpaperVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/2/25.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "WallpaperVC.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

#import "WallpaperCVCell.h"
#import "SinglePaperVC.h"

@interface WallpaperVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic , strong) NSMutableArray *pictureArray; // 图片数组
@property (nonatomic , strong) UICollectionView *wallpaperCollection;

@end

@implementation WallpaperVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pictureArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatPictureArray];
    [self creatWallpaper];
    
 
}
- (void)creatPictureArray
{
    for (int i = 1 ; i <= wallpaperInfoNumber; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.png", i];
        [self.pictureArray addObject:imageName];
    }
}
- (void)creatWallpaper
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    CGFloat width = self.view.frame.size.width /2;
    CGFloat height = self.view.frame.size.height/2;
    flow.itemSize = CGSizeMake(width, height);
    flow.minimumLineSpacing = 0; // 行
    flow.minimumInteritemSpacing = 0; //列
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.wallpaperCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:flow];
    self.wallpaperCollection.delegate = self;
    self.wallpaperCollection.dataSource = self;
    [self.view addSubview:self.wallpaperCollection];
    UINib *cell = [UINib nibWithNibName:@"WallpaperCVCell" bundle:nil ];
    [self.wallpaperCollection registerNib:cell forCellWithReuseIdentifier:@"wallpapercell"];
    [self.wallpaperCollection registerClass:[WallpaperCVCell class] forCellWithReuseIdentifier:@"wallpapercell"];
    self.wallpaperCollection.backgroundColor = [UIColor whiteColor];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallpaperCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wallpapercell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    cell.wallpaper.image = [UIImage imageNamed:[self.pictureArray objectAtIndex:indexPath.row]];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pictureArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WallpaperCVCell *cell = (WallpaperCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    SinglePaperVC *singlePaper = [[SinglePaperVC alloc]init];
    singlePaper.image = cell.wallpaper.image;
    
    [self.navigationController pushViewController:singlePaper animated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    CGRect naviFrame = self.navigationController.navigationBar.frame;
    naviFrame.origin.x = 0;
    self.navigationController.navigationBar.frame = naviFrame;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CGRect naviFrame = self.navigationController.navigationBar.frame;
    naviFrame.origin.x = 0;
    self.navigationController.navigationBar.frame = naviFrame;
}
@end
