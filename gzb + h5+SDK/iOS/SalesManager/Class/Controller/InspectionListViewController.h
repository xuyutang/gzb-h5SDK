//
//  InspectionListViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-11-26.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AppDelegate.h"
#import "InspectionSearchViewController.h"
#import "InspectionDetailViewController.h"


@interface InspectionListViewController : BaseViewController<RefreshTableViewDelegate,InputFinishDelegate,InspectionSearchDelegate,UITableViewDataSource, PullTableViewDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *inspectionArray;
    AppDelegate *appDelegate;
    
    //InspectionReportParams* inspectionParams;
    
    InspectionReport *currentInspection;
    int currentRow;
    int currentPage;
    int pageSize;
    int totleSize;
}

@property (nonatomic, retain) NSMutableArray *inspectionArray;
@property (nonatomic, retain) IBOutlet PullTableView *pullTableView;
@property (nonatomic, retain) InspectionReportParams* inspectionParams;

@end
