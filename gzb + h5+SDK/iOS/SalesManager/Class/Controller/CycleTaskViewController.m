//
//  CycleTaskViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-3-25.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "CycleTaskViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "TaskCell.h"
#import "BaseTable1HeaderView.h"
#import "MyTaskDetailViewController.h"
#import "NSDate+Util.h"

@implementation RepeatTask
@synthesize date,tasks;
@end

@interface CycleTaskViewController ()

@end

@implementation CycleTaskViewController
@synthesize pullTableView,parentCtrl;

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
    
    lblFunctionName.text = TITLENAME(FUNC_PATROL_TASK_DES);
    
    [pullTableView setFrame:CGRectMake(0, 35, MAINWIDTH, MAINHEIGHT+50)];
    pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    pullTableView.pullBackgroundColor = [UIColor yellowColor];
    pullTableView.pullTextColor = [UIColor blackColor];
    pullTableView.delegate = self;
    pullTableView.dataSource = self;
    pullTableView.pullDelegate = self;
    
//    statusSegCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:@[NSLocalizedString(@"task_status_not_finish", nil), NSLocalizedString(@"task_status_finish", nil),NSLocalizedString(@"task_status_all", nil)]];
    statusSegCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:@[NSLocalizedString(@"task_status_all", nil), NSLocalizedString(@"task_status_finish", nil),NSLocalizedString(@"task_status_not_finish", nil)]];
    
    [statusSegCtrl setFrame:CGRectMake(0, 0, 320, 35)];
//    [statusSegCtrl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
    statusSegCtrl.selectionIndicatorMode = HMSelectionIndicatorFillsSegment;
    statusSegCtrl.textColor = [UIColor blackColor];
    statusSegCtrl.selectionIndicatorColor = WT_RED;
    [statusSegCtrl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, MAINWIDTH, 0.5f)];
    lab2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lab2];
    [self.view addSubview:statusSegCtrl];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 0.5f)];
    lab.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lab];
    UILabel *lab3= [[UILabel alloc] initWithFrame:CGRectMake(MAINWIDTH/3, 5, 0.5f, 25)];
    lab3.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lab3];
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(MAINWIDTH/3*2, 5, 0.5f, 25)];
    lab4.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lab4];
    [lab release];
    [lab2 release];
    [lab3 release];
    [lab4 release];
    
    (APPDELEGATE).agent.delegate = self;
    
    currentStatus = TASK_STATUS_ALL;
    bSwitching = YES;

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)clickLeftButton:(id)sender{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)segmentAction:(id)sender{
    if(bSwitching)return;
    bSwitching = YES;
    switch (statusSegCtrl.selectedIndex) {
        case 0:{
            currentStatus = TASK_STATUS_ALL;
        }
            break;
        case 1:{
            currentStatus = TASK_STATUS_FINISH;
        }
            break;
        case 2:{
            currentStatus = TASK_STATUS_NOT_FINISH;
        }
            break;
    }
    [self initData];
    
}

-(void) reload{
    [self.pullTableView setFrame:CGRectMake(0, 35, MAINWIDTH, MAINHEIGHT-75)];
    [self initData];
}



-(void) initData{
    if (taskArray != nil && taskArray.count > 0) {
        [taskArray removeAllObjects];
        [taskArray release];
    }
    taskArray = [[NSMutableArray alloc] init];
    [pullTableView reloadData];
    
    [self refreshTable];
}

- (void) refreshTable{
    pullTableView.pullLastRefreshDate = [NSDate date];
    pullTableView.pullTableIsRefreshing = YES;
    [self _loadData];
}

- (void) loadMoreDataToTable
{
    self.pullTableView.pullTableIsLoadingMore = NO;
}


-(void) _loadData{
    TaskPatrolParams_Builder *pp = [TaskPatrolParams builder];
    [pp setTaskStatus:currentStatus];
    [pp setTaskType:REPEAT_TASK];
    TaskPatrolParams *tpp = [pp build];
    
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeMyTaskPatrolList param:tpp]){
        pullTableView.pullTableIsRefreshing = NO;
        pullTableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
}

-(void)reCreateTasks{
    if (taskArray.count > 0) {
        [taskArray removeAllObjects];
    }
    for (TaskPatrol *task in tasks){
        BOOL bDateExist = NO;
        for (RepeatTask *newTask in taskArray) {
            if ([task.startDate isEqualToString:newTask.date]) {
                [newTask.tasks addObject:task];
                bDateExist = YES;
            }
        }
        
        if (!bDateExist) {
            RepeatTask *newTask = [[RepeatTask alloc] init];
            newTask.date = task.startDate;
            newTask.tasks = [[PBAppendableArray alloc] init];
            [newTask.tasks addObject:task];
            [taskArray addObject:newTask];
            [newTask release];
        }
    }
}


