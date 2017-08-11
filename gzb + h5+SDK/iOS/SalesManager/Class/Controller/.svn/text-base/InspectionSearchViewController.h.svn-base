//
//  InspectionSearchViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-11-27.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "InputCell.h"
#import "DatePicker.h"
#import "InspectionTypeViewController.h"
#import "InspectionTargetsViewController.h"
#import "InspectionTargetTypeViewController.h"
#import "UserSelectViewController.h"
@protocol InspectionSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(InspectionReportParams_Builder *)result;

@end

@interface InspectionSearchViewController : BaseViewController<TargetTypeDelegate,InspectionTypeDelegate,InspectionTargetsDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    InputCell *targetCell;
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    InspectionReportCategory *currentCategory;
    InspectionType *currentTargetType;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<InspectionSearchDelegate> delegate;
    
    NSMutableArray *inspectionArray;
    
    int distance;
}

@property(nonatomic,assign) id<InspectionSearchDelegate> delegate;


@end
