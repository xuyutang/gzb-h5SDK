//
//  CompanySpacePageViewController.h
//  SalesManager
//
//  Created by liuxueyan on 24/4/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface CompanySpacePageViewController : BaseViewController{
    PBAppendableArray* spaceCategories;
    
    NSMutableArray *ctrlArray;
    AppDelegate* appDelegate;
}


@end
