//
//  AlarmDetailViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15/6/9.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "AlarmDetailViewController.h"
#import "UIImage+JSLite.h"
#import "Alarm.h"
#import "Alarm+Extensions.h"
#import "Repetition.h"
#import "Repetition+Extensions.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "GlobalConstant.h"
#import "NSString+Helpers.h"
@interface AlarmDetailViewController (){
    BOOL bUpdate;
}
@property NSArray *repetitions;

@end

@implementation AlarmDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bUpdate = FALSE;
    _managedObjectContext = LOCALMANAGER.managedObjectContext;
    if (_alarmItem != nil) {
        bUpdate = TRUE;
        if (_alarmItem.repetitionsSorted != nil && _alarmItem.repetitionsSorted.count >0) {
            self.repetitions = [_alarmItem.repetitionsSorted retain];
        }
        
        if (![self.repetitions count])
        {
            self.repetitions = [Repetition createRepitionsForDaysWithManagedObjectContext:self.managedObjectContext];
            _alarmItem.repetitions = [NSSet setWithArray:self.repetitions];
        }
    }
    

    
    [_bt1 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_bt1 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt1 addTarget:self action:@selector(clickBt1) forControlEvents:UIControlEventTouchUpInside];
    
    [_bt2 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_bt2 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt2 addTarget:self action:@selector(clickBt2) forControlEvents:UIControlEventTouchUpInside];
    
    [_bt3 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_bt3 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt3 addTarget:self action:@selector(clickBt3) forControlEvents:UIControlEventTouchUpInside];
    
    [_bt4 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_bt4 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt4 addTarget:self action:@selector(clickBt4) forControlEvents:UIControlEventTouchUpInside];
    
    [_bt5 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_bt5 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt5 addTarget:self action:@selector(clickBt5) forControlEvents:UIControlEventTouchUpInside];
    
    [_bt6 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_bt6 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt6 addTarget:self action:@selector(clickBt6) forControlEvents:UIControlEventTouchUpInside];
    
    [_bt7 setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_bt7 setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateSelected];
    [_bt7 addTarget:self action:@selector(clickBt7) forControlEvents:UIControlEventTouchUpInside];
    
    if (_alarmItem != nil) {
        
        _txtHour.text = [NSString stringWithFormat:@"%@",_alarmItem.hour];
        _txtMinute.text = [NSString stringWithFormat:@"%@",_alarmItem.minute];
        
        [_bt1 setSelected:[ ((Repetition *)self.repetitions[0]).shouldRepeat boolValue]];
        [_bt2 setSelected:[ ((Repetition *)self.repetitions[1]).shouldRepeat boolValue]];
        [_bt3 setSelected:[ ((Repetition *)self.repetitions[2]).shouldRepeat boolValue]];
        [_bt4 setSelected:[ ((Repetition *)self.repetitions[3]).shouldRepeat boolValue]];
        [_bt5 setSelected:[ ((Repetition *)self.repetitions[4]).shouldRepeat boolValue]];
        [_bt6 setSelected:[ ((Repetition *)self.repetitions[5]).shouldRepeat boolValue]];
        [_bt7 setSelected:[ ((Repetition *)self.repetitions[6]).shouldRepeat boolValue]];
        
        [_txtTitle setText:_alarmItem.title];
    }
    [_btSave setBackgroundColor:WT_RED];
    [_btSave addTarget:self action:@selector(toSave) forControlEvents:UIControlEventTouchUpInside];
    
    lblFunctionName.text = NSLocalizedString(@"menu_function_alarm", @"");
    _txtHour.keyboardType = UIKeyboardTypeNumberPad;
    _txtHour.textColor = WT_RED;

    _txtMinute.keyboardType = UIKeyboardTypeNumberPad;
    _txtMinute.textColor = WT_RED;
    _txtDot.textColor = WT_RED;
}

-(void)clickBt1{
    if ([_bt1 isSelected]) {
        [_bt1 setSelected:NO];
    }else{
        [_bt1 setSelected:YES];
    }
}

-(void)clickBt2{
    if ([_bt2 isSelected]) {
        [_bt2 setSelected:NO];
    }else{
        [_bt2 setSelected:YES];
    }
}

