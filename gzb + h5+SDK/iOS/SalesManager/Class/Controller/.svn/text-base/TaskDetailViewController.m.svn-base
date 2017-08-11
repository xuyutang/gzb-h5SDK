//
//  TaskDetailViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-3-6.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "SelectCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"
#import "AppDelegate.h"
#import "CustomerSelectViewController.h"
#import "LXActivity.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+Helpers.h"
#import "NSDate+Util.h"
#import "IMGCommentDetailView.h"
#import "TaskCommentViewController.h"
#import "PatrolDetailReplyCell.h"
#import "SDImageView+SDWebCache.h"

@interface TaskDetailViewController ()<TaskCommentViewControllerDelegate,PullTableViewDelegate>{
    
    NSMutableArray *replies;
    int currentPage;
    int pageSize;
    int totleSize;
    
    TaskPatrolReply* taskPatrolReply;
}


@end

@implementation TaskDetailViewController
@synthesize taskId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData{
    
    if ([imageFiles count]>0) {
        [LOCALMANAGER clearImagesWithFiles:imageFiles];
        [imageFiles removeAllObjects];
    }
    imageFiles = [[NSMutableArray alloc] init];
        
    textViewCell.textView.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = WT_WHITE;
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    [self initData];
    
    /*
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 15, 50, 30)];
    [saveImageView setImage:[UIImage imageNamed:@"bt_write"]];
    saveImageView.userInteractionEnabled = YES;
    //UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toComment:forEvent:)];
    //[tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
   // [saveImageView addGestureRecognizer:tapGesture2];*/
   // [btWrite release];
    //[saveImageView release];
    tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT - 45) style:UITableViewStylePlain];
    tableView.pullBackgroundColor = [UIColor yellowColor];
    tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.pullDelegate = self;
    //tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    UIImageView *reFreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [reFreshImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    reFreshImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh)];
    [tapGesture setNumberOfTapsRequired:1];
    reFreshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [reFreshImageView addGestureRecognizer:tapGesture];
    [rightView addSubview:reFreshImageView];
    [reFreshImageView release];
    [tapGesture release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.rightButton = btRight;
    [btRight release];
    
    //KWPopoverView
    popCommentView = [[IMGCommentView alloc] initWithFrame:CGRectMake(0, 64, 320, 280)];
    popCommentView.parentCtrl = self;
    popCommentView.target = self;
    appDelegate = APPDELEGATE;
    
    [lblFunctionName setText:TITLENAME(FUNC_PATROL_TASK_DES)];
    
    AGENT.delegate = self;
    
    [self getDetail];
    
    [self createBottomBar];
    replies = [[NSMutableArray alloc] init];
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
    [button1 setFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    [button1 addTarget:self action:@selector(toReply) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button1];
    [self.view addSubview:bottom];
    [bottom release];
}

-(void)clickLeftButton:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) refresh{
    [replies removeAllObjects];
    
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    TaskPatrolDetailParams_Builder *ppb = [TaskPatrolDetailParams builder];
    [ppb setTaskId:taskId];
    
    TaskPatrolDetailParams *tpp = [ppb build];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeTaskPatrolGet param:tpp]){
        tableView.pullTableIsRefreshing = NO;
        tableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void)toReply{
    TaskCommentViewController *vctrl = [[TaskCommentViewController alloc] init];
    vctrl.delegate = self;
    vctrl.taskId = taskId;
    vctrl.taskPatrol = taskPatrol;
    vctrl.parentController = self;
    vctrl.bNeedBack = YES;
    [self.navigationController pushViewController:vctrl animated:YES];
}

-(void)finishedComment:(TaskPatrolReply *)reply{
    
    [replies insertObject:reply atIndex:0];
    [self refresh];
    [tableView reloadData];
}

- (void) getDetail{
    tableView.pullLastRefreshDate = [NSDate date];
    tableView.pullTableIsRefreshing = YES;
    
    TaskPatrolDetailParams_Builder *ppb = [TaskPatrolDetailParams builder];
    [ppb setTaskId:taskId];
    
    TaskPatrolDetailParams *tpp = [ppb build];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeTaskPatrolGet param:tpp]){
        tableView.pullTableIsRefreshing = NO;
        tableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void) getDetailReply{
    TaskPatrolParams_Builder *bsp = [TaskPatrolParams builder];
    [bsp setPage:currentPage];
    [bsp setId:taskId];
    
    TaskPatrolParams *tpp = [bsp build];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeTaskPatrolReplyList param:tpp]){
        tableView.pullTableIsRefreshing = NO;
        tableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
}

-(void)clearTable{
    if (replies.count > 0){
        [replies removeAllObjects];
    }
}

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (documentController == nil)
    {
        documentController = [[UIDocumentInteractionController interactionControllerWithURL:url] retain];
        documentController.delegate = self;
    }
    else
    {
        documentController.URL = url;
    }
}

