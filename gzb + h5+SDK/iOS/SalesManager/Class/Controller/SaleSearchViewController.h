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

@protocol SaleSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(SaleGoodsParams_Builder *)result;

@end

@interface SaleSearchViewController : BaseViewController<CustomerCategoryDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    Customer *currentCustomer;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<SaleSearchDelegate> delegate;
    int distance;
}

@property(nonatomic,assign) id<SaleSearchDelegate> delegate;

@end
