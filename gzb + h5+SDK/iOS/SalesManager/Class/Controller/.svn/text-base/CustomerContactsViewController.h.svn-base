//
//  CustomerContactsViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "CustomerContactCell.h"
#import "UTTableView.h"
#import "BaseViewController.h"
#import "PullTableView.h"
@class MBProgressHUD;
@class HeaderSearchBar;
@interface CustomerContactsViewController : BaseViewController<MFMessageComposeViewControllerDelegate,CustomerContactCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *contacts;
    NSMutableArray *filterContacts;
    NSMutableArray *customerCategories;

    NSMutableArray *selectTels;
    NSMutableArray *custMularray;
    MBProgressHUD *HUD;
    BOOL bCustomerSync;
    UIViewController *parentCtrl;
    
    int index;
    int pageSize;
    int totalSize;
    
    // CustomerParams *customerParams;
    int currentPage;
    int pageSize2;
    int totleSize;
    int currentRow;
    Customer *currentCus;
}
- (void) reload;
@property(nonatomic,retain) PullTableView *tableView;
@property(nonatomic,retain) NSMutableArray *selectTels;
@property(nonatomic,retain) UIViewController *parentCtrl;
@property (nonatomic,retain) CustomerParams *customerParams;

@property (nonatomic,retain) HeaderSearchBar *searchBar;
@property (nonatomic,retain) NSMutableArray *searchViews;

@end
