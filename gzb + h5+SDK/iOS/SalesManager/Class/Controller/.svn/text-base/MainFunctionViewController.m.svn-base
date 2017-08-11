//
//  MainFunctionViewController.m
//  SalesManager
//
//  Created by liu xueyan on 7/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "MainFunctionViewController.h"
#import "MainMenuViewController.h"
#import "ProfileCell.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "HintHelper.h"
#import "NAMenuItem.h"

@interface MainFunctionViewController ()

@end

@implementation MainFunctionViewController
@synthesize bHasNotification;

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
    
    appDelegate = APPDELEGATE;
    
    if (bHasNotification ) {
        [appDelegate toOpenNotficationDetail];
    }
    bHasNotification = NO;
    
     if (appDelegate.remoteNotificationDict != nil) {
         [appDelegate.remoteNotificationDict release];
         appDelegate.remoteNotificationDict = nil;
     }
     
}

-(void)viewWillAppear:(BOOL)animated{
    [self initMenu];

}

#pragma mark - NAMenuViewDelegate Methods

- (NSUInteger)menuViewNumberOfItems:(id)menuView {
	return functionItems.count;
}

- (NAMenuItem *)menuView:(NAMenuView *)menuView itemForIndex:(NSUInteger)index {
	return [functionItems objectAtIndex:index];
}

- (void)menuView:(NAMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index {
    if (AGENT.bUserIdChanged) {
        [super showMessage:ActionCodeErrorAccountException Title:NSLocalizedString(@"error_operation", @"") Description:@""];
        return;
    }
    NAMenuItem *item = [functionItems objectAtIndex:index];
    [appDelegate.leftSideDrawerViewController selectCell:item.functionId];
	//Class class = [[functionItems objectAtIndex:index] targetViewControllerClass];
	UIViewController *viewController = [[functionItems objectAtIndex:index] viewCtrl];
	[appDelegate.drawerController setCenterViewController:viewController withCloseAnimation:YES completion:nil];
}

-(void)initMenu{

    [self createMenuItems];
    
    if (tableView != nil) {
        [tableView removeFromSuperview];
        [tableView release];
        tableView = nil;
    }
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 120) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.userInteractionEnabled = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    
    
    if (menuView != nil) {
        [menuView removeFromSuperview];
        [menuView release];
        menuView = nil;
    }
    /*
    if (scrollView != nil) {
        [scrollView removeFromSuperview];
        [scrollView release];
        scrollView = nil;
    }*/
    int scrollViewHeight = MAINHEIGHT;
    /*
    int menuViewHeight = 310;
    if (functionItems.count > 9) {
        menuViewHeight = 380;
        scrollViewHeight = menuViewHeight;
    }*/
/*
    scrollView=[[UIScrollView alloc] initWithFrame: CGRectMake(0,90,320,MAINHEIGHT - 90)];
    if (!IS_IPHONE5)
        scrollView.contentSize = CGSizeMake(320,MAINHEIGHT);
    scrollView.delegate = self;
    */
    menuView = [[NAMenuView alloc] init];

    [menuView setFrame:CGRectMake(0, 110, 320, scrollViewHeight-110)];//20//menuViewHeight
    
    [menuView setBackgroundColor:[UIColor clearColor]];
    menuView.delegate = self;
    menuView.menuDelegate = self;
    menuView.showsVerticalScrollIndicator = NO;
    //[scrollView addSubview:menuView];
    [self.view addSubview:menuView];
    [self.view addSubview:tableView];
    [lblFunctionName setText:NSLocalizedString(@"app_name", @"")];
    
    [self showHint:HintViewDashboard];
}

