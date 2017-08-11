//
//  DataSyncViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "ProgressButton.h"

@class AppDelegate;


static BOOL bFirstLogin;
@interface DataSyncViewController : BaseViewController<RequestAgentDelegate>{
    NSString* autoSync;
    AppDelegate* appDelegate;
    UILabel *lblSyncTime;
    
    ProgressButton *btBaseProgressButton;
    ProgressButton *btCustomProgressButton;
    
    UIActionSheet* baseActionSheet;
    UIActionSheet* customerActionSheet;
    UILabel *lblCountBase;
    UILabel *lblCountCustomer;
    int currentPage;
    int pageSize;
    int totalSize;
    int currentSize;
    BOOL bClear;
    //当基础同步 和企业通讯录都成功时 ，才显示同步资料成功
    BOOL baseSyncBool;
    BOOL companyListSyncBool;
}

+(void) setBFirstLogin:(BOOL) bFirst;


@end