//
//  NarrowWeatherTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "NarrowWeatherTableViewCell.h"
#import "NarrowWeatherCollectionViewCell.h"
#import "WeatherInsidePagesVC.h"
#import "WeatherModel.h"

@interface NarrowWeatherTableViewCell ()
{
    NSString * tomorrow;
    NSString * dayAfterTomorrow;
}
@end

@implementation NarrowWeatherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        tomorrow = @"明天";
        dayAfterTomorrow = @"后天";
        self.array = [NSMutableArray array];
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"NarrowWeatherCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"NARROWWEATHERCOLLECTIONCELL"];
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
    ff.minimumLineSpacing = 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NarrowWeatherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NARROWWEATHERCOLLECTIONCELL" forIndexPath:indexPath];
    
    WeatherModel * model = [self.array objectAtIndex:indexPath.row];
    cell.max_mintemp.text = [NSString stringWithFormat:@"%@/%@˚", model.maxtemp, model.mintemp];
    
    cell.windAndwet.text = [NSString stringWithFormat:@"%@|%ld%%",model.directionOfwind, (long)model.humidity];
    cell.weather_txt.text = model.weather_txt;
    // 是否有当前温度
    if (model.nowtemp) {
        cell.nowtemp.text = [NSString stringWithFormat:@"%@˚", model.nowtemp];
        cell.nowtemp.font = [UIFont systemFontOfSize:45];
    }else{
        cell.nowtemp.text = [NSString stringWithFormat:@"%@/%@˚", model.maxtemp,model.mintemp];
        cell.nowtemp.font = [UIFont systemFontOfSize:25];
    }
    // 改变下标题日期
    if (indexPath.row < self.array.count - 1) {
        WeatherModel * leftModel = [self.array objectAtIndex:(indexPath.row + 1)];
        cell.date_left.text = [NSString stringWithFormat:@"%ld/%ld", leftModel.month, leftModel.day];
        cell.max_mintemp_left.text = [NSString stringWithFormat:@"%@/%@˚", leftModel.maxtemp, leftModel.mintemp];
    }else{
        cell.date_left.text = @"";
        cell.max_mintemp_left.text = @"";
    }
    if (indexPath.row < self.array.count - 2) {
        WeatherModel * rightModel = [self.array objectAtIndex:(indexPath.row + 2)];
        cell.date_right.text = [NSString stringWithFormat:@"%ld/%ld", rightModel.month, rightModel.day];
        cell.max_mintemp_right.text = [NSString stringWithFormat:@"%@/%@˚", rightModel.maxtemp, rightModel.mintemp];
    }else{
        cell.date_right.text = @"";
        cell.max_mintemp_right.text = @"";
    }
    
    if (indexPath.row == 0) {
        cell.date_left.text = tomorrow;
        cell.date_right.text = dayAfterTomorrow;
    }
    if (indexPath.row == 1) {
        cell.date_left.text = dayAfterTomorrow;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherInsidePagesVC * weatherInsidePagesVC = [[WeatherInsidePagesVC alloc]init];
    weatherInsidePagesVC.array = self.array;
    [self.viewControllerDelegate.navigationController pushViewController:weatherInsidePagesVC animated:YES];
}

@end
