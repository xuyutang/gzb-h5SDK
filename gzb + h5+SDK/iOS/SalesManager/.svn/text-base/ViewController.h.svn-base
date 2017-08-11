//
//  ViewController.h
//  SalesManager
//
//  Created by liu xueyan on 7/29/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SMWebSocket.h"
#import "BaseViewController.h"

@class AppDelegate;
@class MBProgressHUD;
@interface ViewController : BaseViewController<SMWebSocketDelegate,CLLocationManagerDelegate>{

    CLLocationManager *locationManager;
    SMWebSocket *socket;
    int requestType;
    
    User* loginUser;
    
    MBProgressHUD *HUD;
    AppDelegate* appDelegate;
    User* newUser;
}
@property (retain, nonatomic) IBOutlet UIButton *btLogin;
@property (retain, nonatomic) IBOutlet UIButton *btSync;
@property (retain, nonatomic) IBOutlet UIButton *btGoWork;
@property (retain, nonatomic) IBOutlet UIButton *btGoHome;
@property (retain, nonatomic) IBOutlet UIButton *btSaveWorkLog;
@property (retain, nonatomic) IBOutlet UIButton *btGetWorkLogs;
@property (retain, nonatomic) IBOutlet UIButton *btChangePwd;
@property (retain, nonatomic) IBOutlet UIButton *btSaveStock;
@property (retain, nonatomic) IBOutlet UIButton *btGetStocks;
@property (retain, nonatomic) IBOutlet UIButton *btSaveOrder;
@property (retain, nonatomic) IBOutlet UIButton *btGetOrders;
@property (retain, nonatomic) IBOutlet UIButton *btSavePatrol;
@property (retain, nonatomic) IBOutlet UIButton *btGetPatrols;
@property (retain, nonatomic) IBOutlet UIButton *btShowHUD;

-(IBAction)login:(id)sender;
- (IBAction)sync:(id)sender;

@end
