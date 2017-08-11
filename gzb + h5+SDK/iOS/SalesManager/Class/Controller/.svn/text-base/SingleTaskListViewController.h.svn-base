//
//  SingleTaskListViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-10.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "HMSegmentedControl.h"
@class MBProgressHUD;
@interface SingleTaskListViewController : BaseViewController<PullTableViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    PullTableView *tableView;
    TASK_TYPE currentType;
    TASK_STATUS currentStatus;
    MBProgressHUD *HUD;
    HMSegmentedControl *statusSegCtrl;
    PBAppendableArray *tasks;
    
    BOOL bSwitching;
}
- (void) reload;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) UIViewController *parentCtrl;

@end
