//
//  CalendarTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "CalendarTableViewCell.h"
#import "CalendarCollectionViewCell.h"
//#import "CalendarVC.h"
#import "CalendarViewController1.h"
#import "CalendarMainPagesModel.h"
@implementation CalendarTableViewCell
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
        UINib *nib = [UINib nibWithNibName:@"CalendarCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CALENDARCOLLECTIONVIEWCELL"];
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
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CALENDARCOLLECTIONVIEWCELL" forIndexPath:indexPath];

    CalendarMainPagesModel *calendarMainPagesModel = [[CalendarMainPagesModel alloc]init];
    calendarMainPagesModel = self.array[indexPath.row];
    //    cell.right_up_image.image = [UIImage imageNamed:<#(nonnull NSString *)#>];
    cell.date.text = calendarMainPagesModel.solarStrArray[indexPath.row];
    cell.lunarCalendar.text =calendarMainPagesModel.lunarStrArray[indexPath.row];

    cell.goodOccasion.text = calendarMainPagesModel.JiNianStrArray[indexPath.row];
    cell.doSomething.text = calendarMainPagesModel.HaircutStrArray[indexPath.row];
    cell.approprite.text = calendarMainPagesModel.YiStrArray[indexPath.row];
    cell.avoid.text = calendarMainPagesModel.JiStrArray[indexPath.row];
    cell.memorialDay.text = calendarMainPagesModel.ReligionFestivalStrArray[indexPath.row];
    cell.collision.text = calendarMainPagesModel.ChongAnimalStrArray[indexPath.row];
    cell.goodTime.text = calendarMainPagesModel.LuckyhourStrArray[indexPath.row];
    cell.fierceTime.text = calendarMainPagesModel.badhouStrArray[indexPath.row];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarViewController1 *calendarVC = [[CalendarViewController1 alloc]init];
//     CalendarVC  *calendarVC = [[CalendarVC alloc]init];
    [self.viewControllerDelegate.navigationController pushViewController:calendarVC animated:YES];
}


@end
