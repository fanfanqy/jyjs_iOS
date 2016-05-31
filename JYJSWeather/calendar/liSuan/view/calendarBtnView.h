//
//  calendarBtnView.h
//  FaLv
//
//  Created by han on 15/3/5.
//  Copyright (c) 2015年 xjkjmac01. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol calendarBtnViewDelegate;
/**
 *  时辰
 */
@interface calendarBtnView : UIView

@property (nonatomic, assign) id <calendarBtnViewDelegate> delegate;
@property (nonatomic,strong)UIButton * timeBtn;
@property (nonatomic,strong)UITableView * timeTableView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, assign)BOOL isTableView;

@end
@protocol calendarBtnViewDelegate <NSObject>
-(void)calendarBtnView:(calendarBtnView *)btnView timeTableViewChange:(BOOL)isTableView;

@end