-(void)clickBt3{
    if ([_bt3 isSelected]) {
        [_bt3 setSelected:NO];
    }else{
        [_bt3 setSelected:YES];
    }
}

-(void)clickBt4{
    if ([_bt4 isSelected]) {
        [_bt4 setSelected:NO];
    }else{
        [_bt4 setSelected:YES];
    }
}

-(void)clickBt5{
    if ([_bt5 isSelected]) {
        [_bt5 setSelected:NO];
    }else{
        [_bt5 setSelected:YES];
    }
}

-(void)clickBt6{
    if ([_bt6 isSelected]) {
        [_bt6 setSelected:NO];
    }else{
        [_bt6 setSelected:YES];
    }
}

-(void)clickBt7{
    if ([_bt7 isSelected]) {
        [_bt7 setSelected:NO];
    }else{
        [_bt7 setSelected:YES];
    }
}


-(void)toSave{
    if (_txtHour.text.intValue > 23 || _txtMinute.text.intValue > 59) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"alarm_hint_time", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (_txtTitle.text.isEmpty) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"alarm_hint_title", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (_alarmItem == nil) {
        _alarmItem = [Alarm insertNewObjectInManagedObjectContext:self.managedObjectContext];
    }
    
    _alarmItem.title = _txtTitle.text;
    _alarmItem.hour = [NSNumber numberWithInt:[_txtHour.text intValue]];
    _alarmItem.minute = [NSNumber numberWithInt:[_txtMinute.text intValue]];
    _alarmItem.on = [NSNumber numberWithBool:YES];
    _alarmItem.aid = [NSString UUID];
    if (self.repetitions == nil || self.repetitions.count <7) {
        
        self.repetitions = [[NSArray alloc] initWithArray:[Repetition createRepitionsForDaysWithManagedObjectContext:self.managedObjectContext]];
    }
    Repetition *repition = self.repetitions[0];
    repition.shouldRepeat = [NSNumber numberWithBool:[_bt1 isSelected]];
    
    Repetition *repition1 = self.repetitions[1];
    repition1.shouldRepeat = [NSNumber numberWithBool:[_bt2 isSelected]];
    
    Repetition *repition2 = self.repetitions[2];
    repition2.shouldRepeat = [NSNumber numberWithBool:[_bt3 isSelected]];
    
    Repetition *repition3 = self.repetitions[3];
    repition3.shouldRepeat = [NSNumber numberWithBool:[_bt4 isSelected]];
    
    Repetition *repition4 = self.repetitions[4];
    repition4.shouldRepeat = [NSNumber numberWithBool:[_bt5 isSelected]];
    
    Repetition *repition5 = self.repetitions[5];
    repition5.shouldRepeat = [NSNumber numberWithBool:[_bt6 isSelected]];
    
    Repetition *repition6 = self.repetitions[6];
    repition6.shouldRepeat = [NSNumber numberWithBool:[_bt7 isSelected]];
    
    _alarmItem.repetitions = [NSSet setWithArray:self.repetitions];
    /*
    _alarmItem.bWeek1 = [_bt1 isSelected];
    _alarmItem.bWeek2 = [_bt2 isSelected];
    _alarmItem.bWeek3 = [_bt3 isSelected];
    _alarmItem.bWeek4 = [_bt4 isSelected];
    _alarmItem.bWeek5 = [_bt5 isSelected];
    _alarmItem.bWeek6 = [_bt6 isSelected];
    _alarmItem.bWeek7 = [_bt7 isSelected];
*/
    if (_delegate != nil && [_delegate respondsToSelector:@selector(finishedEdit:Curd:)]) {
        [_delegate finishedEdit:_alarmItem Curd:(bUpdate) ? UPDATE : CREATE];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_hour release];
    [_txtMinute release];
    [_txtHour release];

    [_txtTitle release];
    [_btSave release];
    [_bt1 release];
    [_bt2 release];
    [_bt3 release];
    [_bt4 release];
    [_bt5 release];
    [_bt6 release];
    [_bt7 release];
    [_txtDot release];
    [super dealloc];
}
@end
