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
#import "WeatherModel.h"


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
    NSLog(@"%ld", self.array.count);
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WeatherModel * model = [self.array objectAtIndex:indexPath.row];
    
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day_weather" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSDictionary * dictionary = [dic objectForKey:model.icon];
    
    WeatherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEATHERCOLLECTIONCELL" forIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[dictionary objectForKey:@"background"]]];
    
    UIImage * image = [UIImage imageNamed:[dictionary objectForKey:@"background"]];
    cell.contentView.layer.contents = (id)image.CGImage;
    
    cell.mirror.image = [UIImage imageNamed:[dictionary objectForKey:@"mirror"]];
    cell.person.image = [UIImage imageNamed:[dictionary objectForKey:@"person"]];
    cell.max_mintemp.text = [NSString stringWithFormat:@"%@/%@˚", model.maxtemp, model.mintemp];
    cell.week.text = model.week;
    cell.date.text = [NSString stringWithFormat:@"%ld月%ld日", model.month, model.day];
    cell.weather_txt.text = model.weather_txt;
    if (model.nowtemp) {
        cell.nowtemp.text = [NSString stringWithFormat:@"%@˚", model.nowtemp];
    }else{
        cell.nowtemp.text = @"";
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.viewControllerDelegate isKindOfClass:[RootViewController class]]) {
        
        WeatherInsidePagesVC * weatherInsidePagesVC = [[WeatherInsidePagesVC alloc]init];
        weatherInsidePagesVC.array = self.array;
        [self.viewControllerDelegate.navigationController pushViewController:weatherInsidePagesVC animated:YES];
    }
}

@end
