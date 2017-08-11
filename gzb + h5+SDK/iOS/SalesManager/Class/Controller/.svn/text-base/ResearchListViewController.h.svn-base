//
//  ResearchListViewController.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AppDelegate.h"
#import "SearchViewController.h"
#import "InputViewController.h"
#import "ResearchSearchViewController.h"

@interface ResearchListViewController : BaseViewController<ResearchSearchDelegate,InputFinishDelegate,UITableViewDataSource, PullTableViewDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *researchArray;
    //MarketResearchParams *marketResearchParams;
    int currentPage;
    int pageSize;
    int totleSize;
    int currentRow;
    MarketResearch *currentMarketResearch;
}

@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain, nonatomic) MarketResearchParams *marketResearchParams;
@end
