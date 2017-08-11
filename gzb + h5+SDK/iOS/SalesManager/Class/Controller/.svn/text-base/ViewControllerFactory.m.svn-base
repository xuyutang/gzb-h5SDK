//
//  ViewControllerFactory.m
//  Club
//
//  Created by ZhangLi on 13-12-4.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "ViewControllerFactory.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "NSDate+Util.h"

#import "RDVTabBar.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#import "MyFavoratePageViewController.h"
#import "PatrolViewController.h"
#import "OrderViewController.h"
#import "SaleViewController.h"
#import "StockViewController.h"
#import "GiftDistributeViewController.h"
#import "CompetitionViewController.h"
#import "BusinessOpportunityViewController.h"
#import "ResearchViewController.h"
#import "ContactsPageViewController.h"
#import "SaleListViewController.h"
#import "PatrolListViewController.h"
#import "AttendanceListViewViewController.h"
#import "WorklogListViewController.h"
#import "OrderListViewController.h"
#import "StockListViewController.h"
#import "CompetitionListViewController.h"
#import "BusinessOpportunityListViewController.h"
#import "ResearchListViewController.h"
#import "ApplyListViewController.h"
#import "EditFunctionsViewController.h"
#import "AttendanceViewController.h"
#import "PatrolViewController.h"
#import "TaskPageViewController.h"
#import "InspectionViewController.h"
#import "WorklogViewController.h"
#import "ApplyViewController.h"
#import "GiftPageViewController.h"
#import "MessagePageViewController.h"
#import "DataSyncViewController.h"
#import "InspectionListViewController.h"
#import "DashboardViewController.h"
#import "CustomerListViewController.h"
#import "MyViewController.h"
#import "TrackViewController.h"
#import "TrackMapViewController.h"
#import "NearPersonViewController.h"
#import "AnnounceDetailViewController.h"
#import "ResearchDetailViewController.h"
#import "TaskDetailViewController.h"
#import "ApplyDetailViewController.h"
#import "GiftPurchaseDetailViewController.h"
#import "GiftDistributeDetailViewController.h"
#import "GiftStockDetailViewController.h"
#import "GiftDeliveryDetailViewController.h"
#import "MessageViewController.h"
#import "AnnounceViewController.h"
#import "GiftPageViewController.h"
#import "TaskPageViewController.h"
#import "SettingsViewController.h"
#import "CustomerDetailViewController.h"
#import "AboutViewController.h"
#import "ChangePasswdViewController.h"
#import "PatrolDetail2ViewController.h"
#import "GiftDeliveryListViewController.h"
#import "GiftDistributeListViewController.h"
#import "GiftPurchaseListViewController.h"
#import "GiftStockListViewController.h"
//#import "AlarmListViewController.h"
#import "VIdeoDetailViewController.h"
#import "VideoListViewController.h"
#import "UploadListViewController.h"
#import "CommonPhrasesListViewController.h"
#import "NewOrderNormalViewController.h"
#import "NewOrderConfirmViewController.h"
#import "NewOrderPrintViewController.h"
#import "NewOrderListViewController.h"
#import "NewOrderViewController.h"
#import "PushOrderMsg.h"
#import "MJExtension.h"
#import "DataReportListViewController.h"
#import "DataReportViewController.h"
#import "DataReportDetailViewController.h"
#import "AppliedDetailViewController.h"
#import "WifiAttendanceListViewController.h"
#import "WifiAttendanceDetailViewController.h"

@implementation ViewControllerFactory

+(ViewControllerFactory*)sharedInstance{
    static ViewControllerFactory* sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[ViewControllerFactory alloc] init];
    });
    
    return sharedInstance;
}

-(id)init{
    self = [super init];
    return self;
}


