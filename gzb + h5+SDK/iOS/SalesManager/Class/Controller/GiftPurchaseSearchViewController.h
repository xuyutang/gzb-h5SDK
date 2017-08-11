//
//  GiftPurchaseSearchViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-19.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "InputCell.h"
#import "DatePicker.h"
#import "ApplyTypeViewController.h"
#import "GiftTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "UserSelectViewController.h"

@protocol GiftPurchaseSearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(GiftPurchaseParams_Builder *)result;

@end

@interface GiftPurchaseSearchViewController : BaseViewController<GiftTypeDelegate,ApplyTypeDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>{
    
    InputCell *nameCell;
    
    UITableView *tableView;
    DatePicker* datePicker;
    NSIndexPath *currentIndexPath;
    
    NSString *name;
    ApplyCategory *currentApplyCategory;
    GiftProductCategory *currentGiftProductCategory;
    User *currentUser;
    NSString *fromTime;
    NSString *toTime;
    id<GiftPurchaseSearchDelegate> delegate;
    
    NSMutableArray *giftPurchaseArray;
    
    int distance;
}

@property(nonatomic,assign) id<GiftPurchaseSearchDelegate> delegate;

@end
