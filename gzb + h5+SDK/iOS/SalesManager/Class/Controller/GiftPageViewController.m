//
//  GiftPageViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-9-17.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "GiftPageViewController.h"
#import "DAPagesContainer.h"
#import "CompanySpaceViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "GiftPurchaseViewController.h"
#import "GiftDeliveryViewController.h"
#import "GiftDistributeViewController.h"
#import "GiftStockViewController.h"

@interface GiftPageViewController ()<DAPagesContainerDelegate>
@property (strong, nonatomic) DAPagesContainer *pagesContainer;
@end

@implementation GiftPageViewController
@synthesize selectItem,parentController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //init navigationbar
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [lblFunctionName setText:TITLENAME(FUNC_GIFT_DES)];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_search.png"]];
//    [listImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_LIST]];
//    [listImageView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
//    [listImageView setTextColor:WT_RED];
//    [listImageView setTextAlignment:UITextAlignmentCenter];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.contentMode = UIViewContentModeScaleAspectFit;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save.png"]];
//    [saveImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_SAVE ]];
//    [saveImageView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
//    [saveImageView setTextColor:WT_RED];
//    [saveImageView setTextAlignment:UITextAlignmentCenter];
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.rightButton = btRight;
    [btRight release];

    
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;
    
    ctrlArray =[[NSMutableArray alloc] initWithCapacity:4];
    GiftPurchaseViewController *spaceViewController1 = [[GiftPurchaseViewController alloc] init];
    spaceViewController1.title = NSLocalizedString(@"gift_purchase", nil);
    if (parentController != nil) {
        spaceViewController1.parentCtrl = self.parentController;
    }else{
        spaceViewController1.parentCtrl = self;
    }
    [ctrlArray addObject:spaceViewController1];
    
    GiftDeliveryViewController *spaceViewController2 = [[GiftDeliveryViewController alloc] init];
    spaceViewController2.title = NSLocalizedString(@"gift_delivery", nil);
    if (parentController != nil) {
        spaceViewController2.parentCtrl = self.parentController;
    }else{
        spaceViewController2.parentCtrl = self;
    }
    [ctrlArray addObject:spaceViewController2];
    
    GiftDistributeViewController *spaceViewController3 = [[GiftDistributeViewController alloc] init];
    spaceViewController3.title = NSLocalizedString(@"gift_distibute", nil);
    if (self.customer) {
        spaceViewController3.customer = self.customer;
    }
    if (parentController != nil) {
        spaceViewController3.parentCtrl = self.parentController;
    }else{
        spaceViewController3.parentCtrl = self;
    }
    [ctrlArray addObject:spaceViewController3];
    
    GiftStockViewController *spaceViewController4 = [[GiftStockViewController alloc] init];
    spaceViewController4.title = NSLocalizedString(@"gift_stock", nil);
    if (parentController != nil) {
        spaceViewController4.parentCtrl = self.parentController;
    }else{
        spaceViewController4.parentCtrl = self;
    }
    [ctrlArray addObject:spaceViewController4];
    
    
    self.pagesContainer.viewControllers = ctrlArray;
    
    appDelegate = APPDELEGATE;
    [self.pagesContainer setSelectedIndex:selectItem animated:YES];
}

-(void)toList:(id)sender{
    if ([ctrlArray count] > 0) {
        [[ctrlArray objectAtIndex:self.pagesContainer.selectedIndex] toList:nil];
    }

}

-(void)toSave:(id)sender{
    if ([ctrlArray count] > 0) {
        [[ctrlArray objectAtIndex:self.pagesContainer.selectedIndex] toSave:nil];
    }
}

-(void)toRefresh{
    
    if(self.pagesContainer != nil){
        
        [self.pagesContainer.view removeFromSuperview];
        [self.pagesContainer release];
    }
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)EScrollerViewEnableScroll:(BOOL)bEnable{
    
    self.pagesContainer.scrollView.userInteractionEnabled = bEnable;
    
}

-(IBAction)leftButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) _clear{
    if (spaceCategories.count > 0){
        [spaceCategories release];
    }
    if (ctrlArray.count >0) {
        for (UIViewController *ctrl in ctrlArray) {
            [ctrl.view removeFromSuperview];
            [ctrl release];
        }
        [ctrlArray removeAllObjects];
        //self.pagesContainer.viewControllers = ctrlArray;
    }
    spaceCategories = [[PBAppendableArray alloc] init];
}

-(void) didSelected:(int)index{
    if ([ctrlArray count] > 0) {
        //[((UIViewController*)[ctrlArray objectAtIndex:index]) viewWillAppear:YES];
    }
}
@end
