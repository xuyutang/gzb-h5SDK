//
//  MyTaskDetailViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-16.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "UTTableView.h"
#import "KWPopoverView.h"
#import "IMGCommentView.h"
#import "LXActivity.h"

@class AppDelegate;
@interface MyTaskDetailViewController : BaseViewController<LXActivityDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,PatrolTypeDelegate,CustomerCategoryDelegate,RequestAgentDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    TextViewCell *textViewCell;
    TextViewCell *historyTextViewCell;
    LiveImageCell *liveImageCell;
    LocationCell* locationCell;
    IMGCommentView *popCommentView;
    
    NSMutableArray *imageFiles;
    
    NSMutableArray *patrolCategories;
    NSMutableArray *customerArray;
    
    PatrolCategory *currentPatrolCategory;
    Customer *currentCustomer;
    
    AppDelegate* appDelegate;
    
    TaskPatrol *taskPatrol;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSString *taskId;
@property(nonatomic,retain) NSString *taskDate;
@property(nonatomic,assign) BOOL bCycle;
-(id)init;


@end
