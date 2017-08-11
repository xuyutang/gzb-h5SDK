//
//  WorklogListViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "WorklogListViewController.h"
#import "AppDelegate.h"
#import "WorklogSearchViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "WorkLogCell.h"
#import "InputViewController.h"
#import "HeaderSearchBar.h"
#import "NameFilterViewController.h"
#import "UIView+Util.h"
#import "DepartmentViewController.h"
#import "SDImageView+SDWebCache.h"

@interface WorklogListViewController ()<UITableViewDelegate,InputFinishDelegate,HeaderSearchBarDelegate,NameFilterViewControllerDelegate,DepartmentViewControllerDelegate>

@end

@implementation WorklogListViewController{
    HeaderSearchBar*        _searchBar;
    NSMutableArray*         _searchViews;
    NSMutableArray*         _departments;
    NSMutableArray*         _checkDepartments;
    NSString*               _name;
    NSString*               _formTime;
    NSString*               _endTime;
}
@synthesize worklogArray,worklogParams,pullTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    appDelegate = APPDELEGATE;
    currentWorkLog = nil;
    currentRow = 0;
    
    [super viewDidLoad];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    //搜索条载入
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0,0, MAINWIDTH, 45)];
    NSArray* titles = [NSArray arrayWithObjects:@"部门",@"筛选", nil];
    NSArray*  icons = [NSArray arrayWithObjects:@"",@"",nil];
    _searchBar.titles = [titles copy];
    _searchBar.icontitles = [icons copy];
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchBar];
    
    //计算frame
    CGRect tmpFrame = self.pullTableView.frame;
    tmpFrame.size.height = MAINHEIGHT - 45;
    
    //初始化数据
    _searchViews = [[NSMutableArray alloc] initWithCapacity:1];
    _departments = [[LOCALMANAGER getDepartments] retain];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.departmentArray = _departments;
    departmentVC.delegate = self;
    departmentVC.view.frame = tmpFrame;
    [self addChildViewController:departmentVC];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    [departmentVC release];
    
    //筛选视图
    NameFilterViewController* nameFilterVC = [[NSBundle mainBundle] loadNibNamed:@"NameFilterViewController" owner:self options:nil][0];
    nameFilterVC.frame = tmpFrame;
    nameFilterVC.delegate = self;
    [_searchViews addObject:nameFilterVC];
    
    //数据表格
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    self.pullTableView.tableFooterView = [[UIView alloc]init];
    
    currentPage = 1;
    
    worklogArray = [[NSMutableArray alloc] init];
    
    [lblFunctionName setText:TITLENAME_LIST(FUNC_WORKLOG_DES)];
    
    AGENT.delegate = self;
    
    if (bNeedBack) {
       leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
    
    if (worklogParams == nil) {
        //[self openSearchView];
        //更新参数 刷新数据
        [self refreshParamsAndTable];
    }else{
        [self refreshTable];
    }
}

#pragma -mark 更新参数
-(void) refreshParamsAndTable{
    [self refreshParams];
    [self refreshTable];
}

-(void) refreshParams{
    WorkLogParams_Builder* baseParam = [WorkLogParams builder];
    if (_checkDepartments && _checkDepartments.count > 0) {
        [baseParam setDepartmentsArray:_checkDepartments];
    }else{
        [baseParam clearDepartments];
    }
    if (_formTime.length > 0) {
        [baseParam setStartDate:_formTime];
    }
    if (_endTime.length > 0) {
        [baseParam setEndDate:_endTime];
    }
    if (_name.length > 0) {
        User_Builder* u = [User builder];
        [u setRealName:_name];
        [u setId:0];
        User* user = [u build];
        [baseParam setUsersArray:[NSArray arrayWithObjects:user, nil]];
    }
    [baseParam setPage:1];
    self.worklogParams = [[baseParam build] retain];
}

#pragma -mark NameFilterViewController delegate
-(void)NameFilterViewControllerSearch:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"筛选名称：%@",name);
    _name = name;
    _formTime = formTime;
    _endTime = endTime;
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:1];
    [self refreshParamsAndTable];
}

#pragma -mark DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"选择了 %d 个部门",departments.count);
    _checkDepartments = [departments retain];
    
    //设置状态
    [_searchBar setColor:0];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    NSMutableString* sb = [[NSMutableString alloc] init];
    int i = 0;
    for (Department* item in departments) {
        if (i > 5) {
            break;
        }
        [sb appendFormat:@"%@,",item.name];
        i++;
    }
    UIButton* btn = _searchBar.buttons[0];
    [btn setTitle:departments.count > 0 ?[sb substringToIndex:sb.length - 1] : _searchBar.titles[0] forState:UIControlStateNormal];
    
    [self refreshParamsAndTable];
}

#pragma -mark HeaderSearchBar delegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    NSLog(@"日志搜索条选择了:%d",index);
    if (current == index) {
        [UIView removeViewFormSubViews:-1 views:_searchViews ];
    }else{
        [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
        [UIView removeViewFormSubViews:index views:_searchViews];
    }

}

