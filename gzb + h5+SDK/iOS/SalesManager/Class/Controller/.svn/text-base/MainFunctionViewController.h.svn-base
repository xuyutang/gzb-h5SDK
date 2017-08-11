//
//  MainFunctionViewController.h
//  SalesManager
//
//  Created by liu xueyan on 7/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "NAMenuView.h"

@class AppDelegate;

@interface MainFunctionViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource, NAMenuViewDelegate,UIScrollViewDelegate>{

    NSMutableArray *functionItems;
    NAMenuView *menuView;
    UIScrollView *scrollView;

    UITableView *tableView;
    
    AppDelegate* appDelegate;
}
@property(nonatomic,assign) BOOL bHasNotification;

-(void)initMenu;


@end
