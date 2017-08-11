
//
//  AppDelegate.m
//  SalesManager
//
//  Created by liu xueyan on 7/29/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <sys/utsname.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "Constant.h"
#import "UpdateVersion.h"
#import "NSDate+Util.h"

#import "AttendanceViewController.h"
#import "MainFunctionViewController.h"
#import "DataSyncViewController.h"
#import "MessageViewController.h"
#import "PatrolViewController.h"
#import "InspectionViewController.h"
#import "WorklogViewController.h"
#import "ChangePasswdViewController.h"
#import "OrderViewController.h"
#import "StockViewController.h"
#import "MyFavoratePageViewController.h"
//#import "ContactsViewController.h"
#import "SaleViewController.h"
#import "SaleStatisticsViewController.h"
#import "SettingsViewController.h"
#import "CompetitionViewController.h"
#import "CompanyContactsViewController.h"
#import "ContactsPageViewController.h"
#import "CustomerContactsViewController.h"
#import "ResearchViewController.h"
#import "BusinessOpportunityViewController.h"
#import "ApplyViewController.h"
#import "GiftPageViewController.h"
#import "TaskPageViewController.h"
#import "CompanySpacePageViewController.h"
#import "MessagePageViewController.h"
#import "VideoPostViewController.h"
#import "NewOrderViewController.h"
#import "DataReportViewController.h"
#import "PaperViewController.h"
#import "LeaveManagerViewController.h"
//腾讯Bugly
#import <Bugly/Bugly.h>
//阿里巴巴趣拍
#import <TAESDK/TAESDK.h>

#import "MJExtension.h"
#import "PushOrderMsg.h"
#import "AttencePageViewController.h"
#import <UserNotifications/UserNotifications.h>

@implementation AppDelegate
@synthesize currentUser;
@synthesize agent;
@synthesize loginCtrl;
@synthesize bFirstLogin;
@synthesize myLocation;
@synthesize bChangeFavorate;
@synthesize bPopAction;
@synthesize appBeComeActiveDelegate;
@synthesize locService;
@synthesize remoteNotificationDict;
@synthesize loginNavCtrl;
@synthesize mainTabbar;
@synthesize splashCtrl;
@synthesize splashNavCtrl;


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    NSString *crashLogInfo = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
    NSString *urlStr = [NSString stringWithFormat:@"mailto:appledeveloper@juicyshare.cc?subject=工作宝bug报告&body=感谢您的配合!错误详情:%@",crashLogInfo];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    //NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //捕获异常
    //NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    //crash 日志记录
    [Bugly startWithAppId:BUGLY_KEY];
    [Bugly setUserIdentifier:[UIDevice deviceId]];
    
    backgournCount = 0;
    bChangeFavorate = NO;
    bPopAction = NO;

    AGENT.pushDelegate = self;
    agent = AGENT;
    currentUser = USER;
    splashCtrl = [[SplashViewController alloc] init];
    splashNavCtrl = [[UINavigationController alloc] initWithRootViewController:splashCtrl];
    
    loginCtrl = [[LoginViewController alloc] init];
    loginNavCtrl = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:splashNavCtrl];
    [self.window makeKeyAndVisible];
    
    mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:BAIDU_KEY generalDelegate:nil];
    NSLog(@"Baidu Key:%@",BAIDU_KEY);
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    if (IOS8) {
       CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    search = [[BMKGeoCodeSearch alloc]init];
    search.delegate = self;
    
    poisearch = [[BMKPoiSearch alloc]init];
    poisearch.delegate = self;
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];
    [self checkVersion];
    
    //设置定时定位timer
    gpsTimer = [NSTimer scheduledTimerWithTimeInterval:GPS_DURATION target:self selector:@selector(startGPS) userInfo:nil repeats:YES];
    
    //测试用，强行设置device id
    //[LOCALMANAGER saveDeviceIdToKeychain:@"D7324967-7432-4DEF-AFCF-7220A3AAE5AB"];
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];//可以以多种形式初始化
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    [self updateInterfaceWithReachability: hostReach];
    
    if (IOS10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"succeeded!");
            }
        }];
    } else {
    if (IOS8) {
            UIUserNotificationType apn_type = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:apn_type categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }else {
            UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
        }

    }
        //闹钟设置
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
        
    }
    
    remoteNotificationDict = [[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] copy];
    if (remoteNotificationDict != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toOpenNotficationDetail) name:MESSAGE_NOTIFICATION object:nil];
    }
    mainTabbar = [[RDVTabBarController alloc] init];
    return YES;
}

//IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *sDeviceToken = [[[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];;

    
    NSLog(@"deviceToken:%@", sDeviceToken);
    [LOCALMANAGER saveDeviceToken:sDeviceToken];
    //这里可以把deviceToken发给自己的服务器
}

//监听到网络状态改变
- (void) reachabilityChanged: (NSNotification* )note {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"network_change" object:nil];
    
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
    
}

//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach {
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == kReachableViaWWAN) {
        printf("\n3g/2G\n");
    }
    else if(status == kReachableViaWiFi)
    {
        printf("\nwifi\n");
    } else
    {
        printf("\n无网络\n");
    }
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if (bActivity) {
        return;
    }
    remoteNotificationDict = [userInfo copy];
    [self toOpenNotficationDetail];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandle{
    return;

}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    remoteNotificationDict = [userInfo copy];
    [self toOpenNotficationDetail];
}

-(void)toOpenNotficationDetail{
    if (remoteNotificationDict == nil) {
        return;
    }
    NSDictionary *objDict = [remoteNotificationDict objectForKey:@"obj"];
    NSDictionary *announcement = [remoteNotificationDict objectForKey:@"announcement"];
    
    if (announcement != nil) {
        Announce_Builder* av1 = [Announce builder];

        [av1 setId:[[remoteNotificationDict objectForKey:@"announcement"] intValue]];

        [VIEWCONTROLLER create:nil ViewId:FUNC_ANNOUNCE Object:[av1 build] Delegate:nil NeedBack:YES];
    }else if(objDict != nil){
        NSString* sourceId = [objDict objectForKey:@"sourceId"] ;
        int sourceType = [[objDict objectForKey:@"type"] intValue];
        NSString* content =[objDict objectForKey:@"message"];
        SysMessage_Builder *pb = [SysMessage builder];
        [pb setId:0];
        [pb setSourceId:sourceId];
        [pb setType:sourceType];
        if ((sourceType == MESSAGE_CARGO_REQ || sourceType == MESSAGE_HOLIDAY_APPROVAL_USER || sourceType == MESSAGE_HOLIDAY_APPLY) && content != nil && content.length > 0) {
            [pb setContent:content];
        }
        [VIEWCONTROLLER showMessageWithId:nil MessageType:sourceType objectId:[pb build] Delegate:nil];
    }
    [remoteNotificationDict release];
    remoteNotificationDict = nil;
}

- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"%@",error);
}

-(void)startGPS{
    NSLog(@"百度定位服务启动");
    [locService startUserLocationService];

}

