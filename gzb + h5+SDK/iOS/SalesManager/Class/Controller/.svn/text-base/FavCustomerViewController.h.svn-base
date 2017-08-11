//
//  FavCustomerViewController.h
//  SalesManager
//
//  Created by Administrator on 16/3/29.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class FavCustomerViewController;
@protocol FavCustomerDelegate <NSObject>

- (void)favCustomerDelegate:(UIViewController *)controller didSelectWithObject:(id)aObject;
- (void)favCustomerDelegateDidCanceled:(UIViewController *)controller;
- (void)favCustomerDelegateDidFinished:(UIViewController *)controller newCustomer:(id)aObject;
@end

@interface FavCustomerViewController : BaseViewController
{
    NSMutableArray *tmpArr ;

}
@property (nonatomic,retain) NSMutableArray *customers;
@property (nonatomic,retain) User* user;
@property (nonatomic,assign) id<FavCustomerDelegate> delegate;

-(void) deleteCustomerFav;

@end
