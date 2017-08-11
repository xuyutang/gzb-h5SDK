//
//  PatrolListViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/4/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AppDelegate.h"
#import "PatrolSearch2ViewController.h"
@interface PatrolListViewController : BaseViewController<InputFinishDelegate,PatrolSearchDelegate,UITableViewDataSource,UITableViewDelegate, PullTableViewDelegate,RefreshDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *patrolArray;
    AppDelegate *appDelegate;

    //PatrolParams* patrolParams;
    
    Patrol *currentPatrol;
    int currentRow;
    int currentPage;
    int pageSize;
    int totleSize;
}

@property (nonatomic, retain) NSMutableArray *patrolArray;
@property (retain, nonatomic) PatrolParams *patrolParams;
@property (nonatomic, retain) IBOutlet PullTableView *pullTableView;


@end
