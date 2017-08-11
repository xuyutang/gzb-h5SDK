//
//  DataSyncViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "DataSyncViewController.h"
#import "MessageBarManager.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "ProgressButton.h"
#import <QuartzCore/QuartzCore.h>

@interface DataSyncViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>

@end


@implementation DataSyncViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(void)setBFirstLogin:(BOOL)bFirst{
    bFirstLogin = bFirst;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    baseSyncBool = NO;
    companyListSyncBool = NO;
    self.view.backgroundColor = WT_WHITE;
    appDelegate = APPDELEGATE;
    bClear = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *lblTitleB = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, MAINWIDTH, 40)];
        lblTitleB.text = NSLocalizedString(@"基础资料同步", nil);
        lblTitleB.textAlignment = UITextAlignmentCenter;
        lblTitleB.font = [UIFont systemFontOfSize:16.0f];
        lblTitleB.textColor = RGBA(48,139,201,1.0);
        [self.view addSubview:lblTitleB];
        [lblTitleB release];
        
        UILabel *lblRedline = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, MAINWIDTH, 5)];
        lblRedline.backgroundColor = WT_RED;
        [self.view addSubview:lblRedline];
        [lblRedline release];
        
        UILabel *lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 200, 40)];
        lblInfo.text = NSLocalizedString(@"同步基础资料到本机", nil);
        lblInfo.font = [UIFont systemFontOfSize:16.0f];
        [lblInfo setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:lblInfo];
        [lblInfo release];
        
        UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 300, 60)];
        lblDesc.text = NSLocalizedString(@"message_sync_desc", nil);
        lblDesc.numberOfLines = 3;
        lblDesc.font = [UIFont systemFontOfSize:12.0f];
        [lblDesc setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:lblDesc];
        [lblDesc release];
        
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"SyncButton" owner:self options:nil];
        btBaseProgressButton = [nibViews objectAtIndex:0];
        btBaseProgressButton.title.text = NSLocalizedString(@"data_sync_base", nil);
        btBaseProgressButton.description.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"message_sync_time", nil),[LOCALMANAGER getValueFromUserDefaults:KEY_SYNC_TIME]];
        btBaseProgressButton.frame = CGRectMake(30, 165, 260, 65);
        [btBaseProgressButton addTag:self withAction:@selector(toBaseSync)];
        [btBaseProgressButton.icon setImage:[UIImage imageNamed:@"ic_sync"]];
//        btBaseProgressButton.progressView.progress = [[LOCALMANAGER getValueFromUserDefaults:KEY_SYNC_STATUS] floatValue];
//        btBaseProgressButton.progressView.color = [UIColor orangeColor];
        btBaseProgressButton.layer.cornerRadius = 6;
        btBaseProgressButton.layer.masksToBounds = YES;
        [self.view addSubview:btBaseProgressButton];
        
        [lblFunctionName setText:NSLocalizedString(@"menu_function_datasync",@"")];
        AGENT.delegate = self;
        
        //首次登录自动同步基础数据
        if (bFirstLogin) {
            sleep(.5f);
            [self _SyncBase];
        }
    });
}

-(void) checkFirstLogin{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (bFirstLogin) {
            bFirstLogin = NO;
            [NSThread sleepForTimeInterval:1.5f];
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    bFirstLogin = NO;
    if (buttonIndex == 0) {
        HUDHIDE;
        HUDHIDE2;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        currentPage = 1;
        [self _syncCustomer];
    }
}



#pragma -mark -

-(void)toBaseSync{
    baseActionSheet = [[UIActionSheet alloc]
                                 initWithTitle:NSLocalizedString(@"message_sync_note", @"")
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"no", @"")
                                 destructiveButtonTitle:NSLocalizedString(@"message_sync_base", @"")
                                 otherButtonTitles:nil,nil];
    
    baseActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [baseActionSheet showInView:APPDELEGATE.drawerController.view];
}