#pragma -mark 页面方法
-(void)openSearchView {
    WorklogSearchViewController *ctrl = [[WorklogSearchViewController alloc] init];
    ctrl.delegate = self;
    UINavigationController *searchNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentModalViewController:searchNavCtrl animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)clickLeftButton:(id)sender {
    if (bNeedBack){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clearTable {
    if (worklogArray.count > 0){
        [worklogArray removeAllObjects];
    }
}

-(void)didFinishedSearchWithResult:(WorkLogParams_Builder *)result {
    WorkLogParams_Builder* pp = (WorkLogParams_Builder *)result;
    [pp setPage:currentPage];
    worklogParams = [[pp build] retain];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (worklogArray.count > 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.pullTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeWorklogList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageWorkLog* pageWorkLog = [PageWorkLog parseFromData:cr.data];
        if ([super validateData:pageWorkLog]) {
            int worklogCount = pageWorkLog.workLogs.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < worklogCount;i++){
                WorkLog* w = (WorkLog*)[[pageWorkLog workLogs] objectAtIndex:i];
                [worklogArray addObject:w];
                
            }
            pageSize = pageWorkLog.page.pageSize;
            totleSize = pageWorkLog.page.totalSize;
            
            if (worklogArray.count == 0) {
                [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_WORKLOG_DES)
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
        }
    }
    
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeWorklogReply) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])) {
        [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"worklogreply_msg_saved", @"")];
        
        if (currentWorkLog != nil){
            WorkLog_Builder* wb = [currentWorkLog toBuilder];
            [wb setReplyCount:currentWorkLog.replyCount+1];
            [worklogArray removeObjectAtIndex:currentRow];
            [worklogArray insertObject:[wb build] atIndex:currentRow];
            
            [self.pullTableView reloadData];
        }
    }
    
    [super showMessage2:cr Title:TITLENAME_LIST(FUNC_WORKLOG_DES) Description:@""];
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeWorklogList) || (INT_ACTIONCODE(cr.code) != ActionCodeDone)){
        [self.pullTableView reloadData];
    
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
    }
    HUDHIDE2;
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

- (void)viewDidUnload
{
    [self setPullTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_searchBar release];
    [pullTableView release];
    [super dealloc];
}


#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    if (worklogParams != nil){
        WorkLogParams_Builder* wp = [worklogParams toBuilder];
        [wp setPage:1];
        worklogParams = [[wp build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeWorklogList param:worklogParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_WORKLOG_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
            
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
        }
    }
}

- (void) loadMoreDataToTable
{
    self.pullTableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        WorkLogParams_Builder* wp = [worklogParams toBuilder];
        [wp setPage:currentPage];
        worklogParams = [[wp build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeWorklogList param:worklogParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_WORKLOG_DES)
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
        }
    }else{
        self.pullTableView.pullTableIsLoadingMore = NO;
    }
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWHEADERHEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [worklogArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    WorkLogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"WorkLogCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[WorkLogCell class]])
                cell=(WorkLogCell *)oneObject;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WorkLog *w = [worklogArray objectAtIndex:indexPath.row];
   // cell.userImage.image

    [cell.userImage setImageWithURL:[NSURL URLWithString:[w.user.avatars objectAtIndex:0]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
    cell.title.text = w.user.realName;
    cell.time.text = [NSDate dateWithFormatTodayOrYesterday: w.createDate];
    cell.todayWork.text = w.today;
    cell.btApprove.tag = indexPath.section;
    [cell.btApprove addTarget:self action:@selector(toReply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btApprove.layer setMasksToBounds:YES];
    [cell.btApprove.layer setCornerRadius:15.0];
    cell.btApprove.layer.borderWidth = 1;
    cell.btApprove.layer.borderColor =[UIColor grayColor].CGColor;
    [cell.btApprove setBackgroundColor:[UIColor clearColor]];
    [cell.btApprove setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  //  cell.btApprove.userInteractionEnabled = NO;
    if (w.replyCount > 0){
        [cell.btApprove setTitle:[NSString stringWithFormat:@"%d",w.replyCount] forState:UIControlStateNormal];
    }else{
        cell.btApprove.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self _showWorkLogDetail:[worklogArray objectAtIndex:indexPath.row]];
}

- (void) _showWorkLogDetail:(WorkLog*) w {
    WorklogDetailViewController *ctrl = [[WorklogDetailViewController alloc] init];
    ctrl.worklog = nil;
    ctrl.worklogId = w.id;
    ctrl.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)toReply:(id)sender {
    UIView *view = (UIView*)sender;
    WorkLog* w = [worklogArray objectAtIndex:view.tag];
    
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    ctrl.tag = view.tag;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) didFinishInput:(int)tag Input:(NSString *)input{
    int worklogId = ((WorkLog*)[worklogArray objectAtIndex:tag]).id;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    WorkLogReply_Builder* wrb = [WorkLogReply builder];
    [wrb setContent:input];
    [wrb setSender:USER];
    [wrb setCreateDate:[NSDate getCurrentTime]];
    
    [wrb setWorkLogId:worklogId];
    [wrb setId:-1];
    
    currentRow = tag;
    WorkLog* w = [[worklogArray objectAtIndex:tag] retain];
    NSMutableArray* workReplies = [[NSMutableArray alloc] initWithCapacity:1];
    WorkLogReply* wr = [[wrb build] retain];
    [workReplies addObject:wr] ;
    
    WorkLog_Builder* wb = [w toBuilder];
    currentWorkLog = [[wb build] retain];
    
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeWorklogReply param:wr]){
        [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_WORKLOG_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
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

- (void) refresh:(id)obj{
    if (![obj isKindOfClass:[WorkLog class]]) {
        return;
    }
    WorkLog* worklog = (WorkLog*)obj;
    for (int i = 0; i < worklogArray.count; i++) {
        if (((WorkLog*)[worklogArray objectAtIndex:i]).id == worklog.id){
            [worklogArray removeObjectAtIndex:i];
            [worklogArray insertObject:worklog atIndex:i];
        
            [self.pullTableView reloadData];
        
            break;
        }
    }
}

@end
