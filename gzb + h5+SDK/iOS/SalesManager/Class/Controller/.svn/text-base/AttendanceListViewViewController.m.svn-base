//
//  AttendanceListViewViewController.m
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-10-21.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "AttendanceListViewViewController.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "AttendanceCell.h"
#import "BaseTable1HeaderView.h"
#import "AttendanceSearchViewController.h"
#import "NSDate+Util.h"
#import "UIView+Util.h"
#import "InputViewController.h"
#import "AttendanceDetailViewController.h"
#import "SDImageView+SDWebCache.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"
#import "NameFilterViewController.h"

@interface AttendanceListViewViewController ()<InputFinishDelegate,HeaderSearchBarDelegate,DepartmentViewControllerDelegate,NameFilterViewControllerDelegate>

@end

@implementation AttendanceListViewViewController
{
    HeaderSearchBar* searchBar;
    NSMutableArray* searchViews;
    NSMutableArray* _departments;
    NSMutableArray* _checkDepartments;
    NSString* _formDate;
    NSString* _endDate;
    NSString* _userName;
}
@synthesize aParams;
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
    
    currentAttendance = nil;
    currentRow = 0;
    currentPage = 1;
    attendanceArray = [[NSMutableArray alloc] init];
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    //初始化搜索视图
    searchViews = [[NSMutableArray alloc] initWithCapacity:2];
    _departments = [[NSMutableArray alloc] initWithCapacity:0];
    [_departments removeAllObjects];
    [_departments addObjectsFromArray:[[LOCALMANAGER getDepartments] retain]];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    

    //搜索条载入
    searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0,0, MAINWIDTH, 45)];
    NSArray* titles = [NSArray arrayWithObjects:@"部门",@"筛选", nil];
    NSArray*  icons = [NSArray arrayWithObjects:@"",@"",nil];
    searchBar.titles = titles;
    searchBar.icontitles = icons;
    searchBar.delegate = self;
    searchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchBar];
    //计算frame
    CGRect tmpFrame = self.pullTableView.frame;
    tmpFrame.size.height = MAINHEIGHT - (searchBar.frame.origin.y + searchBar.frame.size.height);
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.departmentArray = _departments;
    departmentVC.delegate = self;
    [self addChildViewController:departmentVC];
    self.childViewControllers.firstObject.view.frame = tmpFrame;
    [searchViews addObject:self.childViewControllers.firstObject.view];
    [departmentVC release];
    //名称筛选
    NameFilterViewController* nameFilterView = [[NSBundle mainBundle] loadNibNamed:@"NameFilterViewController" owner:nil options:nil][0];
    nameFilterView.frame = tmpFrame;
    nameFilterView.delegate = self;
    [self initFilterViewParams:nameFilterView];
    [searchViews addObject:nameFilterView];
    
    //数据表格
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    self.pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    
    /* 搜索按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    UIImageView *seachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    [seachImageView setImage:[UIImage imageNamed:@"topbar_button_search"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSearchView)];
    [tapGesture1 setNumberOfTapsRequired:1];
    seachImageView.userInteractionEnabled = YES;
    [seachImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:seachImageView];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    [rightView release];
    */
    
    [lblFunctionName setText:NSLocalizedString(@"sign_attendance_list", @"")];
    (APPDELEGATE).agent.delegate = self;
    if (bNeedBack) {
       leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
    
    if (!self.aParams) {
        [self refreshParams];
    }
    [self refreshTable];
    
}
-(void) initFilterViewParams:(NameFilterViewController *) vc{
    if (aParams.users.count > 0) {
        vc._txtName.text = ((User *)[aParams.users objectAtIndex:0]).realName;
    }
}
/*
    更新参数
 */
-(void)refreshParams{
    AttendanceParams_Builder* apbparam = [AttendanceParams builder];
    if (_checkDepartments && _checkDepartments.count > 0) {
        [apbparam setDepartmentsArray:_checkDepartments];
    }else{
        [apbparam clearDepartments];
    }
    
    User_Builder* u = [User builder];
    [u setRealName:_userName.length > 0 ? _userName : @""];
    [u setId:0];
    User* tmpUser = [[u build] retain];
    if (_formDate.length > 0) {
        [apbparam setStartDate:_formDate];
    }
    if (_endDate.length > 0) {
        [apbparam setEndDate:_endDate];
    }
    [apbparam setPage:1];
    [apbparam setUsersArray:[NSArray arrayWithObjects:tmpUser, nil]];
    aBuilder = [apbparam retain];
    self.aParams = [[aBuilder build] retain];
}

