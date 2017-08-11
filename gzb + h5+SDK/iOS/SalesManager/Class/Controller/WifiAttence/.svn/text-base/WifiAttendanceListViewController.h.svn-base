//
//  WifiAttendanceListViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/11/30.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"

@interface WifiAttendanceListViewController : BaseViewController<UITableViewDataSource, PullTableViewDelegate,RefreshDelegate> {
    NSMutableArray *checkInMuArray;
    int currentPage;
    int pageSize;
    int totleSize;
     int currentRow;
     Attendance* currentAttendance;

}

@property(nonatomic,strong)PullTableView *pullTableView;

@property (nonatomic, retain) CheckInTrackParams* checkInParams;

@end
