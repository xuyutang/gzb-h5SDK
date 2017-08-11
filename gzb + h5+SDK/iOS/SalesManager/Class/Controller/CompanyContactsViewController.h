//
//  CompanyContactsViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "CompanyContactCell.h"
#import "PullTableView.h"
#import "BaseViewController.h"
@class MBProgressHUD;
@interface CompanyContactsViewController : BaseViewController<MFMessageComposeViewControllerDelegate,CompanyContactCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    
   
    UISearchBar *searchBar;
    NSMutableArray *contacts;
    NSMutableArray *filterContacts;
    
    NSMutableArray *selectTels;
    MBProgressHUD *HUD;
    UIViewController *parentCtrl;
}
- (void) reload;
@property(nonatomic,retain) PullTableView *tableView;
@property(nonatomic,retain) NSMutableArray *selectTels;
@property(nonatomic,retain) UIViewController *parentCtrl;

@end
