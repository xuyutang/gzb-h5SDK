//
//  DateReportListViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/8/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "DataReportListViewController.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "HeaderSearchBar.h"
#import "Constant.h"
#import "InputViewController.h"

#import "DepartmentViewController.h"
#import "SDImageView+SDWebCache.h"
#import "NameFilterViewController.h"
#import "UIView+Util.h"
#import "NSDate+Util.h"

#import "DateReportCell.h"
//#import "VideoTypeViewController.h"
#import "DataReportDetailViewController.h"
#import "DataReportTypeViewController.h"
@interface DataReportListViewController ()<UITableViewDelegate,UITableViewDataSource,NameFilterViewControllerDelegate,HeaderSearchBarDelegate,DepartmentViewControllerDelegate,PullTableViewDelegate,RefreshDelegate,InputFinishDelegate,RequestAgentDelegate,DataReportTypeDelegate>

@end

@implementation DataReportListViewController
{
    HeaderSearchBar         *_headerBar;
    NSMutableArray          *_searchViews;
    NSMutableArray          *_departments;
    NSMutableArray          *_checkDepartments;
    PaperTemplate           *_templateCategory;
    NSString* _formDate;
    NSString* _endDate;
    NSString* _userName;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentRow = 0;
    currentPage = 1;
    dataReportArray = [[NSMutableArray alloc] init];
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    _searchViews = [[NSMutableArray alloc] initWithCapacity:2];
    _departments = [[NSMutableArray alloc] initWithCapacity:0];
    [_departments removeAllObjects];
    [_departments addObjectsFromArray:[[LOCALMANAGER getDepartments] retain]];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
//    _departments = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getDepartments]];
//    _checkDepartments = [[NSMutableArray alloc] init];
    //搜索栏
    _headerBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    _headerBar.titles = @[@"部门",@"模板",@"筛选"];
    _headerBar.icontitles = @[@"",@"",@""];
    _headerBar.backgroundColor = WT_WHITE;
    _headerBar.delegate = self;
    [self.view addSubview:_headerBar];
    [_headerBar release];
    
    CGFloat rectY = _headerBar.frame.origin.y + _headerBar.frame.size.height;
    CGRect rect = CGRectMake(0, rectY, MAINWIDTH, MAINHEIGHT - rectY);
    
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = _departments;
    departmentVC.view.frame = rect;
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    
    CGRect tmpFrame = _pullTableView.frame;
    tmpFrame.size.height = MAINHEIGHT - 45;
    //类型
    DataReportTypeViewController *typeVC = [[DataReportTypeViewController alloc] init];
//    typeVC.view.frame = rect;
//    typeVC.delegate  = self;
////    typeVC.bSearch = YES;//搜索调用 加入不限类型
//    [self addChildViewController:typeVC];
//    [_searchViews addObject:self.childViewControllers[1].view];
//    [typeVC release];
    
    typeVC.delegate = self;
    typeVC.bNeedAll = YES;
    typeVC.bFavorate = NO;
    typeVC.hidenBool = YES;
    typeVC.allBool = YES;
//    tmpFrame = _pullTableView.frame;
//    tmpFrame.size.height = MAINHEIGHT - 45;
    typeVC.view.frame = rect;
    [self addChildViewController:typeVC];
    typeVC = self.childViewControllers[1];
    [_searchViews addObject:typeVC.view];
    [typeVC release];
    
    //筛选
    NameFilterViewController *filterVC = [[[NSBundle mainBundle] loadNibNamed:@"NameFilterViewController" owner:self options:nil] lastObject];
    filterVC.delegate = self;
    filterVC.frame  = rect;
    [self initFilterViewParams:filterVC];
    [_searchViews addObject:filterVC];
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    self.pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT - 45) style:UITableViewStylePlain];
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    self.pullTableView.tableFooterView = [[UIView alloc]init];
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    
    [self.lblFunctionName setText:TITLENAME_LIST(FUNC_PAPER_POST_DES)];
    [self.view addSubview:self.pullTableView];
    (APPDELEGATE).agent.delegate = self;
    if (bNeedBack) {
        leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
    
    
    if (!self.pParams) {
        [self refreshParams];
    }
    [self refreshTable];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)initFilterViewParams:(NameFilterViewController *) vc{
    if (_pParams.users.count > 0) {
        vc._txtName.text = ((User *)[_pParams.users objectAtIndex:0]).realName;
    }
}


