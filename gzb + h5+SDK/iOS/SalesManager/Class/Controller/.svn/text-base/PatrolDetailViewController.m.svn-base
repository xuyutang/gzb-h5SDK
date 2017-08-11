//
//  PatrolDetailViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/5/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "PatrolDetailViewController.h"
#import "SelectCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"
#import "AppDelegate.h"
#import "CustomerSelectViewController.h"
#import "PatrolListViewController.h"
#import "BigImageViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
@interface PatrolDetailViewController ()

@end

@implementation PatrolDetailViewController
@synthesize patrol,delegate,patrolId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData{
    
    patrolReply = nil;
    strPatrolReply = @"";
    
    imageFiles = [[NSMutableArray alloc] init];
    for (int i = 0; i<[patrol.v1.filePath count]; i++) {
        [imageFiles addObject:[patrol.v1.filePath objectAtIndex:i]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [leftImageView setImage:[UIImage imageNamed:@"topbar_button_goback"]];
    [leftView addSubview:leftImageView];
    
    SOCKET.delegate = self;
    if (patrol != nil) {
        [self _show];
    }else{
        [self _getPatrol];
    }
    
    [lblFunctionName setText:NSLocalizedString(@"bar_patrol_detail", @"")];
}

- (void) _show{
    [self initData];
    if ((patrol.v1.user.v1.id != USER.v1.id) && (patrol.v1.patrolReplies.count == 0)){
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
        self.navigationItem.rightBarButtonItem = btRight;
        [btRight release];
    }
    [self.navigationController setNavigationBarHidden:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    //tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
}

- (void) _getPatrol{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    PatrolParams_Builder* pb = [PatrolParams builder];
    PatrolParamsV1_Builder* pbv1 = [PatrolParamsV1 builder];
    BaseSearchParamsV1_Builder* bsv1 = [BaseSearchParamsV1 builder];
    
    [bsv1 setSource:[NSString stringWithFormat:@"%d",patrolId]];
    [pbv1 setBaseParams:[bsv1 build]];
    [pb setVersion: pbv1.version];
    [pb setV1: [pbv1 build]];
    
    if (DONE != [SOCKET sendRequestWithType:RequestTypePatrolGetV1 param:[pb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_message_list", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];

}

-(void)clickLeftButton:(id)sender{
    if (patrolReply != nil){
        if (delegate != nil && [delegate respondsToSelector:@selector(refresh:)]) {
            [delegate refresh:patrol];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)toSave:(id)sender{
    (APPDELEGATE).socket.delegate = self;
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
        
        PatrolReply_Builder* prb = [PatrolReply builder];
        PatrolReplyV1_Builder* prbv1 = [PatrolReplyV1 builder];
        BaseReplyV1_Builder* brv1 = [BaseReplyV1 builder];
        
        [brv1 setContent:strReply];
        [brv1 setCreateDate:[NSDate getCurrentTime]];
        [prbv1 setReply:[brv1 build]];
        [prbv1 setPatrolId:patrol.v1.id];
        [prbv1 setId:-1];
        [prb setVersion:prbv1.version];
        [prb setV1:[prbv1 build]];
        
        PatrolReply* pr = [prb build];
        patrolReply = [pr retain];
        
        if (DONE != [(APPDELEGATE).socket sendRequestWithType:RequestTypePatrolReplyV1 param:pr]){
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
    if (patrol.v1.user.v1.id == USER.v1.id){
        if (patrol.v1.patrolReplies.count > 0)
            return 4;
        else
            return 3;
    }
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 2) {
                return 50;
            }
            return 40;
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
            return 120;
        }
            break;
        case 4:{
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
    return 0;
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
                    selectCell.title.text = NSLocalizedString(@"patrol_label_category", nil);
                    selectCell.value.text = patrol.v1.category.v1.name;
                }else if(indexPath.row == 1){
                    selectCell.title.text = NSLocalizedString(@"customer_label_name", nil);
                    selectCell.value.text = patrol.v1.customer.v1.name;
                }else if(indexPath.row == 2){
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
                    if (!patrol.v1.location.v1.address.isEmpty) {
                        [locationCell.lblAddress setText:patrol.v1.location.v1.address];
                    }else{
                        [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",patrol.v1.location.v1.latitude,patrol.v1.location.v1.longitude]];
                    }
                    return locationCell;
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
            //textViewCell.title.text = NSLocalizedString(@"patrol_label_content", nil);
            textViewCell.textView.delegate=self;
            textViewCell.textView.text = patrol.v1.content;
            [textViewCell.textView setEditable:NO];
            textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return textViewCell;
            
        }
            break;
        case 3:{
            
            if(tvReplyCell==nil){
                tvReplyCell= [[TextViewCell alloc] init];
            }
            if (patrol.v1.patrolReplies.count > 0)
                tvReplyCell.textView.text = [NSString stringWithFormat:@"%@\n-------------------------\n%@\n%@",((PatrolReply*)[patrol.v1.patrolReplies objectAtIndex:0]).v1.reply.content,((PatrolReply*)[patrol.v1.patrolReplies objectAtIndex:0]).v1.reply.sender.v1.realName,((PatrolReply*)[patrol.v1.patrolReplies objectAtIndex:0]).v1.reply.createDate];
            else
                tvReplyCell.textView.text = strPatrolReply;
            
            tvReplyCell.textView.delegate = self;
            
            tvReplyCell.textView.editable =  ((patrol.v1.user.v1.id != USER.v1.id) && (patrol.v1.patrolReplies.count == 0)) ? YES : NO;
            
            return tvReplyCell;
        }

            
        default:
            break;
    }
    
    return cell;
    
}

-(void) textViewDidChange:(UITextView *)textView{
    strPatrolReply = [textView.text retain];
}


-(void)openPhoto:(int)index{
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [imageFiles objectAtIndex:index];
    ctrl.functionName = [NSString stringWithFormat:@"[%@]%@",patrol.v1.category.v1.name,patrol.v1.customer.v1.name];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    WTResponse* cr = [WTResponse parseFromData:message];
    HUDHIDE;
    switch (INT_REQUESTTYPE(cr.type)) {
        case RequestTypePatrolReplyV1:{
            HUDHIDE;
            if (([cr.code isEqual: NS_RESULTCODE(ResultCodeResponseDone)])){
                if (patrolReply != nil){
                    NSMutableArray* replies = [[NSMutableArray alloc] initWithCapacity:1];
                    [replies addObject:patrolReply];
                    Patrol_Builder* pb = [patrol toBuilder] ;
                    PatrolV1_Builder* pbv1 = [pb.v1 toBuilder];
                    [pbv1 setPatrolRepliesArray:replies];
                    [pb setVersion:pbv1.version];
                    [pb setV1:[pbv1 build]];
                    Patrol* p = [[pb build] retain];
                    [patrol release];
                    patrol = nil;
                    patrol = p;
                }
                rightView.hidden = YES;
            }
            
            [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"patrolreply_msg_saved", @"")];
            
        }
            break;

        case RequestTypePatrolGetV1:{
            if (([cr.code isEqual: NS_RESULTCODE(ResultCodeResponseDone)])){
                Patrol* p = [Patrol parseFromData:cr.data];
                patrol = [p retain];
                [self _show];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"bar_message_list", @"") Description:NSLocalizedString(@"patrol_msg_detail", @"")];
            
        }
            break;
            
        default:
            break;
    }
}


@end
