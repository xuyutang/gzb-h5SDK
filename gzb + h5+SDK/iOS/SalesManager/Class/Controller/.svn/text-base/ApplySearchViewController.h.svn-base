//
//  ApplySearchViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CategoryPickerView.h"
#import "DatePicker.h"
#import "UserSelectViewController.h"

@protocol ApplySearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(ApplyItemParams_Builder *)result;

@end

@interface ApplySearchViewController : BaseViewController<UserSearchDelegate,CategoryPickerDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate> {
    
    CategoryPickerView  *pickerView;
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    NSString *name;
    ApplyCategory *currentApplyCategory;
    Customer *currentCustomer;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<ApplySearchDelegate> delegate;
    NSMutableArray *applyCategories;
    UITextField *currentTextField;
    int distance;
}

@property(nonatomic,assign) id<ApplySearchDelegate> delegate;

@end
