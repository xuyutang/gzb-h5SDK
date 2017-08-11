//
//  StockListViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-8.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "StockSearchViewController.h"

@interface StockListViewController : BaseViewController<StockSearchDelegate>{
    
    //StockParams *sParams;
    StockParams_Builder* spBuilder;
    int currentPage;
    int pageSize;
    int totalSize;
    
    NSMutableArray *stockArray;
}
@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property(nonatomic,retain) NSMutableArray *stockArray;
@property(nonatomic,retain) StockParams *sParams;
@property(nonatomic,assign) int msgType;
@property(nonatomic,assign) int sourceId;
@end
