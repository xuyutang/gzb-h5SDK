//
//  WorklogDetailViewController.m
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-7.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "WorklogDetailViewController.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "InputViewController.h"
#import "PatrolDetailReplyCell.h"
#import "SDImageView+SDWebCache.h"
#import "LableCell.h"
#import "WorklogViewController.h"

#define CELL_DEFAULT_HEIGHT 120.f

@interface WorklogDetailViewController ()<InputFinishDelegate>{
    NSMutableArray *replies;
    int currentPage;
    int pageSize;
    int totleSize;
}


@end

@implementation WorklogDetailViewController

@synthesize worklog,delegate,worklogId,msgType;

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
    worklogReply = nil;
    sWorklogReply = @"";
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh)];
    saveImageView.userInteractionEnabled = YES;
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [tapGesture2 release];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = rightButton;
    [saveImageView release];
    [rightButton release];
    [rightView release];
    
   _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT - 45) style:UITableViewStylePlain];
    _tableView.pullBackgroundColor = [UIColor yellowColor];
    _tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    _tableView.sectionHeaderHeight = 10.f;
    _tableView.sectionFooterHeight = 10.f;
    //_tableView.bounces = NO;
    //_tableView.allowsSelection = NO;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    //_tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    
    AGENT.delegate = self;
    if (worklog != nil) {
        [self _show];
    }else{
        [self _getWorklog];
    }
    [self createBottomBar];
    [lblFunctionName setText:TITLENAME(FUNC_WORKLOG_DES)];
    replies = [[NSMutableArray alloc] init];
}

-(void)refresh {
    
    [replies removeAllObjects];

    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    WorkLogParams_Builder* bs = [WorkLogParams builder];
    if (worklog != nil) {
        [bs setId:worklog.id];
    }else{
        [bs setId:worklogId];
    }

    if (DONE != [AGENT sendRequestWithType:ActionTypeWorklogGet param:[bs build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_WORKLOG_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }


}
- (void) _show{
    /*
    if ((worklog.user.id != (APPDELEGATE).currentUser.id) && (worklog.workLogReplies.count == 0)){
        rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 15, 50, 30)];
        [saveImageView setImage:[UIImage imageNamed:@"topbar_button_save"]];
        saveImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
        [tapGesture2 setNumberOfTapsRequired:1];
        saveImageView.contentMode = UIViewContentModeScaleAspectFit;
        [saveImageView addGestureRecognizer:tapGesture2];
        [rightView addSubview:saveImageView];
        [saveImageView release];
        
        UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.rightButton = btRight;
        [btRight release];
    }*/
        
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    [_tableView reloadData];
}

- (void) _getWorklog{
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = YES;
    
    WorkLogParams_Builder* bs = [WorkLogParams builder];
    if (worklog != nil) {
        [bs setId:worklog.id];
    }else{
        [bs setId:worklogId];
    }
    if (DONE != [AGENT sendRequestWithType:ActionTypeWorklogGet param:[bs build]]){
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void) _getWorklogReply{
    WorkLogParams_Builder* pb = [WorkLogParams builder];
    if (worklog != nil) {
        [pb setId:worklog.id];
    }else{
        [pb setId:worklogId];
    }
    [pb setPage:currentPage];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeWorklogReplyList param:[pb build]]){
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }

}
-(void)clickLeftButton:(id)sender{
    if (delegate != nil && [delegate respondsToSelector:@selector(refresh:)]) {
        [delegate refresh:worklog];
    }

    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


-(void)createBottomBar{
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, MAINHEIGHT-45, MAINWIDTH, 45)];
    [bottom setBackgroundColor:[UIColor whiteColor]];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, .5f)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    [bottom addSubview:line1];
    [line1 release];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    // [button1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button1 setTitle:NSLocalizedString(@"title_reply", nil) forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setFrame:CGRectMake(0, 0, MAINWIDTH/2, 45)];
    [button1 addTarget:self action:@selector(toReply) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button1];
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(MAINWIDTH/2, 0, 1, 45)];
    [line2 setBackgroundColor:[UIColor lightGrayColor]];

    [bottom addSubview:line2];
    [line2 release];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    // [button1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button2 setTitle:NSLocalizedString(@"title_upload", nil) forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setFrame:CGRectMake(MAINWIDTH/2, 0, MAINWIDTH/2, 45)];
    [button2 addTarget:self action:@selector(toUpload) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button2];
    [self.view addSubview:bottom];
    [bottom release];

}

-(void)toUpload{
    WorklogViewController *workVC = [[WorklogViewController alloc]init];
    workVC.showListImageBool = NO;
    [self.navigationController pushViewController:workVC animated:YES];
}

