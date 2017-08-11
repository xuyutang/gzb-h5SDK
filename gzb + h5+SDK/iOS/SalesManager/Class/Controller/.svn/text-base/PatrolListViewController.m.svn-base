//
//  PatrolListViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/4/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "PatrolListViewController.h"
#import "PatrolTableCell.h"
#import "PatrolSearch2ViewController.h"
#import "SDImageView+SDWebCache.h"
#import "PatrolDetail2ViewController.h"
#import "MessageBarManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "InputViewController.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"
#import "UIView+Util.h"
#import "PatrolTypeViewController.h"
#import "CustNameAndNameFilterViewController.h"
#import "DropMenu.h"
#import "FileHelper.h"

@interface PatrolListViewController ()<HeaderSearchBarDelegate,DepartmentViewControllerDelegate,CustomerCategoryDelegate,PatrolTypeDelegate,CustNameAndNameDelegate,DropMenuDelegate>

@end

@implementation PatrolListViewController
{
    HeaderSearchBar*_searchBar;
    NSMutableArray* _searchViews;
    NSMutableArray* _departments;
    NSMutableArray* _checkDepartments;
    NSMutableArray* _localCustsCategorys;
    NSMutableArray* _custmoes;
    CustomerCategory* _customeCategory;
    PatrolCategory* _patrolType;
    NSString*       _custName;
    NSString*       _name;
    NSString*       _formTiem;
    NSString*       _endTime;
}
@synthesize patrolArray,patrolParams;

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
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    _departments = [[NSMutableArray alloc] initWithCapacity:0];
    [_departments addObjectsFromArray:[LOCALMANAGER getDepartments]];
    _custmoes = [[NSMutableArray alloc] initWithCapacity:0];
    _localCustsCategorys = [[NSMutableArray alloc] initWithCapacity:0];
    
    //搜索栏
    NSMutableArray* icons = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    NSMutableArray* titles = [NSMutableArray arrayWithObjects:@"部门",@"客户类型",@"类型",@"筛选", nil];
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    _searchBar.icontitles = icons;
    _searchBar.titles = titles;
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchBar];
    
    //加入视图计算Rect
    CGRect tmpFrame = _pullTableView.frame;
    tmpFrame.size.height = MAINHEIGHT - 45;
    //部门
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.departmentArray = _departments;
    departmentVC.delegate = self;
    departmentVC.view.frame = tmpFrame;
    [self addChildViewController:departmentVC];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    [departmentVC release];
    //初始化视图
    DropMenu* dropMenu1 = [[DropMenu alloc] initWithFrame:tmpFrame];
    dropMenu1.delegate = self;
    dropMenu1.menuCount = 1;
    [_localCustsCategorys addObjectsFromArray:[LOCALMANAGER getCustomerCategories]];
    [_custmoes removeAllObjects];
    [_custmoes addObject:@"全部类型"];
    for (CustomerCategory* item in _localCustsCategorys) {
        [_custmoes addObject:item.name];
    }
    dropMenu1.array1 = [[NSMutableArray alloc] initWithArray:_custmoes];
    [dropMenu1 initMenu];
    [_searchViews addObject:dropMenu1];
    [dropMenu1 release];
    
    
    
    //巡访类型
    PatrolTypeViewController* patrolTypeVC = [[PatrolTypeViewController alloc] init];
    patrolTypeVC.delegate = self;
    patrolTypeVC.bNeedAll = YES;
    patrolTypeVC.bFavorate = NO;
    patrolTypeVC.hidenBool = YES;
    patrolTypeVC.allBool = YES;
    tmpFrame = _pullTableView.frame;
    tmpFrame.size.height = MAINHEIGHT - 45;
    patrolTypeVC.view.frame = tmpFrame;
    [self addChildViewController:patrolTypeVC];
    patrolTypeVC = self.childViewControllers[1];
    [_searchViews addObject:patrolTypeVC.view];
    [patrolTypeVC release];
    
    CustNameAndNameFilterViewController* custNameFilterVC =  [[NSBundle mainBundle] loadNibNamed:@"CustNameAndNameFilterViewController" owner:nil options:nil][0];
    custNameFilterVC.frame = tmpFrame;
    custNameFilterVC.delegate = self;
    [self initFilterViewParams:custNameFilterVC];
    [_searchViews addObject:custNameFilterVC];
    
    //表数据
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.backgroundColor = [UIColor whiteColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    
    
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
    currentPatrol = nil;
    currentRow = 0;
    patrolArray = [[NSMutableArray alloc] init];
    
    [lblFunctionName setText:TITLENAME_LIST(FUNC_PATROL_DES)];
    
    AGENT.delegate = self;
    
    if (bNeedBack) {
       leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
    if (patrolParams != nil)
        [self refreshTable];
    else
        [self refreshParamsAndTable];
}


-(void) initFilterViewParams:(CustNameAndNameFilterViewController *) vc{
    if (patrolParams.users.count > 0) {
        vc.txtName.text = ((User *)[patrolParams.users objectAtIndex:0]).realName;
    }else if (patrolParams.customers.count > 0){
        vc.txtCustName.text = ((Customer *)[patrolParams.customers objectAtIndex:0]).name;
    }
}

#pragma -mark 参数更新
-(void) refreshParamsAndTable{
    [self refreshParams];
    [self refreshTable];
}

-(void) refreshParams{
    PatrolParams_Builder* baseParams = [PatrolParams builder];
    [baseParams setPage:1];
    if (_checkDepartments && _checkDepartments.count > 0) {
        [baseParams setDepartmentsArray:_checkDepartments];
    }else{
        [baseParams clearDepartments];
    }
    if (_customeCategory) {
        [baseParams setCustomerCategoryArray:[NSArray arrayWithObject:_customeCategory]];
    }else{
        [baseParams clearCustomerCategory];
    }
    if (_patrolType) {
        [baseParams setCategory:_patrolType];
    }else{
        [baseParams clearCategory];
    }
    if (_formTiem && _formTiem.length > 0) {
        [baseParams setStartDate:_formTiem];
    }
    if (_endTime && _endTime.length > 0) {
        [baseParams setEndDate:_endTime];
    }
    if (_custName && _custName.length > 0) {
        Customer_Builder* cust = [Customer builder];
        [cust setId:0];
        [cust setName:_custName];
        Customer* tmpcust = [[cust build] retain];
        [baseParams setCustomersArray:[NSArray arrayWithObject:tmpcust]];
    }
    if (_name) {
        User_Builder* u = [User builder];
        [u setRealName:_name];
        [u setId:0];
        User* user = [[u build] retain];
        [baseParams setUsersArray:[NSArray arrayWithObject:user]];
    }
    self.patrolParams = [[baseParams build] retain];
}


#pragma -mark HeaderSearchDelegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    NSLog(@"导航点击:%d",index);
    if (index == current) {
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        return;
    }
    [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
    [UIView removeViewFormSubViews:index views:_searchViews];
}

#pragma -mark CustNameAndNameDelegate
-(void)CustNameAndNameSearchClick:(NSString *)custName name:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"搜索参数:%@,%@,%@,%@",custName,name,formTime,endTime);
    _custName = custName;
    _name = name;
    _formTiem = formTime;
    _endTime = endTime;
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:3];
    [self refreshParamsAndTable];
}
#pragma -mark PatrolTypeDelegate 
-(void)patrolSearch:(PatrolTypeViewController *)controller didSelectWithObject:(id)aObject{
    _patrolType = aObject;
    NSLog(@"选择巡访类型:%@",_patrolType.name);
    UIButton* btn = _searchBar.buttons[2];
    [btn setTitle:_patrolType.name forState:UIControlStateNormal];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:2];
    [self refreshParamsAndTable];
}

