//
//  SaleStatisticsSearchViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-8.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "DatePicker.h"
#import "CustomerSelectViewController.h"
#import "UserSelectViewController.h"

@protocol SaleStatisticsSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(SaleGoodsParams_Builder *)result;

@end
@interface SaleStatisticsSearchViewController : BaseViewController<CustomerCategoryDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    Customer *currentCustomer;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<SaleStatisticsSearchDelegate> delegate;
    
    int distance;
}

@property(nonatomic,assign) id<SaleStatisticsSearchDelegate> delegate;


@end
