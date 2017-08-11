//
//  GiftDeliveryListViewController.m
//  SalesManager
//
//  Created by 章力 on 14-9-23.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "GiftDeliveryListViewController.h"
#import "GiftDeliverySearchViewController.h"
#import "GiftDeliveryDetailViewController.h"
#import "SDImageView+SDWebCache.h"
#import "PatrolCell.h"
#import "MessageBarManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"
#import "NameFilterViewController.h"
#import "UIView+Util.h"
#import "ApplyTypeViewController.h"
#import "GiftTypeViewController.h"
#import "UIView+Util.h"
#import "CustNameAndNameFilterViewController.h"

@interface GiftDeliveryListViewController ()<HeaderSearchBarDelegate,GiftTypeDelegate,ApplyTypeDelegate,CustNameAndNameDelegate,DepartmentViewControllerDelegate>

@end

@implementation GiftDeliveryListViewController
{
    HeaderSearchBar*        _searchBar;
    NSMutableArray*         _searchViews;
    NSMutableArray*         _departments;
    NSMutableArray*         _checkDepartments;
    ApplyCategory*          _applyCategory;
    GiftProductCategory*    _giftCategory;
    NSString*               _giftName;
    NSString*               _name;
    NSString*               _formTime;
    NSString*               _endTime;
}

@synthesize giftDeliveryArray,giftDeliveryParams;

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
    NSArray* icons = [NSArray arrayWithObjects:@"",@"",@"",@"", nil];
    NSArray* titles = [NSArray arrayWithObjects:@"部门",@"赠品类型",@"审批类型",@"筛选", nil];
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    _searchBar.icontitles = icons;
    _searchBar.titles = titles;
    _searchBar.delegate = self;
    _searchBar.backgroundColor = WT_WHITE;
    [self.view addSubview:_searchBar];
    //计算 frame
    CGRect tmpFrame = self.pullTableView.frame;
    tmpFrame.size.height = MAINHEIGHT - 45;
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = _departments;
    departmentVC.view.frame = tmpFrame;
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    //赠品类型
    GiftTypeViewController* giftTypeVC = [[GiftTypeViewController alloc] init];
    giftTypeVC.delegate = self;
    [self addChildViewController:giftTypeVC];
    self.childViewControllers[1].view.frame = tmpFrame;
    [_searchViews addObject:self.childViewControllers[1].view];
    [giftTypeVC release];
    //审批类型
    ApplyTypeViewController* applyTypeVC = [[ApplyTypeViewController alloc] init];
    applyTypeVC.delegate = self;
    [self addChildViewController:applyTypeVC];
    self.childViewControllers[2].view.frame = tmpFrame;
    [_searchViews addObject:self.childViewControllers[2].view];
    [applyTypeVC release];
    //筛选视图
    CustNameAndNameFilterViewController* filterView = [[NSBundle mainBundle] loadNibNamed:@"CustNameAndNameFilterViewController" owner:nil options:nil][0];
    filterView.lable2 = @"赠品名称:";
    filterView.frame = tmpFrame;
    filterView.delegate = self;
    [self initFilterViewParams:filterView];
    [_searchViews addObject:filterView];
    
    //表数据
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
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
    self.navigationItem.rightBarButtonItem = btRight;
    [btRight release];
    [rightView release];
     */
    
    currentPage = 1;
    giftDeliveryArray = [[NSMutableArray alloc] init];
    [lblFunctionName setText:NSLocalizedString(@"bar_gift_delivery_list", @"")];
    
    AGENT.delegate = self;
    if (giftDeliveryParams != nil) {
        [self refreshTable];
    }else{
        //[self openSearchView];
        [self refreshParamsAndTable];
    }
}

-(void) initFilterViewParams:(CustNameAndNameFilterViewController *) vc{
    if (giftDeliveryParams.users.count > 0) {
        vc.txtName.text = ((User *)[giftDeliveryParams.users objectAtIndex:0]).realName;
    }else if (giftDeliveryParams.customers.count > 0){
        vc.txtCustName.text = ((Customer *)[giftDeliveryParams.customers objectAtIndex:0]).name;
    }
}
#pragma -mark 参数封装更新
-(void) refreshParams{
    GiftDeliveryParams_Builder* bsp = [GiftDeliveryParams builder];
    [bsp setPage:1];
    if (_checkDepartments && _checkDepartments.count > 0) {
        [bsp setDepartmentsArray:_checkDepartments  ];
    }else{
        [bsp clearDepartments];
    }
    if (_giftCategory) {
        [bsp setGiftCategory:_giftCategory];
    }else{
        [bsp clearGiftCategory];
    }
    if (_applyCategory) {
        [bsp setApplyCategory:_applyCategory];
    }else{
        [bsp clearApplyCategory];
    }
    if (_name && _name.length > 0) {
        User_Builder* u = [User builder];
        [u setId:0];
        [u setRealName:_name];
        [bsp setUsersArray:[NSArray arrayWithObject:[u build]]];
    }
    if (_giftName && _giftName.length > 0) {
        [bsp setGiftName:_giftName];
    }
    if (_formTime && _formTime.length > 0) {
        [bsp setStartDate:_formTime];
    }
    if (_endTime && _endTime.length > 0) {
        [bsp setEndDate:_endTime];
    }
    self.giftDeliveryParams = [[bsp build] retain];
}

