//
//  DatePicker.m
//  SalesManager
//
//  Created by liu xueyan on 8/4/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "DatePicker.h"
#import "NSDate+Util.h"
#import "GlobalConstant.h"

typedef enum {
    ePickerViewTagYear = 2013,
    ePickerViewTagMonth,
    ePickerViewTagDay,
    ePickerViewTagHour,
    ePickerViewTagMinute
}PickViewTag;

@interface DatePicker (private)

-(void)createDataSource;
-(void)createMonthArrayWithYear:(NSInteger)yearInt month:(NSInteger)monthInt;
@end


@implementation DatePicker

@synthesize delegate;
@synthesize yearPicker, monthPicker, dayPicker, hourPicker, minutePicker;
@synthesize date;
@synthesize yearArray, monthArray, dayArray, hourArray, minuteArray;
@synthesize toolBar, hintsLabel;

@synthesize yearValue, monthValue;
@synthesize dayValue, hourValue, minuteValue;

#pragma mark -
-(void)dealloc{
    [yearArray release];
    [monthArray release];
    [dayArray release];
    [hourArray release];
    [minuteArray release];
    
    [date release];
    [yearPicker release];
    [monthPicker release];
    [dayPicker release];
    //    [hourArray release];
    //    [minuteArray release];
    
    [toolBar release];
    [hintsLabel release];
    self.delegate = nil;
    [super dealloc];
}


#pragma mark -
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 260)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        NSMutableArray* tempArray1 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* tempArray2 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* tempArray3 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* tempArray4 = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* tempArray5 = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self setYearArray:tempArray1];
        [self setMonthArray:tempArray2];
        [self setDayArray:tempArray3];
        [self setHourArray:tempArray4];
        [self setMinuteArray:tempArray5];
        
        [tempArray1 release];
        [tempArray2 release];
        [tempArray3 release];
        [tempArray4 release];
        [tempArray5 release];
        
        [self createDataSource];

        UIToolbar* tempToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self setToolBar:tempToolBar];
        [tempToolBar release];
        [self addSubview:self.toolBar];
        //        [toolBar setTintColor:[UIColor lightTextColor]];
        /*
        UILabel* tempHintsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 250, 34)];
        [self setHintsLabel:tempHintsLabel];
        [tempHintsLabel release];
        [self.hintsLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.hintsLabel];
        [self.hintsLabel setFont:[UIFont systemFontOfSize:24.0f]];
        [self.hintsLabel setTextColor:[UIColor whiteColor]];
        */
        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [topView setBarStyle:UIBarStyleDefault];
        [topView setBackgroundColor:WT_TOOLBAR_GRAY];
        UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(actionCancel)];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(actionEnter:)];
        
        NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
        [doneButton release];
        [btnSpace release];
        [helloButton release];
        
        [topView setItems:buttonsArray];
        [self addSubview:topView];

        UIPickerView* yearPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 80, 216)];
        [self setYearPicker:yearPickerTemp];
        [yearPickerTemp release];
        [self.yearPicker setFrame:CGRectMake(0, 44, 80, 216)];
        
        UIPickerView* monthPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(81, 44, 60, 216)];
        [self setMonthPicker:monthPickerTemp];
        [monthPickerTemp release];
        [self.monthPicker setFrame:CGRectMake(80, 44, 61, 216)];
        
        UIPickerView* dayPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(141, 44, 60, 216)];
        [self setDayPicker:dayPickerTemp];
        [dayPickerTemp release];
        [self.dayPicker setFrame:CGRectMake(141, 44, 59, 216)];
        
        UIPickerView* hourPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(201, 44, 60, 216)];
        [self setHourPicker:hourPickerTemp];
        [hourPickerTemp release];
        [self.hourPicker setFrame:CGRectMake(201, 44, 60, 216)];
        
        UIPickerView* minutesPickerTemp = [[UIPickerView alloc] initWithFrame:CGRectMake(261, 44, 60, 216)];
        [self setMinutePicker:minutesPickerTemp];
        [minutesPickerTemp release];
        [self.minutePicker setFrame:CGRectMake(261, 44, 60, 216)];
        
        
        [self.yearPicker setDataSource:self];
        [self.monthPicker setDataSource:self];
        [self.dayPicker setDataSource:self];
        [self.hourPicker setDataSource:self];
        [self.minutePicker setDataSource:self];
        
        [self.yearPicker setDelegate:self];
        [self.monthPicker setDelegate:self];
        [self.dayPicker setDelegate:self];
        [self.hourPicker setDelegate:self];
        [self.minutePicker setDelegate:self];
        
        
        
        [self.yearPicker setTag:ePickerViewTagYear];
        [self.monthPicker setTag:ePickerViewTagMonth];
        [self.dayPicker setTag:ePickerViewTagDay];
        [self.hourPicker setTag:ePickerViewTagHour];
        [self.minutePicker setTag:ePickerViewTagMinute];
        
        
        [self addSubview:self.yearPicker];
        [self addSubview:self.monthPicker];
        [self addSubview:self.dayPicker];
        [self addSubview:self.hourPicker];
        [self addSubview:self.minutePicker];
        
        [self.yearPicker setShowsSelectionIndicator:YES];
        [self.monthPicker setShowsSelectionIndicator:YES];
        [self.dayPicker setShowsSelectionIndicator:YES];
        [self.hourPicker setShowsSelectionIndicator:YES];
        [self.minutePicker setShowsSelectionIndicator:YES];
        
        
        [self resetDateToCurrentDate];
    }
    return self;
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    if (ePickerViewTagYear ==  pickerView.tag) {
//        return 60.0f;
//    } else {
//        return 40.0f;
//    }
//}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (ePickerViewTagYear == pickerView.tag) {
        return [self.yearArray count];
    }
    
    if (ePickerViewTagMonth == pickerView.tag) {
        return [self.monthArray count];
    }
    
    if (ePickerViewTagDay == pickerView.tag) {
        return [self.dayArray count];
    }
    
    if (ePickerViewTagHour == pickerView.tag) {
        return [self.hourArray count];
    }
    
    if (ePickerViewTagMinute == pickerView.tag) {
        return [self.minuteArray count];
    }
    return 0;
}
#pragma makr - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (ePickerViewTagYear == pickerView.tag) {
        return [self.yearArray objectAtIndex:row];
    }
    
    if (ePickerViewTagMonth == pickerView.tag) {
        return [self.monthArray objectAtIndex:row];
    }
    
    if (ePickerViewTagDay == pickerView.tag) {
        return [self.dayArray objectAtIndex:row];
    }
    
    if (ePickerViewTagHour == pickerView.tag) {
        return [self.hourArray objectAtIndex:row];
    }
    
    if (ePickerViewTagMinute == pickerView.tag) {
        return [self.minuteArray objectAtIndex:row];
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (ePickerViewTagYear == pickerView.tag) {
        self.yearValue = [[self.yearArray objectAtIndex:row] intValue];
    } else if(ePickerViewTagMonth == pickerView.tag){
        self.monthValue = [[self.monthArray objectAtIndex:row] intValue];
    } else if(ePickerViewTagDay == pickerView.tag){
        self.dayValue = [[self.dayArray objectAtIndex:row]intValue];
    } else if(ePickerViewTagHour == pickerView.tag){
        self.hourValue = [[self.hourArray objectAtIndex:row]intValue];
    } else if(ePickerViewTagMinute == pickerView.tag){
        self.minuteValue = [[self.minuteArray objectAtIndex:row] intValue];
    }
    if (ePickerViewTagMonth == pickerView.tag || ePickerViewTagYear == pickerView.tag) {
        [self createMonthArrayWithYear:self.yearValue month:self.monthValue];
        [self.dayPicker reloadAllComponents];
    }
    
    NSString* str = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d",self.yearValue, self.monthValue, self.dayValue, self.hourValue, self.minuteValue];
    [self setDate:[NSDate dateFromString:str withFormat:@"yyyyMMddHHmm"]];
}
#pragma mark - 年月日闰年＝情况分析

