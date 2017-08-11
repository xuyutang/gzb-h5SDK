//
//  GiftStockSearchViewController.h
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

@protocol GiftStockSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(GiftStockParams_Builder *)result;

@end

@interface GiftStockSearchViewController : BaseViewController<GiftTypeDelegate,ApplyTypeDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>{
    
    InputCell *nameCell;
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    GiftProductCategory *currentGiftProductCategory;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<GiftStockSearchDelegate> delegate;
    
    NSMutableArray *giftStockArray;
    
    int distance;
}

@property(nonatomic,assign) id<GiftStockSearchDelegate> delegate;

@end
