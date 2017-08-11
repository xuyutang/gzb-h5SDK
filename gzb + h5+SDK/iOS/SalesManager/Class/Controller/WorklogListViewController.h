//
//  WorklogListViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "WorklogSearchViewController.h"
#import "WorklogDetailViewController.h"

@class AppDelegate;

@interface WorklogListViewController : BaseViewController<WorklogSearchDelegate,UITableViewDataSource, PullTableViewDelegate,RefreshDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *worklogArray;
    AppDelegate *appDelegate;
    
    //WorkLogParams* worklogParams;
    
    int currentPage;
    int pageSize;
    int totleSize;
    
    WorkLog* currentWorkLog;
    int currentRow;
}

@property (nonatomic, retain) NSMutableArray *worklogArray;
@property(nonatomic,retain) IBOutlet PullTableView *pullTableView;
@property (nonatomic, retain) WorkLogParams* worklogParams;

@end
