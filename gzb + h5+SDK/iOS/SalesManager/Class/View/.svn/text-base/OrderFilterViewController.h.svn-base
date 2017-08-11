//
//  NameFilterViewController.h
//  SalesManager
//
//  Created by 朱康 on 15/10/10.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

@protocol OrderFilterViewControllerDelegate <NSObject>

@required
-(void)OrderFilterViewControllerSearch:(NSString*) name custName:(NSString *) custName formTime:(NSString*)formTime endTime:(NSString*)endTime;

@end
#import <UIKit/UIKit.h>

#import "DatePicker.h"


@interface OrderFilterViewController : UIView


@property (nonatomic,retain) IBOutlet UITextField *custName;
@property (nonatomic,retain) IBOutlet UITextField *txtName;
@property (nonatomic,retain) IBOutlet UITextField *txtFormTime;
@property (nonatomic,retain) IBOutlet UITextField *txtEndTime;

@property (retain, nonatomic) IBOutlet UIButton *btnReset;

@property (retain, nonatomic) IBOutlet UIButton *btnSearch;
@property (nonatomic,assign) id<OrderFilterViewControllerDelegate> delegate;

@end
