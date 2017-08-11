//
//  MessageViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "MessageViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "MessageCell.h"
#import "DBMessageCell.h"
#import "SDImageView+SDWebCache.h"
#import "SWTableViewCell.h"
#import "PushOrderMsg.h"
#import "UIColor+hex.h"

@interface MessageViewController ()<RefreshDelegate,SWTableViewCellDelegate>{
    NSMutableArray* users;
}

@end

@implementation MessageViewController
@synthesize parentCtrl,userId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT - 44) style:UITableViewStylePlain];
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    [self.view addSubview:self.pullTableView];
    
    [lblFunctionName setText:NSLocalizedString(@"menu_function_permessage", @"")];
    
    currentMessage = nil;
    currentRow = 0;
    currentPage = 1;
    totleSize = [LOCALMANAGER getMessagesCount:userId];
    users = [[LOCALMANAGER getUsersByMessage] retain];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //CGRect frame = self.pullTableView.frame;
   // [self.pullTableView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MAINHEIGHT-20)];
}

- (void)reload
{
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (messageArray.count > 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.pullTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
}

- (void)viewDidUnload
{
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [pullTableView release];
    [super dealloc];
}

-(void)clearTable{
    if (messageArray.count > 0){
        [messageArray removeAllObjects];
    }
}
#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    //本地读取
    currentPage = 1;
    [self clearTable];
    
    messageArray = [[LOCALMANAGER getMessages:currentPage UserId:userId] retain];
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = YES;
    [self.pullTableView reloadData];
    self.pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    self.pullTableView.pullTableIsLoadingMore = YES;
    if(currentPage*PAGESIZE < totleSize){
        currentPage++;
        [messageArray addObjectsFromArray:[[LOCALMANAGER getMessages:currentPage UserId:userId] retain]] ;
    }else{
        self.pullTableView.pullTableIsLoadingMore = NO;
    }
    [self.pullTableView reloadData];
    self.pullTableView.pullTableIsLoadingMore = NO;
}

-(UIView*)setFootView {
    UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT - 150)];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 50)];
    textLabel.text =@"暂无消息通知";
    textLabel.font = [UIFont systemFontOfSize:15.0f];
    textLabel.textAlignment = 1;
    textLabel.textColor = [UIColor grayColor];
    [contentView addSubview:textLabel];
    return contentView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (users.count == 0) {
        [tableView setTableFooterView:[self setFootView]];
        return 0;
    }else {
        tableView.tableFooterView = [[UIView alloc]init];
    }
    //return messageArray.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 85.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    DBMessageCell *msgCell = (DBMessageCell *)[tableView dequeueReusableCellWithIdentifier:@"DBMessageCell"];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons addUtilityButtonWithColor:WT_RED icon:[UIImage imageNamed:@"ic_delete_grey"]];
    msgCell = [[DBMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DBMessageCell" containingTableView:tableView rowHeight:85 leftUtilityButtons:nil rightUtilityButtons:nil];
    
    NSString* avtar = @"";
    NSString* title = @"";
    NSString* subTitle = @"";
    NSString* createDate = @"";
    SysMessage* m = [messageArray objectAtIndex:indexPath.row];
    
    User* u = [LOCALMANAGER getUserByMessage:m.id];
    
    if (u != nil) {
        if (u.avatars.count > 0){
            avtar = [u.avatars objectAtIndex:0];
        }
        title = u.realName;
        subTitle = [APPDELEGATE getContentWithMessage:m];
        createDate = m.createDate;
        msgCell.icon.userInteractionEnabled = YES;
        msgCell.icon.tag = u.id;
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toUser:)];
        [msgCell.icon addGestureRecognizer:singleTap1];
        [singleTap1 release];
    }
    [msgCell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
    if ([m.readStatus isEqual:UNREADED]) {
        msgCell.count.hidden = YES;
        [msgCell.count setBackgroundColor:WT_RED];
    }else{
        msgCell.count.hidden = YES;
    }
    msgCell.count.frame = CGRectMake(msgCell.icon.frame.size.width, msgCell.icon.frame.origin.y - 2, 12, 12);
    [msgCell.count setTextColor:[UIColor whiteColor]];
    msgCell.count.layer.cornerRadius = 6.0f;
    msgCell.count.layer.masksToBounds = YES;
    msgCell.title.text = title;
    msgCell.subTitle.text = subTitle;
    msgCell.flag.frame = CGRectMake(94,58,21,21);
    msgCell.flag.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
    msgCell.flag.textAlignment = UITextAlignmentLeft;
    msgCell.flag.textColor = [UIColor colorWithHexString:@"#783207"];
    //    saveImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_SAVE];
    msgCell.flag.text = [NSString fontAwesomeIconStringForEnum:FAEnvelopeO];

    msgCell.time.text = createDate;
    msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    msgCell.delegate = self;
    [LOCALMANAGER readMessage:u.id];
      [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
    return msgCell;

}
- (void)toUser:(id)sender{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    int userid = tapGesture.view.tag;
    User *u = nil;
    for (User *item in users) {
        if (userid == item.id) {
            u = item;
            break;
        }
    }
   
    if (u != nil) {
        [VIEWCONTROLLER create:self.parentCtrl.navigationController ViewId:FUNC_OTHER_USER_DETAIL Object:u Delegate:nil NeedBack:YES];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.pullTableView.pullTableIsRefreshing == YES) || (self.pullTableView.pullTableIsLoadingMore ==YES)) {
        return;
    }
    SysMessage *message = [messageArray objectAtIndex:indexPath.row];
    [VIEWCONTROLLER showMessageWithId:self.parentCtrl.navigationController MessageType:message.type objectId:message Delegate:self];
   
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

-(void)messageToAnnounce:(NSDictionary *)dict{

    SRWebSocket *webSocket = [dict objectForKey:@"websocket"];
    NSData *message = [dict objectForKey:@"announce"];
    [self webSocket:webSocket didReceiveMessage:message];

}

-(void)refresh:(id)obj{
    int type = MESSAGE_UNKNOW;
    if ([obj isKindOfClass:[WorkLog class]]) {
        type = MESSAGE_DAILY_REPORT;
    }
    if (type == MESSAGE_UNKNOW) {
        return;
    }
    for (int i = 0; i < messageArray.count; i++) {
        SysMessage* m = (SysMessage*)[messageArray objectAtIndex:i];
        if ([m.sourceId isEqualToString:[NSString stringWithFormat:@"%d",((WorkLog*)obj).id]]){
            SysMessage_Builder* sb = [m toBuilder];
            [sb setReadStatus:READED];
            SysMessage* nm = [sb build];
            [messageArray removeObjectAtIndex:i];
            [messageArray insertObject:nm atIndex:i];

            [self.pullTableView reloadData];
            
            break;
        }
    }
}

- (void) setReadedMessage:(SysMessage*) m Index:(int) i{
    SysMessage_Builder* sb = [m toBuilder];
    [sb setReadStatus:READED];
    SysMessage* nm = [sb build];
    [messageArray removeObjectAtIndex:i];
    [messageArray insertObject:nm atIndex:i];
    
    [self.pullTableView reloadData];
}

@end
