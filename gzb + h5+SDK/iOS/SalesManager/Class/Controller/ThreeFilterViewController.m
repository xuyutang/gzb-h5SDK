//
//  ThreeFilterViewController.m
//  SalesManager
//
//  Created by Administrator on 15/10/16.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "ThreeFilterViewController.h"
#import "DatePicker.h"
#import "Constant.h"

@interface ThreeFilterViewController()<DatePickerDelegate,UITextFieldDelegate>

@end

@implementation ThreeFilterViewController
{
    DatePicker* _datePicker;
    IBOutlet UITextField *_txtFormTime;
    IBOutlet UITextField *_txtEndTime;
    IBOutlet UITextField *_txtGiftName;
    
    IBOutlet UILabel *_lbname;
    IBOutlet UILabel *_lbcustName;
    IBOutlet UILabel *_lbgiftName;
    
    int _btnIndex;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_lable2  && _lable2.length > 0) {
        [_lbcustName setText:_lable2];
    }
    if (_lable1 && _lable1.length > 0) {
        [_lbname setText:_lable1];
    }
    if (_lable3 && _lable3.length > 0) {
        [_lbgiftName setText:_lable3];
    }
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
    _txtEndTime.delegate = self;
    _txtFormTime.delegate = self;
    _datePicker = [[DatePicker alloc] init];
    _datePicker.delegate = self;
    
    _btnReset.backgroundColor = WT_RED;
    _btnSearch.backgroundColor = WT_RED;
    [_datePicker setCenter:CGPointMake(_datePicker.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height - _datePicker.frame.size.height + 20)];
}

//移除时钟
-(void) removeDatePickerView{
    for (UIView* item in self.subviews) {
        if ([item isKindOfClass:[DatePicker class]]) {
            [item removeFromSuperview];
        }
    }
}

#pragma -mark 窗体事件
- (IBAction)timeFieldTouch:(id)sender {
    UIButton* btn = (UIButton*)sender;
    _btnIndex = btn.tag;
    [self removeDatePickerView];
    if (_datePicker) {
        [self addSubview:_datePicker];
    }
}
- (IBAction)txtFieldTouch:(id)sender {
    [self removeDatePickerView];
}

- (IBAction)searchAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ThreeFilterToSearch:custName:giftName:formTime:endTime:)]) {
        if (_txtFormTime.text.length > 0 && _txtEndTime.text.length == 0) {
            NSDateFormatter* dateFormart = [[NSDateFormatter alloc] init];
            [dateFormart setDateFormat:@"yyyy-MM-dd HH:mm"];
            _txtEndTime.text = [dateFormart stringFromDate:[NSDate date]];
            [dateFormart release];
        }
        [self.delegate ThreeFilterToSearch:_txtName.text custName:_txtCustName.text giftName:_txtGiftName.text formTime:_txtFormTime.text endTime:_txtEndTime.text];
    }
}

- (IBAction)resetAction:(id)sender {
    _txtCustName.text = @"";
    _txtEndTime.text = @"";
    _txtFormTime.text = @"";
    _txtName.text = @"";
    _txtGiftName.text = @"";
}

#pragma -mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
#pragma -mark DatePickerDelegate
-(void)datePickerDidDone:(DatePicker*)picker{
    NSDateFormatter* formart = [[NSDateFormatter alloc] init];
    [formart setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (_btnIndex == 1) {
        _txtFormTime.text = [formart stringFromDate:picker.date];
    }else{
        _txtEndTime.text = [formart stringFromDate:picker.date];
    }
    [self removeDatePickerView];
    [formart release];
}
-(void)datePickerDidCancel{
    [self removeDatePickerView];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
    self.delegate = nil;
    [_datePicker release];
    [_txtCustName release];
    [_txtName release];
    [_txtFormTime release];
    [_txtEndTime release];
    [_lbgiftName release];
    [_txtGiftName release];
    [_lbgiftName release];
    [_txtGiftName release];
    [_lable1 release];
    [_lable2 release];
    [_lable3 release];
    [_btnSearch release];
    [_btnReset release];
    [super dealloc];
}


@end
