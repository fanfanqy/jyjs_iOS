//
//  IndexViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "IndexViewController.h"
#import "WeatherModel.h"

#import "IndexCollectionViewCell_down.h"


@interface IndexViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat indexpath;
}
@end

@implementation IndexViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFlowLayout];
    indexpath = 0;
    [self handleSunTime:0];

    [self setbackgroundImage];
}
- (void)handleSunTime:(NSInteger)index
{
    WeatherModel * model = [self.array objectAtIndex:index];
    self.max_min_temp.text = [NSString stringWithFormat:@"温度范围:%@~%@˚", model.mintemp, model.maxtemp ];
    self.weather_txt.text = [NSString stringWithFormat:@"天气状况:%@", model.weather_txt];
    self.wind.text = [NSString stringWithFormat:@"风向风力:%@", model.directionOfwind];
    NSDate * risetime = model.riseTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *risetimeStr = [dateFormatter stringFromDate:model.riseTime];
    NSString * settimeStr = [dateFormatter stringFromDate:model.setTime];
    self.suntime.text = [NSString stringWithFormat:@"日出日落:%@~%@", risetimeStr, settimeStr];
}

- (void)setbackgroundImage
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.view addSubview:backgroundImage];
    backgroundImage.image = [UIImage imageNamed:@"2.png"];
    [self.view sendSubviewToBack:backgroundImage];
}

- (void)setFlowLayout
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = flow;
    UINib *nib = [UINib nibWithNibName:@"IndexCollectionViewCell_down" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"INDEXCOLLECTIONVIEWCELLDOWN"];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.sectionInset = UIEdgeInsetsZero;
    flow.itemSize = CGSizeMake(frame.size.width/3-1, self.collectionView.frame.size.height);
    NSLog(@":%f   %f",self.collectionView.frame.size.height , flow.itemSize.height);
    
    flow.minimumLineSpacing = 1;

    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return weatherDays;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherModel * model = [self.array objectAtIndex:indexPath.row];
    IndexCollectionViewCell_down * cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"INDEXCOLLECTIONVIEWCELLDOWN" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.date.text = [NSString stringWithFormat:@"今天\n%ld.%ld", (long)model.month, (long)model.day];
    }else if (indexPath.row == 1){
        cell.date.text = [NSString stringWithFormat:@"明天\n%ld.%ld", (long)model.month, (long)model.day];
    }else if (indexPath.row == 2) {
        cell.date.text = [NSString stringWithFormat:@"后天\n%ld.%ld", (long)model.month, (long)model.day];
    } else {
        cell.date.text = [NSString stringWithFormat:@"%ld.%ld", (long)model.month, (long)model.day];
    }
    if (indexpath == indexPath.row) {
        cell.downArrow.alpha = 1;
        
    } else {
        cell.downArrow.alpha = 0;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [collectionView visibleCells];
    for (IndexCollectionViewCell_down *cell in array) {
        cell.downArrow.alpha = 0;
    }
    IndexCollectionViewCell_down *cell = (IndexCollectionViewCell_down *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.downArrow.alpha = 1;
    indexpath = indexPath.row;
    
    [self handleSunTime:indexpath];
    
}

@end
