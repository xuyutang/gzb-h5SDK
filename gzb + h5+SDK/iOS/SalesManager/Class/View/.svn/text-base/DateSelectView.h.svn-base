//
//  DateSelectView.h
//  SalesManager
//
//  Created by liuxueyan on 15-5-6.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePicker.h"
@protocol DateSelectViewDelegate <NSObject>

@optional
-(void)selectedDateFrom:(NSString *)fromDate to:(NSString *)toDate;

@end


@interface DateSelectView : UIView<UITableViewDataSource,UITableViewDelegate,DatePickerDelegate>{
    NSString *fromDate;
    NSString *toDate;
    NSIndexPath *currentIndexPath;
    int distance;
    
    DatePicker* datePicker;
}

@property(nonatomic,retain)UIView *parentView;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,assign)id<DateSelectViewDelegate> delegate;

- (void)initView;
@end
