//
//  TaskPageViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-6.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface TaskPageViewController : BaseViewController{
    NSMutableArray *ctrlArray;
    AppDelegate* appDelegate;
    UIView *rightView;
}

@property(nonatomic,assign) int showPageIndex;
@property(nonatomic,assign) BOOL bFromMessage;
@property(nonatomic,retain) User* user;
@property(nonatomic,assign) int msgType;
@property(nonatomic,assign) NSString* sourceId;
@end
