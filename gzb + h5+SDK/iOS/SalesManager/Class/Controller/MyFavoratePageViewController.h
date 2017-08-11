//
//  MyFavoratePageViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-11-25.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "ProductFavorateViewController.h"

@interface MyFavoratePageViewController : BaseViewController{
    PBAppendableArray* spaceCategories;
    
    NSMutableArray *ctrlArray;
    AppDelegate* appDelegate;
    ProductFavorateViewController *productVctrl;
}


@end