#pragma -mark NameFilterViewControllerDelegate
-(void)NameFilterViewControllerSearch:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"查询参数:%@\n%@\n%@",name,formTime,endTime);
    _formDate = formTime;
    _endDate = endTime;
    _userName = name;
    [UIView removeViewFormSubViews:-1 views:searchViews];
    [searchBar setColor:1];
    
    [self refreshParams];
    [self refreshTable];
}



#pragma -mark 部门选择 Delegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"部门选择了%d个",departments.count);
    _checkDepartments = [departments retain];
    [UIView removeViewFormSubViews:-1 views:searchViews];
    [searchBar setColor:0];
    
    //设置标题
    NSMutableString* sb = [[[NSMutableString alloc] init] autorelease];
    if (departments && departments.count > 0) {
        int count = 0;
        for (Department* item in departments) {
            if (count > 5) {
                break;
            }
            [sb appendFormat:@"%@,",item.name];
            count ++;
        }
    }
    UIButton* btn = searchBar.buttons[0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [btn setTitle:departments.count > 0 ? [sb substringToIndex:sb.length - 1] : searchBar.titles[0] forState:UIControlStateNormal];
    });
    //更新参数
    [self refreshParams];
    [self refreshTable];
}

#pragma -mark HeaderSearchBar delegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    NSLog(@"%d",index);
    if (current == index) {
        [UIView removeViewFormSubViews:-1 views:searchViews];
    }
    else{
        [UIView addSubViewToSuperView:self.view subView:searchViews[index]];
        [UIView removeViewFormSubViews:index views:searchViews];
    }
}
#pragma -mark 页面方法
-(void)openSearchView{
    
    AttendanceSearchViewController *ctrl = [[AttendanceSearchViewController alloc] init];
    ctrl.delegate = self;
    UINavigationController *searchNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentModalViewController:searchNavCtrl animated:YES];
    //[ctrl release];
    //[searchNavCtrl release];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)clickLeftButton:(id)sender{
    if (bNeedBack){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clearTable{
    if (attendanceArray.count > 0){
        [attendanceArray removeAllObjects];
    }
}

-(void)didFinishedSearchWithResult:(AttendanceParams_Builder *)result{
    aBuilder = [(AttendanceParams_Builder *)result retain];
    self.aParams = [[aBuilder build] retain];
    //[self clearTable];
    //[self refreshTable];
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
}

- (void) didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeAttendanceList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageAttendance* pageAttendance = [PageAttendance parseFromData:cr.data];
        if ([super validateData:pageAttendance]) {
            int attendanceCount = pageAttendance.attendances.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < attendanceCount;i++){
                Attendance* aw = (Attendance*)[[pageAttendance attendances] objectAtIndex:i];
                [attendanceArray addObject:aw];
            }
            pageSize = pageAttendance.page.pageSize;
            totalSize = pageAttendance.page.totalSize;
            
            if (attendanceArray.count == 0) {
                [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_ATTENDANCE_DES)
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
        }
    }
    
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeAttendanceReply) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])) {
        [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"attendancereply_msg_saved", @"")];
        
        if (currentAttendance != nil){
            [attendanceArray removeObjectAtIndex:currentRow];
            [attendanceArray insertObject:currentAttendance atIndex:currentRow];
            
            [self.pullTableView reloadData];
        }
    }
    
    [super showMessage2:cr Title:TITLENAME_LIST(FUNC_ATTENDANCE_DES)Description:@""];
    self.pullTableView.pullTableIsRefreshing = NO;
    self.pullTableView.pullTableIsLoadingMore = NO;
    [self.pullTableView reloadData];
    
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

