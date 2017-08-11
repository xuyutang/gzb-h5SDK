//
//  ApplyListViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "ApplySearchViewController.h"
#import "WorklogDetailViewController.h"
#import "QCheckBox.h"
#import "AppDelegate.h"  


typedef NS_ENUM(NSInteger,applylStatus) {
    APPLY_STATUS_WAIT = 0,
    APPLY_STATUS_PASS = 1,
    APPLY_STATUS_NOT_PASS = 2
} ;

@protocol ApplyListViewControllerDelegate <NSObject>

@optional
-(void)didFinishedSelectApplyItem:(NSMutableArray *)applyItemArray;

@end

@interface ApplyListViewController : BaseViewController<InputFinishDelegate,ApplySearchDelegate,UITableViewDataSource, PullTableViewDelegate,RefreshDelegate,QCheckBoxDelegate> {
    PullTableView *pullTableView;
    NSMutableArray *applyArray;
    AppDelegate *appDelegate;
    ApplyItemParams* applyParams;
    int currentPage;
    int pageSize;
    int totleSize;
    ApplyItem* currentApplyItem;
    int currentRow;
    BOOL bEnableSelect;
    NSMutableArray *selectedArray;
    id<ApplyListViewControllerDelegate> delegate;
}

@property (nonatomic, assign) BOOL bEnableSelect;
@property (nonatomic, retain) NSMutableArray *applyArray;
@property (nonatomic,retain) IBOutlet PullTableView *pullTableView;
@property (nonatomic,retain) id<ApplyListViewControllerDelegate> delegate;
@property (nonatomic,retain) ApplyItemParams* applyParams;

@end
