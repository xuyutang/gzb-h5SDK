//
//  OrderListViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "OrderListViewController.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "OrderCell.h"
#import "OrderHeaderView.h"
#import "OrderSearchViewController.h"
#import "NSDate+Util.h"
#import "SaleCell.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"
#import "DropMenu.h"
#import "CustNameAndNameFilterViewController.h"
#import "UIView+Util.h"

@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate,HeaderSearchBarDelegate,DepartmentViewControllerDelegate,DropMenuDelegate,CustNameAndNameDelegate>

@end

@implementation OrderListViewController
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
@synthesize pullTableView,orderArray,ogParams,msgType,sourceId;

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
    //搜索导航
    NSMutableArray* icons = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    NSMutableArray* titles = [NSMutableArray arrayWithObjects:@"部门",@"客户类型",@"筛选", nil];
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    _searchBar.delegate = self;
    _searchBar.icontitles = icons;
    _searchBar.titles = titles;
    [self.view addSubview:_searchBar];
    
    //加入视图计算Rect
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
    [_searchViews addObject:custNameFilterVC];
    
    //表数据
    currentPage = 1;
    
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    self.pullTableView.allowsSelection = NO;
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
    [lblFunctionName setText:TITLENAME_LIST(FUNC_SELL_ORDER_DES)];
    (APPDELEGATE).agent.delegate = self;
    
    orderArray = [[NSMutableArray alloc] init];
    if (ogParams == nil) {
        //[self openSearchView];
        [self refreshParamsAndTable];
    }else{
        [self _search];
    }
}



#pragma -mark 搜索参数封装
-(void) refreshParamsAndTable{
    [self refreshParams];
    [self _search];
}
-(void) refreshParams{
    OrderGoodsParams_Builder* bsp = [OrderGoodsParams builder];
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
    self.ogParams = [[bsp build] retain];
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
    [_searchBar setColor:-1];
    [self refreshParamsAndTable];
}

#pragma -mark HeaderSearchDelegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
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
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }
}


-(void)didFinishedSearchWithResult:(OrderGoodsParams_Builder *)result{
    ogParamsBuilder = [(OrderGoodsParams_Builder *)result retain];
    ogParams = [[ogParamsBuilder build] retain];
    [self _search];
}

- (void) _search{
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (orderArray.count > 0) {
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
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeOrdergoodsList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageOrderGoods* pageOrderGoods = [PageOrderGoods parseFromData:cr.data];
        if ([super validateData:pageOrderGoods]) {
            int orderCount = pageOrderGoods.orderGoods.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < orderCount;i++){
                OrderGoods* orderItem = (OrderGoods*)[[pageOrderGoods orderGoods] objectAtIndex:i];
                [orderArray addObject:orderItem];
                
            }
            pageSize = pageOrderGoods.page.pageSize;
            totalSize = pageOrderGoods.page.totalSize;
            
            if (orderArray.count == 0) {
                [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_SELL_ORDER_DES)
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
        }
        
    }
    
    if (msgType != MESSAGE_UNKNOW) {
        //if (sourceId == orderItem.id) {
            [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",sourceId]];
        //}
    }
    [super showMessage2:cr Title:TITLENAME_LIST(FUNC_SELL_ORDER_DES) Description:@""];
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

-(void)openSearchView{
    
    OrderSearchViewController *ctrl = [[OrderSearchViewController alloc] init];
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
    if (ogParams != nil){
        OrderGoodsParams_Builder* ogb = [ogParams toBuilder];
    
        [ogb setPage:1];
        ogParams = [[ogb build] retain];

        (APPDELEGATE).agent.delegate = self;
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeOrdergoodsList param:ogParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_SELL_ORDER_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
            
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
        }
    }
}

-(void)clearTable{
    if (orderArray.count > 0){
        [orderArray removeAllObjects];
    }
}

- (void) loadMoreDataToTable
{
    self.pullTableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totalSize){
        currentPage++;
        OrderGoodsParams_Builder* ogb = [ogParams toBuilder];
        
        [ogb setPage:currentPage];
        
        (APPDELEGATE).agent.delegate = self;
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeOrdergoodsList param:ogParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_SELL_ORDER_DES)
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
    return ((OrderGoods*)[orderArray objectAtIndex:indexPath.section]).products.count * 60 + 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWHEADERHEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [orderArray count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SaleCell";
    
    SaleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SaleCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[SaleCell class]])
                cell=(SaleCell *)oneObject;
        }
    }
    OrderGoods *order = (OrderGoods *)[orderArray objectAtIndex:indexPath.section];
    cell.products = order.products;
    [cell showProducts];
    float price = 0;
    for (int i = 0; i < order.products.count; ++i) {
        Product* p = [order.products objectAtIndex:i];
        
        price = p.price * p.num + price;
    }
    cell.total.text = [NSString stringWithFormat:@"￥%.2f",price];
    cell.customer.text = order.customer.name;
    cell.name.text = order.user.realName;
    cell.updateTime.text = order.createDate;
    
    if (msgType != MESSAGE_UNKNOW) {
        if (sourceId == order.id) {
            cell.lMark.frame = CGRectMake(CELL_CONTENT_WIDTH - 20, 5.0f,10.0f, 10.0f);
            cell.lMark.layer.cornerRadius = 5.0f;
            [cell.lMark setBackgroundColor:WT_RED];
            cell.lMark.clipsToBounds = YES;
        }else{
            [cell.lMark setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    return cell;
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

- (void)dealloc {
    [pullTableView release];
    [super dealloc];
}


@end