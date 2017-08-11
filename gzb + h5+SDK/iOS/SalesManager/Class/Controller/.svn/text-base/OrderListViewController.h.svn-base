//
//  OrderListViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "OrderSearchViewController.h"

@interface OrderListViewController : BaseViewController<OrderSearchDelegate,UITableViewDataSource, PullTableViewDelegate>{

    IBOutlet PullTableView *pullTableView;
    OrderGoodsParams_Builder *ogParamsBuilder;
    //OrderGoodsParams *ogParams;
    
    int currentPage;
    int pageSize;
    int totalSize;
    
    NSMutableArray *orderArray;

}

@property(nonatomic,retain) IBOutlet PullTableView *pullTableView;
@property(nonatomic,retain) NSMutableArray *orderArray;
@property(nonatomic,retain) OrderGoodsParams *ogParams;
@property(nonatomic,assign) int msgType;
@property(nonatomic,assign) int sourceId;
@end