-(void) refreshParamsAndTable{
    [self refreshParams];
    [self refreshTable];
}
#pragma -mark DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"departments.count:%d",departments.count);
    _checkDepartments = [departments retain];
    UIButton* btn = _searchBar.buttons[0];
    NSMutableString* sb = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
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

#pragma -mark CustNameAndNameDelegate
-(void)CustNameAndNameSearchClick:(NSString *)custName name:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"%@,%@,%@,%@",custName,name,formTime,endTime);
    _giftName = custName;
    _name = name;
    _formTime = formTime;
    _endTime = endTime;
    
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:3];
    [self refreshParamsAndTable];
}

#pragma -mark ApplyTypeDelegate
-(void)applyTypeSearch:(ApplyTypeViewController *)controller didSelectWithObject:(id)aObject{
    UIButton* btn  = _searchBar.buttons[2];
    if (aObject) {
        _applyCategory = aObject;
        NSLog(@"%@",_applyCategory.name);
        [btn setTitle:_applyCategory.name forState:UIControlStateNormal];
    }else{
        _applyCategory = nil;
        [btn setTitle:_searchBar.titles[2] forState:UIControlStateNormal];
    }
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:2];
    [self refreshParamsAndTable];
}

#pragma -mark GiftTypeDelegate
-(void)giftTypeSearch:(GiftTypeViewController *)controller didSelectWithObject:(id)aObject{
    UIButton* btn = _searchBar.buttons[1];
    if (aObject) {
        _giftCategory = aObject;
        [btn setTitle:_giftCategory.name forState:UIControlStateNormal];
        NSLog(@"%@",_giftCategory.name);
    }else{
        _giftCategory = nil;
        [btn setTitle:_searchBar.titles[1] forState:UIControlStateNormal];
    }
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:1];
    [self refreshParamsAndTable];
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
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)clearTable{
    if (giftDeliveryArray.count > 0){
        [giftDeliveryArray removeAllObjects];
    }
}

-(void)didFinishedSearchWithResult:(PatrolParams_Builder *)result{
    GiftDeliveryParams_Builder* pp = (GiftDeliveryParams_Builder *)result;
    [pp setPage:currentPage];
    giftDeliveryParams = [[pp build] retain];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (giftDeliveryArray.count > 0) {
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
    
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeGiftDeliveryList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageGiftDelivery* pageGiftDelivery = [PageGiftDelivery parseFromData:cr.data];
        if ([super validateData:pageGiftDelivery]) {
            int giftDeliveryCount = pageGiftDelivery.giftDeliveries.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < giftDeliveryCount;i++){
                GiftDelivery* p = (GiftDelivery*)[[pageGiftDelivery giftDeliveries] objectAtIndex:i];
                [giftDeliveryArray addObject:p];
                
            }
            pageSize = pageGiftDelivery.page.pageSize;
            totleSize = pageGiftDelivery.page.totalSize;
            
            if (giftDeliveryArray.count == 0) {
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_gift_delivery_list", @"")
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
        }
        
    }
    [super showMessage2:cr Title:NSLocalizedString(@"bar_gift_delivery_list", @"") Description:@""];
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
    
    GiftDeliverySearchViewController *ctrl = [[GiftDeliverySearchViewController alloc] init];
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
    if (giftDeliveryParams != nil){
        GiftDeliveryParams_Builder* pb = [giftDeliveryParams toBuilder];
        [pb setPage:1];
        giftDeliveryParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeGiftDeliveryList param:giftDeliveryParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_gift_Delivery_list", @"")
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
        GiftDeliveryParams_Builder* pb = [giftDeliveryParams toBuilder];
        [pb setPage:currentPage];
        giftDeliveryParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeGiftDeliveryList param:giftDeliveryParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_gift_delivery_list", @"")
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
    
    return 130.f;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [giftDeliveryArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    PatrolCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[PatrolCell class]])
                cell=(PatrolCell *)oneObject;
        }
    }
    GiftDelivery *giftDelivery = [giftDeliveryArray objectAtIndex:indexPath.row];
    [cell.icon setImageWithURL:[NSURL URLWithString:[giftDelivery.filePath objectAtIndex:0]] refreshCache:YES placeholderImage:[UIImage imageNamed:@"attendance_remarks_icon"]];
    cell.title.text = giftDelivery.user.realName;
    cell.name.text = [NSString stringWithFormat:@"%@",((Department *)[giftDelivery.department objectAtIndex:0]).name];
    cell.subTitle1.text = [NSString stringWithFormat:@"%@",[NSDate dateWithFormatTodayOrYesterday: giftDelivery.createDate]];
    NSLog(@"44444444%@444444",giftDelivery);
//    cell.subTitle1.text = [NSString stringWithFormat:@"%@|%@",((Department *)[giftDelivery.department objectAtIndex:0]).name,[NSDate dateWithFormatTodayOrYesterday: giftDelivery.createDate]];
//    cell.subTitle2.text = [giftDelivery applyItemsAtIndex:0].title;
    cell.subTitle2.text = giftDelivery.content;
    //cell.name.text = [giftDelivery applyItemsAtIndex:0].title;
   // cell.name.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GiftDeliveryDetailViewController *vctrl = [[GiftDeliveryDetailViewController alloc] init];
    
    vctrl.giftDelivery = [giftDeliveryArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vctrl animated:YES];
    [vctrl release];

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