-(void)toCustomSync{
    customerActionSheet =[[UIActionSheet alloc]
                                 initWithTitle:NSLocalizedString(@"message_sync_customer", @"")
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"no", @"")
                                 destructiveButtonTitle:NSLocalizedString(@"message_sync_customer_note_goon", @"")
                                 otherButtonTitles:NSLocalizedString(@"message_sync_customer_note", @""),nil];
    
    customerActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [customerActionSheet showInView:APPDELEGATE.drawerController.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == baseActionSheet) {
        if (USER == nil) {
            return;
        }
        switch (buttonIndex) {
            case 0:{
                AGENT.delegate = self;
                
              //  btBaseProgressButton.progressView.progress = 0;
                /*
                [self _syncCategory:appDelegate.currentUser];
                [self _syncAttendanceCategory:appDelegate.currentUser];
                [self _syncUser:appDelegate.currentUser];
                [self _syncAllUser:appDelegate.currentUser];
                 */
                [self _SyncBase];
            }
                break;
            case 1:{
                
            }
                break;
            default:
                break;
        }
    }
    if (actionSheet == customerActionSheet) {
        if (USER == nil) {
            return;
        }
        switch (buttonIndex) {
            case 0:{
                bClear = NO;
                if(currentPage*pageSize < totalSize){
                    currentPage++;
            
                    [self _syncCustomer];
                }
            }
                break;
            case 1:{
                bClear = YES;
                currentPage = 1;
                [self _syncCustomer];
            }
                break;
            case 2:{
                
            }
                break;
            default:
                break;
        }
    }
}

