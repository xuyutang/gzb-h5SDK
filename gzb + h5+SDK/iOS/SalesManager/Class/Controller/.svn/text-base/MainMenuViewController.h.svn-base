//
//  MainMenuViewController.h
//  SalesManager
//
//  Created by liu xueyan on 7/30/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateVersion.h"

@class AppDelegate;

@interface MainMenuViewController : UITableViewController<UIActionSheetDelegate,UpdateVersionDelegate>{//<UITableViewDataSource,UITableViewDelegate>

    //UITableView *tableView;
    NSMutableArray *menuItems;
    NSMutableArray *othermenuItems;
    BOOL getMessageIsRunning;
    AppDelegate* appDelegate;
}

@property(nonatomic,retain) NSMutableArray *menuItems;
@property(nonatomic,retain) NSMutableArray *othermenuItems;


-(void)selectCell:(int)functionId;
-(void)initData;

@end
