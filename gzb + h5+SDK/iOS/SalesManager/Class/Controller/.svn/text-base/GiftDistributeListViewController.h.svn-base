//
//  GiftDistributeListViewController.h
//  SalesManager
//
//  Created by 章力 on 14-9-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AppDelegate.h"
#import "GiftDeliverySearchViewController.h"

@interface GiftDistributeListViewController : BaseViewController<GiftDeliverySearchDelegate,UITableViewDataSource, PullTableViewDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *giftDistributeArray;
    AppDelegate *appDelegate;
    
    GiftDistributeParams* giftDistributeParams;
    
    int currentPage;
    int pageSize;
    int totleSize;
}

@property (nonatomic, retain) NSMutableArray *giftDistributeArray;
@property (nonatomic, retain) IBOutlet PullTableView *pullTableView;
@property (nonatomic, retain) GiftDistributeParams* giftDistributeParams;
@end
