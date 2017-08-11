//
//  MyTaskDetailViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-3-6.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "MyTaskDetailViewController.h"
#import "SelectCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"
#import "AppDelegate.h"
#import "CustomerSelectViewController.h"
#import "LXActivity.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+Helpers.h"
#import "PatrolViewController.h"
#import "NSDate+Util.h"
#import "PatrolDetail2ViewController.h"

@interface MyTaskDetailViewController (){
    NSMutableArray* replies;
}
@end

@implementation MyTaskDetailViewController
@synthesize taskId,taskDate,bCycle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData{
    
    if ([imageFiles count]>0) {
        [LOCALMANAGER clearImagesWithFiles:imageFiles];
        [imageFiles removeAllObjects];
    }
    imageFiles = [[NSMutableArray alloc] init];
    
    textViewCell.textView.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    //[self initData];
    
    UIButton *btWrite = [UIButton buttonWithType:UIButtonTypeCustom];
    [btWrite setBackgroundImage:[UIImage imageNamed:@"bt_write"] forState:UIControlStateNormal];
    [btWrite addTarget:self action:@selector(toComment:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btWrite setFrame:CGRectMake(90, 10, 44, 44)];
    /*
     UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 15, 50, 30)];
     [saveImageView setImage:[UIImage imageNamed:@"bt_write"]];
     saveImageView.userInteractionEnabled = YES;
     //UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toComment:forEvent:)];
     //[tapGesture2 setNumberOfTapsRequired:1];
     saveImageView.contentMode = UIViewContentModeScaleAspectFit;
     // [saveImageView addGestureRecognizer:tapGesture2];*/
    [rightView addSubview:btWrite];
    //[saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [btRight setAction:@selector(toComment:forEvent:)];
    //[btLogo setAction:@selector(clickLeftButton:)];
    //self.rightButton = btRight;
    [btRight release];
	
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    //tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    
    //KWPopoverView
    popCommentView = [[IMGCommentView alloc] initWithFrame:CGRectMake(0, 45, 320, 280)];
    popCommentView.parentCtrl = self;
    
    appDelegate = APPDELEGATE;
    
    [lblFunctionName setText:TITLENAME(FUNC_PATROL_TASK_DES)];
    
    AGENT.delegate = self;
    
    //[self getDetail];
}

-(void)clickLeftButton:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    // [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    AGENT.delegate = self;
    [self initData];
    [self getDetail];
}

- (IBAction)toComment:(id)sender forEvent:(UIEvent *)event{
    
    
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    NSSet *set = event.allTouches;
    UITouch *touch = [set anyObject];
    CGPoint point1 = [touch locationInView:window];
    //    CGPoint point = sender.center;
    [KWPopoverView showPopoverAtPoint:point1 inView:self.view withContentView:popCommentView];
    
    
}



