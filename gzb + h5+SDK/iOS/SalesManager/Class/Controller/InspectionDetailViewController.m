//
//  InspectionDetailViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-12-4.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InspectionDetailViewController.h"
#import "SelectCell.h"
#import "LiveImageCell.h"
#import "InspectionTargetCell.h"
#import "InspectionTypeViewController.h"
#import "AppDelegate.h"
#import "CustomerSelectViewController.h"
#import "InspectionListViewController.h"
#import "BigImageViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "InputViewController.h"
#import "PatrolDetailReplyCell.h"
#import "SDImageView+SDWebCache.h"
#import "InspectionViewController.h"

@interface InspectionDetailViewController ()<InputFinishDelegate>{
    NSMutableArray *replies;
}
@end

@implementation InspectionDetailViewController

@synthesize inspection,delegate,inspectionId,msgType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData{
    
    inspectionReply = nil;
    strInspectionReply = @"";
    
    imageFiles = [[NSMutableArray alloc] init];
    for (int i = 0; i<[inspection.filePath count]; i++) {
        [imageFiles addObject:[inspection.filePath objectAtIndex:i]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT-45) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    //tableView.allowsSelection = NO;
    [tableView setBackgroundColor:WT_WHITE];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    AGENT.delegate = self;
    if (inspection != nil) {
        [self _show];
    }else{
        [self _getInspectionReport];
    }
    [self createBottomBar];
    [lblFunctionName setText:TITLENAME(FUNC_INSPECTION_DES)];
}

- (void) _show{
    [self initData];
    /*if ((inspection.user.id != USER.id) && (inspection.inspectionReportReplies.count == 0)){
        rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 15, 50, 30)];
        [saveImageView setImage:[UIImage imageNamed:@"topbar_button_save"]];
        saveImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
        [tapGesture2 setNumberOfTapsRequired:1];
        saveImageView.contentMode = UIViewContentModeScaleAspectFit;
        [saveImageView addGestureRecognizer:tapGesture2];
        [rightView addSubview:saveImageView];
        [saveImageView release];
        
        UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.rightButton = btRight;
        [btRight release];
    }*/
    [self.navigationController setNavigationBarHidden:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    [tableView reloadData];
    
    self.lblFunctionName.text = TITLENAME_STR(FUNC_INSPECTION_DES, inspection.user.realName);
}

- (void) _getInspectionReport{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    InspectionReportParams_Builder* pb = [InspectionReportParams builder];
    
    [pb setId:inspectionId];

    if (DONE != [AGENT sendRequestWithType:ActionTypeInspectionReportGet param:[pb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
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
    
    NSString *strReply = input.trim;
    if (strReply.length == 0){
        
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

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"loading", @"");
        
        InspectionReportReply_Builder* prb = [InspectionReportReply builder];
        
        [prb setContent:input.trim];
        [prb setCreateDate:[NSDate getCurrentTime]];
        [prb setSender:USER];
        [prb setInspectionReportId:inspection.id];
        [prb setId:-1];
        
        InspectionReportReply* pr = [prb build];
        inspectionReply = [pr retain];
        
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeInspectionReportReply param:pr]){
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }
    
}


-(void)toReply{
    if (USER.id == inspection.user.id) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"reply_error_self", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    if (inspection.inspectionReportReplies.count > 0) {
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



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)clickLeftButton:(id)sender{
    if (inspectionReply != nil){
        if (delegate != nil && [delegate respondsToSelector:@selector(refresh:)]) {
            [delegate refresh:inspection];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)toSave:(id)sender{
    (APPDELEGATE).agent.delegate = self;
    [self dismissKeyBoard:nil];
    
    NSString *strReply = tvReplyCell.textView.text.trim;
    if (strReply.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"worklog_hint_reply", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
    } else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"loading", @"");
        
        InspectionReportReply_Builder* prb = [InspectionReportReply builder];
        
        [prb setContent:strReply];
        [prb setCreateDate:[NSDate getCurrentTime]];
        [prb setInspectionReportId:inspection.id];
        [prb setId:-1];
        
        InspectionReportReply* pr = [prb build];
        inspectionReply = [pr retain];
        
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeInspectionReportReply param:pr]){
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }
        tvReplyCell.textView.editable = NO;
    }
    
    
}

-(IBAction)dismissKeyBoard:(UIBarButtonItem *)sender
{
    if (textView != nil) {
        [textView resignFirstResponder];
    }
}

-(IBAction)clearInput:(id)sender{
    
    textView.text = @"";
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (inspection.user.id == USER.id){
        if (inspection.inspectionReportReplies.count > 0)
            return 4;
        else
            return 3;
    }
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0 || indexPath.row == inspection.inspectionTargets.count+1) {
                return 50;
            }
            float height = 80.f;
            InspectionTarget *target = (InspectionTarget *)[inspection.inspectionTargets objectAtIndex:indexPath.row-1];
            if (target == nil) return height;
            height = [[[[InspectionTargetCell alloc] init] autorelease] getHeight:target.name number:target.serialNumber value:@"  " status:[self getInspectionStatusName:target]];
            return MAX(80.f, height);
        }
            break;
        case 1:{
            return 88;
        }
            break;
        case 2:{
            return 120;
        }
            break;
        case 3:{
            NSString* text = ((InspectionReportReply *)[inspection.inspectionReportReplies objectAtIndex:indexPath.row]).content;
            CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
            
            CGFloat height = MAX(size.height + 45.0f, 75.0f);
            return height;
        }
            break;
        case 4:{
            return 75.f;
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
        case 0:{
            return NSLocalizedString(@"title_customer_info", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"title_live_image_detail", nil);
        }
            break;
        case 2:{
            return NSLocalizedString(@"title_live_info", nil);
        }
            break;
        case 3:{
            return NSLocalizedString(@"worklog_label_reply", nil);
        }
            break;
            
        default:
            break;
    }
    return @"";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2+inspection.inspectionTargets.count;
    }else if(section == 3){
        return inspection.inspectionReportReplies.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    
    switch (indexPath.section) {
        case 0:{
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                if (indexPath.row == 0){
                    selectCell.title.text = NSLocalizedString(@"inspection_label_category", nil);
                    selectCell.value.text = inspection.inspectionReportCategory.name;
                }else if(indexPath.row == inspection.inspectionTargets.count+1){
                    LocationCell *locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
                    if(locationCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[LocationCell class]])
                                locationCell=(LocationCell *)oneObject;
                        }
                    }
                    locationCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    locationCell.btnRefresh.hidden = YES;
                    if (!inspection.location.address.isEmpty) {
                        [locationCell.lblAddress setText:inspection.location.address];
                    }else{
                        [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",inspection.location.latitude,inspection.location.longitude]];
                    }
                    return locationCell;
                }else{
                    InspectionTargetCell *targetCell =(InspectionTargetCell *)[tableView dequeueReusableCellWithIdentifier:@"InspectionTargetCell"];
                    if(targetCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InspectionTargetCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[InspectionTargetCell class]])
                                targetCell=(InspectionTargetCell *)oneObject;
                        }
                    }
                    InspectionTarget *target = (InspectionTarget *)[inspection.inspectionTargets objectAtIndex:indexPath.row-1];
                    targetCell.name.text = target.name;
                    targetCell.number.text = target.serialNumber;
                    targetCell.value.text = [[[[InspectionViewController alloc] init] getInspectionStatusName:target] autorelease];
                    targetCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    [targetCell resetFrame:target.name number:target.serialNumber];
                    return targetCell;
                    
                }
                selectCell.imageGo.hidden = YES;
            }
            selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return selectCell;
        }
            break;
        case 1:{
            liveImageCell = [[LiveImageCell alloc] initWithImages:imageFiles];
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
        }
            break;
        case 2:{
            textViewCell = [[TextViewCell alloc] init];
            //textViewCell.title.text = NSLocalizedString(@"inspection_label_content", nil);
            textViewCell.textView.delegate=self;
            textViewCell.textView.text = inspection.content;
            [textViewCell.textView setEditable:NO];
            textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return textViewCell;
            
        }
            break;
        case 3:{
            PatrolDetailReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolDetailReplyCell"];
            if (cell == nil) {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolDetailReplyCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            InspectionReportReply *reply = [inspection.inspectionReportReplies objectAtIndex:indexPath.row];
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
            
            
        default:
            break;
    }
    
    return cell;
    
}

