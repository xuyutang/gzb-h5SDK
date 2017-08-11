//
//  TaskSearchViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-11.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import <Foundation/Foundation.h>
#import "InputCell.h"
#import "UserSelectViewController.h"
#import "DatePicker.h"

@protocol TaskSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(TaskPatrolParams_Builder *)result;

@end

@interface TaskSearchViewController : BaseViewController<UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    InputCell *nameCell;
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<TaskSearchDelegate> delegate;
    
    int distance;
}

@property(nonatomic,assign) id<TaskSearchDelegate> delegate;

@end
