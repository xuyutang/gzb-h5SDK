//
//  GiftPurchaseListViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-18.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AppDelegate.h"
#import "GiftPurchaseSearchViewController.h"

@interface GiftPurchaseListViewController : BaseViewController<GiftPurchaseSearchDelegate,UITableViewDataSource, PullTableViewDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *giftPurchaseArray;
    AppDelegate *appDelegate;
    
    GiftPurchaseParams* giftPurchaseParams;

    int currentPage;
    int pageSize;
    int totleSize;
}

@property (nonatomic, retain) NSMutableArray *giftPurchaseArray;
@property (nonatomic, retain) IBOutlet PullTableView *pullTableView;
@property (nonatomic, retain) GiftPurchaseParams* giftPurchaseParams;

@end
