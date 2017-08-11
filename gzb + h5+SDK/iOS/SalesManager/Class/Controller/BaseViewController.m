//
//  BaseViewController.m
//  SalesManager
//
//  Created by liu xueyan on 7/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "LocalManager.h"
#import "Constant.h"
#import "NSString+Helpers.h"
#import "UIImage+JSLite.h"
#import "NSDate+Util.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize leftImageView,lblFunctionName,leftView,bNeedBack,customer;
@synthesize touchDelegate = _touchDelegate;
@synthesize lblTitle;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncTitle)
                                                 name:@"sync_function_menu"
                                               object:nil];

    
    (APPDELEGATE).appBeComeActiveDelegate = self;

    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main"]]];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main"]]];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_top"] forBarMetrics:UIBarMetricsDefault];
        UIView* statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, MAINWIDTH, 20)];
        [statusView setBackgroundColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar addSubview:statusView];
        [statusView release];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_top"] forBarMetrics:UIBarMetricsDefault];
    
    
    spaceButton = [[UIBarButtonItem alloc] init];
    
    //[[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];

    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 11, 24, 22)];
    [leftImageView setImage:[UIImage imageNamed:@"ab_icon_left_meun"]];
//    leftImageView.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
//    leftImageView.textAlignment = UITextAlignmentCenter;
//    leftImageView.textColor = WT_RED;
//    leftImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_LEFT];
    [leftView addSubview:leftImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [leftImageView release];
    [tapGesture release];
    self.view.userInteractionEnabled = YES;
    
    lblFunctionName = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 200, 44)];
    lblFunctionName.textColor = [UIColor brownColor];
    lblFunctionName.font = [UIFont systemFontOfSize:18];
    [lblFunctionName setBackgroundColor:[UIColor clearColor]];
    lblFunctionName.textAlignment = NSTextAlignmentLeft;
    lblFunctionName.text = NSLocalizedString(@"menu_function_dashboard",@"");
    [leftView addSubview:lblFunctionName];
    [lblFunctionName release];
    
    if (bNeedBack) {
        leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];;
    }
    
    /*
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    lblTitle.textColor = [UIColor brownColor];
    lblTitle.font = [UIFont boldSystemFontOfSize: 20.0];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    lblTitle.text = NSLocalizedString(@"menu_function_dashboard",@"");
    lblTitle.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lblTitle;
    */
    
    [leftView addGestureRecognizer:tapGesture];
    UIBarButtonItem *btLogo = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.navigationItem.leftBarButtonItem = btLogo;
    [btLogo release];;
    
    
    self.touchDelegate = self;
    
    (APPDELEGATE).agent.delegate = self;
    APPDELEGATE.agent.actionDelegate = self;
}