-(void)initPage{
    //退出到登陆界面次对象就会被释放,登陆时重新初始化
    if (self.mainTabbar == nil) {
        mainTabbar = [[RDVTabBarController alloc] init];
    }
    _leftSideDrawerViewController = [[MainMenuViewController alloc] init];
    
    UIViewController *attendanceViewController = [[AttencePageViewController alloc] init];
    MainFunctionViewController *mainFunctionViewController = [[MainFunctionViewController alloc] init];
    if (remoteNotificationDict != nil) {
        mainFunctionViewController.bHasNotification = YES;
    }
    
    UIViewController *datasyncViewController = [[DataSyncViewController alloc] init];
    UIViewController *messageViewController = [[MessageViewController alloc] init];
    UIViewController *patrolViewController = [[PatrolViewController alloc] init];
    UIViewController *inspectionViewController = [[InspectionViewController alloc] init];
    UIViewController *worklogViewController = [[WorklogViewController alloc] init];
    UIViewController *changePwdViewController = [[ChangePasswdViewController alloc] init];
    UIViewController *orderViewController = [[NewOrderViewController alloc] init];
    UIViewController *stockViewController = [[StockViewController alloc] init];
    UIViewController *myfavorateViewController = [[MyFavoratePageViewController alloc] init];
   // UIViewController *contactsViewController = [[ContactsViewController  alloc] init];
    UIViewController *saleViewController = [[SaleViewController alloc] init];
    UIViewController *salestatisticsController = [[SaleStatisticsViewController alloc] init];
    UIViewController *settingController = [[SettingsViewController alloc] init];
    UIViewController *competitionController = [[CompetitionViewController alloc] init];
    UIViewController *companyContactController = [[CompanyContactsViewController alloc] init];
    UIViewController *contactsPageController = [[ContactsPageViewController alloc] init];
    
    UIViewController *endContactController = [[CustomerContactsViewController alloc] init];
    UIViewController *researchController = [[ResearchViewController alloc] init];
    UIViewController *bizOppController = [[BusinessOpportunityViewController alloc] init];
    UIViewController *applyViewController = [[ApplyViewController alloc] init];
    UIViewController *giftViewController = [[GiftPageViewController alloc] init];
    UIViewController *videoViewController = [[VideoPostViewController alloc] init];
    UIViewController *dataReportViewController = [[DataReportViewController alloc] init];
    UIViewController *paperViewController = [[PaperViewController alloc] init];
    UIViewController *leaveViewController = [[LeaveManagerViewController alloc] init];
    
    TaskPageViewController *taskViewController = [[TaskPageViewController alloc] init];
    taskViewController.showPageIndex = -1;
    _spaceController = [[CompanySpacePageViewController alloc] init];
    _myMessageController = [[MessagePageViewController alloc] init];
    _datasyncNavCtrl = [[UINavigationController alloc] initWithRootViewController:datasyncViewController];
    _mainFunctionNavCtrl = [[UINavigationController alloc] initWithRootViewController:mainFunctionViewController];
    _attendanceNavCtrl = [[UINavigationController alloc] initWithRootViewController:attendanceViewController];
    _messageNavCtrl = [[UINavigationController alloc] initWithRootViewController:messageViewController];
    _patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:patrolViewController];
    _inspectionNavCtrl = [[UINavigationController alloc] initWithRootViewController:inspectionViewController];
    _worklogNavCtrl = [[UINavigationController alloc] initWithRootViewController:worklogViewController];
    _changePwdNavController = [[UINavigationController alloc] initWithRootViewController:changePwdViewController];
    _orderNavCtrl = [[UINavigationController alloc] initWithRootViewController:orderViewController];
    _stockNavCtrl = [[UINavigationController alloc] initWithRootViewController:stockViewController];
    _myfavorateNavCtrl = [[UINavigationController alloc] initWithRootViewController:myfavorateViewController];
   // _contactsNavCtrl = [[UINavigationController alloc] initWithRootViewController:contactsViewController];
    _saleNavCtrl = [[UINavigationController alloc] initWithRootViewController:saleViewController];
    _salestatisticsNavCtrl = [[UINavigationController alloc] initWithRootViewController:salestatisticsController];
    _settingNavCtrl = [[UINavigationController alloc] initWithRootViewController:settingController];
    _competitionNavCtrl = [[UINavigationController alloc] initWithRootViewController:competitionController];
    _myMessageNavCtrl = [[UINavigationController alloc] initWithRootViewController:_myMessageController];
    _companyContactNavCtrl = [[UINavigationController alloc] initWithRootViewController:companyContactController];
    _endContactNavCtrl = [[UINavigationController alloc] initWithRootViewController:endContactController];
    _researchNavCtrl = [[UINavigationController alloc] initWithRootViewController:researchController];
    _spaceNavCtrl = [[UINavigationController alloc] initWithRootViewController:_spaceController];
    _bizOppNavCtrl = [[UINavigationController alloc] initWithRootViewController:bizOppController];
    _applyNavCtrl = [[UINavigationController alloc] initWithRootViewController:applyViewController];
    _giftNavCtrl = [[UINavigationController alloc] initWithRootViewController:giftViewController];
    _contactsPageNavCtrl = [[UINavigationController alloc] initWithRootViewController:contactsPageController];
    _patrolTaskNavCtrl = [[UINavigationController alloc] initWithRootViewController:taskViewController];
    _videoNavCtrl = [[UINavigationController alloc] initWithRootViewController:videoViewController];
    _dataReportNavCtrl = [[UINavigationController alloc] initWithRootViewController:dataReportViewController];
    _paperNavCtrl = [[UINavigationController alloc] initWithRootViewController:paperViewController];
    _LeaveNavCtrl =  [[UINavigationController alloc] initWithRootViewController:leaveViewController];
    _leftNavigationController = [[UINavigationController alloc] initWithRootViewController:_leftSideDrawerViewController];
    _drawerController = [[MMDrawerController alloc]
                        initWithCenterViewController:_mainFunctionNavCtrl
                        leftDrawerViewController:_leftNavigationController
                        rightDrawerViewController:nil];
    [_drawerController setMaximumLeftDrawerWidth:200.0];
    [_drawerController setMaximumRightDrawerWidth:200.0];
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