- (void) refreshTable{
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    if (self.aParams != nil){
        AttendanceParams_Builder* ab = [self.aParams toBuilder];
        [ab setPage:1];
        self.aParams = [[ab build] retain];
        
        (APPDELEGATE).agent.delegate = self;
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeAttendanceList param:self.aParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_ATTENDANCE_DES)
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
    if(currentPage*pageSize < totalSize){
        currentPage++;
        AttendanceParams_Builder* ab = [self.aParams toBuilder];
        [ab setPage:currentPage];
        
        self.aParams = [[ab build] retain];
        
        (APPDELEGATE).agent.delegate = self;
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeAttendanceList param:self.aParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_ATTENDANCE_DES)
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
    //return 75.f;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [attendanceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWHEADERHEIGHT;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    AttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"Attendance" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[AttendanceCell class]])
                cell=(AttendanceCell *)oneObject;
        }
    }
    CGRect cellFrame = [cell frame];

    Attendance *attendance = (Attendance *)[attendanceArray objectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = attendance.user.realName;
    cell.checkInTime.text =  [NSDate dateWithFormatTodayOrYesterday:attendance.date];
    if ([attendance.location.address isEqualToString:@""]) {
        if (attendance.location.longitude > 0){
            cell.checkInAddress.text = [NSString stringWithFormat:@"%@ %g %g" ,attendance.location.address,attendance.location.latitude,attendance.location.longitude];
        } else {
            cell.checkInAddress.text = NSLocalizedString(@"error_location", @"");
        }
    } else{
        cell.checkInAddress.text = attendance.location.address;
    }
    [cell.ivImage setImageWithURL:[NSURL URLWithString:[attendance.filePath objectAtIndex:0]] refreshCache:YES placeholderImage:[UIImage imageNamed:@"attendance_remarks_icon"]];
    cell.checkInComment.text = attendance.comment;
    [cell.category setTitle:attendance.category.name forState:UIControlStateNormal];
    [cell.category.layer setMasksToBounds:YES];
    [cell.category.layer setCornerRadius:5.0];
 
    [cell.category setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cell.btApprove.tag = indexPath.section;
    //    cell.btApprove.frame = CGRectMake(MAINWIDTH - 40 - 10, 5, 40, 20);
    [cell.btApprove.layer setMasksToBounds:YES];
    [cell.btApprove.layer setCornerRadius:5.0];

    [cell.btApprove setBackgroundColor:[UIColor clearColor]];

    [cell.btApprove setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.btApprove addTarget:self action:@selector(toReply:) forControlEvents:UIControlEventTouchUpInside];
    if (attendance.attendanceReplies.count > 0){
        cell.btApprove.hidden = NO;
        [cell.btApprove setTitle:NSLocalizedString(@"worklog_approval", nil) forState:UIControlStateNormal];
        [cell.btApprove setBackgroundColor:WT_GREEN];
        //[cell.btApprove setBackgroundImage:[UIImage imageNamed:@"bg_msgbox_state_unfinish"] forState:UIControlStateNormal] ;
        
    }else{
        if (USER.id != attendance.user.id){
            /*if (![USER.company.id isEqualToString:attendance.user.company.id] ) {
                cell.btApprove.hidden = YES;
            }else{*/
                cell.btApprove.hidden = YES;
                [cell.btApprove setTitle:NSLocalizedString(@"worklog_unapproval", nil) forState:UIControlStateNormal];
                //[cell.btApprove setBackgroundImage:[UIImage imageNamed:@"bg_msgbox_state_read"] forState:UIControlStateNormal];
           // }
        }
        else{
            cell.btApprove.hidden = YES;
        }
    }
    
    //cell.btApprove.hidden = YES;
    [cell setFrame:cellFrame];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Attendance *att = [attendanceArray objectAtIndex:indexPath.section];
    
    [self _showAttendanceDetail:att];
}

- (void) _showAttendanceDetail:(Attendance*) attendance{

    AttendanceDetailViewController *ctrl = [[AttendanceDetailViewController alloc] init];
    ctrl.attendance = nil;
    ctrl.attendanceId = attendance.id;
    ctrl.delegate = self;
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
    
}


-(void)toReply:(id)sender{
    UIView *view = (UIView*)sender;
    Attendance* attendance = [attendanceArray objectAtIndex:view.tag];
    
    if (attendance.attendanceReplies.count > 0){
        [self _showAttendanceDetail:attendance];
        return;
    }
    
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    ctrl.tag = view.tag;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void) didFinishInput:(int)tag Input:(NSString *)input{
    int attendanceId = ((Attendance*)[attendanceArray objectAtIndex:tag]).id;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    AttendanceReply_Builder* arb = [AttendanceReply builder];
    [arb setSender:USER];
    [arb setContent:input];
    [arb setCreateDate:[NSDate getCurrentTime]];
    [arb setAttendanceId:attendanceId];
    [arb setId:-1];
    
    currentRow = tag;
    NSMutableArray* attendanceReplies = [[NSMutableArray alloc] initWithCapacity:1];
    AttendanceReply* ar = [[arb build] retain];
    [attendanceReplies addObject:ar] ;
    Attendance_Builder* ab = [[attendanceArray objectAtIndex:currentRow] toBuilder];
    [ab setAttendanceRepliesArray:attendanceReplies];
    currentAttendance = [[ab build] retain];
    
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeAttendanceReply param:ar]){
        [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_ATTENDANCE_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}



- (void) refresh:(id)obj{
    if (![obj isKindOfClass:[Attendance class]]) {
        return;
    }
    Attendance* attendance = (Attendance*)obj;
    for (int i = 0; i < attendanceArray.count; i++) {
        if (((Attendance*)[attendanceArray objectAtIndex:i]).id == attendance.id){
            [attendanceArray removeObjectAtIndex:i];
            [attendanceArray insertObject:attendance atIndex:i];
            
            [self.pullTableView reloadData];
            
            break;
        }
    }
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [searchBar release];
    [_pullTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
}
@end
