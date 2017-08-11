//
//  MessageViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "AnnounceViewController.h"
#import "AnnounceDetailViewController.h"
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
#import "UIColor+hex.h"

@interface AnnounceViewController ()<SWTableViewCellDelegate>

@end

@implementation AnnounceViewController
@synthesize parentCtrl;

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
//    [lblFunctionName setText:NSLocalizedString(@"menu_function_announce", @"")];
    [lblFunctionName setText:TITLENAME(FUNC_MESSAGE_DES)];
    lblFunctionName.textAlignment = NSTextAlignmentLeft;
    currentPage = 1;
    totleSize = 0;
    
    currentAnnounce = nil;
    currentRow = 0;
    currentPage = 1;
    announceArray = [[NSMutableArray alloc] init];
    sendMuarray = [[NSMutableArray alloc] init];
    /*
    if (USER != nil) {
        AnnounceParams_Builder* pb = [AnnounceParams builder];
        AnnounceParams_Builder* pb = [AnnounceParams builder];
        [pb setUser:USER];
        [pb setPage:1];
        [pb set:[pb build]];
        [pb setVersion:pb.version];
        
        announceParams = [[pb build] retain];
    }*/
    
}

-(void)syncTitle {
   [lblFunctionName setText:TITLENAME(FUNC_MESSAGE_DES)];
}

