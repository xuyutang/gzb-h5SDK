//
//  OnceTaskViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-25.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "HMSegmentedControl.h"

@class MBProgressHUD;
@interface OnceTaskViewController : BaseViewController<PullTableViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    HMSegmentedControl *statusSegCtrl;
    TASK_TYPE currentType;
    TASK_STATUS currentStatus;
    MBProgressHUD *HUD;
    PBAppendableArray *tasks;
    
    BOOL bSwitching;
}
@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain, nonatomic) IBOutlet UIViewController *parentCtrl;
@end