- (void)createMenuItems {
//    if (functionItems.count > 0){
//        [functionItems removeAllObjects];
//        [functionItems release];
//        functionItems = nil;
//    }
//	functionItems = [[NSMutableArray alloc] initWithCapacity:11];
//    NSMutableArray* userFunc = [LOCALMANAGER getFunctions];
//    
//    BOOL bHasCompany = NO;
//    for (Function* f in userFunc){
//        if ([FUNC_COMPANY_CONTACT_DES isEqual: f.value]){
//            bHasCompany = YES;
//            break;
//        }
//    }
//    BOOL bHasCustomer = NO;
//    for (Function* f in userFunc) {
//        if ([f.value isEqual: FUNC_CUSTOMER_CONTACT_DES]){
//            bHasCustomer = YES;
//            break;
//        }
//    }
//    if (bHasCompany && bHasCustomer) {
//        NAMenuItem *item9 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"contacts", nil)
//                                                        iconFile:[NSString fontAwesomeIconStringForEnum:ICON_CONTACT]iconColor:WT_RED                                               viewController:(APPDELEGATE).contactsPageNavCtrl];
//        item9.functionId = FUNC_CONTACTS;
//        [functionItems addObject:item9];
//    }else if(bHasCompany){
//        NAMenuItem *item9 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"contacts", nil)
//                                                        iconFile:[NSString fontAwesomeIconStringForEnum:ICON_CONTACT]iconColor:WT_RED
//                                               viewController:(APPDELEGATE).companyContactNavCtrl];
//        item9.functionId = FUNC_COMPANY_CONTACT;
//        [functionItems addObject:item9];
//    
//    }else if(bHasCustomer){
//        NAMenuItem *item10 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"contacts", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_CONTACT]iconColor:WT_RED
//                                                viewController:(APPDELEGATE).endContactNavCtrl];
//        item10.functionId = FUNC_CUSTOMER_CONTACT;
//        [functionItems addObject:item10];
//    }
//    
//    for (Function* f in userFunc) {
//        if ([f.value isEqual: FUNC_ATTENDANCE_DES]){
//            
//            NAMenuItem *item1 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_attendance", nil) iconFile:[NSString fontAwesomeIconStringForEnum:ICON_ATTENDANCE] iconColor:WT_RED viewController:(APPDELEGATE).attendanceNavCtrl];
//            item1.functionId  = FUNC_ATTENDANCE;
//            [functionItems addObject:item1];
//            continue;
//        }
//        if ([f.value isEqual: FUNC_PATROL_DES]){
//            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_patrol", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_PATROL]iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).patrolNavCtrl];
//            item2.functionId = FUNC_PATROL;
//            [functionItems addObject:item2];
//            continue;
//        }
//        if ([f.value isEqual: FUNC_PATROL_DES]){
//            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"patrol_task", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL] iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).patrolTaskNavCtrl];
//            item2.functionId = FUNC_PATROL_TASK;
//            [functionItems addObject:item2];
//            continue;
//        }
//        if ([f.value isEqual: FUNC_INSPECTION_DES]){
//            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_inspection", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_INPECTION]iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).inspectionNavCtrl];
//            item2.functionId = FUNC_INSPECTION;
//            [functionItems addObject:item2];
//            continue;
//        }
//        if ([f.value isEqual: FUNC_WORKLOG_DES]){
//            NAMenuItem *item5 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_worklog", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_WORKLOG]iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).worklogNavCtrl];
//            item5.functionId = FUNC_WORKLOG;
//            [functionItems addObject:item5];
//            continue;
//        }
//        if ([f.value isEqual: FUNC_RESEARSH_DES]){
//            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_research", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_MARKET_RESEARCH] iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).researchNavCtrl];
//            item2.functionId = FUNC_RESEARSH;
//            [functionItems addObject:item2];
//            continue;
//        }
//        if ([f.value isEqual: FUNC_BIZOPP_DES]){
//            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_bizopp", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_BUSSINESS_OPPORTUNITY] iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).bizOppNavCtrl];
//            item2.functionId = FUNC_BIZOPP;
//            [functionItems addObject:item2];
//            continue;
//        }
//        if ([f.value isEqual: FUNC_COMPETITION_DES]){
//            NAMenuItem *item5 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_competition", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_COMPETITION] iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).competitionNavCtrl];
//            item5.functionId = FUNC_COMPETITION;
//            [functionItems addObject:item5];
//            continue;
//        }
//        if ([f.value isEqual: FUNC_SELL_TODAY_DES]){
//            
//            NAMenuItem *item7 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_today_sales", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_SELL_TODAY] iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).saleNavCtrl];
//            item7.functionId = FUNC_SELL_TODAY;
//            [functionItems addObject:item7];
//            continue;
//        }
//        if ([f.value isEqual:FUNC_SELL_ORDER_DES]){
//            
//            NAMenuItem *item6 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_goods", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_SELL_ORDER] iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).orderNavCtrl];
//            item6.functionId = FUNC_SELL_ORDER;
//            [functionItems addObject:item6];
//            continue;
//        }
//        if ([f.value isEqual:FUNC_SELL_STOCK_DES]){
//            NAMenuItem *item3 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_uploadstock", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_SELL_STOCK] iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).stockNavCtrl];
//            item3.functionId = FUNC_SELL_STOCK;
//            [functionItems addObject:item3];
//            continue;
//        }
//        if ([f.value isEqual:FUNC_SELL_REPORT_DES]){
//            NAMenuItem *item4 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_statistics", nil)
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_SELL_ORDER] iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).salestatisticsNavCtrl];
//            item4.functionId = FUNC_SELL_REPORT;
//            [functionItems addObject:item4];
//            continue;
//        }
//        if ([f.value isEqual:FUNC_APPROVE_DES]){
//            NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_approvement", nil)
//                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_APPROVE]
//                                                         iconColor:WT_RED
//                                                    viewController:(APPDELEGATE).applyNavCtrl];
//            item12.functionId = FUNC_APPROVE;
//            [functionItems addObject:item12];
//            continue;
//        }
//        if ([f.value isEqual:FUNC_GIFT_DES]){
//            NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_gift", nil)
//                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]iconColor:WT_RED
//                                                    viewController:(APPDELEGATE).giftNavCtrl];
//            item12.functionId = FUNC_GIFT;
//            [functionItems addObject:item12];
//        }
//        if ([f.value isEqual:FUNC_VIDEO_DES]){
//            NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_video", nil)
//                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_VIDEO]iconColor:WT_RED
//                                                    viewController:(APPDELEGATE).giftNavCtrl];
//            item12.functionId = FUNC_VIDEO;
//            [functionItems addObject:item12];
//        }
//    }
//        /*
//        if ([f.value isEqual: @"TASK"]){
//            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_task", nil)
//                                                            image:[UIImage imageNamed:@"ic_task_dashboard"]
//                                                   viewController:(APPDELEGATE).taskManageNavCtrl];
//            item2.functionId = FUNC_TASK;
//            [functionItems addObject:item2];
//        }
//         */
//    
//    NAMenuItem *item10 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_message", nil)
//                                                  iconFile:[NSString fontAwesomeIconStringForEnum:ICON_MESSAGE]
//                                                 iconColor:WT_RED
//                                            viewController:(APPDELEGATE).myMessageNavCtrl];
//    item10.functionId = FUNC_MESSAGE;
//    [functionItems addObject:item10];
//    
//    
//    NAMenuItem *item11 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"my_favorate", nil)
//                                                  iconFile:[NSString fontAwesomeIconStringForEnum:ICON_FAV]
//                                                 iconColor:WT_RED
//                                            viewController:(APPDELEGATE).myfavorateNavCtrl];
//    item11.functionId = FUNC_FAVORATE;
//    [functionItems addObject:item11];
//    
//    NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"menu_function_datasync", nil)
//                                                  iconFile:[NSString fontAwesomeIconStringForEnum:ICON_DATA_SYNC]
//                                                 iconColor:WT_RED                                                          viewController:(APPDELEGATE).datasyncNavCtrl];
//    item12.functionId = FUNC_SYNC;
//    [functionItems addObject:item12];
//
//    
//	return;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 105.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"CellIdentifier";
    ProfileCell *cell=(ProfileCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ProfileView" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[ProfileCell class]])
                cell=(ProfileCell *)oneObject;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite_topbar_bg_orange"]];
            [cell setBackgroundView:imageView];
            [imageView release];

        }
        [cell.lblIcon setText:[NSString fontAwesomeIconStringForEnum:ICON_PROFILE]];
        cell.lblIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
        
        [cell.lblCompany setText:appDelegate.currentUser.company.name];
        [cell.lblDepart setText:appDelegate.currentUser.department.name];
        //[cell.lblPosition setText:appDelegate.currentUser.positionName];
        [cell.lblName setText:[NSString stringWithFormat:@"%@（%@）",appDelegate.currentUser.realName,appDelegate.currentUser.userName]];
    
    }

    return cell;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tableView release];
    /*
    [profileView release];
    [lblCompany release];
    [lblName release];
    [lblDepart release];
    [lblPosition release];*/
    [super dealloc];
}
- (void)viewDidUnload {
    [tableView release];
    tableView = nil;
    /*
    [profileView release];
    profileView = nil;
    [lblCompany release];
    lblCompany = nil;
    [lblName release];
    lblName = nil;
    [lblDepart release];
    lblDepart = nil;
    [lblPosition release];
    lblPosition = nil;*/
    [super viewDidUnload];
}

@end
