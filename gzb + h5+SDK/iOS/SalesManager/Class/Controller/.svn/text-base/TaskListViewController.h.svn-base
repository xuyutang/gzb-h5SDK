//
//  TaskListViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-4.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "TaskSearchViewController.h"

@class MBProgressHUD;
@class HeaderSearchBar;
@interface TaskListViewController : BaseViewController<PullTableViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    PullTableView *pullTableView;
    TaskPatrolParams *tpParams;
    TaskPatrolParams_Builder* tpBuilder;
    int currentPage;
    int pageSize;
    int totalSize;
    NSMutableArray *taskArray;
    MBProgressHUD *HUD;
}
- (void) reload;
@property(nonatomic,retain) IBOutlet PullTableView *pullTableView;
@property(nonatomic,retain) UIViewController *parentCtrl;
@property(nonatomic,retain) User* user;
@property(nonatomic,assign) int msgType;
@property(nonatomic,retain) NSString* sourceId;

@property (nonatomic,retain) HeaderSearchBar*        searchBar;
@property (nonatomic,retain) NSMutableArray*         searchViews;
@end
