//
//  ApplyListViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-9-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "ApplyListViewController.h"
#import "AppDelegate.h"
#import "ApplySearchViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "ApplyItemCell.h"
#import "InputViewController.h"
#import "ApplyDetailViewController.h"
#import "HeaderSearchBarWithTag.h"
#import "DepartmentViewController.h"
#import "NameFilterViewController.h"
#import "UIView+Util.h"
#import "DropMenu.h"
#import "SDImageView+SDWebCache.h"
#import "UIView+CNKit.h"

@interface ApplyListViewController ()<RefreshDelegate,PullTableViewDelegate,HeaderSearchBarDelegate,NameFilterViewControllerDelegate,DepartmentViewControllerDelegate,DropMenuDelegate>

@end

@implementation ApplyListViewController
{
    HeaderSearchBarWithTag*        _searchBar1;
    HeaderSearchBarWithTag*        _searchBar2;
    NSMutableArray*         _searchViews;
    NSMutableArray*         _departments;
    NSMutableArray*         _checkDepartments;
    ApplyCategory*          _applyCategory;
    NSMutableArray*         _applyCategorys;
    NSMutableArray*         _applyCategoryTitles;
    NSString*               _name;
    NSString*               _formTime;
    NSString*               _endTime;
    int tagIndex;
    NSString *statusString;
}
@synthesize delegate,applyParams;

@synthesize applyArray,bEnableSelect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    appDelegate = APPDELEGATE;
    currentApplyItem = nil;
    currentRow = 0;
    
    [super viewDidLoad];
    //初始化数据
    _searchViews = [[NSMutableArray alloc] initWithCapacity:2];
    _departments = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getDepartments]];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    _applyCategorys = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getApplyCategories]];
    _applyCategoryTitles = [[NSMutableArray alloc] initWithCapacity:0];
    [_applyCategoryTitles removeAllObjects];
    [_applyCategoryTitles addObject:@"全部类型"];
    for (ApplyCategory* item in _applyCategorys) {
        [_applyCategoryTitles addObject:item.name];
    }
    //搜索栏
    NSArray* icons = [NSArray arrayWithObjects:@"",@"",@"", nil];
    NSArray* titles = [NSArray arrayWithObjects:@"部门",@"审批类型",@"筛选", nil];
    _searchBar1 = [[HeaderSearchBarWithTag alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    _searchBar1.icontitles = icons;
    _searchBar1.titles = titles;
    _searchBar1.backgroundColor = WT_WHITE;
    _searchBar1.delegate = self;
    _searchBar1.tag = 9999;
    [self.view addSubview:_searchBar1];
    
    //搜索栏
    NSArray* icons2 = [NSArray arrayWithObjects:@"",@"",@"", nil];
    NSArray* titles2 = [NSArray arrayWithObjects:@"待审核",@"审核通过",@"审核拒绝", nil];
    _searchBar2 = [[HeaderSearchBarWithTag alloc] initWithFrame:CGRectMake(0, _searchBar1.bottom, MAINWIDTH, 45)];
    _searchBar2.icontitles = icons2;
    _searchBar2.titles = titles2;
    _searchBar2.backgroundColor = WT_WHITE;
    _searchBar2.delegate = self;
    [self.view addSubview:_searchBar2];
    //计算视图高度
    CGRect tmpFrame = self.pullTableView.frame;
    tmpFrame.size.height = MAINHEIGHT - 90;
    self.pullTableView.backgroundColor = WT_WHITE;
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = _departments;
    departmentVC.view.frame = tmpFrame;
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    //类型下拉框
    DropMenu* categoryMenu = [[DropMenu alloc] initWithFrame:tmpFrame];
    categoryMenu.menuCount = 1;
    categoryMenu.array1 = _applyCategoryTitles;
    categoryMenu.delegate = self;
    [categoryMenu initMenu];
    [_searchViews addObject:categoryMenu];
    [categoryMenu release];
    //筛选视图
    NameFilterViewController* nameFilterVC = [[NSBundle mainBundle] loadNibNamed:@"NameFilterViewController" owner:nil options:nil][0];
    nameFilterVC.frame = tmpFrame;
    nameFilterVC.delegate = self;
    [self initFilterViewParams:nameFilterVC];
    [_searchViews addObject:nameFilterVC];
    
    //数据源
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    self.pullTableView.tableFooterView = [[UIView alloc] init];
    //搜索按钮
    if (bEnableSelect) {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
        UILabel *saveImageView = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
        saveImageView.textColor = WT_RED;
        saveImageView.backgroundColor = WT_CLEARCOLOR;
        saveImageView.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
        saveImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_SAVE];
        saveImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmSelected)];
        [tapGesture2 setNumberOfTapsRequired:1];
        saveImageView.contentMode = UIViewContentModeScaleAspectFit;
        [saveImageView addGestureRecognizer:tapGesture2];
        [rightView addSubview:saveImageView];
        [saveImageView release];
        
        UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.rightButton = btRight;
        [btRight release];
    }
    
    currentPage = 1;
    applyArray = [[NSMutableArray alloc] init];
    selectedArray = [[NSMutableArray alloc] init];
    [lblFunctionName setText:[NSString stringWithFormat:@"%@-申请",TITLENAME(FUNC_APPROVE_DES)]];
    
    AGENT.delegate = self;
    
    if (applyParams == nil) {
        [self refreshParamsAndTable];
    }else{
        [self refreshTable];
    }
}