-(void)allCatgory {
    UIButton* btn = _searchBar.buttons[2];
    [btn setTitle:@"全部类型" forState:UIControlStateNormal];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:2];
    _patrolType = nil;
    
    [self refreshParamsAndTable];
 
}

#pragma -mark DropMenuDelegate
-(void)selectedDropMenuIndex:(int)index row:(int)row{
    NSLog(@"%@",_custmoes[row]);
    UIButton* btn = _searchBar.buttons[1];
    [btn setTitle:_custmoes[row] forState:UIControlStateNormal];
    if (row == 0) {
        _customeCategory = nil;
    }else{
        _customeCategory = _localCustsCategorys[row - 1];
    }
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:1];
    [self refreshParamsAndTable];
}

#pragma -mark DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"选择了%d个部门",departments.count);
    _checkDepartments = [departments retain];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:0];
    //设置标题
    NSMutableString* sb = [[[NSMutableString alloc] init] autorelease];
    for (Department* item in departments) {
        if (item) {
            [sb appendFormat:@"%@,",item.name];
        }
    }
    UIButton* btn = _searchBar.buttons[0];
    [btn setTitle:departments.count > 0 ? [sb substringToIndex:sb.length - 1] : _searchBar.titles[0] forState:UIControlStateNormal];
    //更新数据
    [self refreshParamsAndTable];
}

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
    if (patrolArray.count > 0){
        [patrolArray removeAllObjects];
    }
}

