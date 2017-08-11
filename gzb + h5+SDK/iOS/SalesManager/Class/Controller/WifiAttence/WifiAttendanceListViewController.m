//
//  WifiAttendanceListViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/11/30.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "WifiAttendanceListViewController.h"
#import "HeaderSearchBar.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "InputViewController.h"
#import "HeaderSearchBar.h"
#import "WifiAttenceSearch.h"
#import "UIView+CNKit.h"
#import "UIView+Util.h"
#import "DepartmentViewController.h"
#import "SDImageView+SDWebCache.h"
#import "WifiAttendanceCell.h"
#import "WifiAttendanceDetailViewController.h"

@interface WifiAttendanceListViewController ()<UITableViewDelegate,InputFinishDelegate,HeaderSearchBarDelegate,NameFilterViewControllerDelegate,DepartmentViewControllerDelegate>{
    HeaderSearchBar*        _searchBar;
    NSMutableArray*         _searchViews;
    NSMutableArray*         _departments;
    NSMutableArray*         _checkDepartments;
    NSString*               _name;
    NSString*               _formTime;
    NSString*               _endTime;
    NSString*               _checkTime;
    WifiAttenceSearch* nameFilterVC;

}

@end

@implementation WifiAttendanceListViewController
@synthesize checkInParams;
- (void)viewDidLoad {
    [super viewDidLoad];
    [lblFunctionName setText:NSLocalizedString(@"sign_attendance_list", @"")];
    self.view.backgroundColor = WT_WHITE;
    currentAttendance = nil;
    currentRow = 0;
    currentPage = 1;
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
    
    //初始化数据
    _searchViews = [[NSMutableArray alloc] initWithCapacity:1];
    _departments = [[LOCALMANAGER getDepartments] retain];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    
    //数据表格
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    
    self.pullTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT - 45) style:UITableViewStylePlain];
    
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    self.pullTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.pullTableView];
    currentPage = 1;
    checkInMuArray = [[NSMutableArray alloc] init];
    //计算frame
    CGRect tmpFrame = self.pullTableView.frame;
    tmpFrame.size.height = MAINHEIGHT - 45;
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.departmentArray = _departments;
    departmentVC.delegate = self;
    departmentVC.view.frame = CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT - 45);
    [self addChildViewController:departmentVC];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    [departmentVC release];
    
    //筛选视图
    nameFilterVC = [[NSBundle mainBundle] loadNibNamed:@"WifiAttenceSearch" owner:self options:nil][0];
    nameFilterVC.y = 45;
    nameFilterVC.delegate = self;
    [_searchViews addObject:nameFilterVC];

    
   [lblFunctionName setText:@"打卡考勤－列表"];
    
    AGENT.delegate = self;
    
    if (bNeedBack) {
        leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
    
    if (checkInParams == nil) {
        //[self openSearchView];
        //更新参数 刷新数据
        
        [self refreshParamsAndTable];
    }else{
        [self refreshTable];
    }

    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    if (checkInParams != nil){
        CheckInTrackParams_Builder* wp = [checkInParams toBuilder];
        [wp setPage:1];
        checkInParams = [[wp build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeCheckinTrackList param:checkInParams]){
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
    if(currentPage*pageSize < totleSize){
        currentPage++;
        CheckInTrackParams_Builder* wp = [checkInParams toBuilder];
        [wp setPage:currentPage];
        checkInParams = [[wp build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeCheckinTrackList param:checkInParams]){
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
    return [checkInMuArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWHEADERHEIGHT;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    WifiAttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"WifiAttendanceCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[WifiAttendanceCell class]])
                cell=(WifiAttendanceCell *)oneObject;
        }
    }
    CGRect cellFrame = [cell frame];
    
    CheckInTrack *checkInTrack = (CheckInTrack *)[checkInMuArray objectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = checkInTrack.user.realName;
    cell.dayWork.text = checkInTrack.checkInShiftGroup.name;
    cell.time.text = checkInTrack.checkInShiftGroup.date;
    cell.dateLabel.text = checkInTrack.checkInShiftGroup.shift.date;
    
    switch (checkInTrack.checkInShiftGroup.checkInStatus) {
        case 0:
              [cell.category setTitle:@"已打卡"forState:UIControlStateNormal];
            break;
        case 1:
             [cell.category setTitle:@"迟到"forState:UIControlStateNormal];
            cell.lateTime.text = [NSString stringWithFormat:@"迟到%@",[self timeFormatted:checkInTrack.checkInShiftGroup.checkInAbnormal]];
            break;
        case 2:
             [cell.category setTitle:@"早退"forState:UIControlStateNormal];
            cell.lateTime.text = [NSString stringWithFormat:@"早退%@",[self timeFormatted:checkInTrack.checkInShiftGroup.checkInAbnormal]];
            break;
        case 3:
             [cell.category setTitle:@"未打卡"forState:UIControlStateNormal];
            break;
        case 4:
             [cell.category setTitle:@"未打卡"forState:UIControlStateNormal];
        default:
            break;
    }
    cell.checkInTime.text = checkInTrack.createTime;
    if ([checkInTrack.location.address isEqualToString:@""]) {
        if (checkInTrack.location.longitude > 0){
            cell.checkInAddress.text = [NSString stringWithFormat:@"%@ %g %g" ,checkInTrack.location.address,checkInTrack.location.latitude,checkInTrack.location.longitude];
        } else {
            cell.checkInAddress.text = @"";
        }
    } else{
        cell.checkInAddress.text = checkInTrack.location.address;
    }
    [cell.ivImage setImageWithURL:[NSURL URLWithString:[checkInTrack.filePath objectAtIndex:0]] refreshCache:YES placeholderImage:[UIImage imageNamed:@"attendance_remarks_icon"]];
    if (checkInTrack.checkInShiftGroup.checkInStatus == 4) {
        cell.checkInComment.text = checkInTrack.checkInRemark;
    }else{
     cell.checkInComment.text = checkInTrack.comment;
    }
    
    [cell.category.layer setMasksToBounds:YES];
    [cell.category.layer setCornerRadius:5.0];
    
    [cell.category setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   
    cell.btApprove.tag = indexPath.section;
 
    [cell.btApprove.layer setMasksToBounds:YES];
    [cell.btApprove.layer setCornerRadius:5.0];
   
    [cell.btApprove setBackgroundColor:[UIColor clearColor]];
    
    [cell.btApprove setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.btApprove addTarget:self action:@selector(toReply:) forControlEvents:UIControlEventTouchUpInside];
    if (checkInTrack.checkInTrackReplies.count > 0){
        cell.btApprove.hidden = NO;
        [cell.btApprove setTitle:NSLocalizedString(@"worklog_approval", nil) forState:UIControlStateNormal];
        [cell.btApprove setBackgroundColor:WT_GREEN];
        
    }else{
        if (USER.id != checkInTrack.user.id){
            cell.btApprove.hidden = YES;
            [cell.btApprove setTitle:NSLocalizedString(@"worklog_unapproval", nil) forState:UIControlStateNormal];
        }
        else{
            cell.btApprove.hidden = YES;
        }
    }
    
    //cell.btApprove.hidden = YES;
    [cell setFrame:cellFrame];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckInTrack *track = [checkInMuArray objectAtIndex:indexPath.section];
    
    [self _showAttendanceDetail:track];
}

- (void) _showAttendanceDetail:(CheckInTrack*) checkInTtack{
    
    WifiAttendanceDetailViewController *ctrl = [[WifiAttendanceDetailViewController alloc] init];
    ctrl.checkInTrack = nil;
    ctrl.checkInTrackId = checkInTtack.id;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

#pragma -mark 更新参数
-(void) refreshParamsAndTable{
    [self refreshParams];
    [self refreshTable];
}

-(void) refreshParams{
    CheckInTrackParams_Builder* baseParam = [CheckInTrackParams builder];
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
    if (_checkTime.length > 0) {
        [baseParam setCheckInDate:_checkTime];
    }
    
    if (_name.length > 0) {
        User_Builder* u = [User builder];
        [u setRealName:_name];
        [u setId:0];
        User* user = [u build];
        [baseParam setUsersArray:[NSArray arrayWithObjects:user, nil]];
    }
    
    [baseParam setPage:1];
    self.checkInParams = [[baseParam build] retain];
}

#pragma -mark NameFilterViewController delegate
-(void)NameFilterViewControllerSearch:(NSString*) name formTime:(NSString*)formTime endTime:(NSString*)endTime checkIntime:(NSString*)checkTime{
    NSLog(@"筛选名称：%@",name);
    _name = name;
    _formTime = formTime;
    _endTime = endTime;
    _checkTime = checkTime;
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

-(void)clearTable{
    if (checkInMuArray.count > 0){
        [checkInMuArray removeAllObjects];
    }
}

#pragma -mark HeaderSearchBar delegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    NSLog(@"搜索条选择了:%d",index);
    if (current == index) {
        [UIView removeViewFormSubViews:-1 views:_searchViews ];
    }else{
        [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
        [UIView removeViewFormSubViews:index views:_searchViews];
    }
    
}
-(void)didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeCheckinTrackList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageCheckInTrack* pageCheck = [PageCheckInTrack parseFromData:cr.data];
        if ([super validateData:pageCheck]) {
            int checkCount = pageCheck.checkInTracks.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < checkCount;i++){
               CheckInTrack* ct = (CheckInTrack*)[[pageCheck checkInTracks] objectAtIndex:i];
                
                [checkInMuArray addObject:ct];
                
            }
            pageSize = pageCheck.page.pageSize;
            totleSize = pageCheck.page.totalSize;
            
            if (checkInMuArray.count == 0) {
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
            [checkInMuArray removeObjectAtIndex:currentRow];
            [checkInMuArray insertObject:currentAttendance atIndex:currentRow];
            
            [self.pullTableView reloadData];
        }
    }
    [super showMessage2:cr Title:TITLENAME_LIST(FUNC_ATTENDANCE_DES)Description:@""];
    self.pullTableView.pullTableIsRefreshing = NO;
    self.pullTableView.pullTableIsLoadingMore = NO;
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

-(void)toReply:(id)sender{
    UIView *view = (UIView*)sender;
    CheckInTrack* attendance = [checkInMuArray objectAtIndex:view.tag];
    
    if (attendance.checkInTrackReplies.count > 0){
        [self _showAttendanceDetail:attendance];
        return;
    }
    
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    ctrl.tag = view.tag;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) refresh:(id)obj{
    if (![obj isKindOfClass:[CheckInTrack class]]) {
        return;
    }
    CheckInTrack* check = (CheckInTrack*)obj;
    for (int i = 0; i < checkInMuArray.count; i++) {
        if (((CheckInTrack*)[checkInMuArray objectAtIndex:i]).id == check.id){
            [checkInMuArray removeObjectAtIndex:i];
            [checkInMuArray insertObject:check atIndex:i];
            
            [self.pullTableView reloadData];
            
            break;
        }
    }
}


#pragma mark - tableViewdelegate
-(void)clickLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
