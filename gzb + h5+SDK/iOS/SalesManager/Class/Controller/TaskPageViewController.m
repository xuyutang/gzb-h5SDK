//
//  TaskPageViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-3-6.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "TaskPageViewController.h"
#import "DAPagesContainer.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "OnceTaskViewController.h"
#import "CycleTaskViewController.h"
#import "TaskListViewController.h"
#import "UIView+Util.h"
#import "HeaderSearchBar.h"


@interface TaskPageViewController ()<DAPagesContainerDelegate>
@property (strong, nonatomic) DAPagesContainer *pagesContainer;
@end

@implementation TaskPageViewController
@synthesize showPageIndex,bFromMessage,user,msgType,sourceId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init navigationbar
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (bFromMessage) {
        leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    }
    
    lblFunctionName.text = TITLENAME(FUNC_PATROL_TASK_DES);
    
    ctrlArray =[[NSMutableArray alloc] initWithCapacity:2];
//    OnceTaskViewController *spaceViewController1 = [[OnceTaskViewController alloc] init];
//    spaceViewController1.title = NSLocalizedString(@"patrol_task_single", nil);
//    spaceViewController1.parentCtrl = self;
//    [ctrlArray addObject:spaceViewController1];
//    
//    CycleTaskViewController *spaceViewController2 = [[CycleTaskViewController alloc] init];
//    spaceViewController2.title = NSLocalizedString(@"patrol_task_repeat", nil);
//    spaceViewController2.parentCtrl = self;
//    [ctrlArray addObject:spaceViewController2];
//    
//    TaskListViewController *spaceViewController3 = [[TaskListViewController alloc] init];
//    spaceViewController3.title = NSLocalizedString(@"patrol_task_all", nil);
//    spaceViewController3.parentCtrl = self;
//    spaceViewController3.user = (user != nil) ? user : nil;
//    if (!sourceId.isEmpty) {
//        spaceViewController3.msgType = msgType;
//        spaceViewController3.sourceId = sourceId;
//    }
//    
//    [ctrlArray addObject:spaceViewController3];
    
    
    OnceTaskViewController *spaceViewController1 = [[OnceTaskViewController alloc] init];
    spaceViewController1.title = NSLocalizedString(@"patrol_task_single", nil);
    spaceViewController1.parentCtrl = self;
    [ctrlArray addObject:spaceViewController1];
    
    CycleTaskViewController *spaceViewController2 = [[CycleTaskViewController alloc] init];
    spaceViewController2.title = NSLocalizedString(@"patrol_task_repeat", nil);
    spaceViewController2.parentCtrl = self;
    [ctrlArray addObject:spaceViewController2];
    
    TaskListViewController *spaceViewController3 = [[TaskListViewController alloc] init];
    spaceViewController3.title = NSLocalizedString(@"全部任务", nil);
    spaceViewController3.parentCtrl = self;
    spaceViewController3.user = (user != nil) ? user : nil;
    if (!sourceId.isEmpty) {
        spaceViewController3.msgType = msgType;
        spaceViewController3.sourceId = sourceId;
    }
    [ctrlArray addObject:spaceViewController3];
    
    
    /*  搜索图标 导航代理中也有此图标操作
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    UIImageView *seachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    [seachImageView setImage:[UIImage imageNamed:@"topbar_button_search"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:spaceViewController3 action:@selector(openSearchView)];
    [tapGesture1 setNumberOfTapsRequired:1];
    seachImageView.userInteractionEnabled = YES;
    [seachImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:seachImageView];
    [rightView setHidden:YES];
    [seachImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    */
    
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;
    
    self.pagesContainer.viewControllers = ctrlArray;
    
    if (user != nil || (!sourceId.isEmpty)) {
        [self.pagesContainer setSelectedIndex:0 animated:YES];
    }
    
    appDelegate = APPDELEGATE;
    if (-1<showPageIndex<3) {
       // self.pagesContainer.selectedIndex = showPageIndex;
       // [self toPageWithIndex:showPageIndex];
    }
    
    //[self toRefresh];
}

-(void)syncTitle {
    lblFunctionName.text = TITLENAME(FUNC_PATROL_TASK_DES);
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (-1<showPageIndex<3) {
        [self toRefresh];
    }
}

-(void)toRefresh{
    [[ctrlArray objectAtIndex:showPageIndex] reload];
}

-(void)EScrollerViewEnableScroll:(BOOL)bEnable{
    
    self.pagesContainer.scrollView.userInteractionEnabled = bEnable;
    
}

-(IBAction)clickLeftButton:(id)sender{
    if (bFromMessage) {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissModalViewControllerAnimated:YES];
    }else{
        [super clickLeftButton:sender];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toPageWithIndex:(int)index{
    [self didSelected:index];
}

-(void) didSelected:(int)index{
    
    //切换
    showPageIndex = index;
    if (index == 2) {
        //[rightView setHidden:NO];
        
    }else{
        //[rightView setHidden:YES];
        
        //移除ListView中得搜索视图
        TaskListViewController* listView = (TaskListViewController*)ctrlArray[2];
        [UIView removeViewFormSubViews:-1 views:listView.searchViews];
        HeaderSearchBar* searchBar = listView.searchBar;
        for (int i = 0; i < searchBar.buttons.count; i++) {
            [searchBar setColor:i];
        }
    }
    [[ctrlArray objectAtIndex:index] reload];
    
}

-(void)dealloc{
    [super dealloc];
   // [self.pagesContainer release];
    [ctrlArray release];
}

@end
