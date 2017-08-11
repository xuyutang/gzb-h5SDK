//
//  DashboardViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-4-22.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "NAMenuView.h"
#import "SWTableViewCell.h"
@interface DashboardViewController : BaseViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,NAMenuViewDelegate,SWTableViewCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) UIViewController *parentController;
@property (nonatomic,assign) BOOL bToSyncUI;
@end
