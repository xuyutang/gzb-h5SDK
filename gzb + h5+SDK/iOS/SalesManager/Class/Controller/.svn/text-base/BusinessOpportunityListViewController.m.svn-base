//
//  BusinessOpportunityListViewController.m
//  SalesManager
//
//  Created by 章力 on 14-5-6.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BusinessOpportunityListViewController.h"
#import "BusinessOpportunityCell.h"
#import "SearchViewController.h"
#import "SDImageView+SDWebCache.h"
#import "ResearchDetailViewController.h"
#import "MessageBarManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "InputViewController.h"
#import "BusinessOpportunityDetailViewController.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"
#import "DropMenu.h"
#import "CustNameAndNameFilterViewController.h"
#import "UIView+Util.h"

@interface BusinessOpportunityListViewController ()<InputFinishDelegate,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate,HeaderSearchBarDelegate,DepartmentViewControllerDelegate,DropMenuDelegate,CustNameAndNameDelegate>

@end

@implementation BusinessOpportunityListViewController
{
    HeaderSearchBar*    _searchBar;
    NSMutableArray*     _searchViews;
    NSMutableArray*     _departments;
    NSMutableArray*     _checkDepartments;
    NSMutableArray*     _custCategorys;
    NSMutableArray*     _customeList;
    CustomerCategory*   _custCategory;
    NSString*           _custName;
    NSString*           _name;
    NSString*           _formTime;
    NSString*           _endTime;
     User *user;
}
@synthesize pullTableView,businessOpportunityParams;
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
    
    //初始化搜索栏数据
    //初始化SearchBar
    _searchViews = [[NSMutableArray alloc] initWithCapacity:2];
    _departments = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getDepartments]];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    _custCategorys = [[NSMutableArray alloc] initWithCapacity:0];
    [_custCategorys addObjectsFromArray:[LOCALMANAGER getCustomerCategories]];
    _customeList = [[NSMutableArray alloc] initWithCapacity:0];
    [_customeList removeAllObjects];
    [_customeList addObject:@"全部类型"];
    for (Customer* item in _custCategorys) {
        [_customeList addObject:item.name];
    }
    //加入视图计算Rect
    CGRect tmpFrame = self.pullTableView.frame;
    tmpFrame.size.height = MAINHEIGHT - 45;
    //搜索导航
    NSMutableArray* icons = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    NSMutableArray* titles = [NSMutableArray arrayWithObjects:@"部门",@"客户类型",@"筛选", nil];
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    _searchBar.delegate = self;
    _searchBar.icontitles = icons;
    _searchBar.titles = titles;
    _searchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchBar];
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = _departments;
    departmentVC.view.frame = tmpFrame;
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    //客户类型
    DropMenu* custCategoryView = [[DropMenu alloc] initWithFrame:tmpFrame];
    custCategoryView.array1 = _customeList;
    custCategoryView.menuCount = 1;
    custCategoryView.delegate = self;
    [custCategoryView initMenu];
    [_searchViews addObject:custCategoryView];
    [custCategoryView release];
    //客户筛选
    CustNameAndNameFilterViewController* custNameFilterVC = [[NSBundle mainBundle] loadNibNamed:@"CustNameAndNameFilterViewController" owner:nil options:NULL][0];
    custNameFilterVC.delegate = self;
    custNameFilterVC.frame = tmpFrame;
    [self initFilterViewParams:custNameFilterVC];
    [_searchViews addObject:custNameFilterVC];
    
    //表数据
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    self.pullTableView.tableFooterView = [[UIView alloc]init];
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    
    currentPage = 1;
    currentBiz = nil;
    currentRow = 0;
    
    bizArray = [[NSMutableArray alloc] init];
    
    [lblFunctionName setText:TITLENAME_LIST(FUNC_BIZOPP_DES)];
    
    AGENT.delegate = self;
    if (businessOpportunityParams == nil) {
        //[self openSearchView];
        [self refreshParamsAndTable];
    }else{
        [self refreshTable];
    }
}

