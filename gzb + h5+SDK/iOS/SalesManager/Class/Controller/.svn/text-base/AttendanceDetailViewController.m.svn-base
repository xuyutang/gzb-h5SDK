//
//  AttendanceDetailViewController.m
//  SalesManager
//
//  Created by liuxueyan on 20/5/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "AttendanceDetailViewController.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "TextFieldCell.h"
#import "LiveImageCell.h"
#import "LocationCell.h"
#import "BigImageViewController.h"
#import "NSString+Util.h"
#import "InputViewController.h"
#import "PatrolDetailReplyCell.h"
#import "SDImageView+SDWebCache.h"
#import "UIView+CNKit.h"

@interface AttendanceDetailViewController ()<InputFinishDelegate>{
    NSMutableArray *replies;
}
@end

@implementation AttendanceDetailViewController
@synthesize attendance,delegate,attendanceId,msgType;

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
    appDelegate = APPDELEGATE;
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT-45) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.allowsSelection = NO;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];

    
    AGENT.delegate = self;
    if (attendance != nil) {
        [self _show];
    }else{
        [self _getAttendance];
    }
    [self createBottomBar];
    [lblFunctionName setText:TITLENAME(FUNC_ATTENDANCE_DES)];
}

-(void)_show{
    self.lblFunctionName.text = [NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"sign_attendance", @""),attendance.user.realName];
    //self.lblFunctionName.text = TITLENAME_STR(FUNC_ATTENDANCE_DES, attendance.user.realName);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    [self initData];
    [tableView reloadData];
    
}

-(void)_getAttendance{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    AttendanceParams_Builder* pb = [AttendanceParams builder];
    
    [pb setAttendanceId:attendanceId];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeAttendanceGet param:[pb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }

}

- (void)initData{
    //attendanceReply = nil;
    strAttendanceReply = @"";
    
    imageFiles = [[NSMutableArray alloc] init];
    for (int i = 0; i<[attendance.filePath count]; i++) {
        [imageFiles addObject:[attendance.filePath objectAtIndex:i]];
    }
}

-(void)createBottomBar{
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, MAINHEIGHT-45, MAINWIDTH, 45)];
    [bottom setBackgroundColor:[UIColor whiteColor]];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, .5f)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    [bottom addSubview:line1];
    [line1 release];

    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    // [button1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button1 setTitle:NSLocalizedString(@"title_reply", nil) forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    [button1 addTarget:self action:@selector(toReply) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button1];
    [self.view addSubview:bottom];
    [bottom release];
}

-(void)didFinishInput:(int)tag Input:(NSString *)input{
    (APPDELEGATE).agent.delegate = self;
    [self dismissKeyBoard:nil];
    
    if (input.trim.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"worklog_hint_reply", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
        
    }
    
    if (input.trim.length > 1000){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"input_limit_1000", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
        
    }

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"loading", @"");
        
        AttendanceReply_Builder* br = [AttendanceReply builder];
    
        [br setContent:input.trim];
        [br setCreateDate:[NSDate getCurrentTime]];
        [br setSender:USER];
        [br setAttendanceId:attendance.id];
        [br setId:-1];
        
        
        AttendanceReply* ar = [br build];
        attendanceReply = [ar retain];
        
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeAttendanceReply param:ar]){
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }

    }

-(void)toReply{
    if (USER.id == attendance.user.id) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"reply_error_self", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    if (attendance.attendanceReplies.count > 0) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"reply_error_again", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    //ctrl.tag = view.tag;
    ctrl.delegate = self;
    ctrl.bNeedBack = YES;
    //[self presentViewController:ctrl animated:YES completion:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}



-(void)toSave:(id)sender{
    (APPDELEGATE).agent.delegate = self;
    [self dismissKeyBoard:nil];
    if (tvReplyCell.textView.text.trim.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"worklog_hint_reply", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
    } else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"loading", @"");
        
        AttendanceReply_Builder* arb = [AttendanceReply builder];
        
        [arb setContent:strAttendanceReply];
        [arb setCreateDate:[NSDate getCurrentTime]];
        [arb setAttendanceId:attendance.id];
        [arb setId:-1];

        
        AttendanceReply* ar = [arb build];
        attendanceReply = [ar retain];
        
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeAttendanceReply param:ar]){
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }
        tvReplyCell.textView.editable = NO;
    }
}

