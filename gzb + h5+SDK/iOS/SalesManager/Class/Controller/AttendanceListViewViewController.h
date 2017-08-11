//
//  AttendanceListViewViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-10-21.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AttendanceSearchViewController.h"
#import "AttendanceDetailViewController.h"

@interface AttendanceListViewViewController : BaseViewController<RefreshDelegate,UITableViewDataSource, PullTableViewDelegate,AttendanceSearchDelegate,UITableViewDelegate>{
    //AttendanceParams *aParams;
    AttendanceParams_Builder* aBuilder;
    int currentPage;
    int pageSize;
    int totalSize;
    
    NSMutableArray *attendanceArray;
    
    Attendance* currentAttendance;
    int currentRow;
}


@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain, nonatomic) AttendanceParams *aParams;
@end
