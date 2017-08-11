//
//  SaleListViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-8.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "SaleSearchViewController.h"

@interface SaleListViewController : BaseViewController<SaleSearchDelegate,UITableViewDataSource, PullTableViewDelegate>{
    SaleGoodsParams_Builder *sgParamsBuilder;
    //SaleGoodsParams *sgParams;

    int currentPage;
    int pageSize;
    int totalSize;
    NSMutableArray *saleArray;
}

@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property (retain, nonatomic) NSMutableArray* saleArray;
@property (retain, nonatomic) SaleGoodsParams* sgParams;
@property(nonatomic,assign) int msgType;
@property(nonatomic,assign) int sourceId;
@end
