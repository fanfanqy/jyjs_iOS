//
//  calendarBtnView.m
//  FaLv
//
//  Created by han on 15/3/5.
//  Copyright (c) 2015年 xjkjmac01. All rights reserved.
//

#import "calendarBtnView.h"
#import "timeCell.h"
#import "wanNianLiTool.h"
//#import "WanNianLi.h"
#import "ConvertLunarOrSolar.h"


@interface calendarBtnView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray * caiShenArray;
@property (nonatomic,strong)NSArray * xiShenArray;
@end
@implementation calendarBtnView
{
    UIImage * _newImage;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [[NSMutableArray alloc] init];
        self.caiShenArray = @[@"西北",@"西南",@"正南",@"东南",@"东北",@"西北",@"西南",@"正南",@"东南",@"东北",@"西北",@"西南"];
        self.xiShenArray = @[@"正东",@"正南",@"正南",@"正南",@"东南",@"东南",@"正西",@"正西",@"正北",@"正北",@"正东",@"正南"];
//橘色边框
        UIImage * timeNomal = [UIImage imageNamed:@"orangekuang"];
        CGFloat W = timeNomal.size.width * 0.5;
        CGFloat H = timeNomal.size.height * 0.5;
        UIImage *timeImage = [timeNomal resizableImageWithCapInsets:UIEdgeInsetsMake(H,W,H,W) resizingMode:UIImageResizingModeStretch];
//整个是一个UIButton
        self.timeBtn = [XBControl createBtnWithFrame:CGRectMake(0, 0, ScreenWidth, 50) title:nil image:nil target:self action:@selector(timeBtnClick)];
        _timeBtn.adjustsImageWhenHighlighted = NO;
        [_timeBtn setBackgroundImage:timeImage forState:UIControlStateNormal];
//'时辰' UILabel
       UILabel  * timeLabel = [XBControl createLabelWithFrame:CGRectMake(3 * PADDING, 15,ScreenWidth * 0.5 - 3 * PADDING, 20) text:@"时辰" textColor:UIColorFromRGB(0x303030) font:14];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [_timeBtn addSubview:timeLabel];
//向下拓展的图标
        UIImageView * downImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 - 7, 22, 14, 6)];
        downImage.image = [UIImage imageNamed:@"open0"];
        downImage.tag = 10;
        [_timeBtn addSubview:downImage];
//财神,喜神,吉凶
        NSArray * nameArray = @[@"财神",@"喜神",@"吉凶"];
        for (int i = 0; i < 3; i++) {
            UILabel * label = [XBControl createLabelWithFrame:CGRectMake((ScreenWidth * 0.5 + 7) + i * CALENDARBTNPADDING * 2, 15, CALENDARBTNPADDING * 2, 20) text:nameArray[i] textColor:UIColorFromRGB(0x303030) font:14];
            label.backgroundColor = [UIColor clearColor];
            if (SystemVersion >= 6.0) {
                label.textAlignment = NSTextAlignmentCenter;
            }else {
                label.textAlignment = NSTextAlignmentLeft;
            }

            [_timeBtn addSubview:label];
        }
        [self addSubview:_timeBtn];
        
        _isTableView = YES;
        self.timeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 240) style:UITableViewStylePlain];
        _timeTableView.dataSource = self;
        _timeTableView.delegate = self;
        _timeTableView.allowsSelection = NO;
        _timeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _timeTableView.backgroundColor = [UIColor clearColor];
        [self.timeBtn addSubview:self.timeTableView];
        _timeTableView.hidden = _isTableView;
    }
    return self;
}

-(void)timeBtnClick{
    if ([self.delegate respondsToSelector:@selector(calendarBtnView:timeTableViewChange:)]) {
        [self.delegate calendarBtnView:self timeTableViewChange:_isTableView];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"ID";
    timeCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[timeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.timeLabel.textColor = UIColorFromRGB(0xb3b3b3);
    cell.timeLabel.text = [wanNianLiTool getOldTime:(int)indexPath.row];
    
    cell.caiLabel.textColor = UIColorFromRGB(0xb3b3b3);
    cell.caiLabel.text = _caiShenArray[indexPath.row];
    
    cell.xiLabel.textColor = UIColorFromRGB(0xb3b3b3);
    cell.xiLabel.text = _xiShenArray[indexPath.row];
    if ([_dataArray[indexPath.row] isEqual:@1]) {
        cell.jiXiongLabel.text = @"吉";
        cell.jiXiongLabel.textColor = UIColorFromRGB(0xd43333);
    }else {
        cell.jiXiongLabel.text = @"凶";
        cell.jiXiongLabel.textColor = UIColorFromRGB(0x666666);
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

@end