-(void) initFilterViewParams:(CustNameAndNameFilterViewController *) vc{
    if (businessOpportunityParams.users.count > 0) {
        vc.txtName.text = ((User *)[businessOpportunityParams.users objectAtIndex:0]).realName;
    }else if (businessOpportunityParams.customers.count > 0){
        vc.txtCustName.text = ((Customer *)[businessOpportunityParams.customers objectAtIndex:0]).name;
    }
}
#pragma -mark 搜索参数封装
-(void) refreshParamsAndTable{
    [self refreshParams];
    [self refreshTable];
}
-(void) refreshParams{
    BusinessOpportunityParams_Builder* cg = [BusinessOpportunityParams builder];
    [cg setPage:1];
    if (_checkDepartments && _checkDepartments.count > 0) {
        [cg setDepartmentsArray:_checkDepartments];
    }else{
        [cg clearDepartments];
    }
    if (_custCategory) {
        [cg setCustomerCategoryArray:[NSArray arrayWithObject:_custCategory]];
    }else{
        [cg clearCustomerCategory];
    }
    if (_custName && _custName.length > 0) {
        Customer_Builder* ccb = [Customer builder];
        [ccb setId:0];
        [ccb setName:_custName];
        [cg setCustomersArray:[NSArray arrayWithObject:[ccb build]]];
    }
    if (_name && _name.length > 0) {
        User_Builder* u = [User builder];
        [u setId:0];
        [u setRealName:_name];
        [cg setUsersArray:[NSArray arrayWithObject:[u build]]];
    }
    if (_formTime && _formTime.length > 0) {
        [cg setStartDate:_formTime];
    }
    if (_endTime && _endTime.length > 0) {
        [cg setEndDate:_endTime];
    }
    self.businessOpportunityParams = [[cg build] retain];
}

#pragma -mark CustNameAndNameDelegate
-(void)CustNameAndNameSearchClick:(NSString *)custName name:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"搜索:%@,%@,%@,%@",custName,name,formTime,endTime);
    _custName = custName;
    _name = name;
    _formTime = formTime;
    _endTime = endTime;
    
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:2];
    [self refreshParamsAndTable];
}
#pragma -mark DropMenuDelegate
-(void)selectedDropMenuIndex:(int)index row:(int)row{
    NSLog(@"选择了类型:%@",_customeList[row]);
    UIButton* btn = _searchBar.buttons[1];
    [btn setTitle:_customeList[row] forState:UIControlStateNormal];
    if (row == 0) {
        _custCategory = nil;
    }else{
        _custCategory = _custCategorys[row - 1];
    }
    
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:1];
    [self refreshParamsAndTable];
}

#pragma -mark DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"选择了%d个部门",departments.count);
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
    [self refreshParamsAndTable];
}

#pragma -mark HeaderSearchDelegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    NSLog(@"选择了:%d",index);
    if (current == index) {
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        return;
    }
    [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
    [UIView removeViewFormSubViews:index views:_searchViews];
}

#pragma -mark 窗体方法与socket delegate
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
    if (bizArray.count > 0){
        [bizArray removeAllObjects];
    }
}

-(void)didFinishedSearchWithResult:(BusinessOpportunityParams_Builder *)result{
    BusinessOpportunityParams_Builder* pp = (BusinessOpportunityParams_Builder *)result;
    [pp setPage:currentPage];
    businessOpportunityParams = [[pp build] retain];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (bizArray.count > 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.pullTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeBusinessopportunityList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageBusinessOpportunity* pageBusinessOpportunity = [PageBusinessOpportunity parseFromData:cr.data];
        if ([super validateData:pageBusinessOpportunity]) {
            int bizCount = pageBusinessOpportunity.businessOpportunity.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < bizCount;i++){
                BusinessOpportunity* bo = (BusinessOpportunity*)[[pageBusinessOpportunity businessOpportunity] objectAtIndex:i];
                [bizArray addObject:bo];
            }
            pageSize = pageBusinessOpportunity.page.pageSize;
            totleSize = pageBusinessOpportunity.page.totalSize;
            
            if (bizArray.count == 0) {
                [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_BIZOPP_DES)
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
        }
    }
    
    if ((INT_ACTIONTYPE(cr.type)  == ActionTypeBusinessopportunityReply) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])) {
        [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"bizoppreply_msg_saved", @"")];
        
        if (currentBiz != nil){
            [bizArray removeObjectAtIndex:currentRow];
            [bizArray insertObject:currentBiz atIndex:currentRow];
            
            [self.pullTableView reloadData];
        }
    }
    
    [super showMessage2:cr Title:TITLENAME_LIST(FUNC_BIZOPP_DES) Description:@""];
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeBusinessopportunityList) || (INT_ACTIONCODE(cr.code) != ActionCodeDone)){
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
    [pullTableView release];
    [super dealloc];
}

