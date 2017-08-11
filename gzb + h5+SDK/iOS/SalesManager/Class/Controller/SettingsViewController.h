//
//  SettingsViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-11.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "SettingsCell.h"

@interface SettingsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *tableView;
    SettingsCell *messageCell;
    SettingsCell *locationCell;
}


@end