- (void) didReceiveMessage:(id)message{
    pullTableView.pullTableIsRefreshing = NO;
    pullTableView.pullTableIsLoadingMore = NO;
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeMyTaskPatrolList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        if (tasks != nil) {
            [tasks release];
        }
        PageTaskPatrol* pageTaskPatrol = [PageTaskPatrol parseFromData:cr.data];
        if ([super validateData:pageTaskPatrol]) {
            tasks = [[PBAppendableArray alloc] init];
            if (pageTaskPatrol.taskPatrols.count > 0) {
                [tasks appendArray:pageTaskPatrol.taskPatrols];
            }
            
            [self reCreateTasks];
            [pullTableView reloadData];
            if (tasks.count == 0) {
                /*[MESSAGE showMessageWithTitle:NSLocalizedString(@"patrol_task", @"")
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];*/
            }
            bSwitching = NO;
        }
    }
    
    [pullTableView reloadData];
    HUDHIDE2;
}

- (void) didFailWithError:(NSError *)error{
    
    [super didFailWithError:error];
    pullTableView.pullTableIsRefreshing = NO;
    pullTableView.pullTableIsLoadingMore = NO;
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
    pullTableView.pullTableIsRefreshing = NO;
    pullTableView.pullTableIsLoadingMore = NO;
}

-(UIView*)setFootView {
    UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT - 150)];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 50)];
    textLabel.text =@"本周暂无巡访任务.";
    textLabel.font = [UIFont systemFontOfSize:15.0f];
    textLabel.textAlignment = 1;
    textLabel.textColor = [UIColor blackColor];
    [contentView addSubview:textLabel];
    return contentView;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tasks.count == 0) {
        [tableView setTableFooterView:[self setFootView]];
        return 0;
    }else {
        tableView.tableFooterView = [[UIView alloc]init];
    }
    return taskArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //SMContact *tmp = (SMContact *)[filterContacts objectAtIndex:section];
    return ((RepeatTask *)[taskArray objectAtIndex:section]).tasks.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable1HeaderView" owner:self options:nil];
    BaseTable1HeaderView *header = [nibViews objectAtIndex:0];
    header.title.text = ((RepeatTask *)[taskArray objectAtIndex:section]).date;
    return header;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    NSLog(@"taskArray count=%d  RepeatTask tasks count = %d; indexPath.section=%d indexPath.row = %d",taskArray.count,((RepeatTask *)[taskArray objectAtIndex:indexPath.section]).tasks.count,indexPath.section,indexPath.row);
    TaskPatrol *task = [((RepeatTask *)[taskArray objectAtIndex:indexPath.section]).tasks objectAtIndex:indexPath.row];
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TaskCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[TaskCell class]])
                cell=(TaskCell *)oneObject;
        }
    }
    cell.title.text = task.name;
    //cell.subTitle.text = task.startDate;
    double dFinished = task.finishCount;
    double dUnfinished = task.unfinishedCount;
    NSLog(@"%f/%f = %f",dFinished,dUnfinished,dFinished/(dFinished+dUnfinished));
    cell.progress.progress = dFinished/(dFinished+dUnfinished);
    
    cell.progress.roundedHead = NO;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTaskDetailViewController *vctrl = [[MyTaskDetailViewController alloc] init];
    RepeatTask *repeatTask = (RepeatTask *)[taskArray objectAtIndex:indexPath.section];
    TaskPatrol *task = [repeatTask.tasks objectAtIndex:indexPath.row];
    vctrl.taskId = task.id;
    vctrl.taskDate = repeatTask.date;
    vctrl.bCycle = YES;
    UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:vctrl];
    //[self.parentCtrl presentViewController:patrolNavCtrl animated:YES completion:nil];
    [self.parentCtrl.navigationController pushViewController:vctrl animated:YES];
    [vctrl release];
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
    [statusSegCtrl release];
    [tasks release];
    [taskArray removeAllObjects];
    [taskArray release];
    [pullTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [statusSegCtrl release];
    [tasks release];
    [taskArray removeAllObjects];
    [taskArray release];
    [self setPullTableView:nil];
    [super viewDidUnload];
}
@end
