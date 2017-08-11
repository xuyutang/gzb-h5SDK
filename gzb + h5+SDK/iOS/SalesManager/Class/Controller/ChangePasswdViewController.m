//
//  ChangePasswdViewController.m
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-6.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "ChangePasswdViewController.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+Helpers.h"

@implementation ChangePasswdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad
{
    appDelegate = APPDELEGATE;
    
    [super viewDidLoad];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePwd)];
    [tapGesture2 setNumberOfTapsRequired:1];
    
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    self.view.backgroundColor = WT_WHITE;
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, MAINWIDTH, 200) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.rightButton = btRight;
    [btRight release];
    UILabel* lPwdHint = [[UILabel alloc] initWithFrame:CGRectMake(10, 160 , MAINWIDTH - 20, 60)];
    lPwdHint.text = @"  *密码规则：密码长度至少有8-16个字符，不能使用账号，新密码不能和老密码相同，包含大写字母，小写字母，数字或键盘上的符号.";
   // lPwdHint.textAlignment = NSTextAlignmentCenter;
    lPwdHint.lineBreakMode = UILineBreakModeWordWrap;
    lPwdHint.numberOfLines = 0;

    lPwdHint.textColor = WT_RED;
    lPwdHint.font = [UIFont systemFontOfSize:12.0f];
    lPwdHint.backgroundColor = WT_CLEARCOLOR;
    [self.view addSubview:lPwdHint];

    
    [lblFunctionName setText:NSLocalizedString(@"bar_change_pwd", @"")];
    AGENT.delegate = self;
}

-(void)changePwd{
    [self dismissKeyBoard];
    /*if (passwordCell.inputField.text.length <6 || passwordCell.inputField.text.length>16 ) {
     [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_change_pwd", @"")
     description:NSLocalizedString(@"user_hint_pwd_lenth", @"")
     type:MessageBarMessageTypeInfo
     forDuration:INFO_MSG_DURATION];
     
     }else if (([passwordCell.inputField.text isEqual: chkpasswordCell.inputField.text]) && (passwordCell.inputField.text.length != 0) && (chkpasswordCell.inputField.text.length != 0)){
     [self _changePwd];
     }else{
     [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_change_pwd", @"")
     description:NSLocalizedString(@"user_hint_pwd_match", @"")
     type:MessageBarMessageTypeInfo
     forDuration:INFO_MSG_DURATION];
     }*/
    oldPwd = oldPswCell.inputField.text;
     pwd = passwordCell.inputField.text;
    rpwd = chkpasswordCell.inputField.text;
    
    if (pwd == nil || rpwd == nil) {
        return;
    }
    
    
    if (![oldPwd isEqualToString:[LOCALMANAGER getLoginUser].password]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_change_pwd", @"")
                          description:@"输入旧的密码有误，请重新输入"
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if ([pwd isEqualToString:[LOCALMANAGER getLoginUser].password]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_change_pwd", @"")
                          description:NSLocalizedString(@"user_hint_pwd_match_old", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if ([pwd isEqualToString:[LOCALMANAGER getLoginUser].userName]){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_change_pwd", @"")
                          description:NSLocalizedString(@"user_hint_pwd_match_username", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (![pwd isEqualToString:rpwd]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_change_pwd", @"")
                          description:NSLocalizedString(@"user_hint_pwd_match", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(?!^\\d+$)(?!^[a-zA-Z]+$)[0-9a-zA-Z]{8,16}"];
    
    if (![regex evaluateWithObject:pwd]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_change_pwd", @"")
                          description:NSLocalizedString(@"user_hint_pwd_lenth", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    [self _changePwd];
}

- (void) _changePwd{
    AGENT.delegate = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    User_Builder* ub = [appDelegate.currentUser toBuilder];
    [ub setPassword:passwordCell.inputField.text];
    [ub setNewPwd:passwordCell.inputField.text];
    
    newUser = [ub build];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeChangePwd param:newUser]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_change_pwd", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        return;
        
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
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    InputCell *cell = nil;
    
    if (indexPath.row == 0) {
        oldPswCell=(InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(oldPswCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InputCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[InputCell class]])
                    oldPswCell=(InputCell *)oneObject;
            }
        }
        oldPswCell.title.text = @"旧的密码";
        oldPswCell.inputField.text = oldPwd;
        oldPswCell.inputField.delegate=self;
        oldPswCell.inputField.placeholder = @"请输入旧的密码";
        oldPswCell.inputField.secureTextEntry = YES;
        cell = oldPswCell;
    }
    if (indexPath.row == 1) {
        passwordCell=(InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(passwordCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InputCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[InputCell class]])
                    passwordCell=(InputCell *)oneObject;
            }
        }
        passwordCell.title.text = @"新的密码";
        passwordCell.inputField.delegate=self;
        passwordCell.inputField.text = pwd;
        passwordCell.inputField.placeholder = NSLocalizedString(@"user_hint_newpwd", nil);
        passwordCell.inputField.secureTextEntry = YES;
        cell = passwordCell;
    }else if(indexPath.row == 2){
        chkpasswordCell=(InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(chkpasswordCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InputCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[InputCell class]])
                    chkpasswordCell=(InputCell *)oneObject;
            }
        }
        chkpasswordCell.title.text = NSLocalizedString(@"user_lable_newpwd2", nil);
        chkpasswordCell.inputField.delegate=self;
         chkpasswordCell.inputField.text = rpwd;
        chkpasswordCell.inputField.placeholder = NSLocalizedString(@"user_hint_newpwd2", nil);
        chkpasswordCell.inputField.secureTextEntry = YES;
        cell = chkpasswordCell;
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
//禁止输入符号
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    return [string isEqualToString:filtered];
//}

-(IBAction)dismissKeyBoard{
    [passwordCell.inputField resignFirstResponder];
    [chkpasswordCell.inputField resignFirstResponder];
}

-(IBAction)clearInput{
    
    passwordCell.inputField.text = @"";
    chkpasswordCell.inputField.text = @"";
    
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeChangePwd:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [LOCALMANAGER saveLoginUser:newUser];
                User_Builder* ub = [newUser toBuilder];
                [ub setPassword:[LOCALMANAGER getLoginUser].password.sha256];
                User* u = [ub build];
                USER = [u retain];
                
                [self clearInput];
                
            }
            
            [super showMessage2:cr Title:NSLocalizedString(@"bar_change_pwd", @"") Description:NSLocalizedString(@"user_msg_pwd_updated", @"")];
        }
            break;
            
        default:
            break;
    }
}

@end