-(void) textViewDidChange:(UITextView *)textView{
    strInspectionReply = [textView.text retain];
}

-(NSString *) getInspectionStatusName:(InspectionTarget *) target{
    NSMutableString *sb = [[NSMutableString alloc] init];
    for (InspectionStatus *status in target.inspectionStatus) {
        [sb appendString:status.name];
        [sb appendString:@"   "];
    }
    return sb;
}
-(void)openPhoto:(int)index{
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [imageFiles objectAtIndex:index];
    ctrl.functionName = [NSString stringWithFormat:@"%@",inspection.inspectionReportCategory.name];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE;
    HUDHIDE2;
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type) ) {
        case ActionTypeInspectionReportReply:{
            HUDHIDE;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                if (inspectionReply != nil){

                    [replies addObject:inspectionReply];
                    InspectionReport_Builder* pb = [inspection toBuilder] ;
                    [pb setInspectionReportRepliesArray:replies];
                    InspectionReport* p = [[pb build] retain];
                    
                    [inspection release];
                    inspection = nil;
                    inspection = p;
                }
                [self.navigationController popViewControllerAnimated:YES];
                [tableView reloadData];
            }
            
            [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"inspectionreply_msg_saved", @"")];
            
        }
            break;
            
        case ActionTypeInspectionReportGet:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                InspectionReport* i = [InspectionReport parseFromData:cr.data];
                if ([super validateData:i]) {
                    inspection = [i retain];
                    
                    replies = [[NSMutableArray alloc] init];
                    for (int i = 0; i < inspection.inspectionReportReplies.count; ++i) {
                        [replies addObject:[inspection.inspectionReportReplies objectAtIndex:i]];
                    }
                    [self _show];
                }
            }
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",inspection.id]];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
            
        }
            break;
            
        default:
            break;
    }
}

@end
