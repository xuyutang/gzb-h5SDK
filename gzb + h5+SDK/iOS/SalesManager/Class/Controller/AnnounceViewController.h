//
//  AnnounceViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-12.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"

@class AppDelegate;
@interface AnnounceViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource, PullTableViewDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *announceArray;
    NSMutableArray *sendMuarray;
    NSMutableArray *announceSendMuArray;
    AppDelegate *appDelegate;
    UITableView *tableView;
    AnnounceParams *announceParams;
    Announce *currentAnnounce;
    
    int currentRow;

    int currentPage;
    int pageSize;
    int totleSize;
    
    
}
@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (nonatomic,retain) UIViewController *parentCtrl;
- (void) refreshTable;
- (void) reload;
@end
