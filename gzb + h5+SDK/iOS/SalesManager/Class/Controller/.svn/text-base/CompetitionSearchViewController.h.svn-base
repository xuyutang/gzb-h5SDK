//
//  CompetitionSearchViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-11.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "DatePicker.h"
#import "CustomerSelectViewController.h"
#import "UserSelectViewController.h"

@protocol CompetitionSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(CompetitionGoodsParams_Builder *)result;

@end

@interface CompetitionSearchViewController : BaseViewController<CustomerCategoryDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    Customer *currentCustomer;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<CompetitionSearchDelegate> delegate;
    
    int distance;
    
}

@property(nonatomic,assign) id<CompetitionSearchDelegate> delegate;

@end
