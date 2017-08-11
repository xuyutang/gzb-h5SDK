//
//  NameFilterViewController.m
//  SalesManager
//
//  Created by 朱康 on 15/10/10.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "NameFilterViewController.h"
#import "Constant.h"

@interface NameFilterViewController ()<DatePickerDelegate,UITextFieldDelegate>{
    
    IBOutlet UITextField *_txtName;
    IBOutlet UITextField *_txtFormTime;
    IBOutlet UITextField *_txtEndTime;
    
    DatePicker* _datePicker;
    int _timeTxtIndex;
}

@end

@implementation NameFilterViewController

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
    _txtEndTime.delegate = self;
    _txtFormTime.delegate = self;
    
    _datePicker = [[DatePicker alloc] init];
    _datePicker.delegate = self;
    
    _btnReset.backgroundColor = WT_RED;
    _btnSearch.backgroundColor = WT_RED;
    
    [_datePicker setCenter:CGPointMake(_datePicker.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height - _datePicker.frame.size.height + 20)];
}

#pragma -mark 按钮事件

- (IBAction)btnResetAction:(id)sender {
    _txtFormTime.text = @"";
    _txtEndTime.text = @"";
    _txtName.text = @"";
    [_txtName resignFirstResponder];
    [_txtFormTime resignFirstResponder];
    [_txtEndTime resignFirstResponder];
}

- (IBAction)btnSearchAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(NameFilterViewControllerSearch:formTime:endTime:)]) {
        if (_txtFormTime.text.length > 0 && _txtEndTime.text.length == 0) {
            NSDateFormatter* dateFormart = [[NSDateFormatter alloc] init];
            [dateFormart setDateFormat:@"yyyy-MM-dd HH:mm"];
            _txtEndTime.text = [dateFormart stringFromDate:[NSDate date]];
            [dateFormart release];
        }
        [_delegate NameFilterViewControllerSearch:_txtName.text formTime:_txtFormTime.text endTime:_txtEndTime.text];
    }
}
- (IBAction)btnTxtNameTouchDown:(id)sender {
    [self hideDatePicker];
}

- (IBAction)btnFormDateTextAction:(id)sender {
    [self hideDatePicker];
    if (_datePicker) {
        _timeTxtIndex = 0;
        [self addSubview:_datePicker];
    }
}

- (IBAction)btnEndDateTextAction:(id)sender {
    [self hideDatePicker];
    if (_datePicker) {
        _timeTxtIndex = 1;
        [self addSubview:_datePicker];
    }
}

#pragma -mark UITextFiledDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

#pragma -mark DatePicker delegate
-(void)datePickerDidDone:(DatePicker*)picker{
    NSDateFormatter* dateFormart = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormart setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* txtDate = [dateFormart stringFromDate:picker.date];
    if (_timeTxtIndex == 0) {
        _txtFormTime.text = txtDate;
    }else{
        _txtEndTime.text = txtDate;
    }
    [self hideDatePicker];
}

-(void)datePickerDidCancel{
    [self hideDatePicker];
}

-(void)hideDatePicker{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[DatePicker class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)dealloc {
    [_datePicker release];
    [_txtName release];
    [_txtFormTime release];
    [_txtEndTime release];
    [_btnSearch release];
    [_btnReset release];
    [super dealloc];
}
@end
