//
//  CompanySpaceViewController.h
//  SalesManager
//
//  Created by 章力 on 14-4-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AppDelegate.h"


@interface CompanySpaceViewController : BaseViewController<UITableViewDataSource, PullTableViewDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *itmeArray;
    AppDelegate *appDelegate;
    
    int currentPage;
    int pageSize;
    int totleSize;
    BOOL isLoad;
    
    CompanySpaceParams *csParams;
    CompanySpaceCategory *csCategory;
    
    UIViewController *parentCtrl;
}

@property(nonatomic,retain) UIViewController *parentCtrl;
@property(nonatomic,retain) CompanySpaceCategory *csCategory;

@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;

- (void) load;
- (void) refreshTable;
@end
