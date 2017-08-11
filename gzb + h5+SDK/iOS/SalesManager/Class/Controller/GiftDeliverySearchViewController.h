//
//  GiftDeliverySearchViewController.h
//  SalesManager
//
//  Created by 章力 on 14-9-23.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "InputCell.h"
#import "DatePicker.h"
#import "ApplyTypeViewController.h"
#import "GiftTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "UserSelectViewController.h"

@protocol GiftDeliverySearchDelegate <NSObject>

@optional
-(void)didFinishedSearchWithResult:(GiftDeliveryParams_Builder *)result;

@end

@interface GiftDeliverySearchViewController : BaseViewController<GiftTypeDelegate,ApplyTypeDelegate,UserSearchDelegate,DatePickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>{
    
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
    id<GiftDeliverySearchDelegate> delegate;
    
    NSMutableArray *giftDeliveryArray;
    
    int distance;
}

@property(nonatomic,assign) id<GiftDeliverySearchDelegate> delegate;


@end
