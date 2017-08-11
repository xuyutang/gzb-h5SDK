//
//  MyFavorateViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "MyFavorateViewController.h"
#import "PatrolTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "Constant.h"

@interface MyFavorateViewController ()

@end

@implementation MyFavorateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    [super viewDidLoad];
    [lblFunctionName setText:NSLocalizedString(@"my_favorate", @"")];
    customerCtrl = [[CustomerSelectViewController alloc] init];
    CGRect frame = customerCtrl.view.frame;
    [customerCtrl.view setFrame:CGRectMake(frame.origin.x,frame.origin.y-20,frame.size.width,MAINHEIGHT)];
    CGRect tableFrame = customerCtrl.tableView.frame;
    tableFrame.size.height -= 88;
    [customerCtrl.tableView setFrame:tableFrame];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
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
    
    patrTypeCtrl = [[PatrolTypeViewController alloc] init];
    patrTypeCtrl.bNeedAll = NO;
    patrTypeCtrl.bFavorate = YES;
    frame = patrTypeCtrl.view.frame;
    [patrTypeCtrl.view setFrame:CGRectMake(frame.origin.x,frame.origin.y-20,frame.size.width,MAINHEIGHT)];
    tableFrame = patrTypeCtrl.tableView.frame;
    tableFrame.size.height -= 88;
    [patrTypeCtrl.tableView setFrame:tableFrame];
    [self.view addSubview:patrTypeCtrl.view];
    [self.view addSubview:customerCtrl.view];
    customerCtrl.view.hidden = YES;
    
    contactSegmentCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:@[NSLocalizedString(@"favorate_segment_patrol", nil), NSLocalizedString(@"favorate_segment_customer", nil)]];//[[UISegmentedControl alloc] initWithItems:segmentArray];
    
    [contactSegmentCtrl setFrame:CGRectMake(0, MAINHEIGHT - 44, 320, 44)];
    [contactSegmentCtrl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
    contactSegmentCtrl.selectionIndicatorMode = HMSelectionIndicatorFillsSegment;
    contactSegmentCtrl.textColor = [UIColor whiteColor];
    contactSegmentCtrl.selectionIndicatorColor = [UIColor colorWithRed:244 green:235 blue:0 alpha:0.8];
    [contactSegmentCtrl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:contactSegmentCtrl];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    switch (contactSegmentCtrl.selectedIndex) {//[sender selectedSegmentIndex]
        case 0:{
            [patrTypeCtrl reload];
        }
            break;
        case 1:{
            [customerCtrl reload];
        }
            break;
            
    }
}

-(void)segmentAction:(id)sender{

    switch (contactSegmentCtrl.selectedIndex) {//[sender selectedSegmentIndex]
        case 0:{

            patrTypeCtrl.view.hidden = NO;       //显示controller1
            customerCtrl.view.hidden = YES;
            [patrTypeCtrl reload];
        }
            break;
        case 1:{
            customerCtrl.view.hidden = NO;       //显示controller1
            patrTypeCtrl.view.hidden = YES;
            
            [customerCtrl reload];
        }
            break;
    
    }
}

-(void)saveFavorate{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:(APPDELEGATE).currentUser,@"user",[LOCALMANAGER getFavCustomers],@"favCustomers", [LOCALMANAGER getFavPatrolCategories],@"favPatrolCategories",[LOCALMANAGER getFavProducts],@"favProducts",nil];
    (APPDELEGATE).agent.delegate = self;
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeFavSave param:params]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"my_favorate", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    [params release];
    
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
