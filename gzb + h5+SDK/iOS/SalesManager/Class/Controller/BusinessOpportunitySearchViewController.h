//
//  BusinessOpportunitySearchViewController.h
//  SalesManager
//
//  Created by liuxueyan on 5/5/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CategoryPickerView.h"
#import "DatePicker.h"
#import "UserSelectViewController.h"

@protocol BusinessOpportunitySearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(BusinessOpportunityParams_Builder *)result;

@end

@interface BusinessOpportunitySearchViewController : BaseViewController<UserSearchDelegate,CategoryPickerDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
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
    id<BusinessOpportunitySearchDelegate> delegate;
    
    NSMutableArray *customerCategories;
    UITextField *currentTextField;
    
    int distance;
}

@property(nonatomic,assign) id<BusinessOpportunitySearchDelegate> delegate;

@end
