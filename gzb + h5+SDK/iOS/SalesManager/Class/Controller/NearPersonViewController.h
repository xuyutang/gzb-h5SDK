//
//  NearPersonViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-5-7.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
@interface NearPersonViewController : BaseViewController
@property (retain, nonatomic) IBOutlet PullTableView *tableView;
@property (nonatomic,retain) UIViewController *parentController;

@end