-(void)clickLeftButton:(id)sender{
    
    if (attendanceReply != nil){
        if (delegate != nil && [delegate respondsToSelector:@selector(refresh:)]) {
            [delegate refresh:attendance];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

-(IBAction)dismissKeyBoard:(UIBarButtonItem *)sender
{
    if (tvReplyCell != nil && tvReplyCell.textView != nil) {
        [tvReplyCell.textView resignFirstResponder];
    }
}

-(IBAction)clearInput:(id)sender{
    
    if (tvReplyCell != nil && tvReplyCell.textView != nil)
        tvReplyCell.textView.text = @"";
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4;
     
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    switch (section) {
        case 0:{
            return NSLocalizedString(@"title_attendance_category", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"title_attendance_info", nil);
        }
            break;
        case 2:{
            return NSLocalizedString(@"worklog_label_reply", nil);
        }
        default:
            break;
    }
    return @"";
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不让tableviewcell有选中效果
    if(indexPath.section == 1)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 0;
    }else if(indexPath.section == 1){
    
        if (indexPath.row == 0) {
            return 150.0f;
        }else if(indexPath.row == 1 && (imageFiles.count>0)){
            return 88.0f;
        }else{
            return 50.0f;
        }
    }else{
        NSString* text = ((AttendanceReply*)[attendance.attendanceReplies objectAtIndex:indexPath.row]).content;
        CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
        
        CGFloat height = MAX(size.height + 45.0f, 75.0f);
        return height;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if(section == 1){
        
        if (imageFiles.count>0) {
            return 3;
        }
        return 2;
    }
    if (section == 2) {
        return attendance.attendanceReplies.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 37;
    }
    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier1"];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = attendance.category.name;

    }
    if(indexPath.section == 1){
        if (indexPath.row == 0) {
            txtCell=(TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier2"];
            if(txtCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TextFieldCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[TextFieldCell class]])
                        txtCell=(TextFieldCell *)oneObject;
                }
            }
            txtCell.title.text = NSLocalizedString(@"memo", nil);
            txtCell.txtField.text= attendance.comment;
            txtCell.txtField.editable = NO;
            CGRect rect = txtCell.txtField.frame;
            rect.size.height = 110;
            txtCell.txtField.frame = rect;
            
            cell = txtCell;
            
            
        }else if(indexPath.row == 1 && (imageFiles.count>0)){
            
            LiveImageCell *liveImageCell = [[LiveImageCell alloc] initWithImages:imageFiles];
            liveImageCell.delegate = self;
            //(LiveImageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(liveImageCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LiveImageCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[LiveImageCell class]])
                        liveImageCell=(LiveImageCell *)oneObject;
                }
            }
            //[liveImageCell addDetailImage:imageFiles];
            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return liveImageCell;
            
        }else if(indexPath.row == 2 || (indexPath.row == 1 && (imageFiles.count<1))){
            
            locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:@"CellIdentifier3"];
            if(locationCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[LocationCell class]])
                        locationCell=(LocationCell *)oneObject;
                }
            }
            locationCell.btnRefresh.hidden = YES;
            locationCell.lblAddress.width = MAINWIDTH - 30;
            if (!attendance.location.address.isEmpty) {
                [locationCell.lblAddress setText:attendance.location.address];
            }else{
                [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",attendance.location.latitude,attendance.location.longitude]];
            }
            
            cell = locationCell;
        }
    }
    if(indexPath.section == 2){
        PatrolDetailReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolDetailReplyCell"];
        if (cell == nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolDetailReplyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        AttendanceReply *reply = [attendance.attendanceReplies objectAtIndex:indexPath.row];
        if (reply.content != nil && reply.content.length >0) {
            NSString* avtar = @"";
            if (reply.sender.avatars.count > 0) {
                avtar = [reply.sender.avatars objectAtIndex:0];
            }
            [cell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
            cell.icon.layer.cornerRadius = 30.f;
            cell.icon.layer.masksToBounds = YES;
            cell.name.text = reply.sender.realName;
            cell.time.text = reply.createDate;
            
            NSString* text = reply.content;
            CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
            
            CGFloat height = MAX(size.height, 42.0f);
            
            CGRect rect = cell.content.frame;
            UILabel* lContent = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 3,rect.size.width,height)];
            lContent.backgroundColor = WT_CLEARCOLOR;
            lContent.numberOfLines = 0;
            lContent.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
            lContent.textColor = WT_GRAY;
            lContent.text = reply.content;
            [cell.contentView addSubview:lContent];
            [lContent release];
            lContent = nil;
            
            cell.content.hidden = YES;
            cell.content.text = reply.content;
        }
        return cell;
    }
    return cell;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, MAINWIDTH, 30)]
    ;
    label.text = NSLocalizedString(@"attendance_replay", @"");
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor orangeColor];
       return label;

}

-(void)openPhoto:(int)index{
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [imageFiles objectAtIndex:index];
    ctrl.functionName = [NSString stringWithFormat:@"[%@]%@",attendance.category.name,attendance.user.realName];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void) textViewDidChange:(UITextView *)textView{
    strAttendanceReply = [textView.text retain];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void) didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeAttendanceReply:{
            
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                if (attendanceReply != nil){

                    [replies addObject:attendanceReply];
                    Attendance_Builder* ab = [attendance toBuilder];
                    [ab setAttendanceRepliesArray:replies];
                    
                    Attendance* a = [[ab build] retain];
                    [attendance release];
                    attendance = nil;
                    attendance = a;
                    [self.navigationController popViewControllerAnimated:YES];
                    [tableView reloadData];
                }
                
            }
            //rightView.hidden = YES;
            [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"attendancereply_msg_saved", @"")];
            
        }
            break;
        case ActionTypeAttendanceGet:{
            HUDHIDE;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                Attendance* a = [Attendance parseFromData:cr.data];
                if ([super validateData:a]) {
                    attendance = [a retain];
                    
                    replies = [[NSMutableArray alloc] init];
                    for (int i = 0; i < attendance.attendanceReplies.count; ++i) {
                        [replies addObject:[attendance.attendanceReplies objectAtIndex:i]];
                    }
                    
                    [self _show];
                }
            }
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",attendanceId]];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
            
        }
            break;
            
        default:
            break;
    }

}
@end