- (void) create:(UINavigationController*) nav ViewId:(int)viewId Object:(id)obj Delegate:(id)delegate NeedBack:(BOOL) needBack{
    /*if (![SOCKET isExistenceNetwork] && (SOCKET.webSocket.readyState != SR_OPEN)){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"msg_info", @"")
                          description:NSLocalizedString(@"error_network_unfind", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
        return;
    }    
    
    if (([USER.loginType isEqualToString: ANONYMOUS]) && (viewId != ILLEGAL) && (viewId != NEWS) && (viewId != SETTING) && (viewId != ABOUT) && (viewId != HELP) && (viewId != REGISTER) && (viewId != FORGETPASSWORD) && (viewId != DETAIL) && (viewId != CALL)){
        viewId = LOGIN;
    }*/
    //NSString *fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
    //NSString *toTime = [[NSString alloc] initWithString:[NSDate getTomorrowTime]];

    switch (viewId) {
        case FUNC_DASHBOARD:{
            DashboardViewController *firstViewController = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
            firstViewController.parentController = APPDELEGATE.mainTabbar;
            firstViewController.title = NSLocalizedString(@"dashboard_title_1", "");
            //首次登陆界面跳转同步界面
            firstViewController.bToSyncUI = APPDELEGATE.bFirstLogin;
            [DataSyncViewController setBFirstLogin:APPDELEGATE.bFirstLogin];
            UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                           initWithRootViewController:firstViewController];
            
            
            CustomerListViewController *secondViewController = [[CustomerListViewController alloc] init];
            secondViewController.parentController = APPDELEGATE.mainTabbar;
            secondViewController.user = USER;
            UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:secondViewController];
            
            
            MyViewController *thirdViewController = [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
            thirdViewController.title = NSLocalizedString(@"dashboard_title_2", "");
            thirdViewController.user = USER;
            thirdViewController.parentController = APPDELEGATE.mainTabbar;
            UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                           initWithRootViewController:thirdViewController];
            
            
            [APPDELEGATE.mainTabbar setViewControllers:@[firstNavigationController, secondNavigationController,
                                                    thirdNavigationController]];
            [APPDELEGATE.mainTabbar.tabBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab"]]];
            
            NSArray *titles = [NSArray arrayWithObjects:NSLocalizedString(@"dashboard_title_1", nil),
                               @"",
                               NSLocalizedString(@"dashboard_title_2", nil), nil];
            UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
            UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
            
            NSArray* icons = @[[NSString fontAwesomeIconStringForEnum:ICON_HOME],
                               [NSString fontAwesomeIconStringForEnum:ICON_CIRCLE_THIN],
                               [NSString fontAwesomeIconStringForEnum:ICON_PROFILE]];
            NSInteger index = 0;
            
            UIImage* selectedimage = nil;
            UIImage* unselectedimage = nil;
            for (RDVTabBarItem *item in [[APPDELEGATE.mainTabbar tabBar] items]) {
                item.title = titles[index];
                [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];

                UILabel* mylable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
                mylable.backgroundColor = WT_CLEARCOLOR;
                mylable.font = [UIFont fontWithName:kFontAwesomeFamilyName size:90];
                mylable.text = icons[index];
                mylable.textAlignment = UITextAlignmentCenter;
                
                //默认图片
                mylable.textColor = WT_GRAY;
                if (index == 1) {
                    UILabel *center2 = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, 75, 75)];
                    center2.backgroundColor = WT_CLEARCOLOR;
                    center2.font = [UIFont fontWithName:kFontAwesomeFamilyName size:50];
                    center2.text = [NSString fontAwesomeIconStringForEnum:ICON_CIRCLE_NOTHIN];
                    center2.textAlignment = UITextAlignmentCenter;
                    center2.textColor = WT_GRAY;
                    [mylable addSubview:center2];
                    [center2 release];
                }
                UIGraphicsBeginImageContext(mylable.frame.size);
                [mylable.layer renderInContext:UIGraphicsGetCurrentContext()];
                
                
                unselectedimage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                //选中图片
                mylable.textColor = WT_RED;
                if (index == 1) {
                    UILabel *center2 = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, 75, 75)];
                    center2.backgroundColor = WT_CLEARCOLOR;
                    center2.font = [UIFont fontWithName:kFontAwesomeFamilyName size:50];
                    center2.text = [NSString fontAwesomeIconStringForEnum:ICON_CIRCLE_NOTHIN];
                    center2.textAlignment = UITextAlignmentCenter;
                    center2.textColor = WT_RED;
                    [mylable addSubview:center2];
                    [center2 release];
                }
                UIGraphicsBeginImageContext(mylable.frame.size);
                [mylable.layer renderInContext:UIGraphicsGetCurrentContext()];
                
                selectedimage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
                item.badgeTextColor = WT_RED;
                
                [mylable release];
                index++;
            }
            [nav pushViewController:APPDELEGATE.mainTabbar animated:!APPDELEGATE.bFirstLogin];
            [firstViewController release];
            [firstNavigationController release];
            [secondViewController release];
            [secondNavigationController release];
            [thirdViewController release];
            [thirdNavigationController release];
        }
            break;
        case FUNC_NEW_ORDER_LIST:
        {
            NewOrderListViewController *listVC = [[NewOrderListViewController alloc] init];
            listVC.bNeedBack = YES;
            if (obj == nil) {
                listVC.url = ORDER_LIST_URL;
            }
            OrderGoodsParams_Builder *pb = [OrderGoodsParams builder];
            if ([obj isKindOfClass:[Customer class]]) {
                Customer *c = (Customer *)obj;
                [pb setCustomersArray:@[c]];
                listVC.url = CUSTOMER_ORDER_LIST_URL(c.id);
            }
            if ([obj isKindOfClass:[User class]]) {
                User *u = (User *)obj;
                [pb setUsersArray:@[u]];
                listVC.url = USER_ORDER_LIST_URL(u.id);
            }
            listVC.orderParams = [pb build];
            [nav pushViewController:listVC animated:YES];
            [listVC release];
        }
            break;
        case FUNC_NEW_ORDER_REPORT:
        {
            NewOrderViewController *vc = [[NewOrderViewController alloc] init];
            vc.bNeedBack = YES;
            if (obj != nil) {
                vc.customer = (Customer *)obj;
            }
            [nav pushViewController:vc animated:YES];
            [vc release];
        }
            break;
        case FUNC_NEW_ORDER_PRINT:
        {
            NewOrderPrintViewController *printVC = [[NewOrderPrintViewController alloc] init];
            printVC.bNeedBack  = needBack;
            printVC.orderId = [obj intValue];
            [nav pushViewController:printVC animated:YES];
            [printVC release];
        }
            break;
        case FUNC_NEW_ORDER_NORMAL:
        {
            
            int orderId = [[obj valueForKey:@"orderId"] intValue];
            NewOrderNormalViewController *newVC = [[NewOrderNormalViewController alloc] init];
            newVC.onRefreshUI = ^(){
                [newVC refreshUI];
            };
            newVC.bNeedBack = needBack;
            if (orderId > 0) {
                newVC.bOrderInfoView = YES;
                newVC.orderId = orderId;
                newVC.price = [obj valueForKey:@"needPrice"];
            }
            newVC.url =[obj valueForKey:@"url"];
            [nav pushViewController:newVC animated:YES];
            [newVC release];
        }
            break;
        case FUNC_NEW_ORDER_COMFIRM:
        {
            NewOrderConfirmViewController *newVC = [[NewOrderConfirmViewController alloc] init];
            newVC.bNeedBack = needBack;
            newVC.carVC = delegate;
            newVC.url = obj;
            [nav pushViewController:newVC animated:YES];
            [newVC release];
        }
            break;
        case FUNC_TRACK_LIST:{
            RDVTabBarController *_tabBarController = [[RDVTabBarController alloc] init];
            
            TrackViewController *firstViewController = [[TrackViewController alloc] initWithNibName:@"TrackViewController" bundle:nil];
            UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                           initWithRootViewController:firstViewController];
            //_tabBarController.tabBar.delegate = firstViewController;
            firstViewController.parentController = _tabBarController;
            firstViewController.bNeedBack = needBack;
            firstViewController.user = obj;
            firstViewController.title = NSLocalizedString(@"track_text", "");
            TrackMapViewController *secondViewController = [[TrackMapViewController alloc] initWithNibName:@"TrackMapViewController" bundle:nil];
            
            
            UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:secondViewController];
            //_tabBarController.tabBar.delegate = secondViewController;
            secondViewController.parentController = _tabBarController;
            secondViewController.bNeedBack = needBack;
            secondViewController.user = obj;
            secondViewController.title = NSLocalizedString(@"track_map", "");
            [_tabBarController setViewControllers:@[firstNavigationController, secondNavigationController]];
            [_tabBarController.tabBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab"]]];
            
            UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
            UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
            NSArray *tabBarItemImages = @[@"tab_time", @"tab_mark"];
            
            NSInteger index = 0;
            for (RDVTabBarItem *item in [[_tabBarController tabBar] items]) {
                [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
                UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_press.png",//
                                                              [tabBarItemImages objectAtIndex:index]]];
                UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",
                                                                [tabBarItemImages objectAtIndex:index]]];
                [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
                
                index++;
            }
            
            [nav pushViewController:_tabBarController animated:YES];
            [firstViewController release];
            [firstNavigationController release];
            [secondViewController release];
            [secondNavigationController release];
            [_tabBarController release];
            
        }
            break;
            
        case FUNC_ALARM:{
            /*AlarmListViewController *vctrl = [[AlarmListViewController alloc] init];
            vctrl.bNeedBack = YES;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];*/
        }
            break;
        case FUNC_PATROL:{
            PatrolViewController *vctrl = [[PatrolViewController alloc] init];
            if (obj != nil) {
                vctrl.bNeedBack = needBack;
                vctrl.customer = (Customer*)obj;
            }
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_SELL_ORDER:{
            OrderViewController *vctrl = [[OrderViewController alloc] init];
            if (obj != nil) {
                vctrl.bNeedBack = needBack;
                vctrl.customer = (Customer*)obj;
            }
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_SELL_TODAY:{
            SaleViewController* vctrl = [[SaleViewController alloc] init];
            if (obj != nil) {
                vctrl.bNeedBack = needBack;
                vctrl.customer = (Customer*)obj;
            }
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_CUSTOMER_DETAIL:{
            CustomerDetailViewController* vctrl = [[CustomerDetailViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.customer = (Customer*)obj;

            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_SELL_STOCK:{
            StockViewController* vctrl = [[StockViewController alloc] init];
            if (obj != nil) {
                vctrl.bNeedBack = needBack;
                vctrl.customer = (Customer*)obj;
            }
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_COMPETITION:{
            CompetitionViewController* vctrl = [[CompetitionViewController alloc] init];
            if (obj != nil) {
                vctrl.bNeedBack = needBack;
                vctrl.customer = (Customer*)obj;
            }
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_GIFT:{
            GiftPageViewController *vctrl = [[GiftPageViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.selectItem = SELECT_DISTRIBUTE;
            vctrl.customer = (Customer*)obj;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_GIFT_LIST:{
            GiftPageViewController *vctrl = [[GiftPageViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.selectItem = SELECT_PURCHARSE;
            if ([obj isKindOfClass:[Customer class]]) {
                vctrl.customer = (Customer*)obj;
            }
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_VIDEO_LIST:{
            VideoTopicParams_Builder *pb = [VideoTopicParams builder];
            [pb setPage:1];
            if (obj != nil && [obj isKindOfClass:[User class]]) {
                User *user = (User*)obj;
                if (user.id != USER.id) {
                    User_Builder *suser = [User builder];
                    [suser setId:user.id];
                    [suser setRealName:user.realName];
                    [pb setParamUsersArray:@[[suser build]]];
                }
            }
            VideoListViewController *videoListVC = [[VideoListViewController alloc] init];
            videoListVC.bNeedBack = needBack;
            videoListVC.videoParams = [[pb build] retain];
            [nav pushViewController:videoListVC animated:YES];
            [videoListVC release];
        }
            break;
            
        case FUNC_VIDEO_TASK_LIST:
        {
            UploadListViewController *uploadVC = [[UploadListViewController alloc] init];
            uploadVC.bNeedBack = YES;
            [nav pushViewController:uploadVC animated:YES];
            [uploadVC release];
        }
            break;
        case FUNC_BIZOPP:{
            BusinessOpportunityViewController* vctrl = [[BusinessOpportunityViewController alloc] init];
            if (obj != nil) {
                vctrl.bNeedBack = needBack;
                vctrl.customer = (Customer*)obj;
            }
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_CUSTOMER_LIST:{
            
        }
            break;
        case FUNC_RESEARSH:{
            ResearchViewController* vctrl = [[ResearchViewController alloc] init];
            if (obj != nil) {
                vctrl.bNeedBack = needBack;
                vctrl.customer = (Customer*)obj;
            }
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_TASK:{
            TaskPageViewController* vctrl = [[TaskPageViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.user = (obj != nil) ? (User*)obj : nil;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_CONTACTS:{
            ContactsPageViewController *vctrl = [[ContactsPageViewController alloc] init];
            vctrl.bNeedBack = needBack;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_FAVORATE:{
            MyFavoratePageViewController *vctrl = [[MyFavoratePageViewController alloc] init];
            vctrl.bNeedBack = needBack;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_PATROL_LIST:{
            PatrolParams_Builder* bs = [PatrolParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            PatrolParams* pp = [[bs build] retain];
            PatrolListViewController *vctrl = [[PatrolListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.patrolParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_GIFT_STOCK_LIST:{
            GiftStockParams_Builder* bs = [GiftStockParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            GiftStockParams* pp = [[bs build] retain];
            GiftStockListViewController *vctrl = [[GiftStockListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.giftStockParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_GIFT_DELIVERY_LIST:{
            GiftDeliveryParams_Builder* bs = [GiftDeliveryParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            GiftDeliveryParams* pp = [[bs build] retain];
            GiftDeliveryListViewController *vctrl = [[GiftDeliveryListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.giftDeliveryParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_GIFT_DISTRIBUTE_LIST:{
            GiftDistributeParams_Builder* bs = [GiftDistributeParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            GiftDistributeParams* pp = [[bs build] retain];
            GiftDistributeListViewController *vctrl = [[GiftDistributeListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.giftDistributeParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_GIFT_PURCHASE_LIST:{
            GiftPurchaseParams_Builder* bs = [GiftPurchaseParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            GiftPurchaseParams* pp = [[bs build] retain];
            GiftPurchaseListViewController *vctrl = [[GiftPurchaseListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.giftPurchaseParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_SELL_TODAY_LIST:{
            Customer_Builder* c = [Customer builder];
            
            [c setId:0];
            [c setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [c setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *cc = [CustomerCategory builder];
            [cc setId:0];
            [cc setName:@"全部"];
            
            [c setCategory:[cc build]];
            
            Customer*   currentCustomer = [[c build] retain];
            SaleGoodsParams_Builder* bs = [SaleGoodsParams builder];
            if (currentCustomer.id > 0) {
                [bs setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
            }

            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            [bs setPage:1];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            
            SaleGoodsParams* sgParams = [[bs build] retain];
            
            SaleListViewController *vctrl = [[SaleListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.saleArray = nil;
            vctrl.sgParams = sgParams;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
                 
        case FUNC_ATTENDANCE_ATTENDANCE_LIST:{
            AttendanceParams_Builder* bs = [AttendanceParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                User* u = (User*)obj;
                if (u.id != USER.id) {
                    [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                }
            }
            AttendanceParams* pp = [[bs build] retain];
            AttendanceListViewViewController *vctrl = [[AttendanceListViewViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.aParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];

        
        }
            break;
        case FUNC_ATTENDANCE_CHECK_IN_LIST:{
            CheckInTrackParams_Builder* bs = [CheckInTrackParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                User* u = (User*)obj;
                if (u.id != USER.id) {
                    [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                }
            }
            CheckInTrackParams* pp = [[bs build] retain];
            WifiAttendanceListViewController *vctrl = [[WifiAttendanceListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.checkInParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];

        
        }
            break;
        case FUNK_PAPER_POST_LIST: {
            PaperPostParams_Builder* bs = [PaperPostParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                User* u = (User*)obj;
                if (u.id != USER.id) {
                    [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                }
            }
            PaperPostParams* pp = [[bs build] retain];
            DataReportListViewController *vctrl = [[DataReportListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.pParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];

        }
            break;
        case FUNC_WORKLOG_LIST:{
            WorkLogParams_Builder* bs = [WorkLogParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                User* u = (User*)obj;
                if (u.id != USER.id) {
                    [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                }
            }
            WorkLogParams* pp = [[bs build] retain];
            WorklogListViewController *vctrl = [[WorklogListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.worklogParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_SELL_ORDER_LIST:{
            
            Customer_Builder *c = [Customer builder];
            
            [c setId:0];
            [c setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [c setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *cc = [CustomerCategory builder];
            [cc setId:0];
            [cc setName:@"全部"];
            
            [c setCategory:[cc build]];
            
            Customer*   currentCustomer = [[c build] retain];
            OrderGoodsParams_Builder* bs = [OrderGoodsParams builder];
            if (currentCustomer.id > 0) {
                [bs setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
            }

            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            [bs setPage:1];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            
            OrderGoodsParams* sgParams = [[bs build] retain];
            
            OrderListViewController *vctrl = [[OrderListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.orderArray = nil;
            vctrl.ogParams = sgParams;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_SELL_STOCK_LIST:{
            Customer_Builder *c = [Customer builder];
            
            [c setId:0];
            [c setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [c setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *cc = [CustomerCategory builder];
            [cc setId:0];
            [cc setName:@"全部"];
            
            [c setCategory:[cc build]];
            
            Customer*   currentCustomer = [[c build] retain];
            StockParams_Builder* bs = [StockParams builder];
            if (currentCustomer.id > 0) {
                [bs setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
            }

            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            [bs setPage:1];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            
            StockParams* sgParams = [[bs build] retain];
            
            StockListViewController *vctrl = [[StockListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.stockArray = nil;
            vctrl.sParams = sgParams;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_COMPETITION_LIST:{
            Customer_Builder *c = [Customer builder];
            
            [c setId:0];
            [c setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [c setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *cc = [CustomerCategory builder];
            [cc setId:0];
            [cc setName:@"全部"];
            
            [c setCategory:[cc build]];
            
            Customer*   currentCustomer = [[c build] retain];
            CompetitionGoodsParams_Builder* bs = [CompetitionGoodsParams builder];
            if (currentCustomer.id > 0) {
                [bs setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
            }

            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            [bs setPage:1];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            
            CompetitionGoodsParams* sgParams = [[bs build] retain];
            
            CompetitionListViewController *vctrl = [[CompetitionListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.competitionArray = nil;
            vctrl.cgParams = sgParams;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_BIZOPP_LIST:{
            BusinessOpportunityParams_Builder* bs = [BusinessOpportunityParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            BusinessOpportunityParams* pp = [[bs build] retain];
            BusinessOpportunityListViewController *vctrl = [[BusinessOpportunityListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.businessOpportunityParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_RESEARSH_LIST:{
            MarketResearchParams_Builder* bs = [MarketResearchParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            MarketResearchParams* pp = [[bs build] retain];
            ResearchListViewController *vctrl = [[ResearchListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.marketResearchParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_APPROVE_LIST:{
            ApplyItemParams_Builder* bs = [ApplyItemParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                User* u = (User*)obj;
                if (u.id != USER.id) {
                    [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                }
            }
            ApplyItemParams* pp = [[bs build] retain];
            ApplyListViewController *vctrl = [[ApplyListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.applyParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_EDIT:{
            EditFunctionsViewController *vctrl = [[EditFunctionsViewController alloc] init];
            vctrl.bNeedBack = YES;

            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_ATTENDANCE:{
            AttendanceViewController *vctrl = [[AttendanceViewController alloc] init];
            vctrl.bNeedBack = needBack;

            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_WORKLOG:{
            WorklogViewController *vctrl = [[WorklogViewController alloc] init];
            vctrl.bNeedBack = needBack;

            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_PATROL_TASK:{
            TaskPageViewController *vctrl = [[TaskPageViewController alloc] init];
            vctrl.bNeedBack = needBack;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_INSPECTION:{
            InspectionViewController *vctrl = [[InspectionViewController alloc] init];
            vctrl.bNeedBack = needBack;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_APPROVE:{
            ApplyViewController *vctrl = [[ApplyViewController alloc] init];
            vctrl.bNeedBack = needBack;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_MESSAGE:{
            MessagePageViewController *vctrl = [[MessagePageViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.selectItem = SELECT_ANNOUNCE;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
            
        }
            break;
        case FUNC_MESSAGE_LIST:{
            MessagePageViewController *vctrl = [[MessagePageViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.selectItem = SELECT_MESSAGE;
            vctrl.userId = ((User*)obj).id;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_ANNOUNCE_LIST:{
            MessagePageViewController *vctrl = [[MessagePageViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.selectItem = SELECT_ANNOUNCE;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_SYNC:{
            DataSyncViewController *vctrl = [[DataSyncViewController alloc] init];
            vctrl.bNeedBack = needBack;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];

        }
            break;
        case FUNC_CHANGE_PASSWORD:{
            ChangePasswdViewController *vctrl = [[ChangePasswdViewController alloc] init];
            vctrl.bNeedBack = needBack;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
            
        }
            break;
        case FUNC_INSPECTION_LIST:{
            InspectionReportParams_Builder* bs = [InspectionReportParams builder];
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            [bs setPage:1];
            if (obj != nil) {
                if ([obj isKindOfClass:[User class]]) {
                    User* u = (User*)obj;
                    if (u.id != USER.id) {
                        [bs setUsersArray:[[NSArray alloc] initWithObjects:u, nil]];
                    }
                }
                if ([obj isKindOfClass:[Customer class]]) {
                    Customer* c = (Customer*)obj;
                    [bs setCustomersArray:[[NSArray alloc] initWithObjects:c, nil]];
                }
            }
            InspectionReportParams* pp = [[bs build] retain];
            InspectionListViewController *vctrl = [[InspectionListViewController alloc] init];
            vctrl.bNeedBack = needBack;
            vctrl.inspectionParams = pp;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];

        }
            break;
        case FUNC_LOGIN:{
            if ([[self getCurrentVC] isKindOfClass:[UINavigationController class]])
                [(UINavigationController*)[self getCurrentVC] popToViewController:APPDELEGATE.loginCtrl animated:YES];
            else
                [[self getCurrentVC].navigationController popToViewController:APPDELEGATE.loginCtrl animated:YES];
        }
            break;

        case FUNC_NEARBY_LIST:{
            NearPersonViewController *vctrl = [[NearPersonViewController alloc] init];
            vctrl.bNeedBack = YES;
            
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
            /*
            RDVTabBarController *_tabBarController = [[RDVTabBarController alloc] init];
            
            NearPersonViewController *firstViewController = [[NearPersonViewController alloc] initWithNibName:@"NearPersonViewController" bundle:nil];
            UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                           initWithRootViewController:firstViewController];
            //_tabBarController.tabBar.delegate = firstViewController;
            firstViewController.parentController = _tabBarController;
            firstViewController.bNeedBack = needBack;
            firstViewController.title = NSLocalizedString(@"nearby_list", "");
            
            NearPersonViewController *secondViewController = [[NearPersonViewController alloc] initWithNibName:@"NearPersonViewController" bundle:nil];
            
            UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:secondViewController];
            //_tabBarController.tabBar.delegate = secondViewController;
            secondViewController.parentController = _tabBarController;
            secondViewController.bNeedBack = needBack;
            secondViewController.title = NSLocalizedString(@"nearby_map", "");
            [_tabBarController setViewControllers:@[firstNavigationController, secondNavigationController]];
            [_tabBarController.tabBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab"]]];
            
            UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
            UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
            NSArray *tabBarItemImages = @[@"tab_list", @"tab_mark"];
            
            NSInteger index = 0;
            for (RDVTabBarItem *item in [[_tabBarController tabBar] items]) {
                [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
                UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_press.png",//
                                                              [tabBarItemImages objectAtIndex:index]]];
                UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",
                                                                [tabBarItemImages objectAtIndex:index]]];
                [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
                
                index++;
            }
            
            [nav pushViewController:_tabBarController animated:YES];
            [firstViewController release];
            [firstNavigationController release];
            [secondViewController release];
            [secondNavigationController release];
            [_tabBarController release];*/
            
        }
            break;

        case FUNC_LOGOUT:{
            //NavCtrl 方式返回登陆界面
            if ([[self getCurrentVC] isKindOfClass:[UINavigationController class]])
            {
                @try {
                    [(UINavigationController*)[self getCurrentVC] pushViewController:APPDELEGATE.loginCtrl animated:YES];
                }
                @catch (NSException *exception) {
                    [(UINavigationController*)[self getCurrentVC] popToViewController:APPDELEGATE.loginCtrl animated:YES];
                }
            }
            else{
                @try {
                    [[self getCurrentVC].navigationController popToViewController:APPDELEGATE.loginCtrl animated:YES];
                }
                @catch (NSException *exception) {
                    [[self getCurrentVC].navigationController presentViewController:APPDELEGATE.loginCtrl animated:YES completion:nil];
                }
            }
            //present 方式返回登陆界面
        }
            break;
        case FUNC_OTHER_USER_DETAIL:{
            MyViewController *vctrl = [[MyViewController alloc] init];
            vctrl.bNeedBack = YES;
            vctrl.user = obj;
            vctrl.showAllBOOL = YES;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_ANNOUNCE:{
            AnnounceDetailViewController *vctrl = [[AnnounceDetailViewController alloc] init];
            vctrl.bNeedBack = YES;
            vctrl.announce = obj;
            UINavigationController* patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:vctrl];
            [APPDELEGATE.mainTabbar presentViewController:patrolNavCtrl animated:YES completion:nil];
            [patrolNavCtrl release];
            [vctrl release];
        }
            break;
        case FUNC_SETTING:{
            SettingsViewController* vctrl = [[SettingsViewController alloc] init];
            vctrl.bNeedBack = needBack;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        case FUNC_ABOUT:{
            AboutViewController *ctrl = [[AboutViewController alloc] init];
            [nav setNavigationBarHidden:NO];
            [nav pushViewController:ctrl animated:YES];
            [ctrl release];
        }
            break;
        case FUNC_COMMON_PHRASES:
        {
            CommonPhrasesListViewController *cpvc = [[CommonPhrasesListViewController alloc] init];
            cpvc.bNeedBack = needBack;
            if (obj != nil) {
                cpvc.bSelect = (BOOL)obj;
            }
            [nav pushViewController:cpvc animated:YES];
            [cpvc release];
        }
            break;
            
        case FUNC_PAPER_POST:
        {
            DataReportViewController *vctrl = [[DataReportViewController alloc] init];
            vctrl.bNeedBack = YES;
            vctrl.paperTemplate = obj;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
        /*case NEWS:{
            [APPDELEGATE.drawerController setCenterViewController:APPDELEGATE.mainNavigationController withCloseAnimation:YES completion:nil];
            NewsPageViewController *vctrl = [[NewsPageViewController alloc] init];
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;*/
        /*
        case SENDMESSAGE:{
            WCSendMessageController *vctrl = [[WCSendMessageController alloc] init];
            if ([obj isKindOfClass:[TopicType class]]){
                TopicType* tt = obj;
                vctrl.title = tt.name;
                vctrl.topicType = tt;
            }
            if ([obj isKindOfClass:[User class]]){
                User* u = obj;
                vctrl.title = u.nickName;
                vctrl.sendUser = u;
            }
            vctrl.delegate = delegate;
            [nav pushViewController:vctrl animated:YES];
            [vctrl release];
        }
            break;
       */
            
        default:
            break;
    }
}

-(void)showMessageWithId:(UINavigationController*) nav MessageType:(int)messageType objectId:(SysMessage*)objectId Delegate:(id)delegate{
    [LOCALMANAGER readMessage:messageType SourceId:objectId.sourceId];
    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
    switch(messageType){
        case MESSAGE_VIDEO_ADD:
        case MESSAGE_VIDEO_REPLY:{
            VideoDetailViewController *videoDetail = [[VideoDetailViewController alloc] init];
            videoDetail.videoId = [objectId.sourceId intValue];
            videoDetail.bNeedBack = YES;
            videoDetail.bNetwork = YES;
            UINavigationController *vctrl = [[UINavigationController alloc] initWithRootViewController:videoDetail];
            [APPDELEGATE.mainTabbar presentViewController:vctrl animated:YES completion:nil];
            [videoDetail release];
            [vctrl release];
        }
            break;
        case MESSAGE_TASK_PATROL_APPROVAL:{
            TaskDetailViewController *vctrl = [[TaskDetailViewController alloc] init];
            vctrl.taskId = objectId.sourceId;
            UINavigationController* patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:vctrl];
            [APPDELEGATE.mainTabbar presentViewController:patrolNavCtrl animated:YES completion:nil];
            [patrolNavCtrl release];
            [vctrl release];
        }
            break;
        case MESSAGE_TASK_PATROL_FINISH:
        case MESSAGE_TASK_PATROL_ADD:{
            TaskPageViewController *vctrl = [[TaskPageViewController alloc] init];
            vctrl.showPageIndex = 2;
            vctrl.bFromMessage = YES;
            vctrl.msgType = messageType;
            vctrl.sourceId = objectId.sourceId;
            UINavigationController* patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:vctrl];
            [APPDELEGATE.mainTabbar presentViewController:patrolNavCtrl animated:YES completion:nil];
            [patrolNavCtrl release];
            [vctrl release];
        }
            break;
        case MESSAGE_INSPECTION_APPROVAL:
        case MESSAGE_INSPECTION_DETAIL:{
            InspectionDetailViewController *ctrl = [[InspectionDetailViewController alloc] init];
            ctrl.inspection = nil;
            ctrl.inspectionId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            UINavigationController* patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:patrolNavCtrl animated:YES completion:nil];
            [patrolNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_DAILY_REPORT:
        case MESSAGE_DAILY_APPROVAL:{
            WorklogDetailViewController *ctrl = [[WorklogDetailViewController alloc] init];
            ctrl.worklog = nil;
            ctrl.worklogId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.delegate = delegate;
            UINavigationController* worklogNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:worklogNavCtrl animated:YES completion:nil];
            [worklogNavCtrl release];
            [ctrl release];
        }
            break;
            
        case MESSAGE_PAPER_DETAIL: {
            DataReportDetailViewController *ctrl = [[DataReportDetailViewController alloc] init];
            ctrl.msgType = messageType;
            ctrl.paperPostId = [objectId.sourceId intValue];
            ctrl.bNeedBack = YES;
            ctrl.delegate = delegate;
            UINavigationController *vctrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:vctrl animated:YES completion:nil];
            [ctrl release];
            [vctrl release];
        }
        break;
            
        case MESSAGE_VIVID_REPORT_APPROVAL:
        case MESSAGE_VIVID_REPORT:{
            PatrolDetail2ViewController *ctrl = [[PatrolDetail2ViewController alloc] init];
            ctrl.patrol = nil;
            ctrl.patrolId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:patrolNavCtrl animated:YES completion:nil];
            [patrolNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_MARKET_APPROVAL:
        case MESSAGE_MARKET_REPORT:{
            ResearchDetailViewController *ctrl = [[ResearchDetailViewController alloc] init];
            ctrl.currentMarketResearch = nil;
            ctrl.martketresearchId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:resNavCtrl animated:YES completion:nil];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
            
        case MESSAGE_BUSINESS_APPROVAL:
        case MESSAGE_BUSINESS_REPORT:{
            BusinessOpportunityDetailViewController *ctrl = [[BusinessOpportunityDetailViewController alloc] init];
            ctrl.currentBizOpp = nil;
            ctrl.bizoppId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* bizNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:bizNavCtrl animated:YES completion:nil];
            [bizNavCtrl release];
            [ctrl release];
        }
            break;
            
            
        case MESSAGE_APPLY_ITEM_APPROVAL:
        case MESSAGE_APPLY_ITEM:
        case MESSAGE_APPLY_ITEM_AUDIT:{
            ApplyDetailViewController *ctrl = [[ApplyDetailViewController alloc] init];
            ctrl.applyItem = nil;
            ctrl.applyItemId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:resNavCtrl animated:YES completion:nil];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_GIFT_PURCHASE:{
            GiftPurchaseDetailViewController *ctrl = [[GiftPurchaseDetailViewController alloc] init];
            ctrl.giftPurchase = nil;
            ctrl.giftPurchaseId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:resNavCtrl animated:YES completion:nil];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_GIFT_DISTRIBUTE:{
            GiftDistributeDetailViewController *ctrl = [[GiftDistributeDetailViewController alloc] init];
            ctrl.giftDistribute = nil;
            ctrl.giftDistributeId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:resNavCtrl animated:YES completion:nil];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_GIFT_DELIVERY:{
            GiftDeliveryDetailViewController *ctrl = [[GiftDeliveryDetailViewController alloc] init];
            ctrl.giftDelivery = nil;
            ctrl.giftDeliveryId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:resNavCtrl animated:YES completion:nil];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_GIFT_STOCK:{
            GiftStockDetailViewController *ctrl = [[GiftStockDetailViewController alloc] init];
            ctrl.giftStock = nil;
            ctrl.giftStockId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:resNavCtrl animated:YES completion:nil];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        case MESSAGE_ATTENDANCE_APPROVAL:{
            AttendanceDetailViewController *ctrl = [[AttendanceDetailViewController alloc] init];
            ctrl.attendance = nil;
            ctrl.attendanceId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:resNavCtrl animated:YES completion:nil];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
            
        case MESSAGE_CARGO_REQ:{
            NewOrderNormalViewController *detailVC = [[NewOrderNormalViewController alloc] init];
            detailVC.bNeedBack = YES;
            detailVC.bOrderInfoView = YES;
            detailVC.bMessageView = YES;
            detailVC.orderId = objectId.sourceId.intValue;
            PushOrderMsg *msg = [[[PushOrderMsg alloc] init] mj_setKeyValues:objectId.content.mj_JSONObject];
            detailVC.url = msg.url;
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:detailVC];
            [APPDELEGATE.mainTabbar presentViewController:navCtrl animated:YES completion:nil];
            [detailVC release];
            [navCtrl release];
        }
            break;
            
        case MESSAGE_INVENTORY:{
            Customer_Builder *c = [Customer builder];
            
            [c setId:0];
            [c setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [c setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *cc = [CustomerCategory builder];
            [cc setId:0];
            [cc setName:@"全部"];
            
            [c setCategory:[cc build]];
            
            Customer*   currentCustomer = [[c build] retain];
            StockParams_Builder* bs = [StockParams builder];
            if (currentCustomer.id > 0) {
                [bs setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
            }
            
            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            
            StockParams* sParams = [[bs build] retain];
            
            if (sParams != nil){
                StockParams_Builder* bs = [sParams toBuilder];
                [bs setPage:1];
                sParams = [[bs build] retain];
                
                StockListViewController *ctrl = [[StockListViewController alloc] init];
                ctrl.stockArray = nil;
                ctrl.sParams = sParams;
                ctrl.msgType = messageType;
                ctrl.sourceId = objectId.sourceId.intValue;
                UINavigationController* orderNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [APPDELEGATE.mainTabbar presentViewController:orderNavCtrl animated:YES completion:nil];
                [orderNavCtrl release];
                [ctrl release];
            }
            
        }
            break;
            
        case MESSAGE_TODAY_SALE_REQ:{
            Customer_Builder *c = [Customer builder];
            
            [c setId:0];
            [c setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [c setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *cc = [CustomerCategory builder];
            [cc setId:0];
            [cc setName:@"全部"];
            
            [c setCategory:[cc build]];
            
            Customer*   currentCustomer = [[c build] retain];
            //currentCustomer = [[[[[currentCustomer toBuilder] setId:0] setName:@"全部"] build] retain];
            SaleGoodsParams_Builder* bs = [SaleGoodsParams builder];
            if (currentCustomer.id > 0) {
                [bs setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
            }

            //[bs setStartDate:fromTime];
            //[bs setEndDate:toTime];
            
            SaleGoodsParams* sgParams = [[bs build] retain];
            
            if (sgParams != nil){
                SaleGoodsParams_Builder* bs = [sgParams toBuilder];
                [bs setPage:1];
                sgParams = [[bs build] retain];
                
                SaleListViewController *ctrl = [[SaleListViewController alloc] init];
                ctrl.saleArray = nil;
                ctrl.sgParams = sgParams;
                ctrl.msgType = messageType;
                ctrl.sourceId = objectId.sourceId.intValue;
                UINavigationController* orderNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [APPDELEGATE.mainTabbar presentViewController:orderNavCtrl animated:YES completion:nil];
                [orderNavCtrl release];
                [ctrl release];
            }
            
        }
            break;
            
        case MESSAGE_COMPETITION_SALE_REQ:{
            Customer_Builder *c = [Customer builder];
            
            [c setId:0];
            [c setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [c setLocation:(APPDELEGATE).myLocation];
            }
            CustomerCategory_Builder *cc = [CustomerCategory builder];
            [cc setId:0];
            [cc setName:@"全部"];
            [c setCategory:[cc build]];
            
            Customer*   currentCustomer = [[c build] retain];
           
            CompetitionGoodsParams_Builder* bs = [CompetitionGoodsParams builder];
            if (currentCustomer.id > 0) {
                [bs setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
            }
            
            CompetitionGoodsParams* cgParams = [[bs build] retain];
            
            if (cgParams != nil){
                CompetitionGoodsParams_Builder* bs = [cgParams toBuilder];
                [bs setPage:1];
                cgParams = [[bs build] retain];
                
                CompetitionListViewController *ctrl = [[CompetitionListViewController alloc] init];
                ctrl.competitionArray = nil;
                ctrl.cgParams = cgParams;
                ctrl.msgType = messageType;
                ctrl.sourceId = objectId.sourceId.intValue;
                UINavigationController* orderNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
                [APPDELEGATE.mainTabbar presentViewController:orderNavCtrl animated:YES completion:nil];
                [orderNavCtrl release];
                [ctrl release];
            }
            
        }
            break;
        case MESSAGE_HOLIDAY_APPROVAL_USER:
        case MESSAGE_HOLIDAY_APPLY:{
            AppliedDetailViewController *ctrl = [[AppliedDetailViewController alloc] init];
            
            NSData *JSONData = [objectId.content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
          
            ctrl.applyIdString =[responseJSON objectForKey:@"applyId"];            UINavigationController* holidayNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:holidayNavCtrl animated:YES completion:nil];
            [holidayNavCtrl release];
            [ctrl release];
         }
            break;
            
        case MESSAGE_CHENK_IN_ATTENDANCE:{
            WifiAttendanceDetailViewController *ctrl = [[WifiAttendanceDetailViewController alloc] init];
            ctrl.checkInTrack = nil;
            ctrl.checkInTrackId = objectId.sourceId.intValue;
            ctrl.msgType = messageType;
            ctrl.bNeedBack = YES;
            UINavigationController* resNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [APPDELEGATE.mainTabbar presentViewController:resNavCtrl animated:YES completion:nil];
            [resNavCtrl release];
            [ctrl release];
        }
            break;
        default:
            
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"info_version", @"")
                              description:NSLocalizedString(@"info_message_update_version", @"")
                                     type:MessageBarMessageTypeImportant
                              forDuration:2.0];
            break;
            
    }
}

- (void) pushViewController:(UINavigationController*) nav Ctrl:(UIViewController*) ctrl{
    if (nav != nil) {
        [nav pushViewController:ctrl animated:YES];
        return;
    }
    if ([[self getCurrentVC] isKindOfClass:[UINavigationController class]]){
        [(UINavigationController*)[self getCurrentVC] pushViewController:ctrl animated:YES];
    }
    else
        [[self getCurrentVC].navigationController pushViewController:ctrl animated:YES];
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end
