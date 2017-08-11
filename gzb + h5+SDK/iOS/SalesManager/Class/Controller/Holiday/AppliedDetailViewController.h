//
//  AppliedDetailViewController.h
//  SalesManager
//  详情
//  Created by iOS-Dev on 16/10/8.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//


#import "LeaveBaseViewController.h"


typedef NS_ENUM(NSInteger,approvalResult) {
    USER_NOT_PASS = 0,
    USER_PASS = 1,
    USER_WAIT = 2,
    USER_PASS_AND_MOVEMENT = 3
} ;

@interface AppliedDetailViewController : LeaveBaseViewController

@property(nonatomic,copy)NSString *applyIdString;

@property (nonatomic,assign)BOOL hasNavBool;
//是否是我审批
@property (nonatomic,assign)BOOL isMyApproveBool;

@property(nonatomic,strong)UIButton *button;

-(void)rel;

@end
