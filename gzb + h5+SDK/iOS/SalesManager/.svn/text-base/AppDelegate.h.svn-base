//
//  AppDelegate.h
//  SalesManager
//
//  Created by liu xueyan on 7/29/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
//引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
//引入定位功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
//只引入所需的单个头文件
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "MMDrawerController.h"
#import "RequestAgent.h"
#import "SplashViewController.h"
#import "LoginViewController.h"
#import "MessageBarManager.h"
#import "MainMenuViewController.h"
#import "RDVTabBarController.h"
#import <UserNotifications/UserNotifications.h>

@class Location_Builder;
@class User;

@interface AppDelegate : UIResponder <BMKMapViewDelegate,BMKGeneralDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,UIApplicationDelegate,MessageBarManagerDelegate,PushDelegete,CLLocationManagerDelegate,UNUserNotificationCenterDelegate> {
    BMKMapManager* mapManager;
    BMKLocationService* locService;
    BMKGeoCodeSearch *search;
    BMKPoiSearch* poisearch;
    Location *myLocation;
    RequestAgent *agent;
    User *currentUser;
    
    Location_Builder* locationBuilder;
    BOOL bFirstLogin;
    BOOL bChangeFavorate;
    BOOL bPopAction;
    BOOL bActivity;
    BMKMapView *mapView;
    
    int backgournCount ;
    
    NSString* lastAddress;
    NSTimer*  gpsTimer;
    int retryTimes;
    
@private
    Reachability *hostReach;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Location *myLocation;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) RequestAgent *agent;
@property (nonatomic,assign) BOOL bFirstLogin;
@property (nonatomic,assign) BOOL bChangeFavorate;
@property (nonatomic,assign) BOOL bPopAction;
@property (nonatomic,strong) NSDictionary *remoteNotificationDict;
@property (strong, nonatomic) MMDrawerController *drawerController;
@property (strong, nonatomic) LoginViewController *loginCtrl;
@property (strong, nonatomic) UINavigationController *loginNavCtrl;
@property (strong, nonatomic) MainMenuViewController *leftSideDrawerViewController;
@property (strong, nonatomic) SplashViewController* splashCtrl;
@property (strong, nonatomic) UINavigationController *splashNavCtrl;
@property (strong, nonatomic) UINavigationController *mainFunctionNavCtrl;
@property (strong, nonatomic) UINavigationController *attendanceNavCtrl;
@property (strong, nonatomic) UINavigationController *patrolNavCtrl;
@property (strong, nonatomic) UINavigationController *inspectionNavCtrl;
@property (strong, nonatomic) UINavigationController *worklogNavCtrl;
@property (strong, nonatomic) UINavigationController *orderNavCtrl;
@property (strong, nonatomic) UINavigationController *stockNavCtrl;
@property (strong, nonatomic) UINavigationController *statisticsNavCtrl;
@property (strong, nonatomic) UINavigationController *messageNavCtrl;
@property (strong, nonatomic) UINavigationController *passwordNavCtrl;
@property (strong, nonatomic) UINavigationController *datasyncNavCtrl;
@property (strong, nonatomic) UINavigationController *leftNavigationController;
@property (strong, nonatomic) UINavigationController *changePwdNavController;
@property (strong, nonatomic) UINavigationController *myfavorateNavCtrl;
@property (strong, nonatomic) UINavigationController *contactsNavCtrl;
@property (strong, nonatomic) UINavigationController *saleNavCtrl;
@property (strong, nonatomic) UINavigationController *salestatisticsNavCtrl;
@property (strong, nonatomic) UINavigationController *settingNavCtrl;
@property (strong, nonatomic) UINavigationController *competitionNavCtrl;
@property (strong, nonatomic) UINavigationController *myMessageNavCtrl;
@property (strong, nonatomic) UINavigationController *companyContactNavCtrl;
@property (strong, nonatomic) UINavigationController *endContactNavCtrl;
@property (strong, nonatomic) UINavigationController *contactsPageNavCtrl;
@property (strong, nonatomic) UINavigationController *researchNavCtrl;
@property (strong, nonatomic) UINavigationController *bizOppNavCtrl;
@property (strong, nonatomic) UINavigationController *spaceNavCtrl;
@property (strong, nonatomic) UINavigationController *applyNavCtrl;
@property (strong, nonatomic) UINavigationController *giftNavCtrl;
@property (strong, nonatomic) UINavigationController *videoNavCtrl;
@property (strong, nonatomic) UINavigationController *dataReportNavCtrl;
@property (strong, nonatomic) UINavigationController *paperNavCtrl;
@property (strong, nonatomic) UINavigationController *LeaveNavCtrl;

@property (strong, nonatomic) UIViewController *myMessageController;
@property (strong, nonatomic) UINavigationController *patrolTaskNavCtrl;
@property (strong, nonatomic) UIViewController *spaceController;
@property (strong, nonatomic) RDVTabBarController *mainTabbar;

@property (nonatomic,strong) id<AppBecomeActiveDelegate> appBeComeActiveDelegate;
@property (strong,nonatomic) BMKLocationService* locService;

-(void)initPage;
-(void)releaseAllPage;
-(void)toOpenNotficationDetail;
-(NSString *) getContentWithMessage:(SysMessage *) m;

- (void) reachabilityChanged: (NSNotification* )note;//网络连接改变
- (void) updateInterfaceWithReachability: (Reachability*) curReach;//处理连接
//同步数据
-(void)syncData:(NSData*)syncData;

@end