-(void)_SyncBase{
    SHOWHUD;
    if (DONE != [AGENT sendRequestWithType:ActionTypeSyncBaseData param:USER]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_data_sync", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    /*
     [self _syncCategory:appDelegate.currentUser];
     [self _syncAttendanceCategory:appDelegate.currentUser];
     [self _syncCustomer:appDelegate.currentUser];
     [self _syncUser:appDelegate.currentUser];
     [self _syncAllUser:appDelegate.currentUser];
     */
}

- (void) _syncCustomer{
    SHOWHUD;
    AGENT.delegate = self;
    CustomerParams_Builder* cb = [CustomerParams builder];
    
    [cb setPage:currentPage];
    [cb setUser:USER];
    if (DONE != [AGENT sendRequestWithType:ActionTypeSyncCustomerList param:[cb build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_data_sync", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        return;
    }else{
        if (bClear) {
           // btCustomProgressButton.progressView.progress = 0;
        }
    }
}

- (void) _syncCompanyContact{
    // SHOWHUD;
    if (DONE != [AGENT sendRequestWithType:ActionTypeCompanyContactList param:@""]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_data_sync", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void)dealloc{
    [customerActionSheet release];
    [baseActionSheet release];
    [lblCountCustomer release];
    [lblCountBase release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
            
        case   ActionTypeSyncBaseData:{
            if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]){
                baseSyncBool = YES;
                 [(APPDELEGATE) syncData:cr.data];
                //默认模板的同步
                [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_PAPER_DEFAULT object:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"syncAttendanceCatogry" object:nil];
                
                SyncData* data = [SyncData parseFromData:cr.data];
                
                [LOCALMANAGER saveValueToUserDefaults:KEY_APP_TITLE Value:[NSString stringWithFormat:@"%@",data.appSetting.appTitle]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    btBaseProgressButton.description.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"message_sync_time", nil),[LOCALMANAGER getValueFromUserDefaults:KEY_SYNC_TIME]];
                    //btBaseProgressButton.progressView.progress = [[LOCALMANAGER getValueFromUserDefaults:KEY_SYNC_STATUS] floatValue];
                });
               
                [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_VIDEO_MEDIA object:nil];
            }
            HUDHIDE;
            HUDHIDE2;
        
            [self _syncCompanyContact];
            [super showMessage2:cr Title:NSLocalizedString(@"data_sync_base", @"") Description:@""];
            //检测首次登陆
            [self checkFirstLogin];
        }
            break;
        case ActionTypeCompanyContactList:{
            
            if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]) {
                companyListSyncBool = YES;
                BOOL ret = FALSE;
                for (int i = 0 ; i < cr.datas.count; ++i) {
                    User* user = [User parseFromData:[cr.datas objectAtIndex:i]];
                    
                    if ([super validateData:user]) {
                        ret = TRUE;
                        break;
                    }
                }
                if (ret) {
                    [LOCALMANAGER saveAllUsers:cr.datas];
                    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_USER_CONTACT Value:[NSString stringWithFormat:@"%d",cr.datas.count]];
                }
            }else{
                HUDHIDE;
                HUDHIDE2;
            }
            if (baseSyncBool  && companyListSyncBool ) {
              [super showMessage2:cr Title:NSLocalizedString(@"data_sync_base", @"") Description:NSLocalizedString(@"data_sync_done", nil)];
            }
            
        }
            break;
        case ActionTypeSyncCustomerList:{
            if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]){
                SyncData* data = [SyncData parseFromData:cr.data];
                NSLog(@"customer sync end time:%@",[NSDate getCurrentDateTime]);
                NSLog(@"current sync times:%d",currentPage);
                NSLog(@"customer total size: %lu.",(unsigned long)data.pageCustomer.customers.count);
                //NSLog(@"customer page size: %d.",cr.pageCustomer.pageSize);
                if (bClear) {
                    [LOCALMANAGER clearCustomerWithSync];
                }
                pageSize = data.pageCustomer.page.pageSize;
                totalSize = data.pageCustomer.page.totalSize;
                
                NSLog(@"start insert customer into db:%@",[NSDate getCurrentDateTime]);
                [LOCALMANAGER saveCustomersWithSync:data.pageCustomer.customers];
                NSLog(@"end insert customer into db:%@",[NSDate getCurrentDateTime]);
                
                [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_CUSTOMER_TIME Value:[NSDate getCurrentTime]];
                if (totalSize == 0) {
                    [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_CUSTOMER_STATUS Value:@"0"];
                    [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_CUSTOMER_PAGE Value:@"0"];
                }else{
                    float currentPresent = (float)pageSize / (float)totalSize;
                    float persent = currentPresent + [[LOCALMANAGER getValueFromUserDefaults:KEY_SYNC_CUSTOMER_STATUS] floatValue];
                    int count = data.pageCustomer.customers.count;
                    int size = [[LOCALMANAGER getValueFromUserDefaults:KEY_SYNC_CUSTOMER_CURRENT_SIZE] intValue] + count;
                    [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_CUSTOMER_CURRENT_SIZE Value:[NSString stringWithFormat:@"%d",size]];
                    
                    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_CURRENT_CUSTOMER Value:[NSString stringWithFormat:@"%d",size]];
                    [LOCALMANAGER saveValueToUserDefaults:KEY_COUNT_CUSTOMER Value:[NSString stringWithFormat:@"%d",totalSize]];
                    
                    
                    if (size == totalSize) {
                        [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_CUSTOMER_STATUS Value:@"1"];
                    }else{
                        [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_CUSTOMER_STATUS Value:[NSString stringWithFormat:@"%.2f",persent]];
                    }
                    [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_CUSTOMER_PAGE Value:[NSString stringWithFormat:@"%d",currentPage]];
                    [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_CUSTOMER_PAGE_SIZE Value:[NSString stringWithFormat:@"%d",pageSize]];
                    [LOCALMANAGER saveValueToUserDefaults:KEY_SYNC_CUSTOMER_TOTAL_SIZE Value:[NSString stringWithFormat:@"%d",totalSize]];
                }
                
                btCustomProgressButton.description.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"message_sync_time", nil),[LOCALMANAGER getValueFromUserDefaults:KEY_SYNC_CUSTOMER_TIME]];
               // btCustomProgressButton.progressView.progress = [[LOCALMANAGER getValueFromUserDefaults:KEY_SYNC_CUSTOMER_STATUS] floatValue];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION object:nil];
                
            }else{
                --currentPage;
            }
            [super showMessage2:cr Title:NSLocalizedString(@"message_sync_customer", @"") Description:NSLocalizedString(@"data_sync_done", @"")];
            
            lblCountCustomer.text = [NSString stringWithFormat:NSLocalizedString(@"message_count_customer", nil),[LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_CURRENT_CUSTOMER],[LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_CUSTOMER]];
            
            
            HUDHIDE;
            HUDHIDE2;
        }
            break;

        default:
            break;
    }
}

//更新统计数量
-(NSString *) createLableCountBaseText{
    return [NSString stringWithFormat:NSLocalizedString(@"message_count_base", nil),
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_CUSTOMER_CATEGORY],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_PATROL_CATEGORY],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_PRODUCT],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_COMPETITION_PRODUCT],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_USER],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_USER_CONTACT],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_DEPARTMENT],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_GIF_PRODUCT],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_GIF_PRODUCT_CATEGORY],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_APPLY_CATEGORY],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_VIDEO_DURATION],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_VIDEOCATETORY],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_ATTENDANCE_CATEGORY],
            [LOCALMANAGER getValueFromUserDefaults:KEY_COUNT_INSPECTION]];;
}

@end
