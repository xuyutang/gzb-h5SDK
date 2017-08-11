//
//  InspectionListViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-11-26.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InspectionListViewController.h"
#import "PatrolTableCell.h"
#import "InspectionSearchViewController.h"
#import "SDImageView+SDWebCache.h"
#import "InspectionDetailViewController.h"
#import "MessageBarManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "InputViewController.h"
#import "HeaderSearchBar.h"
#import "DropMenu.h"
#import "InspectionTypeViewController.h"
#import "InspectionTargetsViewController.h"
#import "UIView+Util.h"
#import "DepartmentViewController.h"
#import "CustNameAndNameFilterViewController.h"

@interface InspectionListViewController ()<UITableViewDelegate,HeaderSearchBarDelegate,InspectionTypeDelegate,DepartmentViewControllerDelegate,TargetTypeDelegate,CustNameAndNameDelegate>

@end

@implementation InspectionListViewController
{
    HeaderSearchBar*    _searchBar;
    NSMutableArray*     _searchViews;
    
    NSMutableArray*     _departments;
    NSMutableArray*     _checkDepartments;
    
    InspectionType*     _inspectionType;
    
    InspectionReportCategory*   _inspectionCategory;
    
    NSString*           _targetName;
    NSString*           _name;
    NSString*           _formTime;
    NSString*           _endTime;
    
}
@synthesize inspectionArray,inspectionParams;

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
    [super viewDidLoad];
    //初始化数据
    _searchViews = [[NSMutableArray alloc] initWithCapacity:3];
    _departments = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getDepartments]];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    
    //搜索栏
    NSArray* titiles = [[NSArray alloc] initWithObjects:@"部门",@"报告类型",@"对象类型",@"筛选", nil];
    NSArray* icons = [[NSArray alloc] initWithObjects:@"",@"",@"",@"", nil];
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    _searchBar.icontitles = icons;
    _searchBar.titles = titiles;
    _searchBar.backgroundColor = WT_WHITE;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    [titiles release];
    [icons release];
    //计算高度
    CGRect tmpFrame = self.pullTableView.frame;
    self.pullTableView.backgroundColor = WT_WHITE;
    tmpFrame.size.height = MAINHEIGHT - 45;
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = _departments;
    departmentVC.view.frame = tmpFrame;
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    //报告类型
    InspectionTypeViewController* inspectionTypeVC = [[InspectionTypeViewController alloc] init];
    inspectionTypeVC.delegate = self;
    inspectionTypeVC.allBool = YES;
    [self addChildViewController:inspectionTypeVC];
    self.childViewControllers[1].view.frame = tmpFrame;