/*
 更新参数
 */
-(void)refreshParams{
    PaperPostParams_Builder *ppbparam = [PaperPostParams builder];
    if (_checkDepartments && _checkDepartments.count > 0) {
        [ppbparam setDepartmentsArray:_checkDepartments];
    }else{
        [ppbparam clearDepartments];
    }
    if (_templateCategory) {
        [ppbparam setPaperTemplate:_templateCategory];
    }
    User_Builder* u = [User builder];
    [u setRealName:_userName.length > 0 ? _userName : @""];
    [u setId:0];
    User* tmpUser = [[u build] retain];
    if (_formDate.length > 0) {
        [ppbparam setStartDate:_formDate];
    }
    if (_endDate.length > 0) {
        [ppbparam setEndDate:_endDate];
    }
    [ppbparam setPage:1];
    [ppbparam setUsersArray:[NSArray arrayWithObjects:tmpUser, nil]];
    pBuilder = [ppbparam retain];
    self.pParams = [[pBuilder build] retain];
}

-(void) refreshParamsAndTable{
    [self refreshParams];
    [self refreshTable];
}
- (void)refreshTable {
    NSLog(@"refresh") ;
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = YES;
    self.pullTableView.pullTableIsLoadingMore = NO;
    currentPage = 1;
    if (self.pParams != nil){
        PaperPostParams_Builder* ab = [self.pParams toBuilder];
        [ab setPage:1];
        self.pParams = [[ab build] retain];
        
        (APPDELEGATE).agent.delegate = self;
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypePaperPostList param:self.pParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_PAPER_POST_DES)
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
        }
    }
}

#pragma -mark 加载&刷新
- (void) loadMoreDataToTable
{
    self.pullTableView.pullTableIsLoadingMore = YES;
    self.pullTableView.pullTableIsRefreshing = NO;
    if(currentPage*pageSize < totalSize){
        currentPage++;
        PaperPostParams_Builder* ab = [self.pParams toBuilder];
        [ab setPage:currentPage];
        
        self.pParams = [[ab build] retain];
        
        (APPDELEGATE).agent.delegate = self;
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypePaperPostList param:self.pParams]){
            [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_PAPER_POST_DES)
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



#pragma -mark NameFilterViewControllerDelegate
-(void)NameFilterViewControllerSearch:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"%@<%@<%@",name,formTime,endTime);
    _formDate = formTime;
    _endDate = endTime;
    _userName = name;
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerBar setColor:2];
    [self refreshParams];
    
    [self refreshTable];
    
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
    if (dataReportArray.count > 0){
        [dataReportArray removeAllObjects];
    }
}


-(void)didFinishedSearchWithResult:(PaperPostParams_Builder *)result{
    pBuilder = [(PaperPostParams_Builder *)result retain];
    self.pParams = [[pBuilder build] retain];
    
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
}



#pragma -mark DatareportTypeDelegate
-(void)datareportSearch:(DataReportTypeViewController *)controller didSelectWithObject:(id)aObject{
    UIButton *btn = _headerBar.buttons[1];
    if (aObject != nil)
    {
        _templateCategory = (PaperTemplate*)aObject;
        NSLog(@"选择模板类型:%@",_templateCategory.name);
        [btn setTitle:_templateCategory.name forState:UIControlStateNormal];
    }else{
        [btn setTitle:_headerBar.titles[1] forState:UIControlStateNormal];
    }
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerBar setColor:1];
    [self refreshParamsAndTable];
}

-(void)allTemplate {
    UIButton* btn = _headerBar.buttons[1];
    [btn setTitle:@"全部模板" forState:UIControlStateNormal];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerBar setColor:2];
    _templateCategory = nil;
    
    [self refreshParamsAndTable];
    
}

#pragma -mark DepartmentViewControllerDelegate
-(void)didFnished:(NSMutableArray *)departments{
    NSLog(@"%d",departments.count);
    _checkDepartments = [departments retain];
    NSMutableString *ms = [[[NSMutableString alloc] init] autorelease];
    int i = 0;
    for (Department *item in departments) {
        if (i > 5) {
            break;
        }
        [ms appendFormat:@"%@,",item.name];
        i++;
    }
    UIButton *btn = _headerBar.buttons[0];
    [btn setTitle:departments.count > 0 ? [ms substringToIndex:ms.length - 1] : _headerBar.titles[0] forState:UIControlStateNormal];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerBar setColor:-1];
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

