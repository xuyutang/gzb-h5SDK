//
//  ResearchListViewController.m
//  SalesManager
//
//  Created by ZhangLi on 14-1-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "ResearchListViewController.h"
#import "PatrolTableCell.h"
#import "SearchViewController.h"
#import "SDImageView+SDWebCache.h"
#import "ResearchDetailViewController.h"
#import "MessageBarManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"
#import "DropMenu.h"
#import "CustNameAndNameFilterViewController.h"
#import "UIView+Util.h"

@interface ResearchListViewController ()<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate,HeaderSearchBarDelegate,DepartmentViewControllerDelegate,DropMenuDelegate,CustNameAndNameDelegate>

@end

@implementation ResearchListViewController
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
}
@synthesize pullTableView,marketResearchParams;
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
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    self.pullTableView.backgroundColor =[UIColor whiteColor];
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
    
    researchArray = [[NSMutableArray alloc] init];
    
    [lblFunctionName setText:TITLENAME_LIST(FUNC_RESEARSH_DES)];
    
    AGENT.delegate = self;
    
    if (marketResearchParams == nil) {
        //[self openSearchView];
        [self refreshParamsAndTable];
    }else{
        [self refreshTable];
    }
    
}

-(void) initFilterViewParams:(CustNameAndNameFilterViewController *) vc{
    if (marketResearchParams.users.count > 0) {
        vc.txtName.text = ((User *)[marketResearchParams.users objectAtIndex:0]).realName;
    }else if (marketResearchParams.customers.count > 0){
        vc.txtCustName.text = ((Customer *)[marketResearchParams.customers objectAtIndex:0]).name;
    }
}
#pragma -mark 搜索参数封装
-(void) refreshParamsAndTable{
    [self refreshParams];
    [self refreshTable];
}
-(void) refreshParams{
    MarketResearchParams_Builder* bsp = [MarketResearchParams builder];
    [bsp setPage:1];
    if (_checkDepartments && _checkDepartments.count > 0) {
        [bsp setDepartmentsArray:_checkDepartments];
    }else{
        [bsp clearDepartments];
    }
    if (_custCategory) {
        [bsp setCustomerCategoryArray:[NSArray arrayWithObject:_custCategory]];
    }else{
        [bsp clearCustomerCategory];
    }
    if (_custName && _custName.length > 0) {
        Customer_Builder* cb = [Customer builder];
        [cb setId:0];
        [cb setName:_custName];
        [bsp setCustomersArray:[NSArray arrayWithObject:[cb build]]];
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
    if (_endTime && _endTime.length > 0) {
        [bsp setEndDate:_endTime];
    }
    self.marketResearchParams = [[bsp build] retain];
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
    if (researchArray.count > 0){
        [researchArray removeAllObjects];
    }
}

-(void)didFinishedSearchWithResult:(MarketResearchParams_Builder *)result{
    MarketResearchParams_Builder* pp = (MarketResearchParams_Builder *)result;
    [pp setPage:currentPage];
    marketResearchParams = [[pp build] retain];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (researchArray.count > 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.pullTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
}

- (void) didReceiveMessage:(id)message{
    HUDHIDE;
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeMarketresearchList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageMarketResearch* pageMarketResearch = [PageMarketResearch parseFromData:cr.data];
        if ([super validateData:pageMarketResearch]) {
            int patrolCount = pageMarketResearch.marketResearchs.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < patrolCount;i++){
                MarketResearch* p = (MarketResearch*)[[pageMarketResearch marketResearchs] objectAtIndex:i];
                [researchArray addObject:p];
                
            }
            pageSize = pageMarketResearch.page.pageSize;
            totleSize = pageMarketResearch.page.totalSize;
            
            if (researchArray.count == 0) {
                [MESSAGE showMessageWithTitle:[NSString stringWithFormat:@"%@列表",TITLENAME(FUNC_RESEARSH_DES)]
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
        }
    }
    
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeMarketresearchReply) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])) {
        [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"research_msg_reply", @"")];
        
        if (currentMarketResearch != nil){
            [researchArray removeObjectAtIndex:currentRow];
            [researchArray insertObject:currentMarketResearch atIndex:currentRow];
            
            [self.pullTableView reloadData];
        }
    }

    [super showMessage2:cr Title:[NSString stringWithFormat:@"%@列表",TITLENAME(FUNC_RESEARSH_DES)] Description:@""];
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
    
    ResearchSearchViewController *ctrl = [[ResearchSearchViewController alloc] init];
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
    if (marketResearchParams != nil){
        MarketResearchParams_Builder* pb = [marketResearchParams toBuilder];
        [pb setPage:1];
        marketResearchParams = [[pb build] retain];
    
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeMarketresearchList param:marketResearchParams]){
            [MESSAGE showMessageWithTitle:[NSString stringWithFormat:@"%@列表",TITLENAME(FUNC_RESEARSH_DES)]
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
        MarketResearchParams_Builder* pb = [marketResearchParams toBuilder];
        [pb setPage:currentPage];
        marketResearchParams = [[pb build] retain];

        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeMarketresearchList param:marketResearchParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_RESEARSH_DES)
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
    return [researchArray count];
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
    
    MarketResearch *marketResearch = [researchArray objectAtIndex:indexPath.row];
    [cell.icon setImageWithURL:[NSURL URLWithString:[marketResearch.filePath objectAtIndex:0]] refreshCache:YES placeholderImage:[UIImage imageNamed:@"ic_default_rect_pic"]];
    cell.subTitle1.text = marketResearch.customer.name;
    cell.title.text = [NSString stringWithFormat:@"%@",marketResearch.customer.category.name];
    cell.subTitle2.text = marketResearch.remarks;
    cell.name.text = marketResearch.user.realName;
    cell.time.text = [NSDate dateWithFormatTodayOrYesterday: marketResearch.createDate];
    
    cell.btApprove.tag = indexPath.section;
    [cell.btApprove addTarget:self action:@selector(toReply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btApprove.layer setMasksToBounds:YES];
    [cell.btApprove.layer setCornerRadius:8.0];
    if (marketResearch.marketResearchReplies.count > 0){
        cell.btApprove.hidden = NO;
        [cell.btApprove setTitle:NSLocalizedString(@"worklog_approval", nil) forState:UIControlStateNormal];
        //[cell.btApprove setBackgroundImage:[UIImage imageNamed:@"bg_msgbox_state_unfinish"] forState:UIControlStateNormal] ;
        [cell.btApprove setBackgroundColor:WT_GREEN];
        [cell.btApprove setTitleColor:WT_WHITE forState:UIControlStateNormal];
        
    }else{
        if (USER.id != marketResearch.user.id){
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
    
    [self showDetail:[researchArray objectAtIndex:indexPath.row]];

}

-(void)showDetail:(MarketResearch *)marketResearch{
    
    ResearchDetailViewController *ctrl = [[ResearchDetailViewController alloc] init];
    ctrl.currentMarketResearch = nil;
    ctrl.martketresearchId = marketResearch.id;
    ctrl.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
    
}

-(void)toReply:(id)sender{
    UIView *view = (UIView*)sender;
    MarketResearch* marketResearch = [researchArray objectAtIndex:view.tag];
    
    if (marketResearch.marketResearchReplies.count > 0){
        [self showDetail:marketResearch];
        return;
    }
    
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    ctrl.tag = view.tag;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) didFinishInput:(int)tag Input:(NSString *)input{
    int patrolId = ((MarketResearch*)[researchArray objectAtIndex:tag]).id;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    MarketResearchReply_Builder* prb = [MarketResearchReply builder];
    
    [prb setContent:input];
    [prb setCreateDate:[NSDate getCurrentTime]];
    
    [prb setMarketResearchId:patrolId];
    [prb setId:-1];
    
    currentRow = tag;
    MarketResearch* marketResearch = [[researchArray objectAtIndex:tag] retain];
    NSMutableArray* marketResearchReplies = [[NSMutableArray alloc] initWithCapacity:1];
    MarketResearchReply* pr = [[prb build] retain];
    [marketResearchReplies addObject:pr] ;
    
    MarketResearch_Builder* mr = [marketResearch toBuilder];
    [mr setMarketResearchRepliesArray:marketResearchReplies];
    
    currentMarketResearch = [[mr build] retain];
    
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeMarketresearchReply param:pr]){
        [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_RESEARSH_DES)
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
