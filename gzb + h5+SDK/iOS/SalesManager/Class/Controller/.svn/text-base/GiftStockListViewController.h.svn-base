//
//  GiftStockListViewController.h
//  SalesManager
//
//  Created by 章力 on 14-9-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AppDelegate.h"
#import "GiftStockSearchViewController.h"

@interface GiftStockListViewController : BaseViewController<GiftStockSearchDelegate,UITableViewDataSource, PullTableViewDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *giftStockArray;
    AppDelegate *appDelegate;
    
    GiftStockParams* giftStockParams;
    
    int currentPage;
    int pageSize;
    int totleSize;
}

@property (nonatomic, retain) NSMutableArray *giftStockArray;
@property (nonatomic, retain) IBOutlet PullTableView *pullTableView;
@property (nonatomic, retain) GiftStockParams *giftStockParams;

@end