- (void) getDetail{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    TaskPatrolDetailParams_Builder *pp = [TaskPatrolDetailParams builder];
    [pp setTaskId:taskId];
    if (taskDate != nil && taskDate.length >0) {
        [pp setStartDate:taskDate];
    }
    TaskPatrolDetailParams *tpp = [pp build];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeMyTaskPatrolGet param:tpp]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE;
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type) ) {
        case ActionTypeMyTaskPatrolGet:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                TaskPatrol* t = [TaskPatrol parseFromData:cr.data];
                if ([super validateData:t]) {
                    taskPatrol = [t retain];
                    [tableView reloadData];
                }
                
            }
            [super showMessage2:cr Title:TITLENAME(FUNC_PATROL_TASK_DES) Description:NSLocalizedString(@"patrol_task_got", @"")];
            
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (taskPatrol == nil) {
        return 0;
    }else if(taskPatrol.replyCount <1){
        return 1;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            return 40;
        }
            break;
        case 1:{
            return 40;
        }
            break;
        case 2:{
            return 40;
        }
            break;
        case 3:{
            return 120;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
            /*case 0:{
             return NSLocalizedString(@"patrol_task_info", nil);
             }
             break;*/
        case 0:{
            return NSLocalizedString(@"patrol_sub_task", nil);
        }
            break;
        case 2:{
            return NSLocalizedString(@"patrol_task_comments", nil);
        }
            break;
            
        default:
            break;
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return taskPatrol.detail.count;//6;////////////
    }else{
        return replies.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        TaskPatrolDetail *detail = [taskPatrol.detail objectAtIndex:indexPath.row];
        if (detail.taskStatus == TASK_STATUS_FINISH) {
            PatrolDetail2ViewController *vctrl = [[PatrolDetail2ViewController alloc] init];
            vctrl.patrolId = detail.patrolId;
            vctrl.bNeedBack = YES;
            [self.navigationController pushViewController:vctrl animated:YES];
        }else{
            if (bCycle) {
                NSDate *selectDate = [NSDate dateFromString:taskDate withFormat:[NSDate dateFormatString]];
                NSDate *currentDate = [NSDate dateFromString:[NSDate getCurrentDate] withFormat:[NSDate dateFormatString]];
                if (![selectDate isEqualToDate:currentDate]) {// && [[selectDate earlierDate:currentDate] isEqualToDate:selectDate]
                    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_PATROL_TASK_DES)
                                      description:NSLocalizedString(@"task_time_error", @"")
                                             type:MessageBarMessageTypeInfo
                                      forDuration:INFO_MSG_DURATION];
                    return;
                }
            }
            
            PatrolViewController *vctrl = [[PatrolViewController alloc] init];
            vctrl.taskId = detail.taskId;
            vctrl.taskCustomer = detail.customer;
            [self.navigationController pushViewController:vctrl animated:YES];
        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    NSString *taskTypeRepeat =  NSLocalizedString(@"patrol_task_repeat", nil);
    NSString *taskTypeSingle =  NSLocalizedString(@"patrol_task_single", nil);
    NSString *taskStatusFinish =  NSLocalizedString(@"task_status_finish", nil);
    NSString *taskStatusNoFinish =  NSLocalizedString(@"task_status_not_finish", nil);
    
    switch (indexPath.section) {
        case 4:{
            InputCell *categorySelectCell =(InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell00"];
            if(categorySelectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InputCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[InputCell class]])
                        categorySelectCell=(InputCell *)oneObject;
                }
                categorySelectCell.inputField.placeholder = @"";
                categorySelectCell.inputField.enabled = NO;
            }
            if (indexPath.row == 0) {
                categorySelectCell.title.text = NSLocalizedString(@"task_name", nil);
                categorySelectCell.inputField.text = taskPatrol.name;
            }else if (indexPath.row == 1){
                categorySelectCell.title.text = NSLocalizedString(@"task_type", nil);
                categorySelectCell.inputField.text = taskPatrol.taskType == 0?taskTypeSingle:taskTypeRepeat;
            }else if (indexPath.row == 2){
                categorySelectCell.title.text = NSLocalizedString(@"task_status", nil);
                categorySelectCell.inputField.text = taskPatrol.taskStatus == 0?taskStatusNoFinish:taskStatusFinish;
            }else if (indexPath.row == 3){
                categorySelectCell.title.text = NSLocalizedString(@"task_start_time", nil);
                categorySelectCell.inputField.text = taskPatrol.startDate;
            }else if (indexPath.row == 4){
                categorySelectCell.title.text = NSLocalizedString(@"task_end_time", nil);
                categorySelectCell.inputField.text = taskPatrol.endDate;
            }else if (indexPath.row == 5){
                categorySelectCell.title.text = NSLocalizedString(@"task_finished_time", nil);
                categorySelectCell.inputField.text = taskPatrol.finishDate;
            }
            
            categorySelectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return categorySelectCell;
        }
            break;
        case 0:{
            
            TaskPatrolDetail *detail = [taskPatrol.detail objectAtIndex:indexPath.row];
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
            }
            CGRect rect = selectCell.title.frame;
            [selectCell.title setFrame:CGRectMake(rect.origin.x, rect.origin.y, CELL_CONTENT_WIDTH-110, rect.size.height)];
            selectCell.title.text = detail.customer.name;
            selectCell.value.text = detail.taskStatus == 0?taskStatusNoFinish:taskStatusFinish;
            selectCell.value.textAlignment = NSTextAlignmentRight;
            selectCell.selectionStyle= UITableViewCellSelectionStyleBlue;
            return selectCell;
        }
            break;
        case 2:{
            NSString *history = @"HistoryCell";
            TaskPatrolReply *reply = [replies objectAtIndex:indexPath.row];
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:history];
            if(cell==nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:history];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                cell.detailTextLabel.textColor = [UIColor darkGrayColor];
            }
            cell.textLabel.text = reply.sender.realName;
            cell.detailTextLabel.text = reply.content;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (void)dealloc {
    [imageFiles release];
    [rightView release];
    [tableView release];
    [popCommentView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [imageFiles release];
    [rightView release];
    rightView = nil;
    [tableView release];
    tableView = nil;
    [popCommentView release];
    popCommentView = nil;
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
