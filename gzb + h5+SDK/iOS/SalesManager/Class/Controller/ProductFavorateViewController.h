//
//  ProductFavorateViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-11-25.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonCell.h"

@class MBProgressHUD;
@interface ProductFavorateViewController : BaseViewController<UIActionSheetDelegate,CommonCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *tableView;
    UISearchBar *searchBar;
      NSMutableArray *products;
    NSMutableArray *filterProducts;
    NSMutableArray *favoratProducts;
    NSMutableArray *productCategories;

    //NewCustomerBar *newCustomerBar;
    UIView *addCustomerBar;
    UITextField *txtProdct;

    int categoryIndex;

    BOOL bCustomerSync;
    MBProgressHUD *HUD;
}

@property (nonatomic,strong)UITextField *searchField;
@property (nonatomic,retain) NSMutableArray *customerArray;
@property (nonatomic,assign) UITableView *tableView;
-(void) reload;


@end
