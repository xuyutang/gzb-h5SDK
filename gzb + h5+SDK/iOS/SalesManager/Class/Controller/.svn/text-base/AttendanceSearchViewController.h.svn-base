//
//  AttendanceSearchViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-10-17.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import <Foundation/Foundation.h>
#import "InputCell.h"
#import "UserSelectViewController.h"
#import "DatePicker.h"

@protocol AttendanceSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(AttendanceParams_Builder *)result;

@end

@interface AttendanceSearchViewController : BaseViewController<UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    InputCell *nameCell;
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<AttendanceSearchDelegate> delegate;
    
    int distance;
}

@property(nonatomic,assign) id<AttendanceSearchDelegate> delegate;

@end