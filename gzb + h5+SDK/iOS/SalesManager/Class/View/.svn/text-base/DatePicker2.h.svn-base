//
//  DatePicker2.h
//  SalesManager
//
//  Created by liu xueyan on 8/4/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePicker2;
@protocol DatePicker2Delegate <NSObject>

/**
 * 点击确定后的事件
 */
@optional
-(void)datePickerDidDone:(DatePicker2*)picker;
-(void)datePickerDidCancel;

@end


@interface DatePicker2 : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign) BOOL bHistoryDate;
@property (nonatomic, retain) UIPickerView* yearPicker;     // 年
@property (nonatomic, retain) UIPickerView* monthPicker;    // 月
@property (nonatomic, retain) UIPickerView* dayPicker;      // 日

@property (nonatomic, retain) NSDate*   date;       // 当前date
@property (nonatomic, retain) UIToolbar * topView;
@property (nonatomic, retain) UIToolbar*    toolBar;        // 工具条
@property (nonatomic, retain) UILabel*      hintsLabel;     // 提示信息

@property (nonatomic, retain) NSMutableArray* yearArray;
@property (nonatomic, retain) NSMutableArray* monthArray;
@property (nonatomic, retain) NSMutableArray* dayArray;

@property (nonatomic, assign) NSUInteger yearValue;
@property (nonatomic, assign) NSUInteger monthValue;
@property (nonatomic, assign) NSUInteger dayValue;

-(void)resetDateToCurrentDate;


-(void)setHintsText:(NSString*)hints;

-(IBAction)actionEnter:(id)sender;

@property (nonatomic, assign) id<DatePicker2Delegate>delegate;
@end


