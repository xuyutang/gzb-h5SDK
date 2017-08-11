//
//  LoginViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "NSString+Helpers.h"
#import "DashboardViewController.h"
#import "CustomerListViewController.h"
#import "MyViewController.h"
#import "RDVTabBar.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "CookieHelper.h"

@interface LoginViewController (){
    BOOL bSync;
    int iSyncCount;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    HUDHIDE2;
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    appDelegate = APPDELEGATE;
    
    [super viewDidLoad];

    [self.leftView setHidden:NO];
    leftImageView.hidden = YES;
    lblFunctionName.text = APPTITLE;
    lblFunctionName.textAlignment = NSTextAlignmentCenter;
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, 320, 90) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tableView];
    
    //400 电话
    UILabel *telTile = [[UILabel alloc] initWithFrame:CGRectMake(MAINWIDTH - 180, MAINHEIGHT - 30, 80, 25)];
    telTile.backgroundColor = WT_CLEARCOLOR;
    telTile.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
    telTile.textColor = WT_GRAY;
    telTile.text = NSLocalizedString(@"app_400_title", nil);
    [self.view addSubview:telTile];
    [telTile release];
    
    UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(210,MAINHEIGHT - 30, 100, 25)];
    tel.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
    tel.backgroundColor = WT_CLEARCOLOR;
    tel.userInteractionEnabled = YES;
    tel.textColor = WT_BLUE;
    NSString *telNumber = NSLocalizedString(@"app_400_number", nil);
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:telNumber];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName
                    value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                    range:contentRange];
    tel.attributedText = content;
    UITapGestureRecognizer *callTel = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(callTel)];
    callTel.numberOfTapsRequired = 1;
    [tel addGestureRecognizer:callTel];
    [self.view addSubview:tel];
    [callTel release];
    [tel release];
    
    UIButton *btLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [btLogin setFrame:CGRectMake(8, 130, 305, 40)];
    [btLogin setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateNormal];
    [btLogin setTitle:NSLocalizedString(@"login", @"") forState:UIControlStateNormal];
    [btLogin addTarget:self action:@selector(chechlogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btLogin];
    AGENT.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload)
                                                 name:SYNC_NOTIFICATION_MENU object:nil];
    
    bSync = FALSE;
    iSyncCount = 0;
}

-(void) callTel {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SERVICE_TEL]];
}

-(void)reload{
    lblFunctionName.text = APPTITLE;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self clearInput];
    if (!appDelegate.bFirstLogin){
        if (![AGENT isExistenceNetwork]) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"login_msg_posting", @"")
                              description:NSLocalizedString(@"error_network_unfind", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            return;
        }
        [self setLoginUser];
        //每次都会去CALL登录
        //[self chechlogin];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)chechlogin{
    [self dismissKeyBoard];
        if (![AGENT isExistenceNetwork]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"login_msg_posting", @"")
                          description:NSLocalizedString(@"error_network_unfind", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    if (accountCell.inputField.text.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"login_msg_posting", @"")
                                                     description:NSLocalizedString(@"login_hint_username", @"")
                                                            type:MessageBarMessageTypeInfo
                                                     forDuration:INFO_MSG_DURATION];
        return;
         
    }
    else if (passwordCell.inputField.text.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"login_msg_posting", @"")
                                                     description:NSLocalizedString(@"login_hint_pwd", @"")
                                                            type:MessageBarMessageTypeInfo
                                                     forDuration:INFO_MSG_DURATION];
        return;
         
    }
    else{
        if ([AGENT isExistenceNetwork]){
                if (appDelegate.currentUser != nil){
                    if ([appDelegate.currentUser.userName compare: accountCell.inputField.text]){
                        appDelegate.bFirstLogin = TRUE;
                    }else{
                        appDelegate.bFirstLogin = FALSE;
                    }
                }else{
                    appDelegate.bFirstLogin = TRUE;
                }
                [self login];
        }
        else{
            [self setLoginUser];
        }
        
    }
}

