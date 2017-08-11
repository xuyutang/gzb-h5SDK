//
//  MyFavoratePageViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-11-25.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "MyFavoratePageViewController.h"
#import "DAPagesContainer.h"
#import "CompanySpaceViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "CustomerSelectViewController2.h"
#import "PatrolTypeViewController.h"
#import "ProductFavorateViewController.h"
#import "GiftStockViewController.h"

@interface MyFavoratePageViewController ()<DAPagesContainerDelegate>
@property (strong, nonatomic) DAPagesContainer *pagesContainer;
@end

@implementation MyFavoratePageViewController

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
    
    [lblFunctionName setText:NSLocalizedString(@"my_favorate", @"")];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
       saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveFavorate)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    
    
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;
    ctrlArray =[[NSMutableArray alloc] initWithCapacity:3];
    
//    CustomerSelectViewController2 *customerCtrl = [[CustomerSelectViewController2 alloc] init];
//    customerCtrl.title = NSLocalizedString(@"favorate_segment_customer", nil);
//    CGRect frame = customerCtrl.view.frame;
//    [customerCtrl.view setFrame:CGRectMake(frame.origin.x,frame.origin.y-64,frame.size.width,MAINHEIGHT)];
//    CGRect tableFrame = customerCtrl.tableView.frame;
//    tableFrame.size.height -= 88;
//    [customerCtrl.tableView setFrame:tableFrame];
//    [ctrlArray addObject:customerCtrl];
    CGRect frame,tableFrame;
    PatrolTypeViewController *patrTypeCtrl = [[PatrolTypeViewController alloc] init];
    patrTypeCtrl.title = [NSString stringWithFormat:@"巡访类型收藏"];
    patrTypeCtrl.bNeedAll = NO;
    patrTypeCtrl.bFavorate = NO;
    frame = patrTypeCtrl.view.frame;
    [patrTypeCtrl.view setFrame:CGRectMake(frame.origin.x,frame.origin.y-20,frame.size.width,MAINHEIGHT)];
    tableFrame = patrTypeCtrl.tableView.frame;
    tableFrame.size.height -= 45;
    [patrTypeCtrl.tableView setFrame:tableFrame];
    
    [ctrlArray addObject:patrTypeCtrl];
   
    
    productVctrl = [[ProductFavorateViewController alloc] init];
    productVctrl.title = [NSString stringWithFormat:@"产品收藏"];
    [ctrlArray addObject:productVctrl];
    self.pagesContainer.viewControllers = ctrlArray;
    
    appDelegate = APPDELEGATE;
    
    if (bNeedBack) {
        leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
}

-(void)clickLeftButton:(id)sender{
    if (bNeedBack){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [super clickLeftButton:sender];
    }
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
    [productVctrl.searchField resignFirstResponder];
    if ([ctrlArray count] > 0) {
         [[ctrlArray objectAtIndex:index] reload];
    }
}

-(void)saveFavorate{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    FavData_Builder* fb = [FavData builder];
//    [fb setCustomersArray:[LOCALMANAGER getFavCustomers]];
    [fb setPatrolCategoriesArray:[LOCALMANAGER getFavPatrolCategories]];
    [fb setProductsArray:[LOCALMANAGER getFavProducts]];
    
    (APPDELEGATE).agent.delegate = self;
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeFavSave param:[fb build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"my_favorate", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type) ) {
        case ActionTypeFavSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                (APPDELEGATE).bChangeFavorate = NO;
            }
            [super showMessage2:cr Title:NSLocalizedString(@"my_favorate", @"") Description:NSLocalizedString(@"favorate_commit_done", @"")];
        }
            break;
    }
}


@end
