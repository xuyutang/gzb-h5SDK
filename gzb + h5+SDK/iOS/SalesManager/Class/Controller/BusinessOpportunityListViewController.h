//
//  BusinessOpportunityListViewController.h
//  SalesManager
//
//  Created by 章力 on 14-5-6.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AppDelegate.h"
#import "BusinessOpportunityViewController.h"
#import "BusinessOpportunitySearchViewController.h"
#import "BusinessOpportunityDetailViewController.h"

@interface BusinessOpportunityListViewController : BaseViewController<RefreshTableViewDelegate,BusinessOpportunitySearchDelegate,UITableViewDataSource, PullTableViewDelegate,RefreshTableViewDelegate>{
    
    NSMutableArray *bizArray;
    //BusinessOpportunityParams *businessOpportunityParams;
    int currentPage;
    int pageSize;
    int totleSize;
    int currentRow;
    
    BusinessOpportunity *currentBiz;
}

@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain, nonatomic) BusinessOpportunityParams *businessOpportunityParams;
@end
