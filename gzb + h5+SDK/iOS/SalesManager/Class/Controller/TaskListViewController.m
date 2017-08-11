//
//  TaskListViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-3-4.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "TaskListViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "Task0Cell.h"
#import "BaseTable1HeaderView.h"
#import "TaskDetailViewController.h"
#import "TaskPageViewController.h"
#import "HeaderSearchBar.h"
#import "NameFilterViewController.h"
#import "UIView+Util.h"
#import "DepartmentViewController.h"

@interface TaskListViewController ()<HeaderSearchBarDelegate,NameFilterViewControllerDelegate,DepartmentViewControllerDelegate>

@end

@implementation TaskListViewController{
    NSMutableArray*         _departments;
    NSMutableArray*         _checkDepartments;
    NSString*               _name;
    NSString*               _formTime;
    NSString*               _endTime;
}
@synthesize pullTableView,parentCtrl,user,msgType,sourceId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = WT_WHITE;
    UILabel *grayLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 0.5f)];
    grayLabel1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:grayLabel1];
    
    //搜索条载入
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0,0, MAINWIDTH, 45)];
    NSArray* titles = [NSArray arrayWithObjects:@"部门",@"筛选", nil];
    NSArray*  icons = [NSArray arrayWithObjects:@"",@"",nil];
    _searchBar.titles = [titles copy];
    _searchBar.icontitles = [icons copy];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    //计算frame
    CGRect tmpFrame = self.pullTableView.frame;
//    tmpFrame.origin.y += 45;
    tmpFrame.size.height = MAINHEIGHT - 45 * 2;
    
    //初始化数据
    _searchViews = [[NSMutableArray alloc] initWithCapacity:2];
    _departments = [[NSMutableArray alloc] initWithCapacity:0];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    [_departments removeAllObjects];
    [_departments addObjectsFromArray:[LOCALMANAGER getDepartments] ];
    
    
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = _departments;
    departmentVC.view.frame = tmpFrame;
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    
    //筛选视图
    NameFilterViewController* nameFilterVC = [[NSBundle mainBundle] loadNibNamed:@"NameFilterViewController" owner:self options:nil][0];
    nameFilterVC.frame = tmpFrame;
    nameFilterVC.delegate = self;
    [_searchViews addObject:nameFilterVC];
    [self initFilterViewParams:nameFilterVC];
    lblFunctionName.text = TITLENAME(FUNC_PATROL_TASK_DES);
    //数据表
    
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
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
    [tapGesture1 release];
    [seachImageView release];
    
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    [rightView release];
     */

    (APPDELEGATE).agent.delegate = self;
    
    taskArray = [[NSMutableArray alloc] initWithCapacity:10];
    TaskPatrolParams_Builder *bs = [TaskPatrolParams builder];
    if (user != nil) {
        [bs setParamUsersArray:[[NSArray alloc] initWithObjects:user, nil]];
    }
    [bs setPage:1];
    
    tpParams = [[bs build] retain];
    if (tpParams) {
        [self refreshTable];
    }else{
        [self refreshParamsAndTable];
    }
}

-(void) initFilterViewParams:(NameFilterViewController *) vc{
    if (user != nil) {
        vc._txtName.text = user.realName;
    }
}
#pragma -mark 更新参数
-(void) refreshParamsAndTable{
    [self refreshParams];
    [self refreshTable];
}

-(void) refreshParams{
    TaskPatrolParams_Builder* baseParam = [TaskPatrolParams builder];
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
    if (_name.length > 0) {
        User_Builder* u = [User builder];
        [u setRealName:_name];
        [u setId:0];
        [baseParam setParamUsersArray:[NSArray arrayWithObjects:[u build], nil]];
    }
    [baseParam setPage:1];
    tpParams = [[baseParam build] retain];
}

#pragma -mark NameFilterViewController delegate
-(void)NameFilterViewControllerSearch:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"筛选名称：%@",name);
    _name = name;
    _formTime = formTime;
    _endTime = endTime;
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
    NSMutableString* sb = [[[NSMutableString alloc] init] autorelease];
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

#pragma -mark HeaderSearchBar delegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    if (current == index) {
        [UIView removeViewFormSubViews:-1 views:_searchViews ];
        return;
    }
    [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
    [UIView removeViewFormSubViews:index views:_searchViews];
}

#pragma -mark 页面方法
-(void)openSearchView{
    
    TaskSearchViewController *ctrl = [[TaskSearchViewController alloc] init];
    ctrl.delegate = self;
    UINavigationController *searchNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self.parentCtrl presentModalViewController:searchNavCtrl animated:YES];
    //[ctrl release];
    //[searchNavCtrl release];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)clickLeftButton:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)clearTable{
    if (taskArray.count > 0){
        [taskArray removeAllObjects];
    }
}

