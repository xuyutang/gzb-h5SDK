//
//  PatrolSearchViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/4/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "InputCell.h"
#import "DatePicker.h"
#import "PatrolTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "UserSelectViewController.h"
@protocol PatrolSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(PatrolParams_Builder *)result;

@end

@interface PatrolSearch2ViewController : BaseViewController<PatrolTypeDelegate,CustomerCategoryDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{

    InputCell *nameCell;
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    PatrolCategory *currentPatrolCategory;
    Customer *currentCustomer;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<PatrolSearchDelegate> delegate;
    
    NSMutableArray *patrolArray;
    
    int distance;
}

@property(nonatomic,assign) id<PatrolSearchDelegate> delegate;

@end