-(void)releaseAllPage{
    [self.mainTabbar release];
    self.mainTabbar = nil;
    [_leftSideDrawerViewController release];
    _leftSideDrawerViewController = nil;
    [_spaceController release];
    _spaceController = nil;
    [_myMessageController release];
    _myMessageController = nil;
    [_leftNavigationController release];
    _leftNavigationController = nil;
    [_datasyncNavCtrl release];
    _datasyncNavCtrl = nil;
    [_mainFunctionNavCtrl release];
    _mainFunctionNavCtrl = nil;
    [_attendanceNavCtrl release];
    _attendanceNavCtrl = nil;
    [_messageNavCtrl release];
    _messageNavCtrl = nil;
    [_patrolNavCtrl release];
    _patrolNavCtrl = nil;
    [_inspectionNavCtrl release];
    _inspectionNavCtrl = nil;
    [_worklogNavCtrl release];
    _worklogNavCtrl = nil;
    [_changePwdNavController release];
    _changePwdNavController = nil;
    [_orderNavCtrl release];
    _orderNavCtrl = nil;
    [_stockNavCtrl release];
    _stockNavCtrl = nil;
    [_myfavorateNavCtrl release];
    _myfavorateNavCtrl = nil;
    [_contactsNavCtrl release];
    _contactsNavCtrl = nil;
    [_saleNavCtrl release];
    _saleNavCtrl = nil;
    [_salestatisticsNavCtrl release];
    _salestatisticsNavCtrl = nil;
    [_settingNavCtrl release];
    _settingNavCtrl = nil;
    [_competitionNavCtrl release];
    _competitionNavCtrl = nil;
    [_myMessageNavCtrl release];
    _myMessageNavCtrl = nil;
    [_companyContactNavCtrl release];
    _companyContactNavCtrl = nil;
    [_endContactNavCtrl release];
    _endContactNavCtrl = nil;
    [_researchNavCtrl release];
    _researchNavCtrl = nil;
    [_spaceNavCtrl release];
    _spaceNavCtrl = nil;
    [_bizOppNavCtrl release];
    _bizOppNavCtrl = nil;
    [_applyNavCtrl release];
    _applyNavCtrl = nil;
    [_giftNavCtrl release];
    _giftNavCtrl = nil;
    [_contactsPageNavCtrl release];
    _contactsPageNavCtrl = nil;
    [_patrolTaskNavCtrl release];
    _patrolTaskNavCtrl = nil;
    [_videoNavCtrl release];
    _videoNavCtrl = nil;
    [_dataReportNavCtrl release];
    _dataReportNavCtrl = nil;
    [_paperNavCtrl release];
    _paperNavCtrl = nil;
    [_LeaveNavCtrl release];
    _LeaveNavCtrl = nil;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [gpsTimer setFireDate:[NSDate distantFuture]];
    [locService stopUserLocationService];
    bActivity = NO;
    NSLog(@"退到后台，百度定位关闭");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if(gpsTimer == nil){
        gpsTimer = [NSTimer scheduledTimerWithTimeInterval:GPS_DURATION target:self selector:@selector(startGPS) userInfo:nil repeats:YES];
    }
    [gpsTimer setFireDate:[NSDate distantPast]];
    
    if ([CLLocationManager locationServicesEnabled]) {
        [locService startUserLocationService];
    }else{
        [locService stopUserLocationService];
        myLocation = nil;
        NSLog(@"本机定位关闭");
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%@",@"进入前台");
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    bActivity = YES;
    if (appBeComeActiveDelegate != nil && [appBeComeActiveDelegate respondsToSelector:@selector(appBeComeActive)]) {
        [appBeComeActiveDelegate appBeComeActive];
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"network_change" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
 
    double d_latitude = userLocation.location.coordinate.latitude;
    double d_longitude = userLocation.location.coordinate.longitude;
    float f_latitude = [[NSNumber numberWithDouble: d_latitude] floatValue];
    float f_longitude = [[NSNumber numberWithDouble: d_longitude] floatValue];
    
    if ((f_latitude < 0) || (f_longitude < 0)) return;
    
    locationBuilder = [[Location builder] retain];
    [locationBuilder setLatitude:f_latitude];
    [locationBuilder setLongitude:f_longitude];
    if (lastAddress != nil && !lastAddress.isEmpty) {
        [locationBuilder setAddress:lastAddress];
    }else{
        //[locationBuilder setAddress:[NSString stringWithFormat:@"%f   %f",f_latitude,f_longitude]];
    }
    myLocation = [[locationBuilder build] retain];
    
    //发起反地理编码
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){myLocation.latitude, myLocation.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [search reverseGeoCode:reverseGeocodeSearchOption];
    [reverseGeocodeSearchOption release];
    if(flag)
    {
        NSLog(@"百度地图反geo检索发送成功");
    }
    else
    {
        NSLog(@"百度地图反geo检索发送失败");
    }
    //发送广播通知UI更新地址
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_location" object:nil];
    [locService stopUserLocationService];
   
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == 0) {
        lastAddress = [result.address copy];
        [locationBuilder setCreateTime:[NSDate getCurrentDateTime]];
        NSLog(@"%@",result.address);
        
        Location* v1 = [[[myLocation toBuilder] setAddress:lastAddress ] build];
        self.myLocation = [v1 retain];
        retryTimes = 0;
        [self _searchNearBy:NSLocalizedString(@"POI_NEARBY_COMPANY", @"") Location:result.location Radius:GPS_REDIUS];
	}
}

//查询附近
- (void)_searchNearBy:(NSString*) keyword Location:(CLLocationCoordinate2D) location Radius:(int) radius{
    
    BMKNearbySearchOption *citySearchOption = [[BMKNearbySearchOption alloc]init];
    citySearchOption.location = location;
    citySearchOption.radius = radius;
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.keyword = keyword;
    BOOL flag = [poisearch poiSearchNearBy:citySearchOption];
    [citySearchOption release];
    if(flag){
        NSLog(@"百度地图附近检索发送成功");
    }
    else{
        NSLog(@"百度地图附近检索发送失败");
    }

}

- (void) _retrySearchNearBy:(int) times Radius:(int) radius{
    CLLocationCoordinate2D location = (CLLocationCoordinate2D){myLocation.latitude, myLocation.longitude};
    switch (times) {
        case 1:
            [self _searchNearBy:NSLocalizedString(@"POI_NEARBY_FOOD", @"") Location:location Radius:radius];
            break;
        case 2:
            [self _searchNearBy:NSLocalizedString(@"POI_NEARBY_AREA", @"") Location:location Radius:radius];
            break;
        case 3:
            [self _searchNearBy:NSLocalizedString(@"POI_NEARBY_ENTERMENT", @"") Location:location Radius:radius];
            break;
        case 4:
            [self _searchNearBy:NSLocalizedString(@"POI_NEARBY_COMPANY", @"") Location:location Radius:5*radius];
            break;
        default:
            break;
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
		for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            if(i == 0){
                NSLog(@"当前位置附近：%@",poi.name);
                lastAddress = [[NSString stringWithFormat:NSLocalizedString(@"POI_NEARBY", @""),lastAddress,poi.name] copy];
                Location* v1 = [[[myLocation toBuilder] setAddress:lastAddress ] build];
                self.myLocation = v1;

                break;
            }
		}
	} else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"百度地图查询周边起始点有歧义");
    } else {
        retryTimes++;
        [self _retrySearchNearBy:retryTimes Radius:GPS_REDIUS];
        NSLog(@"百度地图无法查询周边");
    }
}

- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"百度地图联网成功");
    }
    else{
        NSLog(@"百度地图 onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"百度地图授权成功");
    }
    else {
        NSLog(@"百度地图 onGetPermissionState %d",iError);
    }
}

- (void)toLogin:(NSString* )msg {
    [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                      description:msg
                             type:MessageBarMessageTypeError
                      forDuration:ERR_MSG_DURATION];
    [currentUser release];
    currentUser = nil;
    [AGENT close];
    [VIEWCONTROLLER create:nil ViewId:FUNC_LOGIN Object:nil Delegate:nil NeedBack:NO];
    return;
}

- (void)receivePushMessage:(SessionResponse*)wtr {
    SessionResponse* cr = wtr;
    if (([cr.code isEqualToString:NS_ACTIONCODE(ActionCodeErrorAccountException)] || [cr.code isEqual:NS_ACTIONCODE(ActionCodeErrorAppException)] ) ) {
        [self toLogin:cr.resultMessage];
    }
    if (([cr.type isEqual:NS_ACTIONTYPE(ActionTypePushMsg)])) {
        int countMessage = 0;
        int countAnnounce = 0;
        SysMessage* m;
        Announce* a;
        if (cr.hasData) {
            SessionMessage* wtm = [SessionMessage parseFromData:cr.data];
            if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeService)]) {
                m = [SysMessage parseFromData:wtm.body.content];
                ++countMessage;
            }
            if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeAnnounce)]) {
                a = [Announce parseFromData:wtm.body.content];
                ++countAnnounce;
            }
            if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeException)]) {
                ExceptionMessage* em = [ExceptionMessage parseFromData:wtm.body.content];
                [self setUserExpire:em];
                return;
                //[self toLogin:em.content];
            }
        }else{
            for (int i = 0; i < cr.datas.count; ++i) {
                SessionMessage* wtm = [SessionMessage parseFromData:[cr.datas objectAtIndex:i]];
                
                if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeService)]) {
                    m = [SysMessage parseFromData:wtm.body.content];
                    ++countMessage;
                }
                if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeAnnounce)]) {
                    a = [Announce parseFromData:wtm.body.content];
                    ++countAnnounce;
                }
                if ([wtm.header.messageType isEqual:NS_MESSAGETYPE(MessageTypeException)]) {
                    ExceptionMessage* em = [ExceptionMessage parseFromData:wtm.body.content];
                    [self setUserExpire:em];
                    return;
                    //不跳转登录页面
                    //[self toLogin:em.content];
                }
            }
        }
        if (countMessage > 0) {
            if ([LOCALMANAGER getValueFromUserDefaults:KEY_MESSAGE].intValue == 0){
                
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"menu_function_message", @"")
                                  description:[NSString stringWithFormat:@"收到%d条消息\n%@",countMessage,[self getContentWithMessage:m]]
                                     type:MessageBarMessageTypeInfo
                              forDuration:5.0];
                MESSAGE.delegate = self;
                MESSAGE.object = m;
            }
        }
        if (countAnnounce > 0){
            if ([LOCALMANAGER getValueFromUserDefaults:KEY_MESSAGE].intValue == 0){
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *realName = [ user objectForKey:@"announceRealName"];
                [MESSAGE showMessageWithTitle:realName
                              description:[NSString stringWithFormat:@"收到%d条通知\n%@",countAnnounce,a.subject]
                                     type:MessageBarMessageTypeImportant
                              forDuration:5.0];
            
                MESSAGE.delegate = self;
                MESSAGE.object = a;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
    }
    if ((([cr.type isEqual:NS_ACTIONTYPE(ActionTypeSyncBaseData)] ) && ([cr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]))){
        [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
    }
    if ((([cr.type isEqual:NS_ACTIONTYPE(ActionTypeLogin)] ) && ([cr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]))){
        Log_Builder* ub = [Log builder];
        if (APPDELEGATE.myLocation != nil) {
            [ub setLocation:APPDELEGATE.myLocation];
        }
        [ub setType:NS_USERLOGTYPE(LogTypeLogin)];
        [AGENT sendRequestWithType:ActionTypeUserLogSave param:[ub build]];
    }
}

- (void) itemClicked:(NSObject *)object{
    if ([object isKindOfClass:[Announce class]]) {
        [VIEWCONTROLLER create:nil ViewId:FUNC_ANNOUNCE Object:(Announce*)object Delegate:nil NeedBack:YES];
    }else{
        SysMessage *m = (SysMessage *)object;
        [VIEWCONTROLLER showMessageWithId:nil MessageType:m.type objectId:m Delegate:nil];
    }
}

-(void)checkVersion{
    [[UpdateVersion sharedInstance] setAppID:@"688032620"];
    
    /* (Optional) Set the Alert Type for your app
     By default, the Singleton is initialized to HarpyAlertTypeOption */
    [[UpdateVersion sharedInstance] setAlertType:AlertTypeOption];
    
    /* (Optional) If your application is not availabe in the U.S. Store, you must specify the two-letter
     country code for the region in which your applicaiton is available in. */
    //[[UpdateVersion sharedInstance] setCountryCode:@"<countryCode>"];
    
    // Perform check for new version of your app
    [[UpdateVersion sharedInstance] checkVersion:FALSE];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if (notification) {
        NSLog(@"%@",notification.alertBody);
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSString *) getContentWithMessage:(SysMessage *) m{
    NSString *msg = @"";
    //订单详情处理
    if (m.type == MESSAGE_CARGO_REQ) {
        PushOrderMsg *obj = [[[PushOrderMsg alloc] init] mj_setKeyValues:[m.content mj_JSONObject]];
        msg = obj.message;
        [obj release];
         return msg;
    }
    
   if (m.type == MESSAGE_HOLIDAY_APPROVAL_USER || m.type == MESSAGE_HOLIDAY_APPLY ) {
        
        NSData *JSONData = [m.content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        msg = [responseJSON objectForKey:@"message"];
    }

    else{
        msg = m.content;
    }
   
     return msg;
}


#pragma -mark --Private Method

-(void) setUserExpire:(ExceptionMessage *) em{
    [AGENT setUserExpire:em];
    NSString *error = em.content.length > 0 ? em.content : [LOCALMANAGER isUserExpire:USER];
    if (error.length == 0) {
        error = NSLocalizedString(@"error_account_expired", nil);
    }
    [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                      description:error
                             type:MessageBarMessageTypeError
                      forDuration:ERR_MSG_DURATION];
}

-(void)syncData:(NSData*)syncData {
    SyncData* data = [SyncData parseFromData:syncData];
    [LOCALMANAGER saveInspectionCategories:data.inspectionReportCategories];
    [LOCALMANAGER saveInspectionModels:data.inspectionModels];
    [LOCALMANAGER saveInspectionStatus:data.inspectionStatuses];
    [LOCALMANAGER saveInspectionTargets:data.inspectionTargets];
    [LOCALMANAGER saveInspectionTypes:data.inspectionTypes];
    [LOCALMANAGER saveVideoCategories:data.videoCategories];
    [LOCALMANAGER saveVideoDurationCategories:data.videoDurationCategories];
    [LOCALMANAGER saveCustomerCategories:data.customerCategories];
    [LOCALMANAGER savePatrolCategories:data.patrolCategories];
    [LOCALMANAGER saveFunctions:data.functions];
    [LOCALMANAGER savePatrolMediaCategories:data.patrolMediaCategories];
    [LOCALMANAGER savePatrolVideoDurationCategories:data.patrolVideoDurationCategories];
    [LOCALMANAGER saveProductCategories:data.productCategories];
    [LOCALMANAGER saveProductSpecifications:data.productSpecifications];
    [LOCALMANAGER saveCustomerTags:data.customerTags];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_VIDEO_DURATION Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.videoDurationCategories.count]];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_VIDEOCATETORY Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.videoCategories.count]];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_INSPECTION Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.inspectionTargets.count]];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_CUSTOMER_CATEGORY Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.customerCategories.count]];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_PATROL_CATEGORY Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.patrolCategories.count]];
    
    [LOCALMANAGER savePaperTemplates:data.paperTemplates];
    //默认模板的同步
    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_PAPER_DEFAULT object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"syn     cAnnouceNotification" object:nil];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_COMPETITION_PRODUCT Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.competitionProducts.count]];
    
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_PRODUCT Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.products.count]];
    
    [LOCALMANAGER saveCompetitionProducts:data.competitionProducts];
    [LOCALMANAGER saveProducts:data.products];
    [LOCALMANAGER saveDepartments:data.departments];
    [LOCALMANAGER saveGiftProductCategories:data.giftProductCategories];
    [LOCALMANAGER saveApplyCategories:data.applyCategories];
    [LOCALMANAGER saveGiftProducts:data.giftProducts];
    
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_DEPARTMENT Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.departments.count]];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_GIF_PRODUCT Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.giftProducts.count]];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_GIF_PRODUCT_CATEGORY Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.giftProductCategories.count]];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_APPLY_CATEGORY Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.applyCategories.count]];
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_ATTENDANCE_CATEGORY Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.attendanceCategories.count]];
    
    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_USER Value:[NSString stringWithFormat:@"%lu",(unsigned long)data.users.count]];
    
    //客户标签 与 产品规格选择个数限定
    [LOCALMANAGER saveKvo:[NSString stringWithFormat:@"%d",data.systemSetting.customerTagQueryMax] key:KEY_CUSTOMERTAG_MAX_COUNT];
    [LOCALMANAGER saveKvo:[NSString stringWithFormat:@"%d",data.systemSetting.customerTagValQueryMax] key:KEY_CUSTOMERTAG_COUNT];
    [LOCALMANAGER saveKvo:[NSString stringWithFormat:@"%d",data.systemSetting.prodSpecQueryMax] key:KEY_PRODUCT_SPEC_MAX_COUNT];
    [LOCALMANAGER saveKvo:[NSString stringWithFormat:@"%d",data.systemSetting.prodSpecValQueryMax] key:KEY_PRODUCT_SPEC_COUNT];
    
    //版本功能更新检测
    if (![LOCALMANAGER isFuncSync:FUNC_VIDEO]){
        [LOCALMANAGER favFunction:FUNC_VIDEO_DES];
        [LOCALMANAGER setFuncSync:FUNC_VIDEO];
        NSLog(@"检测强制更新视频功能!");
    }
    
    if (![LOCALMANAGER isFuncSync:FUNC_PATROL_VIDEO]) {
        [LOCALMANAGER setFuncSync:FUNC_PATROL_VIDEO];
        NSLog(@"检测强制更新功能标题!");
        //移除两个之前写死的 企业空间和系统消息 (库改名此处不)
        [LOCALMANAGER deleteFunctionWithDes:@"SPACE"];
        [LOCALMANAGER deleteFunctionWithDes:@"MESSAGE"];
    }
    
    [LOCALMANAGER saveUsers:data.users];
    [LOCALMANAGER saveAttendanceCategories:data.attendanceCategories];
    [LOCALMANAGER saveHolidayCategories:data.holidayCategories];
    
    //wifi考勤新增
    [LOCALMANAGER saveAttendanceTypes:data.attendanceTypes];
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"syncAttendanceCatogry" object:nil];
    [LOCALMANAGER saveCheckInChannels:data.checkInChannels];
    [LOCALMANAGER saveUserPermission:data.sessionUser];
   
    [LOCALMANAGER saveChenkInShift:data.checkInShift];
    [LOCALMANAGER saveHolidays:data.checkInShift.holidays];
    [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_TIME Value:[NSDate getCurrentTime]];
    [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_STATUS Value:@"1"];}

@end
