//
//  WorklogViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/5/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "WorklogViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "WorklogListViewController.h"
#import "UIView+CNKit.h"

@interface WorklogViewController ()

@end

@implementation WorklogViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _showListImageBool = YES;
        // Custom initialization
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (bHasKeyboard) {
        return;
    }
    bHasKeyboard = YES;
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = tableView.frame;
    frame.size.height -= keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    tableView.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{

    bHasKeyboard = NO;
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = tableView.frame;
    frame.size.height += keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    tableView.frame = frame;
    [UIView commitAnimations];
}


-(void)syncTitle {
 [lblFunctionName setText:TITLENAME_REPORT(FUNC_WORKLOG_DES)];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = APPDELEGATE;
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_search"]];
//    [listImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_LIST]];
//    [listImageView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
//    [listImageView setTextColor:WT_RED];
//    [listImageView setTextAlignment:UITextAlignmentCenter];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.contentMode = UIViewContentModeScaleAspectFit;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    [tapGesture1 release];
    
       UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];

    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    if (!_showListImageBool) {
        listImageView.hidden = YES;
        saveImageView.x = 100;
    }

    [rightView addSubview:saveImageView];
    [saveImageView release];
    [tapGesture2 release]; 
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
	
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.separatorColor = [UIColor whiteColor];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_WORKLOG_DES)];

}
-(void)clickLeftButton:(id)sender {
    if (_showListImageBool) {
         [super clickLeftButton:sender];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    
    }

}
-(void)toList:(id)sender{
    [self dismissKeyBoard:nil];
    WorklogListViewController *ctrl = [[WorklogListViewController alloc] init];
    //UINavigationController *worklogNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)toSave:(id)sender{
    AGENT.delegate = self;
    [self dismissKeyBoard:nil];
    if (tvTodayCell.textView.text.length == 0){
        
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_WORKLOG_DES)
                          description:NSLocalizedString(@"worklog_hint_content", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
        
    }
    if (tvTomorrowCell.textView.text.length == 0){
        
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_WORKLOG_DES)
                          description:NSLocalizedString(@"worklog_hint_plan", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if([NSString stringContainsEmoji:tvTodayCell.textView.text] ||
       [NSString stringContainsEmoji:tvTomorrowCell.textView.text] ||
       [NSString stringContainsEmoji:tvQuestionCell.textView.text]){
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_WORKLOG_DES)
                              description:NSLocalizedString(@"post_hint_text_error", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
        
    WorkLog_Builder* wb = [WorkLog builder];
    [wb setToday:tvTodayCell.textView.text];
    [wb setPlan:tvTomorrowCell.textView.text];
    [wb setSpecial:tvQuestionCell.textView.text];
    [wb setId:-1];
    [wb setUser:USER];

    if (DONE != [AGENT sendRequestWithType:ActionTypeWorklogSave param:[wb build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_WORKLOG_DES)
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];

    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return NSLocalizedString(@"worklog_label_content", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"worklog_label_plan", nil);
        }
            break;
        case 2:{
            return NSLocalizedString(@"worklog_label_question", nil);
        }
            break;
        default:
            break;
    }
    return @"";
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, MAINWIDTH - 40, 0.5)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 20 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    return contView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput:)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard:)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    [helloButton release];

    if (indexPath.section == 0) {
        static NSString *tdCellIdentifier = @"tdCellIdentifier";
        //tvTodayCell =(TextViewCell *)[tableView dequeueReusableCellWithIdentifier:tdCellIdentifier];
        if(tvTodayCell==nil){
            tvTodayCell= [[TextViewCell alloc] init];
        }
        tvTodayCell.textView.delegate=self;
        
        [topView setItems:buttonsArray];
        //[tvTodayCell.textView setInputAccessoryView:topView];
        tvTodayCell.selectionStyle=UITableViewCellSelectionStyleNone;
        [topView release];
        return tvTodayCell;
    }else if(indexPath.section == 1){
        static NSString *tmCellIdentifier = @"tmCellIdentifier";
        //tvTomorrowCell =(TextViewCell *)[tableView dequeueReusableCellWithIdentifier:tmCellIdentifier];
        if(tvTomorrowCell==nil){
            tvTomorrowCell= [[TextViewCell alloc] init];
        }
        tvTomorrowCell.textView.delegate=self;
        
        [topView setItems:buttonsArray];
        //[tvTomorrowCell.textView setInputAccessoryView:topView];
        tvTomorrowCell.selectionStyle=UITableViewCellSelectionStyleNone;
        [topView release];
        return tvTomorrowCell;
    
    }else if(indexPath.section == 2){
        static NSString *qCellIdentifier = @"qCellIdentifier";
        //tvQuestionCell =(TextViewCell *)[tableView dequeueReusableCellWithIdentifier:qCellIdentifier];
        if(tvQuestionCell==nil){
            tvQuestionCell= [[TextViewCell alloc] init];
        }
        tvQuestionCell.textView.delegate=self;
        
        [topView setItems:buttonsArray];
        //[tvQuestionCell.textView setInputAccessoryView:topView];
        tvQuestionCell.selectionStyle=UITableViewCellSelectionStyleNone;
        [topView release];
        return tvQuestionCell;
    }
    
    return nil;

}

-(void)textViewDidBeginEditing:(UITextView *)textView{

}

-(void)textViewDidEndEditing:(UITextView *)textView{

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)_textView{
    textView =_textView;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    return YES;
}

-(IBAction)dismissKeyBoard:(UIBarButtonItem *)sender
{
    if (textView != nil) {
        [textView resignFirstResponder];
    }
}

-(IBAction)clearInput:(id)sender{
    
    textView.text = @"";
    
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
        case ActionTypeWorklogSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [tvTodayCell.textView setText:@""];
                [tvTomorrowCell.textView setText:@""];
                [tvQuestionCell.textView setText:@""];
                
            }
            if (!_showListImageBool) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [super showMessage2:cr Title:TITLENAME(FUNC_WORKLOG_DES)
                    Description:NSLocalizedString(@"worklog_msg_saved", @"")];
        }
            break;
            
        default:
            break;
    }
}

@end