-(void)createDataSource{
    // 年
    NSInteger yearInt = [[NSDate date] getYear];
    [self.yearArray removeAllObjects];
    for (int i=yearInt -10; i<=yearInt +10; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    // 月
    [self.monthArray removeAllObjects];
    for (int i=1; i<=12; i++) {
        [self.monthArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    NSInteger month = [[NSDate date] getMonth];
    
    [self createMonthArrayWithYear:yearInt month:month];
    
    // 时
    [self.hourArray removeAllObjects];
    for(int i=0; i<24; i++){
        [self.hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    // 分
    [self.minuteArray removeAllObjects];
    for(int i=0; i<60; i++){
        [self.minuteArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}
#pragma mark -
-(void)resetDateToCurrentDate{
    NSDate* nowDate = [NSDate date];
    [self.yearPicker selectRow:[self.yearArray count]-11 inComponent:0 animated:YES];
    [self.monthPicker selectRow:[nowDate getMonth]-1 inComponent:0 animated:YES];
    [self.dayPicker selectRow:[nowDate getDay]-1 inComponent:0 animated:YES];
    
    [self.hourPicker selectRow:[nowDate getHour] inComponent:0 animated:YES];
    [self.minutePicker selectRow:[nowDate getMinute] inComponent:0 animated:YES];
    
    
    [self setYearValue:[nowDate getYear]];
    [self setMonthValue:[nowDate getMonth]];
    [self setDayValue:[nowDate getDay]];
    [self setHourValue:[nowDate getHour]];
    [self setMinuteValue:[nowDate getMinute]];
    
    NSString* str = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d",self.yearValue, self.monthValue, self.dayValue, self.hourValue, self.minuteValue];
    [self setDate:[NSDate dateFromString:str withFormat:@"yyyyMMddHHmm"]];
}
#pragma mark -
-(void)createMonthArrayWithYear:(NSInteger)yearInt month:(NSInteger)monthInt{
    int endDate = 0;
    switch (monthInt) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            endDate = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            endDate = 30;
            break;
        case 2:
            // 是否为闰年
            if (yearInt % 400 == 0) {
                endDate = 29;
            } else {
                if (yearInt % 100 != 0 && yearInt %4 ==4) {
                    endDate = 29;
                } else {
                    endDate = 28;
                }
            }
            break;
        default:
            break;
    }
    
    if (self.dayValue > endDate) {
        self.dayValue = endDate;
    }
    // 日
    [self.dayArray removeAllObjects];
    for(int i=1; i<=endDate; i++){
        [self.dayArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
}
#pragma mark - 点击确定按钮
-(IBAction)actionEnter:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerDidDone:)]) {
        [self.delegate datePickerDidDone:self];
    }
}

-(IBAction)actionCancel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerDidCancel)]) {
        [self.delegate datePickerDidCancel];
    }
    
}
#pragma mark - 设置提示信息
-(void)setHintsText:(NSString*)hints{
    [self.hintsLabel setText:hints];
}
#pragma mark -
-(void)removeFromSuperview{
    self.delegate = nil;
    [super removeFromSuperview];
}
@end
