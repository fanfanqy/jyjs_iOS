//
//  WeatherTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import "WeatherCollectionViewCell.h"
#import "WeatherInsidePagesVC.h"
#import "RootViewController.h"


@implementation WeatherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.array = [NSMutableArray array];
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"WeatherCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"WEATHERCOLLECTIONCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.pagingEnabled = YES;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect fream = [UIScreen mainScreen].bounds;
    self.collectionView.frame = CGRectMake(0, 0, fream.size.width, self.contentView.frame.size.height);
    UICollectionViewFlowLayout *ff  = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    ff.itemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    NSLog(@"self.collectionView.frame.size.width:%f",self.collectionView.frame.size.width);
    ff.minimumLineSpacing = 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEATHERCOLLECTIONCELL" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"晴 - 主页Assistor.png"]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.viewControllerDelegate isKindOfClass:[RootViewController class]]) {
        
        WeatherInsidePagesVC * weatherInsidePagesVC = [[WeatherInsidePagesVC alloc]init];
        [self.viewControllerDelegate.navigationController pushViewController:weatherInsidePagesVC animated:YES];
    }
}

@end
