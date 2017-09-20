
//  WorklogListMuiViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 2017/8/28.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "WorklogSearchViewController.h"

#import <Foundation/Foundation.h>
#import "PDRCore.h"
#import "PDRCoreAppWindow.h"

@interface MuiViewController : BaseViewController<WorklogSearchDelegate,PDRCoreDelegate,PDRCoreAppWindowDelegate>

@end
