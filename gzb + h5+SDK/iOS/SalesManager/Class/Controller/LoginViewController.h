//
//  LoginViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "InputCell.h"

@class AppDelegate;

@interface LoginViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,RequestAgentDelegate> {
    UITableView *tableView;
    InputCell *accountCell;
    InputCell *passwordCell;
    AppDelegate *appDelegate;
}

@end
