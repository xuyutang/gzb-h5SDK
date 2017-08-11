//
//  WifiAttenceSearch.h
//  SalesManager
//
//  Created by iOS-Dev on 16/12/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

@protocol NameFilterViewControllerDelegate <NSObject>

@required
-(void)NameFilterViewControllerSearch:(NSString*) name formTime:(NSString*)formTime endTime:(NSString*)endTime checkIntime:(NSString*)checkTime;

-(void)getAttenceCatogry;
@end
#import <UIKit/UIKit.h>
#import "DatePicker.h"
#import "DatePicker2.h"


@interface WifiAttenceSearch : UIView<DatePickerDelegate,DatePicker2Delegate,UITextFieldDelegate> {
    DatePicker* _datePicker;
    DatePicker2 *_datePicker2;
    int _timeTxtIndex;

}
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UITextField *catagoryField;
@property (retain, nonatomic) IBOutlet UITextField *startField;
@property (retain, nonatomic) IBOutlet UITextField *endField;
@property (retain, nonatomic) IBOutlet UIButton *resetBtn;
@property (retain, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic,assign) id<NameFilterViewControllerDelegate> delegate;
@end
