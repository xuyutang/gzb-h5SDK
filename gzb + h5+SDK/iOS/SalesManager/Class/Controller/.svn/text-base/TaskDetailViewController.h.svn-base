//
//  TaskDetailViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-6.
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
#import "PullTableView.h"
#import "TitleLableCell.h"
@class AppDelegate;
@interface TaskDetailViewController : BaseViewController<IMGCommentViewDelegate,LXActivityDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,PatrolTypeDelegate,CustomerCategoryDelegate,RequestAgentDelegate>{
    
    UIView *rightView;
    
    PullTableView *tableView;
    TextViewCell *textViewCell;
    TextViewCell *historyTextViewCell;
    LiveImageCell *liveImageCell;
    LocationCell* locationCell;
    IMGCommentView *popCommentView;
    TitleLableCell *titleLableCell;
    KWPopoverView *popView;
    NSMutableArray *imageFiles;
    
    NSMutableArray *patrolCategories;
    NSMutableArray *customerArray;
    
    PatrolCategory *currentPatrolCategory;
    Customer *currentCustomer;
    
    AppDelegate* appDelegate;
    
    TaskPatrol *taskPatrol;
    UIDocumentInteractionController *documentController;
}

@property(nonatomic,retain) PullTableView *tableView;
@property(nonatomic,retain) NSString *taskId;
-(void)submitComment;
-(id)init;


@end
