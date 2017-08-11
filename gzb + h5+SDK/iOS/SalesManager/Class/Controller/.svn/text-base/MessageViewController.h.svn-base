//
//  MessageViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"

@class AppDelegate;
@interface MessageViewController : BaseViewController<UITableViewDataSource, PullTableViewDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *messageArray;
    AppDelegate *appDelegate;
    
    SysMessageParams *messageParams;
    SysMessage *currentMessage;
    
    int currentRow;
    int currentPage;
    int pageSize;
    int totleSize;
}

- (void)reload;
@property (nonatomic, retain) IBOutlet PullTableView *pullTableView;
@property (nonatomic, retain) UIViewController *parentCtrl;
@property (nonatomic, assign) int userId;
@end
