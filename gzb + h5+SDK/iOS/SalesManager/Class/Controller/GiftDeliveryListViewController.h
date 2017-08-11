//
//  GiftDeliveryListViewController.h
//  SalesManager
//
//  Created by 章力 on 14-9-23.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "AppDelegate.h"
#import "GiftDeliverySearchViewController.h"

@interface GiftDeliveryListViewController : BaseViewController<GiftDeliverySearchDelegate,UITableViewDataSource, PullTableViewDelegate>{
    PullTableView *pullTableView;
    
    NSMutableArray *giftDeliveryArray;
    AppDelegate *appDelegate;
    
    GiftDeliveryParams* giftDeliveryParams;
    
    int currentPage;
    int pageSize;
    int totleSize;
}

@property (nonatomic, retain) NSMutableArray *giftDeliveryArray;
@property (nonatomic, retain) IBOutlet PullTableView *pullTableView;
@property (nonatomic, retain) GiftDeliveryParams* giftDeliveryParams;

@end