-(void)setFirstStatus {
    UIButton *btn = _searchBar2.buttons[0];
    [btn setTitleColor:WT_RED forState:UIControlStateNormal];
    
//    currentPage = 1;
//    if (applyParams != nil){
//        ApplyItemParams_Builder* pb = [applyParams toBuilder];
//        [pb setPage:1];
//        [pb setApplyStatus:[NSString stringWithFormat:@"%d",APPLY_STATUS_WAIT]];
//        applyParams = [[pb build] retain];
//        
//        AGENT.delegate = self;
//        if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemList param:applyParams]){
//            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
//                              description:NSLocalizedString(@"error_connect_server", @"")
//                                     type:MessageBarMessageTypeError
//                              forDuration:ERR_MSG_DURATION];
//            
//            self.pullTableView.pullTableIsRefreshing = NO;
//            self.pullTableView.pullTableIsLoadingMore = NO;
//        }
//    }


}

-(void) initFilterViewParams:(NameFilterViewController *) vc {
    if (applyParams.users.count > 0) {
        vc._txtName.text = ((User *)[applyParams.users objectAtIndex:0]).realName;
    }
}

#pragma -mark 参数封装
-(void) refreshParamsAndTable {
    [self refreshParams];
    [self refreshTable];
}

-(void) refreshParams {
    ApplyItemParams_Builder* aipb = [ApplyItemParams builder];
    [aipb setPage:1];
    
    if (_checkDepartments && _checkDepartments.count > 0) {
        [aipb setDepartmentsArray:_checkDepartments];
    }else{
        [aipb clearDepartments];
    }
    
    if (_applyCategory) {
        [aipb setApplyCategory:_applyCategory];
    }else{
        [aipb clearApplyCategory];
    }
    
    if (_name) {
        User_Builder* ub = [User builder];
        [ub setId:0];
        [ub setRealName:_name];
        [aipb setUsersArray:[NSArray arrayWithObject:[ub build]]];
    }
    
    if (_formTime && _formTime.length > 0) {
        [aipb setStartDate:_formTime];
    }
    
    if (_endTime && _endTime.length > 0) {
        [aipb setEndDate:_endTime];
    }
    [aipb setApplyStatus:statusString];
    self.applyParams = [[aipb build] retain];
}

#pragma -mark DropMenuDelegate
-(void)selectedDropMenuIndex:(int)index row:(int)row{
    NSString* title = _applyCategoryTitles[row];
    UIButton* btn = _searchBar1.buttons[1];
    [btn setTitle:title forState:UIControlStateNormal];
    NSLog(@"选择了:%@",title);
    if (row > 0) {
        _applyCategory = _applyCategorys[row - 1];
    }else{
        _applyCategory = nil;
    }
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar1 setColor:1];
    [self refreshParamsAndTable];
}

#pragma -mark DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"选择了%d个部门",departments.count);
    _checkDepartments = [departments retain];
    
    UIButton* btn = _searchBar1.buttons[0];
    NSMutableString* sb = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    int i = 0;
    for (Department* item in departments) {
        if (i > 5) {
            break;
        }
        [sb appendFormat:@"%@,",item.name];
        i++;
    }
    [btn setTitle:departments.count > 0 ? [sb substringToIndex:sb.length - 1] : _searchBar1.titles[0] forState:UIControlStateNormal];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar1 setColor:0];
    [self refreshParamsAndTable];
}

