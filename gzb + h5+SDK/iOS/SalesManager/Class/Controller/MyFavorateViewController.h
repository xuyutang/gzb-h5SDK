//
//  MyFavorateViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PatrolTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "HMSegmentedControl.h"

@interface MyFavorateViewController : BaseViewController{
    UIView *rightView;
    UISegmentedControl *contactsTypeSegctrl;
    PatrolTypeViewController *patrTypeCtrl;
    CustomerSelectViewController *customerCtrl;
    HMSegmentedControl *contactSegmentCtrl;
    
}

@end
