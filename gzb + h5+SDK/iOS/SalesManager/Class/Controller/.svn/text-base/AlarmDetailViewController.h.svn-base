//
//  AlarmDetailViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15/6/9.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "Alarm.h"
#define CREATE 0
#define DELETE 1
#define UPDATE 2

@protocol MAAlarmViewControllerProtocol <NSObject>
@property NSManagedObjectContext *managedObjectContext;
@property Alarm *alarm;
@end

@protocol AlarmDetailViewControllerDelegate <NSObject>

@optional
-(void)finishedEdit:(Alarm *)alarmItem Curd:(int)curd;

@end

@interface AlarmDetailViewController : BaseViewController<MAAlarmViewControllerProtocol>
@property (retain, nonatomic) IBOutlet UILabel *txtDot;
@property (retain, nonatomic) IBOutlet UITextField *hour;
@property (retain, nonatomic) IBOutlet UITextField *txtMinute;
@property (retain, nonatomic) IBOutlet UITextField *txtHour;

@property (retain, nonatomic) IBOutlet UITextField *txtTitle;
@property (retain, nonatomic) IBOutlet UIButton *btSave;

@property (retain, nonatomic) IBOutlet UIButton *bt1;
@property (retain, nonatomic) IBOutlet UIButton *bt2;
@property (retain, nonatomic) IBOutlet UIButton *bt3;
@property (retain, nonatomic) IBOutlet UIButton *bt4;
@property (retain, nonatomic) IBOutlet UIButton *bt5;
@property (retain, nonatomic) IBOutlet UIButton *bt6;
@property (retain, nonatomic) IBOutlet UIButton *bt7;

@property Alarm *alarmItem;
@property NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) id<AlarmDetailViewControllerDelegate> delegate;
@end
