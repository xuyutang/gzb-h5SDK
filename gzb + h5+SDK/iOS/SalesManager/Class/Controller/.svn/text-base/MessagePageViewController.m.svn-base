//
//  MessagePageViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-10-10.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "MessagePageViewController.h"
#import "DAPagesContainer.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "MessageViewController.h"
#import "AnnounceViewController.h"
#import "AddMessageViewController.h"


@interface MessagePageViewController ()<DAPagesContainerDelegate> {

  UIView *rightView;
  UIImageView *addImageView;
  NSMutableArray *permissionMuarray;
    
}
@property (strong, nonatomic) DAPagesContainer *pagesContainer;
@end

@implementation MessagePageViewController
@synthesize userId,selectItem,parentController;
- (void)viewDidLoad {
    //init navigationbarsm
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    lblFunctionName.text = TITLENAME(FUNC_MESSAGE_DES);
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
    [addImageView setImage:[UIImage imageNamed:@"ab_icon_add"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMessage:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    addImageView.userInteractionEnabled = YES;
    addImageView.contentMode = UIViewContentModeScaleAspectFit;
    [addImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:addImageView];
    [addImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = btRight;
    [btRight release];

    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, MAINHEIGHT + 40);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;
    
    ctrlArray =[[NSMutableArray alloc] initWithCapacity:2];
    AnnounceViewController *spaceViewController1 = [[AnnounceViewController alloc] init];
    spaceViewController1.title = NSLocalizedString(@"云通知", nil);
    if (parentController != nil) {
        spaceViewController1.parentCtrl = self.parentController;
    }else{
        spaceViewController1.parentCtrl = self;
    }
    
    [ctrlArray addObject:spaceViewController1];
    
    MessageViewController *spaceViewController2 = [[MessageViewController alloc] init];
    spaceViewController2.title = NSLocalizedString(@"favorate_segment_message", nil);
    if (parentController != nil) {
        spaceViewController2.parentCtrl = self.parentController;
    }else{
        spaceViewController2.parentCtrl = self;
    }
    spaceViewController2.userId = userId;
    [ctrlArray addObject:spaceViewController2];
    
    self.pagesContainer.viewControllers = ctrlArray;
    [self addChildViewController:self.pagesContainer];
    [self.pagesContainer setSelectedIndex:selectItem animated:YES];
    appDelegate = APPDELEGATE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncAnnouceNotification) name:@"syncAnnouceNotification" object:nil];
}

-(void)syncAnnouceNotification {
   [self checkPermission];
   
}

//-(void)viewDidAppear:(BOOL)animated {
 //  [self checkPermission];
//}

-(void)addMessage:(id)sender {
    AddMessageViewController *addMessageVC = [[AddMessageViewController alloc] init];
    [self.navigationController pushViewController:addMessageVC animated:YES];

}

-(void)syncTitle {
 lblFunctionName.text = TITLENAME(FUNC_MESSAGE_DES);
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

-(void) didSelected:(int)index{
    if ([ctrlArray count] > 0) {
        [([ctrlArray objectAtIndex:index]) reload];
    }
    if (index == 0) {
        //判断用户是否拥有增加云通知的权限,没有则隐藏
        permissionMuarray = [LOCALMANAGER getUserPermisson];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [permissionMuarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:((Permission*)obj).value];
        }];
        if ([array containsObject:USER_PERMISSION_ANNOUNCE_ADD]) {
            addImageView.hidden = NO;
            
        }else {
            addImageView.hidden = YES;
        }
        
        }else {
        addImageView.hidden = YES;
    }

}

-(void)checkPermission {
    permissionMuarray = [LOCALMANAGER getUserPermisson];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [permissionMuarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:((Permission*)obj).value];
    }];
    if ([array containsObject:USER_PERMISSION_ANNOUNCE_ADD]) {
        addImageView.hidden = NO;
        
    }else {
        addImageView.hidden = YES;
    }
}

@end