#pragma -mark NameFilterViewControllerDelegate
-(void)NameFilterViewControllerSearch:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"%@,%@,%@",name,formTime,endTime);
    _name = name;
    _formTime = formTime;
    _endTime = endTime;
    
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar1 setColor:2];
    [self refreshParamsAndTable];
}

#pragma -mark HeaderSearchBarDelegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current andWithTag:(int)tag{
    tagIndex = tag;
    NSLog(@"选择:%d",index);
    if (tag == 9999) {
        if (index == current) {
            [UIView removeViewFormSubViews:-1 views:_searchViews];
            return;
        }
        [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
        [UIView removeViewFormSubViews:index views:_searchViews];
    }else {
    //待审核，审核通过，审核拒绝 状态查询
        ApplyItemParams_Builder* pb = [applyParams toBuilder];
        
        if (index == 0) {
        statusString = [NSString stringWithFormat:@"%d",APPLY_STATUS_WAIT];
           
        }else if (index == 1){
        statusString = [NSString stringWithFormat:@"%d",APPLY_STATUS_PASS];
       
        }else {
        statusString = [NSString stringWithFormat:@"%d",APPLY_STATUS_NOT_PASS];
       
        }
        [pb setApplyStatus:statusString];
        applyParams = [[pb build] retain];
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemList param:applyParams]){
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
           
        }
    }
  
}

//窗体方法
-(void)openSearchView{
    
    ApplySearchViewController *ctrl = [[ApplySearchViewController alloc] init];
    ctrl.delegate = self;
    UINavigationController *searchNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentModalViewController:searchNavCtrl animated:YES];
    
}

-(void)confirmSelected {
    if ([self.delegate respondsToSelector:@selector(didFinishedSelectApplyItem:)]) {
        [self.delegate didFinishedSelectApplyItem:selectedArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    if (applyArray.count > 0){
        [applyArray removeAllObjects];
    }
}

-(void)didFinishedSearchWithResult:(ApplyItemParams_Builder *)result {
    ApplyItemParams_Builder* pp = (ApplyItemParams_Builder *)result;
    [pp setPage:currentPage];
    applyParams = [[pp build] retain];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        if (applyArray.count > 0) {
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
        HUDHIDE2;
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeApplyItemList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageApplyItem* pageApplyItem = [PageApplyItem parseFromData:cr.data];
        if ([super validateData:pageApplyItem]) {
            int applyCount = pageApplyItem.applyItems.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < applyCount;i++){
                ApplyItem* w = (ApplyItem*)[[pageApplyItem applyItems] objectAtIndex:i];
                [applyArray addObject:w];
            }
            pageSize = pageApplyItem.page.pageSize;
            totleSize = pageApplyItem.page.totalSize;
            
            if (applyArray.count == 0) {
                [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
        }
    }
    
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeApplyItemReply) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])) {
        [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"applyreply_msg_saved", @"")];
        
        if (applyArray != nil){
            ApplyItem_Builder* wb = [currentApplyItem toBuilder];
            [wb setReplyCount:currentApplyItem.replyCount+1];
            
            [applyArray removeObjectAtIndex:currentRow];
            [applyArray insertObject:[wb build] atIndex:currentRow];
            
            [self.pullTableView reloadData];
        }
    }
    
    [super showMessage2:cr Title:TITLENAME(FUNC_APPROVE_DES)            Description:@""];
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeApplyItemList) || (INT_ACTIONCODE(cr.code) != ActionCodeDone)){
        [self.pullTableView reloadData];
        
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
    }
    HUDHIDE2;
}

- (void) didFailWithError:(NSError *)error {
    self.pullTableView.pullTableIsRefreshing = NO;
    self.pullTableView.pullTableIsLoadingMore = NO;
    
    [super didFailWithError:error];
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
    self.pullTableView.pullTableIsRefreshing = NO;
    self.pullTableView.pullTableIsLoadingMore = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}

- (void)viewDidUnload {
    [self setPullTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [pullTableView release];
    [super dealloc];
    NSLog(@"_searchBar.retainCount:%d",_searchBar1.retainCount);
}


#pragma mark - Refresh and load more methods
- (void) refreshTable {
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    if (applyParams != nil){
        ApplyItemParams_Builder* pb = [applyParams toBuilder];
        [pb setPage:1];
        applyParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemList param:applyParams]){
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
        }
    }
}