- (void) login{
    AGENT.delegate = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
   
    User_Builder* ub = [User builder];
    [ub setId:0];
    [ub setUserName:accountCell.inputField.text];
    [ub setPassword:passwordCell.inputField.text.sha256];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeLogin param:[ub build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45.0f;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    InputCell *cell = nil;
    
    if (indexPath.row == 0) {
        accountCell=(InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(accountCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InputCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[InputCell class]])
                    accountCell=(InputCell *)oneObject;
            }
        }
        accountCell.title.text = NSLocalizedString(@"login_label_username", nil);
        accountCell.inputField.delegate=self;
        accountCell.inputField.keyboardType = UIKeyboardTypeNumberPad;
        accountCell.inputField.placeholder = NSLocalizedString(@"login_hint_username", nil);
        cell = accountCell;
    }else if(indexPath.row == 1){
        passwordCell=(InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(passwordCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InputCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[InputCell class]])
                    passwordCell=(InputCell *)oneObject;
            }
        }
        passwordCell.title.text = NSLocalizedString(@"login_label_pwd", nil);
        passwordCell.inputField.delegate=self;
        passwordCell.inputField.placeholder = NSLocalizedString(@"login_hint_pwd", nil);
        passwordCell.inputField.secureTextEntry = YES;
        cell =passwordCell;
    }

    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    [helloButton release];
    
    [topView setItems:buttonsArray];
    //[cell.inputField setInputAccessoryView:topView];
    
    return cell;
}

-(IBAction)dismissKeyBoard{
    if (passwordCell.inputField != nil && accountCell.inputField != nil){
        [passwordCell.inputField resignFirstResponder];
        [accountCell.inputField resignFirstResponder];
    }
}

-(IBAction)clearInput {
    passwordCell.inputField.text = @"";
    accountCell.inputField.text = @"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toSync {
    // 登陆地方只同步基础数据
    [self _syncCompanyContact];
    if (DONE != [AGENT sendRequestWithType:ActionTypeSyncBaseData param:USER]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_data_sync", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        return;
    }

}

- (void) _syncCustomer:(User*) u{
    CustomerParams_Builder* cb = [CustomerParams  builder];
    [cb setPage:1];
    [cb setUser:u];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeSyncCustomerList param:[cb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_data_sync", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        return;
    }
}

- (void) _syncCompanyContact{
    if (DONE != [AGENT sendRequestWithType:ActionTypeCompanyContactList param:@""]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_data_sync", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    
    if ([cr.code isEqual:NS_ACTIONCODE(ActionCodeErrorAccountException)]  && !appDelegate.bFirstLogin) {
        HUDHIDE;
        
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeLogin:{
            if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]){
                [self connectSocket];
                
                User* user = [User parseFromData:cr.data];
                if ([super validateData:user]) {
                    
                    User_Builder* nb = [user toBuilder];
                    [nb setPassword:passwordCell.inputField.text];
                    
                    User* newUser = [nb build];
                    
                    [LOCALMANAGER saveLoginUser:newUser];
                    if ([LOCALMANAGER getLatestUserId] != nil) {
                        if ([[LOCALMANAGER getLatestUserId] intValue] != newUser.id) {
                            [LOCALMANAGER cleanLatestUserData];
                        }
                    }
                    
                    [LOCALMANAGER saveLatestUserId:[NSString stringWithFormat:@"%d",newUser.id]];
                    
                    appDelegate.currentUser = newUser;
                    
                    [self performSelectorOnMainThread:@selector(toMainPage) withObject:nil waitUntilDone:NO];
                    

                }
             }
            [super showMessage2:cr Title:NSLocalizedString(@"login_msg_posting", @"") Description:@""];
        }
            break;
            
        case ActionTypeCompanyContactList:{
            
            if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]) {
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
            }
            [super showMessage2:cr Title:NSLocalizedString(@"data_sync_base", @"") Description:@""];
        }
            break;
           
        case   ActionTypeSyncBaseData:{
            if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]) {
                 [(APPDELEGATE) syncData:cr.data];
                
               [self performSelectorOnMainThread:@selector(toMainPage) withObject:nil waitUntilDone:NO];
               
            }
            
            [super showMessage2:cr Title:NSLocalizedString(@"data_sync_base", @"") Description:@""];
        }
            break;
        default:
            break;
    }
}

//设置自动登录用户
-(void) setLoginUser {
    HUDHIDE;
    [USER release];
    USER = nil;
    USER = [LOCALMANAGER getLoginUser];
    User_Builder *user = [USER toBuilder];
    [user setPassword:USER.password.sha256];
    USER = [[user build] retain];
    if (USER != nil && ![LOCALMANAGER validateUserExpire:USER]) {
        [self connectSocket];
        [self performSelectorOnMainThread:@selector(toMainPage) withObject:nil waitUntilDone:NO];
    }else{
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"login_msg_posting", @"")
                          description:NSLocalizedString(@"error_account_expired", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        [USER release];
        USER = nil;
        return;
    }
}

-(void) connectSocket {
    //创建socket连接
    [AGENT loginWithUsername:accountCell.inputField.text password:passwordCell.inputField.text.sha256];
}

- (void) toMainPage {
    [appDelegate initPage];
    [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_DASHBOARD Object:nil Delegate:nil NeedBack:NO];
}

@end
