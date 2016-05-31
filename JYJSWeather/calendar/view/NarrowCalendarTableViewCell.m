//
//  NarrowCalendarTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "NarrowCalendarTableViewCell.h"
#import "NarrowCalendarCollectionViewCell.h"
//#import "CalendarVC.h"
#import "CalendarViewController1.h"
#import "CalendarMainPagesModel.h"
@implementation NarrowCalendarTableViewCell

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
        UINib *nib = [UINib nibWithNibName:@"NarrowCalendarCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"NARROWCALENDARCOLLECTIONVIEWCELL"];
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
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NarrowCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NARROWCALENDARCOLLECTIONVIEWCELL" forIndexPath:indexPath];
    CalendarMainPagesModel *calendarMainPagesModel = [[CalendarMainPagesModel alloc]init];
    calendarMainPagesModel = self.array[indexPath.row];
//吉凶平
//  cell.luckyImageView.image = [UIImage imageNamed:<#(nonnull NSString *)#>];
    cell.dateLabel.text = calendarMainPagesModel.solarStrArray[indexPath.row];
    cell.lunarCalendarLabel.text =calendarMainPagesModel.lunarStrArray[indexPath.row];
//丙申年 等等
//  cell.goodOccasion.text = calendarMainPagesModel.JiNianStrArray[indexPath.row];
    cell.haircutLabel.text = calendarMainPagesModel.HaircutStrArray[indexPath.row];
    cell.appropriteLabel.text = calendarMainPagesModel.YiStrArray[indexPath.row];
    cell.avoidLabel.text = calendarMainPagesModel.JiStrArray[indexPath.row];
    cell.memorialDayLabel.text = calendarMainPagesModel.ReligionFestivalStrArray[indexPath.row];
    cell.chongAnimalLabel.text = calendarMainPagesModel.ChongAnimalStrArray[indexPath.row];
    cell.goodtimeLabel.text = calendarMainPagesModel.LuckyhourStrArray[indexPath.row];
    cell.badtimeLabel.text = calendarMainPagesModel.badhouStrArray[indexPath.row];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CalendarVC *calendarVC = [[CalendarVC alloc]init];
    CalendarViewController1 *calendarVC = [[CalendarViewController1 alloc]init];
    [self.viewControllerDelegate.navigationController pushViewController:calendarVC animated:YES];
}

@end