- (void) loadMoreDataToTable {
    self.pullTableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        ApplyItemParams_Builder* pb = [applyParams toBuilder];
        [pb setPage:currentPage];
        applyParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemList param:applyParams]){
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [applyArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    ApplyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ApplyItemCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[ApplyItemCell class]])
                cell=(ApplyItemCell *)oneObject;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ApplyItem *w = [applyArray objectAtIndex:indexPath.row];
    cell.userName.text = w.user.realName;
    cell.date.text = [NSDate dateWithFormatTodayOrYesterday: w.createDate];
    cell.content.text = w.title;
    cell.btnApprove.tag = indexPath.row;
    
    [cell.checkBox initWithDelegate:self];
    cell.checkBox.tag = indexPath.row;
    if(bEnableSelect){
        cell.checkBox.hidden = NO;
        if ([self hasChecked:w]) {
            [cell.checkBox setBoxStatus:YES];
        }else{
            [cell.checkBox setBoxStatus:NO];
        }
    } else {
        cell.checkBox.hidden = YES;
    }
    cell.lblCategory.textColor = WT_KHAKI;
    cell.lblCategory.text = w.category.name;

    [cell.userImage setImageWithURL:[NSURL URLWithString:[w.filePath objectAtIndex:0]] refreshCache:NO placeholderImage:[UIImage imageNamed:@"attendance_remarks_icon"]];
    
    if (w.replyCount > 0){
        [cell.btnApprove.layer setCornerRadius:16.0f];
        cell.btnApprove.layer.borderWidth = 1;
        cell.btnApprove.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.btnApprove.layer.masksToBounds = YES;
        [cell.btnApprove setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cell.btnApprove setTitle:[NSString stringWithFormat:@"%d",w.replyCount] forState:UIControlStateNormal];
    }else{
        [cell.btnApprove setTitle:NSLocalizedString(@" ", nil) forState:UIControlStateNormal];
    }
    [cell.btnApprove addTarget:self action:@selector(toReply:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self hasApplyPermission:w]){
        cell.btnApprove.hidden = NO;
       
    }
    else{
        cell.btnApprove.hidden = NO;
    }
    
    if(bEnableSelect)
        cell.btnApprove.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self _showApplyItemDetail:[applyArray objectAtIndex:indexPath.row]];
}

-(BOOL)hasApplyPermission:(ApplyItem *)applyItem {
    
    BOOL bResult = NO;
    for(User *user in applyItem.category.users){
        if (user.id == USER.id) {
            bResult = YES;
            break;
        }
    }
    return bResult;
}

- (BOOL)hasChecked:(ApplyItem *)applyItem {
    
    BOOL bResult = NO;
    for(ApplyItem *item in selectedArray){
        if (item.id == applyItem.id) {
            bResult = YES;
            break;
        }
    }
    return bResult;
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    if (checked) {
        [selectedArray addObject:[applyArray objectAtIndex:checkbox.tag]];
    }else{
        [selectedArray removeObject:[applyArray objectAtIndex:checkbox.tag]];
    }
}

- (void) _showApplyItemDetail:(ApplyItem*) w {
    ApplyDetailViewController *ctrl = [[ApplyDetailViewController alloc] init];
    ctrl.applyItem = nil;
    ctrl.applyItemId = w.id;
    ctrl.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
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

- (void) didFinishInput:(int)tag Input:(NSString *)input {
    int applyItemId = ((ApplyItem*)[applyArray objectAtIndex:tag]).id;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    ApplyItemReply_Builder* wrb = [ApplyItemReply builder];
    [wrb setContent:input];
    [wrb setCreateDate:[NSDate getCurrentTime]];
    [wrb setApplyItemId:applyItemId];
    [wrb setId:-1];
    
    currentRow = tag;
    ApplyItem* w = [[applyArray objectAtIndex:tag] retain];
    NSMutableArray* applyItemReplies = [[NSMutableArray alloc] initWithCapacity:1];
    ApplyItemReply* wr = [[wrb build] retain];
    [applyItemReplies addObject:wr];
    
    ApplyItem_Builder* pb =[w toBuilder];
    currentApplyItem = [[pb build] retain];
    
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemReply param:wr]){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_APPROVE_DES)                                     description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void) refresh:(id)obj {
    if ([obj isKindOfClass:[ApplyItem class]]) {
        for (int i = 0; i < applyArray.count; i++) {
            ApplyItem* applyItem = (ApplyItem*)obj;
            if (((ApplyItem*)[applyArray objectAtIndex:i]).id == applyItem.id){
                [applyArray removeObjectAtIndex:i];
                [applyArray insertObject:applyItem atIndex:i];
                
                [self.pullTableView reloadData];
                
                break;
            }
        }
    }
    
}

@end
