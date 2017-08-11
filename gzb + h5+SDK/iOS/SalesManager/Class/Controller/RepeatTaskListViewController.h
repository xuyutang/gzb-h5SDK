//
//  RepeatTaskListViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-10.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "HMSegmentedControl.h"
#import "PullTableView.h"
@interface RepeatTask:NSObject{
    
}
@property(nonatomic,retain)NSString *date;
@property(nonatomic,retain)PBAppendableArray *tasks;
@end

@class MBProgressHUD;
@interface RepeatTaskListViewController : BaseViewController<PullTableViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    PullTableView *tableView;
    TASK_TYPE currentType;
    TASK_STATUS currentStatus;
    MBProgressHUD *HUD;
    HMSegmentedControl *statusSegCtrl;
    PBAppendableArray *tasks;
    NSMutableArray *taskArray;
    
    BOOL bSwitching;
}
- (void) reload;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) UIViewController *parentCtrl;

@end