#pragma -mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if ([dataReportArray count] == 0) {
        [tableView setTableFooterView:[self setFootView]];
        return 0;
    }else {
        tableView.tableFooterView = [[UIView alloc]init];
    }
    return 1;

   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _videoList.count;
    return  [dataReportArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return TABLEVIEWHEADERHEIGHT;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 90.f;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"Cell";
    DateReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DateReportCell" owner:self options:nil] lastObject];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"Attendance" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[DateReportCell class]])
                cell=(DateReportCell *)oneObject;
        }
    }
    CGRect cellFrame = [cell frame];
    
    PaperPost *paperPost = (PaperPost *)[dataReportArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = paperPost.user.realName;
    cell.time.text =  [NSDate dateWithFormatTodayOrYesterday:paperPost.createDate];
    if ([paperPost.location.address isEqualToString:@""]) {
        if (paperPost.location.longitude > 0){
            cell.address.text = [NSString stringWithFormat:@"%@ %g %g" ,paperPost.location.address,paperPost.location.longitude,paperPost.location.latitude];
        } else {
            cell.address.text = NSLocalizedString(@"error_location", @"");
        }
    } else{
        cell.address.text = paperPost.location.address;
    }
    //头像
    [cell.ivImage setImageWithURL:[NSURL URLWithString:[paperPost.user.avatars objectAtIndex:0]] refreshCache:YES placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
    cell.mType.text = paperPost.paperTemplate.name;
    cell.mType.textColor = [UIColor grayColor];
    CGSize maximumLabelSize = CGSizeMake(100, 9999);
    CGSize expectSize = [cell.mType sizeThatFits:maximumLabelSize];
    cell.mType.layer.masksToBounds = YES;
    cell.mType.layer.cornerRadius = 5;
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    cell.mType.frame = CGRectMake(MAINWIDTH-expectSize.width-15, 7, expectSize.width, expectSize.height + 5);
    
    [cell setFrame:cellFrame];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaperPost *pap = [dataReportArray objectAtIndex:indexPath.row];
    [self _showPaperPostDetail:pap];
}


-(UIView*)setFootView {
    UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT - 150)];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, MAINWIDTH, 50)];
    textLabel.text =@"暂无内容";
    textLabel.font = [UIFont systemFontOfSize:15.0f];
    textLabel.textAlignment = 1;
    textLabel.textColor = [UIColor blackColor];
    [contentView addSubview:textLabel];
    return contentView;
}

- (void) _showPaperPostDetail:(PaperPost*) currentPaperPost{
    
    DataReportDetailViewController *ctrl = [[DataReportDetailViewController alloc] init];
    ctrl.currentPaperPost = nil;

    ctrl.paperPostId = currentPaperPost.id;
    ctrl.delegate = self;
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
    
}

#pragma -mark InputFinishDelegate

- (void) refresh:(id)obj{
    if (![obj isKindOfClass:[PaperPost class]]) {
        return;
    }
    PaperPost* paperpost = (PaperPost*)obj;
    for (int i = 0; i < dataReportArray.count; i++) {
        if (((PaperPost*)[dataReportArray objectAtIndex:i]).id == paperpost.id){
            [dataReportArray removeObjectAtIndex:i];
            [dataReportArray insertObject:paperpost atIndex:i];
            
            [self.pullTableView reloadData];
            
            break;
        }
    }
}

#pragma -mark WebSocketDelegate
- (void) didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypePaperPostList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PagePaperPost* pagePaperPost = [PagePaperPost parseFromData:cr.data];
        if ([super validateData:pagePaperPost]) {
            int paperPostCount = pagePaperPost.paperPosts.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < paperPostCount;i++){
                PagePaperPost* aw = (PagePaperPost*)[[pagePaperPost paperPosts] objectAtIndex:i];
                [dataReportArray addObject:aw];
            }
            pageSize = pagePaperPost.page.pageSize;
            totalSize = pagePaperPost.page.totalSize;
            
            if (dataReportArray.count == 0) {
                [MESSAGE showMessageWithTitle:TITLENAME_LIST(FUNC_PAPER_POST_DES)
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
            }
            [self.pullTableView reloadData];
        }
    }
    
    [super showMessage2:cr Title:TITLENAME_LIST(FUNC_PAPER_POST_DES) Description:@""];
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

#pragma -mark PullTableViewDelegate
-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}

-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_pullTableView release];
    [super dealloc];
}

@end