- (void)reload
{
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (announceArray.count > 0) {
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
    if (announceArray.count > 0){
        [announceArray removeAllObjects];
    }
    
    if (announceSendMuArray.count > 0) {
        [announceSendMuArray removeAllObjects];
    }
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    //本地读取
    currentPage = 1;
    [self clearTable];
   // sendMuarray 是我发送的消息 去掉发给自己的重复
//    sendMuarray  = [LOCALMANAGER getMyAnnounce];
//  
//    [sendMuarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([((Announce*)obj).creator.realName isEqualToString:USER.realName]) {
//            [sendMuarray removeObject:obj];
//        }
//    }];
    
    announceSendMuArray = [[LOCALMANAGER getAnnouncesenders] retain];
    announceArray = [[LOCALMANAGER getAnnounces:currentPage] retain];
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = YES;
    [self.pullTableView reloadData];
    self.pullTableView.pullTableIsRefreshing = NO;
    /*if (announceParams != nil){
        AnnounceParams_Builder* pb = [announceParams toBuilder];
        AnnounceParams_Builder* pb = [pb toBuilder];

        [pb setPage:1];
        [pb set:[pb build]];
        announceParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:RequestTypeAnnounceList param:announceParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_announce_list", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
        }

    }*/
}

- (void) loadMoreDataToTable
{
    self.pullTableView.pullTableIsLoadingMore = YES;
    if(currentPage*PAGESIZE < totleSize){
        currentPage++;
        [announceArray addObjectsFromArray:[[LOCALMANAGER getAnnounces:currentPage] retain]] ;
    }else{
        self.pullTableView.pullTableIsLoadingMore = NO;
    }
    [self.pullTableView reloadData];
    self.pullTableView.pullTableIsLoadingMore = NO;
    /*
    self.pullTableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        AnnounceParams_Builder* pb = [announceParams toBuilder];
        AnnounceParams_Builder* pb = [pb toBuilder];
        
        [pb setPage:currentPage];
        [pb set:[pb build]];
        announceParams = [[pb build] retain];

        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:RequestTypeAnnounceList param:announceParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_announce_list", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
        }

    }else{
        self.pullTableView.pullTableIsLoadingMore = NO;
    }*/
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
    if (announceArray.count == 0) {
        [tableView setTableFooterView:[self setFootView]];
        return 0;
    }else {
        tableView.tableFooterView = [[UIView alloc]init];
        
    }
    //return messageArray.count;
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*NSString *text = ((Announce *)[announceArray objectAtIndex:indexPath.section]).subject;

    CGSize size = [super rebuildSizeWithString:text ContentWidth:(CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN*2 - 30.0f) FontSize:FONT_SIZE];
    
    CGFloat height = MAX(size.height + 40.0f, 62.0f);

    return height;*/
    return 85.0f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 1;
    //[(NSMutableArray* )[(NSDictionary* )[announceArray objectAtIndex:section] objectForKey:@"announce"] count];
    return announceArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    DBMessageCell *msgCell = (DBMessageCell *)[tableView dequeueReusableCellWithIdentifier:@"DBMessageCell"];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons addUtilityButtonWithColor:WT_RED icon:[UIImage imageNamed:@"ic_delete_grey"]];
    msgCell = [[DBMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DBMessageCell" containingTableView:tableView rowHeight:85 leftUtilityButtons:nil rightUtilityButtons:nil];
    
    NSString* avtar = @"";
    User* u = nil;
    NSString* title = @"";
    NSString* subTitle = @"";
    NSString* createDate = @"";
    Announce *a = [announceArray objectAtIndex:indexPath.row];
  //  User *sender = [announceSendMuArray objectAtIndex:announceSendMuArray.count - 1 - indexPath.row];
    
    title = a.creator.realName;
    subTitle = a.subject;
    createDate = a.createDate;
    
    if (a.creator.avatars.count > 0){
        avtar = [a.creator.avatars objectAtIndex:0];
    }
    
    [msgCell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
    if ([a.readStatus isEqual:UNREADED]) {
        msgCell.count.hidden = NO;
    }else{
        msgCell.count.hidden = YES;
        [msgCell.count setBackgroundColor:WT_RED];
    }
    
    [msgCell.count setTextColor:[UIColor whiteColor]];
    msgCell.count.layer.cornerRadius = 10;
    msgCell.count.layer.masksToBounds = YES;
    msgCell.title.text = title;
    msgCell.subTitle.text = subTitle;
    
    msgCell.flag.frame = CGRectMake(94,58,21,21);
    msgCell.flag.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
    msgCell.flag.textAlignment = UITextAlignmentLeft;
    msgCell.flag.textColor = [UIColor colorWithHexString:@"#783207"];
    msgCell.flag.text = [NSString fontAwesomeIconStringForEnum:FABullhorn];
  
    msgCell.time.text = createDate;
    msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    msgCell.delegate = self;
    
    [LOCALMANAGER setReadedAnnounceStatus:announceArray[indexPath.row]];
    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
    return msgCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.pullTableView.pullTableIsRefreshing == YES) || (self.pullTableView.pullTableIsLoadingMore ==YES)) {
        return;
    }
    if ([announceArray count] > 0) {
        [VIEWCONTROLLER create:self.parentCtrl.navigationController ViewId:FUNC_ANNOUNCE Object:[announceArray objectAtIndex:indexPath.row] Delegate:nil NeedBack:YES];
        
        [self setReadedAnnounce:[announceArray objectAtIndex:indexPath.row] Index:indexPath.row];
    }
}

- (void) setReadedAnnounce:(Announce*) m Index:(int) i{
    Announce_Builder* sb = [m toBuilder];
    [sb setReadStatus:READED];
    Announce* nm = [sb build];
    [announceArray removeObjectAtIndex:i];
    [announceArray insertObject:nm atIndex:i];
    
    [self.pullTableView reloadData];
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

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if (INT_ACTIONTYPE(cr.type) == ActionTypeMessageList){
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NOTIFICATION object:nil];
        return;
    }
    
    if ((INT_ACTIONTYPE(cr.type)  == ActionTypeAnnounceList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        NSLog(@"get announce finished");
        PageAnnounce* pageAnnounce = [PageAnnounce parseFromData:cr.data];
        int announceCount = pageAnnounce.announces.count;
        if (currentPage == 1)
            [self clearTable];
        
        for (int i = 0 ;i < announceCount;i++){
            Announce* announce = (Announce*)[[pageAnnounce announces] objectAtIndex:i];
            [announceArray addObject:announce];
            
        }
        pageSize = pageAnnounce.page.pageSize;
        totleSize = pageAnnounce.page.totalSize;
        
        if (announceArray.count == 0) {
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_MESSAGE_DES)                              description:NSLocalizedString(@"noresult", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
        }
    }
    
    [super showMessage2:cr Title:TITLENAME(FUNC_MESSAGE_DES) Description:@""];
    
    if (INT_ACTIONTYPE(cr.type)  == ActionTypeAnnounceList){
        [self.pullTableView reloadData];
        
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
    }
    HUDHIDE2;
}

-(void)viewWillAppear:(BOOL)animated{
   // CGRect frame = self.pullTableView.frame;
   // [self.pullTableView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MAINHEIGHT-20)];
}

- (void) didFailWithError:(NSError *)error{
    self.pullTableView.pullTableIsRefreshing = NO;
    self.pullTableView.pullTableIsLoadingMore = NO;
    
    [super didFailWithError:error];
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    self.pullTableView.pullTableIsRefreshing = NO;
    self.pullTableView.pullTableIsLoadingMore = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}

@end
