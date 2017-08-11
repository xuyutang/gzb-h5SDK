//
//  GiftDistributeSearchViewController.h
//  SalesManager
//
//  Created by 章力 on 14-9-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "InputCell.h"
#import "DatePicker.h"
#import "ApplyTypeViewController.h"
#import "GiftTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "UserSelectViewController.h"

@protocol GiftDistributeSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(GiftDistributeParams_Builder *)result;

@end

@interface GiftDistributeSearchViewController : BaseViewController<GiftTypeDelegate,ApplyTypeDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>{
    
    InputCell *nameCell;
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    ApplyCategory *currentApplyCategory;
    GiftProductCategory *currentGiftProductCategory;
    User *currentUser;
    Customer *currentCustomer;
    NSString *fromTime;
    NSString *toTime;
    id<GiftDistributeSearchDelegate> delegate;
    
    NSMutableArray *giftDistributeArray;
    
    int distance;
}

@property(nonatomic,assign) id<GiftDistributeSearchDelegate> delegate;


@end
