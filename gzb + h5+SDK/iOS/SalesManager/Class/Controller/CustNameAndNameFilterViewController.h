//
//  CustNameAndNameViewController.h
//  SalesManager
//
//  Created by Administrator on 15/10/12.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePicker;
@protocol CustNameAndNameDelegate <NSObject>

-(void) CustNameAndNameSearchClick:(NSString*) custName name:(NSString*) name formTime:(NSString*) formTime endTime:(NSString*) endTime;

@end


@interface CustNameAndNameFilterViewController : UIView

@property (retain, nonatomic) DatePicker* datePicker;
@property (retain, nonatomic) IBOutlet UITextField *txtCustName;
@property (retain, nonatomic) IBOutlet UITextField *txtName;
@property (retain, nonatomic) IBOutlet UITextField *txtFormTime;
@property (retain, nonatomic) IBOutlet UITextField *txtEndTime;
@property (retain, nonatomic) IBOutlet UILabel *lcustTitle;
@property (assign, nonatomic) int btnIndex;
@property (retain, nonatomic) IBOutlet UILabel *lbname;

@property (retain, nonatomic) IBOutlet UIButton *btnSearch;
@property (retain, nonatomic) IBOutlet UIButton *btnReset;

@property (nonatomic,retain) NSString* lable1;
@property (nonatomic,retain) NSString* lable2;
@property (nonatomic,assign) id<CustNameAndNameDelegate> delegate;
@end