//    [_searchViews addObject:@"全部类型"];
    [_searchViews addObject:self.childViewControllers[1].view];
    [inspectionTypeVC release];
    //对象类型
    InspectionTargetTypeViewController* inspectionTargetVC = [[InspectionTargetTypeViewController alloc] init];
    inspectionTargetVC.delegate = self;
    [self addChildViewController:inspectionTargetVC];
    self.childViewControllers[2].view.frame = tmpFrame;
    [_searchViews addObject:self.childViewControllers[2].view];
    [inspectionTargetVC release];
    //筛选
    CustNameAndNameFilterViewController* custFilterVC = [[NSBundle mainBundle] loadNibNamed:@"CustNameAndNameFilterViewController" owner:nil options:nil][0];
    custFilterVC.delegate = self;
    custFilterVC.lable2 = @"对象名称";
    custFilterVC.frame = tmpFrame;
    [self initFilterViewParams:custFilterVC];
    [_searchViews addObject:custFilterVC];
    
    //数据表
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    self.pullTableView.pullDelegate = self;
    
    /* 搜索图标
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
    
    currentPage = 1;
    currentInspection = nil;
    currentRow = 0;
    inspectionArray = [[NSMutableArray alloc] init];
    
    [lblFunctionName setText:TITLENAME_LIST(FUNC_INSPECTION_DES)];
    
    AGENT.delegate = self;
    
    if (bNeedBack) {
       leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
    if (inspectionParams != nil)
        [self refreshTable];
    else
    {
        //[self openSearchView];
        [self refreshPramsAndTable];
    }
    
}

-(void) initFilterViewParams:(CustNameAndNameFilterViewController *) vc{
    if (inspectionParams.users.count > 0) {
        vc.txtName.text = ((User *)[inspectionParams.users objectAtIndex:0]).realName;
    }
}

#pragma -mark 参数封装更新
-(void) refreshParams{
    InspectionReportParams_Builder* bsp = [InspectionReportParams builder];
    [bsp setPage:1];
    if (_checkDepartments && _checkDepartments.count > 0) {
        [bsp setDepartmentsArray:_checkDepartments];
    }else{
        [bsp clearDepartments];
    }
    if (_inspectionType) {
        [bsp setInspectionType:_inspectionType];
    }else{
        [bsp clearInspectionType];
    }
    if (_inspectionCategory) {
        [bsp setInspectionReportCategory:_inspectionCategory];
    }else{
        [bsp clearInspectionReportCategory];
    }
    if (_targetName && _targetName.length > 0) {
        InspectionTarget_Builder* it = [InspectionTarget builder];
        [it setId:0];
        [it setName:_targetName];
        [bsp setInspectionTarget:[it build]];
    }
    if (_name && _name.length > 0) {
        User_Builder* u = [User builder];
        [u setId:0];
        [u setRealName:_name];
        [bsp setUsersArray:[NSArray arrayWithObject:[u build]]];
    }
    if (_formTime && _formTime.length > 0) {
        [bsp setStartDate:_formTime];
    }
    if (_endTime && _formTime.length > 0) {
        [bsp setEndDate:_endTime];
    }
    self.inspectionParams = [[bsp build] retain];
}

-(void) refreshPramsAndTable{
    [self refreshParams];
    [self refreshTable];
}


#pragma -mark CustNameAndNameDelegate
-(void)CustNameAndNameSearchClick:(NSString *)custName name:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"%@,%@,%@,%@",custName,name,formTime,endTime);
    _targetName = custName;
    _name = name;
    _formTime = formTime;
    _endTime = endTime;
    
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:3];
    [self refreshPramsAndTable];
}

#pragma -mark TargetTypeDelegate
-(void)targetTypeSearch:(InspectionTargetTypeViewController *)controller didSelectWithObject:(id)aObject{
    if (aObject) {
        _inspectionType = aObject;
        UIButton* btn = _searchBar.buttons[2];
        [btn setTitle:_inspectionType.name forState:UIControlStateNormal];
    }else{
        _inspectionType = nil;
    }
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:2];
    [self refreshPramsAndTable];
}

#pragma -mark InspectionTypeDelegate
-(void)inspectionSearch:(InspectionTypeViewController *)controller didSelectWithObject:(id)aObject{
    if (aObject) {
        _inspectionCategory = aObject;
        UIButton* btn = _searchBar.buttons[1];
        [btn setTitle:_inspectionCategory.name forState:UIControlStateNormal];
    }else{
        _inspectionCategory = nil;
    }
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:1];
    [self refreshPramsAndTable];
}
#pragma -mark DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"部门选中个数:%d",departments.count);
    _checkDepartments = [departments retain];
    UIButton* btn = _searchBar.buttons[0];
    NSMutableString* sb = [[[NSMutableString alloc] init] autorelease];
    int i = 0;
    for (Department* item in departments) {
        if (i > 5) {
            break;
        }
        [sb appendFormat:@"%@,",item.name];
        i++;
    }
    [btn setTitle:departments.count > 0 ? [sb substringToIndex:sb.length - 1] : _searchBar.titles[0] forState:UIControlStateNormal];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:0];
    [self refreshPramsAndTable];
}
-(void)allInspect {
    UIButton* btn = _searchBar.buttons[1];
    [btn setTitle:@"全部类型" forState:UIControlStateNormal];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:2];
   
    _inspectionCategory = nil;
    [self refreshPramsAndTable];

}
-(void)allTarget {
    UIButton* btn = _searchBar.buttons[2];
    [btn setTitle:@"全部类型" forState:UIControlStateNormal];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:2];
    
    _inspectionType = nil;
    [self refreshPramsAndTable];


}
#pragma -mark HeaderSearchBarDelegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    if (index == current) {
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        return;
    }
    [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
    [UIView removeViewFormSubViews:index views:_searchViews];
}

#pragma -mark 窗体方法
- (void)viewWillAppear:(BOOL)animated
{
    
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
    if (inspectionArray.count > 0){
        [inspectionArray removeAllObjects];
    }
}

-(void)didFinishedSearchWithResult:(InspectionReportParams_Builder *)result{
    InspectionReportParams_Builder* pp = (InspectionReportParams_Builder *)result;
    [pp setPage:currentPage];
    inspectionParams = [[pp build] retain];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (inspectionArray.count > 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.pullTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
    
    //[self clearTable];
    //[self refreshTable];
}

- (void) didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeInspectionReportList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageInspectionReport* pageInspectionReport = [PageInspectionReport parseFromData:cr.data];
        if ([super validateData:pageInspectionReport]) {
            int inspectionCount = pageInspectionReport.inspectionReports.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < inspectionCount;i++){
                InspectionReport* p = (InspectionReport*)[[pageInspectionReport inspectionReports] objectAtIndex:i];
                [inspectionArray addObject:p];
                
            }
            pageSize = pageInspectionReport.page.pageSize;
            totleSize = pageInspectionReport.page.totalSize;
            
            if (inspectionArray.count == 0) {
                [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_INSPECTION_DES)                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
        }
    }
    
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeInspectionReportReply) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])) {
        [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"inspectionreply_msg_saved", @"")];
        
        if (currentInspection != nil){
            [inspectionArray removeObjectAtIndex:currentRow];
            [inspectionArray insertObject:currentInspection atIndex:currentRow];
            
            [self.pullTableView reloadData];
        }
    }
    
    [super showMessage2:cr Title:TITLENAME_LIST(FUNC_INSPECTION_DES) Description:@""];
    [self.pullTableView reloadData];
    
    self.pullTableView.pullTableIsRefreshing = NO;
    self.pullTableView.pullTableIsLoadingMore = NO;
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
    [pullTableView release];
    [super dealloc];
}

-(void)openSearchView{
    
    InspectionSearchViewController *ctrl = [[InspectionSearchViewController alloc] init];
    ctrl.delegate = self;
    UINavigationController *searchNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentModalViewController:searchNavCtrl animated:YES];
    //[ctrl release];
    //[searchNavCtrl release];
    
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = YES;
    currentPage = 1;
    if (inspectionParams != nil){
        InspectionReportParams_Builder* pb = [inspectionParams toBuilder];
        [pb setPage:1];
        inspectionParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeInspectionReportList param:inspectionParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_INSPECTION_DES)
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
        InspectionReportParams_Builder* pb = [inspectionParams toBuilder];
        [pb setPage:currentPage];
        inspectionParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeInspectionReportList param:inspectionParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_INSPECTION_DES)
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
    
    return 115.f;
    
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
    return  [inspectionArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    PatrolTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolTableCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[PatrolTableCell class]])
                cell=(PatrolTableCell *)oneObject;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    InspectionReport *inspection = [inspectionArray objectAtIndex:indexPath.row];
    [cell.icon setImageWithURL:[NSURL URLWithString:[inspection.filePath objectAtIndex:0]] refreshCache:YES placeholderImage:[UIImage imageNamed:@"ic_default_rect_pic"]];
    cell.title.text = inspection.inspectionReportCategory.name;
    cell.subTitle1.text = ((InspectionTarget *)[inspection.inspectionTargets objectAtIndex:0]).name;
    cell.subTitle2.text = inspection.content;
    cell.subTitle2.textColor = RGBA(7,178,205,1.0);
    cell.name.text = inspection.user.realName;
    cell.time.text = [NSDate dateWithFormatTodayOrYesterday: inspection.createDate];
    
    cell.btApprove.tag = indexPath.section;
    [cell.btApprove addTarget:self action:@selector(toReply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btApprove.layer setMasksToBounds:YES];
    [cell.btApprove.layer setCornerRadius:8.0];
    [cell.btApprove setBackgroundColor:WT_GREEN];
    [cell.btApprove setTitleColor:WT_WHITE forState:UIControlStateNormal];
    if (inspection.inspectionReportReplies.count > 0){
        cell.btApprove.hidden = NO;
        [cell.btApprove setTitle:NSLocalizedString(@"已批复", nil) forState:UIControlStateNormal];
        //[cell.btApprove setBackgroundImage:[UIImage imageNamed:@"bg_msgbox_state_unfinish"] forState:UIControlStateNormal] ;
        cell.btApprove.frame = CGRectMake(MAINWIDTH-40-10, 6, 40, 20);
        [cell.btApprove setBackgroundColor:WT_GREEN];
        [cell.btApprove setTitleColor:WT_WHITE forState:UIControlStateNormal];
        
    }else{
        if (USER.id != inspection.user.id){
            cell.btApprove.hidden = YES;
            [cell.btApprove setTitle:NSLocalizedString(@"worklog_unapproval", nil) forState:UIControlStateNormal];
            //[cell.btApprove setBackgroundImage:[UIImage imageNamed:@"bg_msgbox_state_read"] forState:UIControlStateNormal];
            [cell.btApprove setBackgroundColor:WT_GREEN];
            [cell.btApprove setTitleColor:WT_WHITE forState:UIControlStateNormal];
            
        }
        else{
            cell.btApprove.hidden = YES;
        }
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showInspectionReport:[inspectionArray objectAtIndex:indexPath.row]];
    
}

-(void)showInspectionReport:(InspectionReport *)inspection{
    
    InspectionDetailViewController *ctrl = [[InspectionDetailViewController alloc] init];
    ctrl.inspection = nil;
    ctrl.inspectionId = inspection.id;
    ctrl.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
    
}

-(void)toReply:(id)sender{
    UIView *view = (UIView*)sender;
    InspectionReport* inspection = [inspectionArray objectAtIndex:view.tag];
    
    if (inspection.inspectionReportReplies.count > 0){
        [self showInspectionReport:inspection];
        return;
    }
    
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    ctrl.tag = view.tag;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) didFinishInput:(int)tag Input:(NSString *)input{
    int inspectionId = ((InspectionReport*)[inspectionArray objectAtIndex:tag]).id;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    InspectionReportReply_Builder* prb = [InspectionReportReply builder];
    [prb setContent:input];
    [prb setCreateDate:[NSDate getCurrentTime]];
    [prb setInspectionReportId:inspectionId];
    [prb setId:-1];
    
    currentRow = tag;
    InspectionReport* inspection = [[inspectionArray objectAtIndex:tag] retain];
    NSMutableArray* inspectionReplies = [[NSMutableArray alloc] initWithCapacity:1];
    InspectionReportReply* pr = [[prb build] retain];
    [inspectionReplies addObject:pr];
    
    InspectionReport_Builder* pb =[inspection toBuilder];
    [pb setInspectionReportRepliesArray:inspectionArray];
    currentInspection = [[pb build] retain];
    
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeInspectionReportReply param:pr]){
        [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_INSPECTION_DES)
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

- (void) refresh:(InspectionReport *)inspection{
    for (int i = 0; i < inspectionArray.count; i++) {
        if (((InspectionReport*)[inspectionArray objectAtIndex:i]).id == inspection.id){
            [inspectionArray removeObjectAtIndex:i];
            [inspectionArray insertObject:inspection atIndex:i];
            
            [self.pullTableView reloadData];
            
            break;
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