-(void) setRightButton:(UIBarButtonItem *) barbutton{
    self.navigationItem.rightBarButtonItems = @[spaceButton,barbutton];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

-(void)clickLeftButton:(id)sender{
    if (bNeedBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    
}

-(void)showMessage:(REQUEST_STATUS)status Title:(NSString*)title{
    switch (status) {
        case DONE:
            return;
            break;
        case RECONNECT_WEBSOCKET:
            //HUDHIDE2;
            [MESSAGE showMessageWithTitle:title
                              description:NSLocalizedString(@"reconnect_server", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            break;
        case NETWROK_NOT_AVAILABLE:
            break;
        case WEBSOCKET_NOT_OPEN:
            break;
        default:
            break;
    }
}

-(void)didReceiveActionCode:(PBGeneratedMessage *)wtr{
    if ([wtr isKindOfClass:SessionResponse.class]) {
        NSInteger resultCode = INT_ACTIONCODE(((SessionResponse*)wtr).code);
        if (ActionCodeErrorTimeout == resultCode) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"app_name", @"")
                              description:NSLocalizedString(@"error_timeout", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }else if (ActionCodeErrorAccountException == resultCode) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"app_name", @"")
                              description:NSLocalizedString(@"error_account_expired", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }
        if (ActionCodeDone != resultCode) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"app_name", @"")
                              description:((SessionResponse*)wtr).resultMessage
                                     type:MessageBarMessageTypeError
                              forDuration:SUCCESS_MSG_DURATION];
        }
    }
    HUDHIDE;
}
//
-(void)showMessage2:(SessionResponse*) cr Title:(NSString*)title Description:(NSString*)desc{
    if ([cr isKindOfClass:SessionResponse.class]) {
        NSInteger resultCode = INT_ACTIONCODE(((SessionResponse*)cr).code);
        if (ActionCodeErrorTimeout == resultCode) {
            [MESSAGE showMessageWithTitle:title
                              description:NSLocalizedString(@"error_timeout", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }else if (ActionCodeErrorAccountException == resultCode) {
//            [MESSAGE showMessageWithTitle:title
//                              description:NSLocalizedString(@"error_account_expired", @"")
//                                     type:MessageBarMessageTypeError
//                              forDuration:ERR_MSG_DURATION];
        } else if (ActionCodeDone == resultCode) {
            if (![desc isEqualToString:@""]){
                [MESSAGE showMessageWithTitle:title
                                  description:desc
                                         type:MessageBarMessageTypeSuccess
                                  forDuration:SUCCESS_MSG_DURATION];
            }
        }
        if (ActionCodeDone != resultCode) {
            [MESSAGE showMessageWithTitle:title
                              description:((SessionResponse*)cr).resultMessage
                                     type:MessageBarMessageTypeError
                              forDuration:SUCCESS_MSG_DURATION];
            
            HUDHIDE;
        }
    }
    
    
}


-(void)showMessage:(ActionCode)resultCode Title:(NSString*)title Description:(NSString*)desc{
    if (ActionCodeErrorInvalidAction == resultCode) {
        [MESSAGE showMessageWithTitle:title
                          description:NSLocalizedString(@"error_invaction", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    } else if (ActionCodeErrorServer == resultCode) {
        [MESSAGE showMessageWithTitle:title
                          description:NSLocalizedString(@"error_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    } else if (ActionCodeErrorTimeout == resultCode) {
        [MESSAGE showMessageWithTitle:title
                          description:NSLocalizedString(@"error_timeout", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    } else if (ActionCodeDone == resultCode) {
        if (![desc isEqualToString:@""]){
            [MESSAGE showMessageWithTitle:title
                              description:desc
                                     type:MessageBarMessageTypeSuccess
                              forDuration:SUCCESS_MSG_DURATION];
        }
    }
    if (ActionCodeDone != resultCode) {
        HUDHIDE;
        //HUDHIDE2;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    //NSLog(@"you clicked!");
}

-(IBAction) slideFrameUp
{
    [self slideFrame:YES];
}

-(IBAction) slideFrameDown
{
    [self slideFrame:NO];
}

-(void) slideFrame:(BOOL) up
{
    const int movementDistance = 140; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)allview:(UIView *)rootview indent:(NSInteger)indent
{
    NSLog(@"[%2d] %@",indent,rootview);
    indent++;
    for (UIView *aview in [rootview subviews])
    {
        [self allview:aview indent:indent];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"memory warnning～～～～");
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取wifi 名称
-(NSString*)getWifiName {
    id info = nil;
    NSArray *ifs = ( id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        wifiNameString = info[@"SSID"];
    }
    
    return wifiNameString;
}

#pragma mark 获取mac地址
-(NSString*)getMacAddress {
    id info = nil;
    NSArray *ifs = ( id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        // mac 地址省略情况 补0
        NSArray *macArr = [info[@"BSSID"] componentsSeparatedByString:@":"];
        NSMutableArray *mulArray = [[NSMutableArray alloc]init];
        [macArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (((NSString*)obj).length == 1) {
                obj = [NSString stringWithFormat:@"0%@",obj];
            }
            [mulArray addObject:obj];
        }];
        
        macAddrString =  [mulArray componentsJoinedByString:@":"];
        
    }
    return macAddrString;
}

#pragma mark 将秒数转化成时间
- (NSString *)timeFormatted:(int)totalSeconds {
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (minutes == 0) {
       return [NSString stringWithFormat:@"%d小时",hours];
    }
    if (hours == 0) {
     return [NSString stringWithFormat:@"%d分钟",minutes];
    }
    return [NSString stringWithFormat:@"%d小时%d分钟",hours, minutes];
}

-(void)syncTitle{

}

- (void)dealloc {
  [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) didFailWithError:(NSError *)error{
    HUDHIDE;
    HUDHIDE2;
    
    if ((AGENT.webSocket.readyState == SR_CLOSED) && error.code == 2132){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"error_operation", @"")
                          description:NSLocalizedString(@"error_login", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    
    switch (error.code) {
        case 3:
            NSLog(@"socket error code:3");
            /*[MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_account_expired", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];*/
            break;
        case 60:
            NSLog(@"socket error code:60");
            
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_timeout", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            break;
        case 57:
            NSLog(@"socket error code:57");
            /*[MESSAGE showMessageWithTitle:NSLocalizedString(@"error_operation", @"")
                              description:NSLocalizedString(@"error_network_unfind", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];*/
            break;
        case 61:
            NSLog(@"socket error code:61");
            /*[MESSAGE showMessageWithTitle:NSLocalizedString(@"error_operation", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];*/
            break;
        case 54:{
            NSLog(@"socket error code:54");
        }
            break;
            
        case 2145:{
            NSLog(@"socket error code:2145");
        }
            
            break;
            
        default:
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"error_operation", @"")
                              description:NSLocalizedString(@"error_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            break;
    }
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    HUDHIDE;
    HUDHIDE2;
    if ((APPDELEGATE).agent.recevieResultCode == ActionCodeErrorAccountException) {
        return;
    }
    AGENT.bRequesting = NO;
}

- (void) appBeComeActive{
    if (((APPDELEGATE).agent != nil) && ((APPDELEGATE).agent.webSocket != nil)){
        NSLog(@"%d",(APPDELEGATE).agent.webSocket.readyState);
        
        if ((APPDELEGATE).currentUser == nil) {
            return;
        }
        
        if (![(APPDELEGATE).agent isExistenceNetwork]) {
            return;
        }
        
        if ((APPDELEGATE).agent.webSocket.readyState != SR_OPEN){
            NSLog(@"reconnect");
            [(APPDELEGATE).agent reconnect];
            
            /*[MESSAGE showMessageWithTitle:NSLocalizedString(@"login_msg_posting", @"")
                              description:NSLocalizedString(@"reconnect_server", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:5.0];*/
            if ((APPDELEGATE).agent.recevieResultCode != ActionCodeDone){
                HUDHIDE;
             //   HUDHIDE2;
                /*[MESSAGE showMessageWithTitle:NSLocalizedString(@"error_operation", @"")
                                  description:NSLocalizedString(@"replay_operation", @"")
                                         type:MessageBarMessageTypeError
                                  forDuration:ERR_MSG_DURATION];*/
                if (AGENT.delegate != nil) {
                    [AGENT.delegate didFailWithError:nil];
                }
            }
        }
    }
}

-(void) showHint:(EHintView) hintView{
    return;
    if (_hintHelper == nil) {
        _hintHelper = [[HintHelper alloc] initWithViewController:self HintView:hintView];
    }
}

-(void)refreshLocation{
    [APPDELEGATE.locService startUserLocationService];
}

-(void)readMessage:(int)type SourceId:(NSString*)sourceId{
    [LOCALMANAGER readMessage:type SourceId:sourceId];
    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
}


//Version 已经被移除 全部删除次方法
-(BOOL)validateData:(id)data{
    BOOL ret = TRUE;

    return ret;
}

-(CGSize)rebuildSizeWithString:(NSString*) text ContentWidth:(double)width FontSize:(double)fontsize{
    if (text == nil || text.length == 0) {
        return CGSizeMake(0, 0);
    }
    CGSize constraint = CGSizeMake(width, 2000.0f);
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{
                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:fontsize]
                                                                                                     }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size;
}

-(BOOL)validateSessionResponse:(SessionResponse *)wtr{
    //服务器端数据包处理失败处理，返回LOGIN_,ERROR_SERVER
    BOOL ret = FALSE;
    if (([wtr.type isEqual:NS_ACTIONTYPE(ActionTypeLogin)] && [wtr.code isEqual:NS_ACTIONCODE(ActionCodeErrorServer)])) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"error_server", @"")
                          description:wtr.resultMessage
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        ret = TRUE;
    }
    HUDHIDE2;
    HUDHIDE;
    return ret;
}

-(BOOL)validateResponse:(SessionResponse *)wtr{
    //服务器端数据包处理失败处理，返回LOGIN_,ERROR_SERVER
    BOOL ret = FALSE;
    if (([wtr.type isEqual:NS_ACTIONTYPE(ActionTypeLogin)] && [wtr.code isEqual:NS_ACTIONCODE(ActionCodeErrorServer)])) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"error_server", @"")
                          description:wtr.resultMessage
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        ret = TRUE;
    }
    HUDHIDE2;
    HUDHIDE;
    return ret;
}

@end