-(void)openSearchView{
    
    BusinessOpportunitySearchViewController *ctrl = [[BusinessOpportunitySearchViewController alloc] init];
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
    if (businessOpportunityParams != nil){
        BusinessOpportunityParams_Builder* pb = [businessOpportunityParams toBuilder];
        [pb setPage:1];
        businessOpportunityParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeBusinessopportunityList param:businessOpportunityParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_BIZOPP_DES)
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
        BusinessOpportunityParams_Builder* ps = [businessOpportunityParams toBuilder];
        [ps setPage:currentPage];
        
       businessOpportunityParams = [[ps build] retain];
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeBusinessopportunityList param:businessOpportunityParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_BIZOPP_DES)
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWHEADERHEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.f;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [bizArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    BusinessOpportunityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"BusinessOpportunityCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[BusinessOpportunityCell class]])
                cell=(BusinessOpportunityCell *)oneObject;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BusinessOpportunity *bo = [bizArray objectAtIndex:indexPath.row];
    cell.customer.text = [NSString stringWithFormat:@"%@",bo.customer.name];
    cell.bizOppPrincipal.text = [NSString stringWithFormat:@"%@",bo.customer.category.name];
    cell.bizOppName.text = [NSString stringWithFormat:@"%@",bo.bizOppName];
    cell.user.text = bo.user.realName;
    cell.time.text = bo.createDate;
     NSString* avtar = @"";
    if (USER.avatars.count > 0) {
        avtar = [USER.avatars objectAtIndex:0];
    }
    [cell.userImageView setImageWithURL:[NSURL URLWithString:[bo.user.avatars objectAtIndex:0]] refreshCache:YES placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
 
    cell.btnApprove.tag = indexPath.row;
    [cell.btnApprove addTarget:self action:@selector(toReply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnApprove.layer setMasksToBounds:YES];
    [cell.btnApprove.layer setCornerRadius:5.0];
    cell.btnApprove.backgroundColor = WT_GREEN;
   
    if (bo.businessOpportunityReplies.count > 0){
        cell.btnApprove.hidden = NO;
        [cell.btnApprove setTitle:NSLocalizedString(@"worklog_approval", nil) forState:UIControlStateNormal];
        [cell.btnApprove setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[cell.btnApprove setBackgroundImage:[UIImage imageNamed:@"bg_msgbox_state_unfinish"] forState:UIControlStateNormal] ;
        
    }else{
        if (APPDELEGATE.currentUser.id != bo.user.id){
            cell.btnApprove.hidden = YES;
            [cell.btnApprove setTitle:NSLocalizedString(@"worklog_unapproval", nil) forState:UIControlStateNormal];
            [cell.btnApprove setBackgroundColor:[UIColor clearColor]];
            [cell.btnApprove setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //[cell.btnApprove setBackgroundImage:[UIImage imageNamed:@"bg_msgbox_state_read"] forState:UIControlStateNormal] ;
        }
        else{
            cell.btnApprove.hidden = YES;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self _showBizOppDetail:[bizArray objectAtIndex:indexPath.row]];
}

- (void) _showBizOppDetail:(BusinessOpportunity*) bo{
    
    BusinessOpportunityDetailViewController *ctrl = [[BusinessOpportunityDetailViewController alloc] init];
    ctrl.currentBizOpp = nil;
    ctrl.bizoppId = bo.id;
    ctrl.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)toReply:(id)sender{
    UIView *view = (UIView*)sender;
    BusinessOpportunity* bo = [bizArray objectAtIndex:view.tag];
    
    if (bo.businessOpportunityReplies.count > 0){
        [self _showBizOppDetail:bo];
        return;
    }
    
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    ctrl.tag = view.tag;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) didFinishInput:(int)tag Input:(NSString *)input{
    int bizId = ((WorkLog*)[bizArray objectAtIndex:tag]).id;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    BusinessOpportunityReply_Builder *br = [BusinessOpportunityReply builder];
    [br setContent:input];
    [br setCreateDate:[NSDate getCurrentTime]];
    [br setBusinessOpportunityId:bizId];
    [br setId:-1];
    
    currentRow = tag;
    BusinessOpportunity* bo = [[bizArray objectAtIndex:tag] retain];
    NSMutableArray* bizReplies = [[NSMutableArray alloc] initWithCapacity:1];
    BusinessOpportunityReply* bor = [[br build] retain];
    [bizReplies addObject:bor] ;
    
    BusinessOpportunity_Builder* pb =[bo toBuilder];
    [pb setBusinessOpportunityRepliesArray:bizReplies];
    currentBiz = [[pb build] retain];
    
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeBusinessopportunityReply param:bor]){
        [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_BIZOPP_DES)
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

- (void) refresh:(BusinessOpportunity *)bizopp{
    for (int i = 0; i < bizArray.count; i++) {
        if (((BusinessOpportunity*)[bizArray objectAtIndex:i]).id == bizopp.id){
            [bizArray removeObjectAtIndex:i];
            [bizArray insertObject:bizopp atIndex:i];
            
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
