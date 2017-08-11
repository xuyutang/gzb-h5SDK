//
//  AttencePageViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/11/13.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@class DAPagesContainer;

@interface AttencePageViewController : BaseViewController {
    NSMutableArray *contrlArray;
    AppDelegate* appDelegate;
    UIView *rightView;
    NSMutableArray *attendanceTypeMularray;
    NSMutableArray *checkInChannelMularray;
}

@property(nonatomic,retain) UIViewController *parentController;
@property (assign, nonatomic) int selectItem;
@property (assign, nonatomic) int userId;
@property (nonatomic,assign) NSString* type;
@property (nonatomic,strong) UIImageView *addWifiImageView;;

@end
