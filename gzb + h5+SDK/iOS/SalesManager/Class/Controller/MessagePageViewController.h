//
//  MessagePageViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-10-10.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#define SELECT_ANNOUNCE 0
#define SELECT_MESSAGE  1
@class DAPagesContainer;
@interface MessagePageViewController : BaseViewController{
    NSMutableArray *ctrlArray;
    AppDelegate* appDelegate;
}
@property(nonatomic,retain) UIViewController *parentController;
@property (assign, nonatomic) int selectItem;
@property (assign, nonatomic) int userId;
@end
