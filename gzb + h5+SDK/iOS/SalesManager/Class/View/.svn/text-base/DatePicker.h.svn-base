//
//  DatePicker.h
//  SalesManager
//
//  Created by liu xueyan on 8/4/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePicker;
@protocol DatePickerDelegate <NSObject>

/**
 * 点击确定后的事件
 */
@optional
-(void)datePickerDidDone:(DatePicker*)picker;
-(void)datePickerDidCancel;

@end


@interface DatePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, retain) UIPickerView* yearPicker;     // 年
@property (nonatomic, retain) UIPickerView* monthPicker;    // 月
@property (nonatomic, retain) UIPickerView* dayPicker;      // 日
@property (nonatomic, retain) UIPickerView* hourPicker;     // 时
@property (nonatomic, retain) UIPickerView* minutePicker;   // 分

@property (nonatomic, retain) NSDate*   date;       // 当前date

@property (nonatomic, retain) UIToolbar*    toolBar;        // 工具条
@property (nonatomic, retain) UILabel*      hintsLabel;     // 提示信息

@property (nonatomic, retain) NSMutableArray* yearArray;
@property (nonatomic, retain) NSMutableArray* monthArray;
@property (nonatomic, retain) NSMutableArray* dayArray;
@property (nonatomic, retain) NSMutableArray* hourArray;
@property (nonatomic, retain) NSMutableArray* minuteArray;

@property (nonatomic, assign) NSUInteger yearValue;
@property (nonatomic, assign) NSUInteger monthValue;
@property (nonatomic, assign) NSUInteger dayValue;
@property (nonatomic, assign) NSUInteger hourValue;
@property (nonatomic, assign) NSUInteger minuteValue;

-(void)resetDateToCurrentDate;


-(void)setHintsText:(NSString*)hints;

-(IBAction)actionEnter:(id)sender;

@property (nonatomic, assign) id<DatePickerDelegate>delegate;
@end


