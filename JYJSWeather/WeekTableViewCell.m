//
//  WeekTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "WeekTableViewCell.h"
#import "WeekCollectionCell.h"
#import "WeatherModel.h"



@implementation WeekTableViewCell

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
        UINib *nib = [UINib nibWithNibName:@"WeekCollectionCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"WEEKCOLLECTIONCELL"];
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
    ff.itemSize = CGSizeMake(self.collectionView.frame.size.width/5-1, self.collectionView.frame.size.height);
    ff.minimumLineSpacing = 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return weatherDays;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeekCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEEKCOLLECTIONCELL" forIndexPath:indexPath];
    WeatherModel * model = [self.array objectAtIndex:indexPath.row];
    cell.maxtemp.text = [NSString stringWithFormat:@"%@˚", model.maxtemp];
    cell.mintemp.text = [NSString stringWithFormat:@"%@˚", model.mintemp];
    cell.week.text = model.week;
    cell.date.text = [NSString stringWithFormat:@"%ld/%ld", model.month, model.day];
    cell.weather_txt.text = model.weather_txt;
    cell.directionOfwind.text = model.directionOfwind;
    
    
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day_weather" ofType:@"plist"];
    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSDictionary * dictionary = [dic objectForKey:model.icon];
    cell.weather_image.image = [UIImage imageNamed:[dictionary objectForKey:@"icon"]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectItemAtIndexPath:indexPath];
}
@end
