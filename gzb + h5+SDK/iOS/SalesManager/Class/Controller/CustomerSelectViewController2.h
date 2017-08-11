//
//  CustomerSelectViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/3/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "NewCustomerBar.h"
#import "SMCustomer.h"
#import "CommonCell.h"
#import "NewCustomerView.h"
#import "MCSegmentedControl.h"
@class MBProgressHUD;
@class CustomerSelectViewController;
@protocol CustomerCategoryDelegate2 <NSObject>

- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject;
- (void)customerSearchDidCanceled:(CustomerSelectViewController *)controller;
- (void)newCustomerDidFinished:(CustomerSelectViewController *)controller newCustomer:(id)aObject;
@end

@interface CustomerSelectViewController2 : BaseViewController<UIActionSheetDelegate,CommonCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{

    NewCustomerView *newCustomerView;
    UITableView *tableView;
    UISearchBar *searchBar;
    
    NSMutableArray *customers;
    NSMutableArray *filterCustomers;
    NSMutableArray *favoratCustomers;
    NSMutableArray *customerCategories;
    UIBarButtonItem *btAddCustomer;
    //NewCustomerBar *newCustomerBar;
    UIView *addCustomerBar;
    UITextField *txtCustomer;
    BOOL bNewCustomer;
    int categoryIndex;
    BOOL bNeedAddCustomer;
    BOOL bNeedAll;
    BOOL bCustomerSync;

    UIBarButtonItem *btNewCustomer;
    UISegmentedControl *segmentCtrl;
    MBProgressHUD *HUD;
}

@property (nonatomic,retain) NSMutableArray *customerArray;

@property (nonatomic,retain) UIBarButtonItem *btNewCustomer;
@property (nonatomic,assign) id<CustomerCategoryDelegate2> delegate;
@property (nonatomic,assign) BOOL bNeedAddCustomer;
@property (nonatomic,assign) BOOL bNeedAll;
@property (nonatomic,assign) UITableView *tableView;
-(void) reload;
@end
