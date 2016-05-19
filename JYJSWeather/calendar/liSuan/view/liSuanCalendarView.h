//
//  liSuanCalendarView.h
//  
//
//  Created by han on 15/3/6.
//
//

#import <UIKit/UIKit.h>
#import "calendarDBModel.h"

@protocol lisuanCalendarViewDelegate <NSObject>

@optional  //可选实现
-(void)reloadDataWithYear:(int)newYear month:(int)newMonth day:(int)newDay andIsSelected:(BOOL)isSelected;
-(void)dateBtnClick;
-(void)updateBtnTitleWithArray:(NSMutableArray *)birArr dateArr:(NSMutableArray *)dateArr year:(int)year month:(int)month day:(int)day;

@end

@interface liSuanCalendarView : UIView

@property (nonatomic, assign) id <lisuanCalendarViewDelegate> delegate;
@property (nonatomic, retain) NSArray *markedDates;
@property (nonatomic, retain, getter = selectedDate) NSDate *selectedDate;
@property (nonatomic,strong)NSMutableArray * calendarArray;
@property (nonatomic,strong)NSMutableArray * dateArr;
@property (nonatomic,strong)NSMutableArray * birArr;
@property (nonatomic,strong)UIButton * dateBtn;
-(void)markDataWithYear:(int)year month:(int)month day:(int)day;
-(void)reloadDataWithDate:(int)date andMonth:(int)month andYear:(int)year andIsSelected:(BOOL)isSelected;


@end

