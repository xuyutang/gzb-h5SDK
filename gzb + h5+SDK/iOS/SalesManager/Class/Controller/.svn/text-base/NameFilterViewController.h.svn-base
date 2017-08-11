//
//  NameFilterViewController.h
//  SalesManager
//
//  Created by 朱康 on 15/10/10.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

@protocol NameFilterViewControllerDelegate <NSObject>

@required
-(void)NameFilterViewControllerSearch:(NSString*) name formTime:(NSString*)formTime endTime:(NSString*)endTime;

@end
#import <UIKit/UIKit.h>

#import "DatePicker.h"


@interface NameFilterViewController : UIView

@property (retain, nonatomic) IBOutlet UIButton *btnReset;

@property (retain, nonatomic) IBOutlet UIButton *btnSearch;
@property (nonatomic,assign) id<NameFilterViewControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UITextField *_txtName;
@property (retain, nonatomic) IBOutlet UITextField *_txtFormTime;
@property (retain, nonatomic) IBOutlet UITextField *_txtEndTime;

@end