-(void)didFinishedSearchWithResult:(TaskPatrolParams_Builder *)result{
    tpBuilder = [(TaskPatrolParams_Builder *)result retain];
    tpParams = [[tpBuilder build] retain];
    if(!self.pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullTableIsRefreshing = YES;
        //[self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
}

- (void) didReceiveMessage:(id)message{
    self.pullTableView.pullTableIsRefreshing = NO;
    self.pullTableView.pullTableIsLoadingMore = NO;
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type)  == ActionTypeTaskPatrolList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageTaskPatrol* pageTaskPatrol = [PageTaskPatrol parseFromData:cr.data];
        if ([super validateData:pageTaskPatrol]) {
            int taskCount = pageTaskPatrol.taskPatrols.count;
            if (currentPage == 1)
                [self clearTable];
            
            for (int i = 0 ;i < taskCount;i++){
                TaskPatrol* aw = (TaskPatrol*)[[pageTaskPatrol taskPatrols] objectAtIndex:i];
                [taskArray addObject:aw];
                
                
            }
            
            pageSize = pageTaskPatrol.page.pageSize;
            totalSize = pageTaskPatrol.page.totalSize;
            
            if (taskArray.count == 0) {
                /*[MESSAGE showMessageWithTitle:NSLocalizedString(@"patrol_task", @"")
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];*/
            }

        }
        
    }
    if (msgType != MESSAGE_UNKNOW) {
        //if ([sourceId isEqual: aw.id]) {
            [super readMessage:msgType SourceId:sourceId];
        //}
    }
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

-(void)reload{
    [self refreshTable];
}

- (void) refreshTable{
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    if (tpParams != nil){
        TaskPatrolParams_Builder* pb = [tpParams toBuilder];
        [pb setPage:1];
        tpParams = [[pb build] retain];
        
        (APPDELEGATE).agent.delegate = self;
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeTaskPatrolList param:tpParams]){
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)
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
        TaskPatrolParams_Builder* pb = [tpParams toBuilder];
        [pb setPage:currentPage];
        tpParams = [[pb build] retain];
    
        (APPDELEGATE).agent.delegate = self;
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeTaskPatrolList param:tpParams]){
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)
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

-(UIView*)setFootView {
    UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT - 150)];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 50)];
    textLabel.text =@"暂无内容";
    textLabel.font = [UIFont systemFontOfSize:15.0f];
    textLabel.textAlignment = 1;
    textLabel.textColor = [UIColor blackColor];
    [contentView addSubview:textLabel];
    return contentView;
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 113.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWHEADERHEIGHT;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([taskArray count] == 0) {
        [tableView setTableFooterView:[self setFootView]];
        return 0;
    }else {
        tableView.tableFooterView = [[UIView alloc]init];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [taskArray count] ;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    TaskPatrol *task = [taskArray objectAtIndex:indexPath.row];
    Task0Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"Task0Cell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[Task0Cell class]])
                cell=(Task0Cell *)oneObject;
        }
    }
    cell.title.text = task.name;
    cell.subTitle.text = task.taskType == 0?@"单次任务":@"周期任务";
    cell.duration.text = [NSString stringWithFormat:@"%@～%@",task.startDate,task.endDate];
    cell.userName.text = task.user.realName;
    [cell.btStatus setTitle:(task.taskStatus == 1?@"已完成":@"未完成") forState:UIControlStateNormal];
    [cell.btStatus setBackgroundImage:[UIImage imageNamed:(task.taskStatus == 1?@"bg_msgbox_state_read":@"bg_msgbox_state_starting")] forState:UIControlStateNormal];
//    if (task.taskStatus != 1) {
//        cell.btStatus.backgroundColor = [UIColor orangeColor];
//        cell.btStatus.layer.cornerRadius = 8.0f;
//        cell.btStatus.layer.masksToBounds = YES;
//    }
    if (task.replyCount > 0) {
        [cell.btComment setTitle:[NSString stringWithFormat:@"%d",task.replyCount] forState:UIControlStateNormal];
        [cell.btComment.layer setMasksToBounds:YES];
        [cell.btComment.layer setCornerRadius:13.0];
        cell.btComment.layer.borderWidth = 1;
        cell.btComment.layer.borderColor =[UIColor grayColor].CGColor;
        [cell.btComment setBackgroundColor:[UIColor clearColor]];
        [cell.btComment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else{
        [cell.btComment setTitle:@"" forState:UIControlStateNormal];
        [cell.btComment setBackgroundImage:nil forState:UIControlStateNormal];
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (msgType != MESSAGE_UNKNOW) {
        if ([sourceId isEqual: task.id]) {
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

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskDetailViewController *vctrl = [[TaskDetailViewController alloc] init];
    TaskPatrol *task = [taskArray objectAtIndex:indexPath.row];
    vctrl.taskId = task.id;
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:vctrl];
    [self.parentCtrl presentModalViewController:navCtrl animated:YES];
    //[vctrl release];
}

- (void) refresh:(TaskPatrol *)task{
    for (int i = 0; i < taskArray.count; i++) {
        if (((TaskPatrol*)[taskArray objectAtIndex:i]).id == task.id){
            [taskArray removeObjectAtIndex:i];
            [taskArray insertObject:task atIndex:i];
            
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
    [taskArray release];
    [pullTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [taskArray release];
    [pullTableView release];
    [self setPullTableView:nil];
    [super viewDidUnload];
}


@end
