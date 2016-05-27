//
//  LimitNumberVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "LimitNumberVC.h"
#import "IndexCollectionViewCell_down.h"


@interface LimitNumberVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat indexpath;
}
@end

@implementation LimitNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    indexpath = 0;

    [self setFlowLayout];
    [self setbackgroundImage];

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
//    NSLog(@":%f   %f",self.collectionView.frame.size.height , flow.itemSize.height);

    flow.minimumLineSpacing = 1;
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return weatherDays;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IndexCollectionViewCell_down * cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"INDEXCOLLECTIONVIEWCELLDOWN" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.date.text = @"今天\n03.2";
    }else if (indexPath.row == 1){
        cell.date.text = @"明天\n03.3";
    }else if (indexPath.row == 2) {
        cell.date.text = @"后天\n03.3";
    } else {
        cell.date.text = [NSString stringWithFormat:@"3.%ld",indexPath.row + 3];
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
    
}


@end
