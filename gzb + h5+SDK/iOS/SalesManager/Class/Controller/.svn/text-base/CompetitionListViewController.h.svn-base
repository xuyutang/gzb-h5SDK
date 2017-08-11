//
//  CompetitionListViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-11.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "CompetitionSearchViewController.h"

@interface CompetitionListViewController : BaseViewController<UITableViewDataSource, PullTableViewDelegate,CompetitionSearchDelegate>{
    //CompetitionGoodsParams *cgParams;
    CompetitionGoodsParams_Builder* cgBuilder;
    int currentPage;
    int pageSize;
    int totalSize;
    
    NSMutableArray *competitionArray;
}
@property (retain, nonatomic) CompetitionGoodsParams *cgParams;
@property (retain, nonatomic) NSMutableArray *competitionArray;
@property (retain, nonatomic) IBOutlet PullTableView *pullTableView;
@property(nonatomic,assign) int msgType;
@property(nonatomic,assign) int sourceId;
@end
