//
//  SearchViewController.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-13.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "DatePicker.h"
#import "CustomerSelectViewController.h"
#import "UserSelectViewController.h"

@protocol SearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(NSObject *)result;

@end

@interface SearchViewController : BaseViewController<CustomerCategoryDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    Customer *currentCustomer;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<SearchDelegate> delegate;
    
    int distance;
    
}

@property(nonatomic,assign) id<SearchDelegate> delegate;
@property(nonatomic,retain) NSObject* param;

@end