-(void) open:(NSString *) url{
    [self setupDocumentControllerWithURL:[NSURL fileURLWithPath:url]];
    CGRect navRect = self.navigationController.navigationBar.frame;
    //documentController.UTI = @"zip.mp3.mp4.pdf.doc.word.txt.rar";
    navRect.size = CGSizeMake(1500.0f, 40.0f);
    [documentController presentOptionsMenuFromRect:navRect inView:self.view  animated:YES];
}

-(void) openAttachment{
    if (taskPatrol.fileNames.count == 0) {
        return;
    }
    SHOWHUD;
    NSString *localFile = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[taskPatrol.fileNames objectAtIndex:0]];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:localFile]) {
        
        NSLog(@"提示用户打开文件");
        [self open:localFile];
        HUDHIDE2;
    }else{
        NSLog(@"本地没有此文件,去下载");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[taskPatrol.filePaths objectAtIndex:0]]];
            [data writeToFile:localFile atomically:YES];
            
            NSLog(@"下载成功");
            NSLog(@"提示用户打开文件");
            [self open:localFile];
            HUDHIDE2;
        });
    }
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    SessionResponse *sr = nil;
    BOOL isWT = YES;
    HUDHIDE2;
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type) ) {
        case ActionTypeTaskPatrolGet:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                TaskPatrol* t = [TaskPatrol parseFromData:cr.data];
                if ([super validateData:t]) {
                    taskPatrol = [t retain];
                    sr = [SessionResponse parseFromData:message];
                    isWT = NO;
                    self.lblFunctionName.text = TITLENAME_STR(FUNC_PATROL_TASK_DES,taskPatrol.name);
                    [self getDetailReply];
                    
                }
            }
        }
            break;
        default:
            break;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeTaskPatrolReplyList:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                Pagination* pageReply = [Pagination parseFromData:cr.data];
                
                pageSize = pageReply.pageSize;
                totleSize = pageReply.totalSize;
                if (currentPage == 1) {
                    [self clearTable];
                }
                for (int i = 0; i < pageReply.datas.count; ++i) {
                    TaskPatrolReply* wr = [TaskPatrolReply parseFromData:[pageReply.datas objectAtIndex:i]];
                    if (![super validateData:wr]) {
                        continue;
                    }else{
                        [replies addObject:wr];
                    }
                }
                [tableView reloadData];
            }
            
        }
            break;
        default:
            break;
    }
    [super showMessage2:isWT ? cr : sr Title:NSLocalizedString(@"note", @"") Description:@""];
    
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeTaskPatrolReplyList) || (INT_ACTIONTYPE(cr.type) == ActionTypeTaskPatrolGet)){
        tableView.pullTableIsRefreshing = NO;
        tableView.pullTableIsLoadingMore = NO;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (taskPatrol == nil) {
        return 0;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 7) {
                CGSize size = [super rebuildSizeWithString:taskPatrol.content ContentWidth:215.f FontSize:FONT_SIZE + 1];
                return MAX(40, size.height + 19);
            }
            return 40;
        }
            break;
        case 1:{
            return 40;
        }
            break;
        case 2:{
            NSString* text = ((TaskPatrolReply *)[replies objectAtIndex:indexPath.row]).content;
            CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
            
            CGFloat height = MAX(size.height + 45.0f, 75.0f);
            return height;
        }
            break;
        case 3:{
            return 120;
        }
            break;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 0;
    }else {
        return 30;
    
    }

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return NSLocalizedString(@"patrol_task_info", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"patrol_sub_task", nil);
        }
            break;
        case 2:{
            return NSLocalizedString(@"apply_label_replied", nil);
        }
            break;
            
        default:
            break;
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 8;////////////
    }else if(section == 1){
        return taskPatrol.detail.count;
    }else
        return replies.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 6) {
                [self openAttachment];
            }
        }
            break;
        case 2:{
            TaskPatrolReply *reply = [replies objectAtIndex:indexPath.row];
            IMGCommentDetailView *commentDetailView = [[IMGCommentDetailView alloc] initWithFrame:CGRectMake(0, 64, 320, 240)];
            
            commentDetailView.parentCtrl = self;
            commentDetailView.content = reply.content;
            commentDetailView.imageFiles = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSString *url in reply.filePath) {
                [commentDetailView.imageFiles addObject:url];
            }
            [commentDetailView.tableView reloadData];
            KWPopoverView *pop2View = [[[KWPopoverView alloc] initWithFrame:CGRectZero] autorelease];
            CGPoint point;
            point.x = 280.f;
            point.y = 64.f;
            [pop2View showPopoverAtPoint2:point inView:self.view withContentView:commentDetailView];
            [commentDetailView release];
            commentDetailView.parentView = pop2View;
            //[pop2View release];
        }
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    NSString *taskTypeRepeat =  NSLocalizedString(@"patrol_task_repeat", nil);
    NSString *taskTypeSingle =  NSLocalizedString(@"patrol_task_single", nil);
    NSString *taskStatusFinish =  NSLocalizedString(@"task_status_finish", nil);
    NSString *taskStatusNoFinish =  NSLocalizedString(@"task_status_not_finish", nil);
    
    switch (indexPath.section) {
        case 0:{
            InputCell *categorySelectCell =(InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell00"];
            if(categorySelectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InputCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[InputCell class]])
                        categorySelectCell=(InputCell *)oneObject;
                }
                categorySelectCell.inputField.placeholder = @"";
                categorySelectCell.inputField.enabled = NO;
            }
            if (indexPath.row == 0) {
                categorySelectCell.title.text = NSLocalizedString(@"task_name", nil);
                categorySelectCell.inputField.text = taskPatrol.name;
            }else if (indexPath.row == 1){
                NSString *weekDays = @"";
                if (taskPatrol.taskType == REPEAT_TASK) {
                    NSMutableArray *tmpDays = [[NSMutableArray alloc] initWithArray:[taskPatrol.cycleDate componentsSeparatedByString:@","]];
                    for (NSString *strDay in tmpDays) {
                        weekDays = [NSString stringWithFormat:@"%@,%@",weekDays,[NSDate weekDayWithIndex:strDay]];
                    }
                    if (weekDays.length >0) {
                        weekDays = [weekDays substringFromIndex:1];
                        weekDays = [NSString stringWithFormat:@"(每周%@)",weekDays];
                    }
                    //[tmpDays release];
                }
                
                categorySelectCell.title.text = NSLocalizedString(@"task_type", nil);
                categorySelectCell.inputField.text = [NSString stringWithFormat:@"%@%@",taskPatrol.taskType == 0?taskTypeSingle:taskTypeRepeat,weekDays];
            }else if (indexPath.row == 2){
                categorySelectCell.title.text = NSLocalizedString(@"task_status", nil);
                categorySelectCell.inputField.text = taskPatrol.taskStatus == 0?taskStatusNoFinish:taskStatusFinish;
            }else if (indexPath.row == 3){
                categorySelectCell.title.text = NSLocalizedString(@"task_start_time", nil);
                categorySelectCell.inputField.text = taskPatrol.startDate;
            }else if (indexPath.row == 4){
                categorySelectCell.title.text = NSLocalizedString(@"task_end_time", nil);
                categorySelectCell.inputField.text = taskPatrol.endDate;
            }else if (indexPath.row == 5){
                categorySelectCell.title.text = NSLocalizedString(@"task_finished_time", nil);
                categorySelectCell.inputField.text = taskPatrol.finishDate;
            }else if (indexPath.row == 6){
                categorySelectCell.title.text = NSLocalizedString(@"task_attchment", nil);
                categorySelectCell.inputField.text = [taskPatrol.fileNames objectAtIndex:0];
                categorySelectCell.inputField.textColor = WT_BLUE;
            }else if (indexPath.row == 7){
                if (titleLableCell == nil) {
                    titleLableCell = [[[[NSBundle mainBundle] loadNibNamed:@"TitleLableCell" owner:nil options:nil] firstObject] retain];
                }
                titleLableCell.lbTitle.text = NSLocalizedString(@"task_content", nil);
                CGSize size = [super rebuildSizeWithString:taskPatrol.content ContentWidth:215.f FontSize:FONT_SIZE + 1];
                [titleLableCell setContent:taskPatrol.content size:size];
                titleLableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return titleLableCell;
            }
            
            categorySelectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return categorySelectCell;
        }
            break;
        case 1:{
            
            TaskPatrolDetail *detail = [taskPatrol.detail objectAtIndex:indexPath.row];
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            }
            Customer *cust = detail.customer;
            cell.textLabel.text = [NSString stringWithFormat:@"  %@",cust.name];
            return cell;
        }
            break;
        case 2:{
            PatrolDetailReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolDetailReplyCell"];
            if (cell == nil) {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolDetailReplyCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            TaskPatrolReply *reply = [replies objectAtIndex:indexPath.row];
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
            break;
                    
        default:
            break;
    }
    
    return cell;
    
}

- (void)dealloc {
    
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didFailWithError:(NSError *)error{
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    
    [super didFailWithError:error];
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    tableView.pullLastRefreshDate = [NSDate date];
    tableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    [self getDetail];
}

- (void) loadMoreDataToTable
{
    tableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        
        [self getDetailReply];
    }else{
        tableView.pullTableIsLoadingMore = NO;
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
