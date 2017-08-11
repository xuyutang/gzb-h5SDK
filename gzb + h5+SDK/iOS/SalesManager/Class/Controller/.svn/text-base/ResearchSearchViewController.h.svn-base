//
//  ResearchSearchViewController.h
//  SalesManager
//
//  Created by liu xueyan on 1/24/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CategoryPickerView.h"
#import "DatePicker.h"
#import "UserSelectViewController.h"

@protocol ResearchSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(MarketResearchParams_Builder *)result;

@end

@interface ResearchSearchViewController : BaseViewController<UserSearchDelegate,CategoryPickerDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    CategoryPickerView  *pickerView;
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    CustomerCategory *currentCustomerCategory;
    Customer *currentCustomer;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<ResearchSearchDelegate> delegate;
    
    NSMutableArray *customerCategories;
    UITextField *currentTextField;
    
    int distance;
}

@property(nonatomic,assign) id<ResearchSearchDelegate> delegate;

@end
