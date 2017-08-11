//
//  TaskListViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-3-4.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "SingleTaskListViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "TaskCell.h"
#import "BaseTable1HeaderView.h"
#import "TaskDetailViewController.h"
#import "Product.h"
#import "HMSegmentedControl.h"
#import "MyTaskDetailViewController.h"

@interface SingleTaskListViewController ()

@end

@implementation SingleTaskListViewController
@synthesize tableView,parentCtrl;

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
    
    lblFunctionName.text = NSLocalizedString(@"customer_contacts_book", nil);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80,50)];

    statusSegCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:@[NSLocalizedString(@"task_status_not_finish", nil), NSLocalizedString(@"task_status_finish", nil),NSLocalizedString(@"task_status_all", nil)]];

    [statusSegCtrl setFrame:CGRectMake(0, 0, 320, 35)];
    [statusSegCtrl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
    statusSegCtrl.selectionIndicatorMode = HMSelectionIndicatorFillsSegment;
    statusSegCtrl.textColor = [UIColor whiteColor];
    statusSegCtrl.selectionIndicatorColor = [UIColor colorWithRed:244 green:235 blue:0 alpha:0.8];
    [statusSegCtrl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:statusSegCtrl];
    
    tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 35, 320, MAINHEIGHT - 74) style:UITableViewStylePlain];
    tableView.pullBackgroundColor = [UIColor yellowColor];
    tableView.pullTextColor = [UIColor blackColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.pullDelegate = self;
    
    tableView.bounces = NO;
    tableView.allowsSelection = YES;
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    currentStatus = TASK_STATUS_NOT_FINISH;
    bSwitching = YES;
    //[self initData];
}


-(void)segmentAction:(id)sender{
    if(bSwitching)return;
    bSwitching = YES;
    switch (statusSegCtrl.selectedIndex) {
        case 0:{
            currentStatus = TASK_STATUS_NOT_FINISH;
        }
            break;
        case 1:{
            currentStatus = TASK_STATUS_FINISH;
        }
            break;
        case 2:{
            currentStatus = TASK_STATUS_ALL;
        }
            break;
    }
    [self initData];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

-(void) reload{
    [self initData];
}



-(void) initData{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:MAINVIEW];
    }
    
    [MAINVIEW addSubview:HUD];
	HUD.labelText = NSLocalizedString(@"loading", @"");
	HUD.delegate = self;
    [HUD show:YES];
    
	//[HUD showWhileExecuting:@selector(_loadData) onTarget:self withObject:nil animated:YES];

    [self refreshTable];
}

- (void) refreshTable{
    tableView.pullLastRefreshDate = [NSDate date];
    tableView.pullTableIsRefreshing = YES;
    [self _loadData];
}

-(void) _loadData{
    
    TaskPatrolParams_Builder *ppb = [TaskPatrolParams builder];
    [ppb setTaskStatus:currentStatus];
    [ppb setTaskType:SINGLE_TASK];
    TaskPatrolParams *tpp = [ppb build];
        
        SOCKET.delegate = self;
        if (DONE != [SOCKET sendRequestWithType:RequestTypeMyTaskPatrolList param:tpp]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"patrol_task", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    ClientResponse* cr = [ClientResponse parseFromData:(NSData*)message];
    if ((cr.type == RequestTypeMyTaskPatrolList) && (cr.code == ResultCodeResponseDone)){
        if (tasks != nil) {
            [tasks release];
        }
        tasks = [[PBAppendableArray alloc] initWithArray:cr.pageTaskPatrol.taskPatrols valueType:PBArrayValueTypeObject];


        if (tasks.count == 0) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"patrol_task", @"")
                              description:NSLocalizedString(@"noresult", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
        }
        bSwitching = NO;
    }
    
    [self.tableView reloadData];
    
    HUDHIDE2;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{

    [super webSocket:webSocket didFailWithError:error];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    [super webSocket:webSocket didCloseWithCode:code reason:reason wasClean:wasClean];
}

#pragma mark - UITableView Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //SMContact *tmp = (SMContact *)[filterContacts objectAtIndex:section];
    return tasks.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    TaskPatrol *task = [tasks objectAtIndex:indexPath.row];
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
    //NSLog(@"%f",dFinished/(dFinished+dUnfinished));
    cell.progress.progress = dFinished/(dFinished+dUnfinished);
    cell.progress.roundedHead = NO;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTaskDetailViewController *vctrl = [[MyTaskDetailViewController alloc] init];
    TaskPatrol *task = [tasks objectAtIndex:indexPath.row];
    vctrl.taskId = task.id;
    UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:vctrl];
    //[self.parentCtrl presentViewController:patrolNavCtrl animated:YES completion:nil];
    [self.parentCtrl.navigationController pushViewController:vctrl animated:YES];
    [vctrl release];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
