//
//  CycleTaskViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-25.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "HMSegmentedControl.h"

@interface RepeatTask:NSObject{
    
}
@property(nonatomic,retain)NSString *date;
@property(nonatomic,retain)PBAppendableArray *tasks;
@end

@class MBProgressHUD;
@interface CycleTaskViewController : BaseViewController<PullTableViewDelegate,UITableViewDelegate,UITableViewDataSource>{

    TASK_TYPE currentType;
    TASK_STATUS currentStatus;
    MBProgressHUD *HUD;
    HMSegmentedControl *statusSegCtrl;
    PBAppendableArray *tasks;
    NSMutableArray *taskArray;
    
    BOOL bSwitching;

}

- (void) reload;
@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain, nonatomic) UIViewController *parentCtrl;
@end