-(void)didFinishedSearchWithResult:(PatrolParams_Builder *)result{
    PatrolParams_Builder* pp = (PatrolParams_Builder *)result;
    [pp setPage:currentPage];
    patrolParams = [[pp build] retain];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (patrolArray.count > 0) {
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
    if ((INT_ACTIONTYPE(cr.type) == ActionTypePatrolList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PagePatrol* pagePatrol = [PagePatrol parseFromData:cr.data];
        if ([super validateData:pagePatrol]) {
            int patrolCount = pagePatrol.patrols.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < patrolCount;i++){
                Patrol* p = (Patrol*)[[pagePatrol patrols] objectAtIndex:i];
                [patrolArray addObject:p];
                
            }
            pageSize = pagePatrol.page.pageSize;
            totleSize = pagePatrol.page.totalSize;
            
            if (patrolArray.count == 0) {
                [MESSAGE showMessageWithTitle:[NSString stringWithFormat:@"%@列表",TITLENAME(FUNC_PATROL_DES)]
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
        }
    }
    
    if ((INT_ACTIONTYPE(cr.type) == ActionTypePatrolReply) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])) {
        [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"patrolreply_msg_saved", @"")];
        
        if (currentPatrol != nil){
            Patrol_Builder* wb = [currentPatrol toBuilder];
            [wb setReplyCount:currentPatrol.replyCount+1];
            [patrolArray removeObjectAtIndex:currentRow];
            [patrolArray insertObject:[wb build] atIndex:currentRow];
            
            [self.pullTableView reloadData];
        }
    }
    
    [super showMessage2:cr Title:[NSString stringWithFormat:@"%@列表",TITLENAME(FUNC_PATROL_DES)]
     Description:@""];
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

    PatrolSearch2ViewController *ctrl = [[PatrolSearch2ViewController alloc] init];
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
    if (patrolParams != nil){
        PatrolParams_Builder* pb = [patrolParams toBuilder];
        [pb setPage:1];
        patrolParams = [[pb build] retain];

        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypePatrolList param:patrolParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_PATROL_DES)

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
        PatrolParams_Builder* pb = [patrolParams toBuilder];
        [pb setPage:currentPage];
        patrolParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypePatrolList param:patrolParams]){
            [MESSAGE showMessageWithTitle:[NSString stringWithFormat:@"%@列表",TITLENAME(FUNC_PATROL_DES)]

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
    return [patrolArray count];
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
    
    Patrol *patrol = [patrolArray objectAtIndex:indexPath.row];
    [cell.icon setImageWithURL:[NSURL URLWithString:[patrol.filePath objectAtIndex:0]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_default_rect_pic"]];
    cell.subTitle1.text = patrol.customer.name;
    cell.title.text = [NSString stringWithFormat:@"%@",patrol.customer.category.name];
    cell.subTitle2.text = patrol.content;
    cell.name.text = patrol.user.realName;
    cell.time.text = [NSDate dateWithFormatTodayOrYesterday: patrol.createDate];
    cell.parentVC = self;
    if (patrol.videoPaths.count > 0) {
        NSString *videSizeStr = [NSString stringWithFormat:@"%@",[patrol.videoSizes objectAtIndex:0]];
        cell.videoSize = videSizeStr;
        cell.videoPath = [patrol.videoPaths objectAtIndex:0];
    }
    cell.btApprove.tag = indexPath.section;
//    [cell.btApprove addTarget:self action:@selector(toReply:) forControlEvents:UIControlEventTouchUpInside];
    cell.btApprove.frame = CGRectMake(MAINWIDTH - 45, 6, 30, 30);
    [cell.btApprove.layer setMasksToBounds:YES];
    [cell.btApprove.layer setCornerRadius:15.0];
    cell.btApprove.layer.borderWidth = 1;
    cell.btApprove.layer.borderColor = [UIColor grayColor].CGColor;
    
    [cell.btApprove setBackgroundColor:[UIColor clearColor]];
    [cell.btApprove setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    if (patrol.replyCount > 0){
        [cell.btApprove setTitle:[NSString stringWithFormat:@"%d",patrol.replyCount] forState:UIControlStateNormal];
    }else{
        cell.btApprove.hidden = YES;
    }
    /*
    if (patrol.patrolReplies.count > 0){
        cell.btApprove.hidden = NO;
        [cell.btApprove setTitle:NSLocalizedString(@"worklog_approval", nil) forState:UIControlStateNormal];
        [cell.btApprove setBackgroundImage:[UIImage imageNamed:@"bg_msgbox_state_unfinish"] forState:UIControlStateNormal] ;
        
    }else{
        
        if (USER.id != patrol.user.id){
            cell.btApprove.hidden = NO;
            [cell.btApprove setTitle:NSLocalizedString(@"worklog_unapproval", nil) forState:UIControlStateNormal];
            [cell.btApprove setBackgroundImage:[UIImage imageNamed:@"bg_msgbox_state_read"] forState:UIControlStateNormal];

        }
        else{
            cell.btApprove.hidden = YES;
        }
    }*/

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self showPatrol:[patrolArray objectAtIndex:indexPath.row]];
    
}

-(void)showPatrol:(Patrol *)patrol{
    PatrolDetail2ViewController *ctrl = [[PatrolDetail2ViewController alloc] init];
    ctrl.patrolId = patrol.id;
    ctrl.delegate = self;
    ctrl.bNeedBack = YES;
//    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)toReply:(id)sender{
    UIView *view = (UIView*)sender;
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    ctrl.tag = view.tag;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) didFinishInput:(int)tag Input:(NSString *)input{
    int patrolId = ((Patrol*)[patrolArray objectAtIndex:tag]).id;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    PatrolReply_Builder* prb = [PatrolReply builder];
    [prb setContent:input];
    [prb setCreateDate:[NSDate getCurrentTime]];
    [prb setPatrolId:patrolId];
    [prb setId:-1];
    
    currentRow = tag;
    Patrol* patrol = [[patrolArray objectAtIndex:tag] retain];
    NSMutableArray* patrolReplies = [[NSMutableArray alloc] initWithCapacity:1];
    PatrolReply* pr = [[prb build] retain];
    [patrolReplies addObject:pr] ;

    currentPatrol = patrol;
    //mrak
//    currentPatrol = [[prb build] retain];
    
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypePatrolReply param:pr]){
        [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_PATROL_DES)
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
    if (![obj isKindOfClass:[Patrol class]]) {
        return;
    }
    Patrol* patrol = (Patrol*)obj;
    for (int i = 0; i < patrolArray.count; i++) {
        if (((Patrol*)[patrolArray objectAtIndex:i]).id == patrol.id){
            [patrolArray removeObjectAtIndex:i];
            [patrolArray insertObject:patrol atIndex:i];
            
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
