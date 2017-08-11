//
//  CustomerSelectViewController.h
//  SalesManager
//
//  Created by Administrator on 16/3/16.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerListViewController.h"
#import "NewCustomerViewController.h"
#import "CustomerSelectViewController2.h"
#import "FavCustomerViewController.h"
@protocol CustomerCategoryDelegate <NSObject>

- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject;
- (void)customerSearchDidCanceled:(CustomerSelectViewController *)controller;
- (void)newCustomerDidFinished:(CustomerSelectViewController *)controller newCustomer:(id)aObject;
@end
@interface CustomerSelectViewController : BaseCustomerViewController<UITableViewDelegate,UITableViewDataSource,NewCustomerViewControllerDelegate,CustomerCategoryDelegate,FavCustomerDelegate>
{
    UIView *_favView;
    NSMutableArray *_favCusts;
}

@property (nonatomic,assign) id<CustomerCategoryDelegate> delegate;
@property (nonatomic,assign) BOOL bNeedAddCustomer;
@property (nonatomic,assign) BOOL bNeedAll;

@end
