//
//  OrderSearchViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "DatePicker.h"
#import "CustomerSelectViewController.h"
#import "UserSelectViewController.h"

@protocol StockSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(StockParams_Builder *)result;

@end

@interface StockSearchViewController : BaseViewController<CustomerCategoryDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    Customer *currentCustomer;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<StockSearchDelegate> delegate;
    
    int distance;
}

@property(nonatomic,assign) id<StockSearchDelegate> delegate;

@end
