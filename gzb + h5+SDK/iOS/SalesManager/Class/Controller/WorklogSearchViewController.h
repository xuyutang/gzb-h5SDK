//
//  WorklogSearchViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-7.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputCell.h"
#import "UserSelectViewController.h"
#import "BaseViewController.h"
#import "DatePicker.h"
@protocol WorklogSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(WorkLogParams_Builder *)result;

@end
@interface WorklogSearchViewController : BaseViewController<UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    InputCell *nameCell;
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<WorklogSearchDelegate> delegate;
    
    int distance;
}

@property(nonatomic,assign) id<WorklogSearchDelegate> delegate;

@end