-(void)didFinishInput:(int)tag Input:(NSString *)input{
    (APPDELEGATE).agent.delegate = self;
    [self dismissKeyBoard:nil];
    if (input.trim.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"worklog_hint_reply", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (input.trim.length > 1000){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"input_limit_1000", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if([NSString stringContainsEmoji:input.trim]){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    WorkLogReply_Builder* br = [WorkLogReply builder];
    
    [br setContent:input.trim];
    [br setCreateDate:[NSDate getCurrentTime]];
    [br setSender:USER];
    [br setWorkLogId:worklog.id];
    [br setId:-1];
    WorkLogReply* wr = [br build];
    worklogReply = [wr retain];
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeWorklogReply param:[wr retain]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
    
}


-(void)toReply{
    
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    ctrl.delegate = self;
    ctrl.bNeedBack = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}


-(void)toSave:(id)sender{
    (APPDELEGATE).agent.delegate = self;
    [self dismissKeyBoard:nil];
    if (tvReplyCell.textView.text.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"worklog_hint_reply", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if([NSString stringContainsEmoji:tvReplyCell.textView.text]){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
        
    WorkLogReply_Builder* wb = [WorkLogReply builder];
    
    [wb setContent:sWorklogReply];
    [wb setSender:USER];
    [wb setCreateDate:[NSDate getCurrentTime]];
    [wb setWorkLogId:worklog.id];
    [wb setId:-1];
    WorkLogReply* wr = [wb build];
    worklogReply = [wr retain];
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeWorklogReply param:[wb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
    }
    
    tvReplyCell.textView.editable = NO;
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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (worklog.user.id == (APPDELEGATE).currentUser.id){
        if (replies.count > 0)
            return 4;
        else
            return 3;
    }
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && worklog.today.length > 0) {
        CGSize size = [super rebuildSizeWithString:worklog.today ContentWidth:MAINWIDTH - 20 FontSize:FONT_SIZE + 1];
        return  size.height < CELL_DEFAULT_HEIGHT ? CELL_DEFAULT_HEIGHT : size.height + 10;
    }
    if (indexPath.section == 1 && worklog.plan.length > 0) {
        CGSize size = [super rebuildSizeWithString:worklog.plan ContentWidth:MAINWIDTH - 20 FontSize:FONT_SIZE + 1];
        return  size.height < CELL_DEFAULT_HEIGHT ? CELL_DEFAULT_HEIGHT : size.height + 10;
    }
    if (indexPath.section == 2 && worklog.special.length > 0) {
        CGSize size = [super rebuildSizeWithString:worklog.special ContentWidth:MAINWIDTH - 20 FontSize:FONT_SIZE + 1];
        return  size.height < CELL_DEFAULT_HEIGHT ? CELL_DEFAULT_HEIGHT : size.height + 10;
    }
    if (indexPath.section == 3) {
        NSString* text = ((WorkLogReply *)[replies objectAtIndex:indexPath.row]).content;
        CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
        CGFloat height = MAX(size.height + 45.0f, 75.0f);
        NSLog(@"height:%f",height);
        return height;
    }
    return CELL_DEFAULT_HEIGHT;
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
        case 3:{
            return NSLocalizedString(@"worklog_label_reply", nil);
        }
            break;
            
        default:
            break;
    }
    return @"";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
       return replies.count;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[[UIView alloc] init] autorelease];
    myView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor orangeColor];
   
    titleLabel.text=@"dasdsad";
    switch (section) {
        case 0:{
            titleLabel.text = NSLocalizedString(@"worklog_label_content", nil);
        }
            break;
        case 1:{
             titleLabel.text =   NSLocalizedString(@"worklog_label_plan", nil);
        }
            break;
        case 2:{
           titleLabel.text = NSLocalizedString(@"worklog_label_question", nil);
        }
            break;
        case 3:{
          titleLabel.text = @"日志回复";
        }
            break;
            
        default:
            break;
    }

    [myView addSubview:titleLabel];
    [titleLabel release];
    return myView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cell1";
   if (indexPath.section == 0) {
        LableCell *txtCell = (LableCell*)[tableView dequeueReusableCellWithIdentifier:cellid];
        if(txtCell==nil){
            txtCell = [self getCellWithCellid:cellid];
        }
        CGSize size = [super rebuildSizeWithString:worklog.today ContentWidth:MAINWIDTH - 20 FontSize:FONT_SIZE + 1];
        [txtCell setText:worklog.today size:size];
       txtCell.frame = CGRectMake(0, 0, _tableView.frame.size.width, size.height + 5);
        return txtCell;
    }else if(indexPath.section == 1){
        LableCell *txtCell = (LableCell*)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if(txtCell==nil){
            txtCell = [self getCellWithCellid:@"cell2"];
        }
        CGSize size = [super rebuildSizeWithString:worklog.plan ContentWidth:MAINWIDTH - 20 FontSize:FONT_SIZE + 1];
        [txtCell setText:worklog.plan size:size];
        
        txtCell.frame = CGRectMake(0, 0, _tableView.frame.size.width, size.height + 5);
        return txtCell;
    }else if(indexPath.section == 2){
        LableCell *txtCell = (LableCell*)[tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if(txtCell==nil){
            txtCell = [self getCellWithCellid:@"cell3"];
        }
        CGSize size = [super rebuildSizeWithString:worklog.special ContentWidth:MAINWIDTH - 20 FontSize:FONT_SIZE + 1];
        [txtCell setText:worklog.special size:size];
        txtCell.frame = CGRectMake(0, 0, _tableView.frame.size.width, size.height + 5);
        return txtCell;
    }else if(indexPath.section == 3){
        PatrolDetailReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolDetailReplyCell"];
        if (cell == nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolDetailReplyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        WorkLogReply *reply = [replies objectAtIndex:indexPath.row];
        if (reply.content != nil && reply.content.length >0) {
            NSString* avtar = @"";
            if (reply.sender.avatars.count > 0) {
                avtar = [reply.sender.avatars objectAtIndex:0];
            }
            [cell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
            cell.icon.layer.cornerRadius = 30.f;
            cell.icon.layer.masksToBounds = YES;
            cell.name.text = reply.sender.realName;
            cell.time.text = reply.createDate;
            
            NSString* text = reply.content;
            CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
            
            CGFloat height = MAX(size.height, 42.0f);
            
            CGRect rect = cell.content.frame;
            UILabel* lContent = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 3,rect.size.width,height)];
            lContent.backgroundColor = WT_CLEARCOLOR;
            lContent.numberOfLines = 0;
            lContent.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
            lContent.textColor = WT_GRAY;
            lContent.text = reply.content;
            [cell.contentView addSubview:lContent];
            [lContent release];
            lContent = nil;
            
            cell.content.hidden = YES;
            cell.content.text = reply.content;
        }
        return cell;

    }
    
    return nil;
    
}


-(LableCell *) getCellWithCellid:(NSString *) cellid{
    LableCell *txtCell = [[LableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    CGRect r = txtCell.lable.frame;
    r.origin.x += 13;
    txtCell.lable.frame = r;
    return txtCell;
}

-(void) textViewDidChange:(UITextView *)textView{
    sWorklogReply = [textView.text retain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clearTable{
    if (replies.count > 0){
        [replies removeAllObjects];
    }
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE;
    if ([super validateResponse:cr]) {
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeWorklogReply:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                if (worklogReply != nil){
                    [replies insertObject:worklogReply atIndex:0];
                }
                WorkLog_Builder* wb = [worklog toBuilder];
                [wb setReplyCount:replies.count];
                [worklog release];
                worklog = nil;
                worklog = [[wb build] retain];
                [self.navigationController popViewControllerAnimated:YES];
                [_tableView reloadData];
            }

            [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"worklogreply_msg_saved", @"")];
        }
            break;
        
        case ActionTypeWorklogGet:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                WorkLog* w = [WorkLog parseFromData:cr.data];
                if ([super validateData:w]) {
                    worklog = [w retain];
                    self.lblFunctionName.text = TITLENAME_STR(FUNC_WORKLOG_DES, worklog.user.realName);
                    [self _getWorklogReply];
                }
            }
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",worklogId]];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
        }
            break;
        
        case ActionTypeWorklogReplyList:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                Pagination* pageReply = [Pagination parseFromData:cr.data];
            
                pageSize = pageReply.pageSize;
                totleSize = pageReply.totalSize;
                if (currentPage == 1) {
                    [self clearTable];
                }
                for (int i = 0; i < pageReply.datas.count; ++i) {
                    WorkLogReply* wr = [WorkLogReply parseFromData:[pageReply.datas objectAtIndex:i]];
                    if (![super validateData:wr]) {
                        continue;
                    }else{
                        [replies addObject:wr];
                    }
                }
                [_tableView reloadData];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];

        }
            break;

        default:
            break;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeWorklogReplyList) || (INT_ACTIONCODE(cr.code) != ActionCodeDone)){
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
    }
}
- (void) didFailWithError:(NSError *)error{
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullTableIsLoadingMore = NO;
    
    [super didFailWithError:error];
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullTableIsLoadingMore = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    [self _getWorklog];
}

- (void) loadMoreDataToTable
{
    _tableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        
        [self _getWorklogReply];
    }else{
        _tableView.pullTableIsLoadingMore = NO;
    }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}

@end
