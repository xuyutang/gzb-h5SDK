//
//  WifiAttenceSearch.m
//  SalesManager
//
//  Created by iOS-Dev on 16/12/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "WifiAttenceSearch.h"
#import "Constant.h"
@implementation WifiAttenceSearch


-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
    _endField.delegate = self;
    _startField.delegate = self;
    _catagoryField.delegate = self;
    _datePicker = [[DatePicker alloc] init];
    _datePicker.delegate = self;
    
    _datePicker2 = [[DatePicker2 alloc] init];
    _datePicker2.delegate = self;
    _resetBtn.backgroundColor = WT_RED;
    _searchBtn.backgroundColor = WT_RED;
    
    [_datePicker setCenter:CGPointMake(_datePicker.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height - _datePicker.frame.size.height + 20)];
    [_datePicker2 setCenter:CGPointMake(_datePicker2.frame.size.width / 2, [UIScreen mainScreen].bounds.size.height - _datePicker2.frame.size.height + 20)];
}

- (IBAction)btnResetAction:(id)sender {
    _startField.text = @"";
    _endField.text = @"";
    _nameField.text = @"";
    _catagoryField.text = @"";
    [_nameField resignFirstResponder];
    [_startField resignFirstResponder];
    [_endField resignFirstResponder];
    [_catagoryField resignFirstResponder];
    
}
- (IBAction)btnSearchAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(NameFilterViewControllerSearch:formTime:endTime:checkIntime:)]) {
//        if (_startField.text.length > 0 && _endField.text.length == 0) {
//            NSDateFormatter* dateFormart = [[NSDateFormatter alloc] init];
//            [dateFormart setDateFormat:@"yyyy-MM-dd HH:mm"];
//            _endField.text = [dateFormart stringFromDate:[NSDate date]];
//            [dateFormart release];
//        }
        [_delegate NameFilterViewControllerSearch:_nameField.text formTime:_startField.text endTime:_endField.text checkIntime:_catagoryField.text];
    }

}
- (IBAction)btnTxtNameTouchDown:(id)sender {
     [self hideDatePicker];
}
- (IBAction)btnStartDateTextAction:(id)sender {
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
- (IBAction)btnCatagoryTextAction:(id)sender {
    [self hideDatePicker2];
    if (_datePicker2) {
        
        [self addSubview:_datePicker2];
    }

}

#pragma -mark UITextFiledDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

#pragma -mark DatePicker delegate
-(void)datePickerDidDone:(DatePicker*)picker{
    if ([picker isKindOfClass:[DatePicker2 class]]) {
        NSDateFormatter* dateFormart = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormart setDateFormat:@"yyyy-MM-dd"];
        NSString* txtDate = [dateFormart stringFromDate:picker.date];
        _catagoryField.text = txtDate;
        [self hideDatePicker2];
    }else {
    
        NSDateFormatter* dateFormart = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormart setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString* txtDate = [dateFormart stringFromDate:picker.date];
        if (_timeTxtIndex == 0) {
            _startField.text = txtDate;
        }else{
            _endField.text = txtDate;
        }
        [self hideDatePicker];
    }
   
}

-(void)datePickerDidCancel{
    [self hideDatePicker];
    [self hideDatePicker2];
}

-(void)hideDatePicker{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[DatePicker class]]) {
            [view removeFromSuperview];
        }
    }
}

-(void)hideDatePicker2{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[DatePicker2 class]]) {
            [view removeFromSuperview];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [_nameField release];
    [_catagoryField release];
    [_startField release];
    [_endField release];
    [_resetBtn release];
    [_searchBtn release];
    [super dealloc];
}
@end
