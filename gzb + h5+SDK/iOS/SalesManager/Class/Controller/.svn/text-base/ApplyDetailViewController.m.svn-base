//
//  ApplyDetailViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-9-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "ApplyDetailViewController.h"
#import "BigImageViewController.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "SelectCell.h"
#import "InputCell.h"
#import "InputViewController.h"
#import "PatrolDetailReplyCell.h"
#import "AuditTableViewCell.h"
#import "SDImageView+SDWebCache.h"
#import "ApplyViewController.h"
#import "ApplyAuditViewController.h"
#import "UIView+CNKit.h"

@interface ApplyDetailViewController ()<InputFinishDelegate,PullTableViewDelegate,RequestAgentDelegate>{

    NSMutableArray* replies;
    NSMutableArray *auditMulArray;
    int currentPage;
    int pageSize;
    int totleSize;
    BOOL isButtonRefreshing;
    UIView *line1;
     UIView *line2;
     UIView *line3;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIView *bottom;
    BOOL *showWaitBool;
  
}

@end

@implementation ApplyDetailViewController
@synthesize applyItem,delegate,applyItemId,msgType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    applyItemReply = nil;
    sApplyItemReply = @"";
    isButtonRefreshing = NO;
    [super viewDidLoad];
    
    self.view.backgroundColor = WT_WHITE;
    [self.navigationController setNavigationBarHidden:NO];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
   
    tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT - 45) style:UITableViewStylePlain];
    tableView.pullBackgroundColor = [UIColor yellowColor];
    tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.pullDelegate = self;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    bottom = [[UIView alloc] initWithFrame:CGRectMake(0, MAINHEIGHT-45, MAINWIDTH, 45)];
    [bottom setBackgroundColor:[UIColor whiteColor]];
    line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, MAINWIDTH, .5f)];
    [line1 setBackgroundColor:[UIColor lightGrayColor]];
    [bottom addSubview:line1];
    ;
     [self.view addSubview:bottom];
    //刷新按钮
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *reFreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [reFreshImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    reFreshImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refesh)];
    [tapGesture setNumberOfTapsRequired:1];
    reFreshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [reFreshImageView addGestureRecognizer:tapGesture];
    [rightView addSubview:reFreshImageView];
    [reFreshImageView release];
    [tapGesture release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    AGENT.delegate = self;
    if (applyItem != nil) {
        [self _show];
    }else{
        [self _getApplyItem];
    }
    replies = [[NSMutableArray alloc] init];
    [lblFunctionName setText:TITLENAME(FUNC_APPROVE_DES)];
    auditMulArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:@"refreshApplyDetail" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)refesh {
    if (tableView.pullTableIsLoadingMore || tableView.pullTableIsRefreshing) {
        return;
    }
    
    isButtonRefreshing = YES;
    [replies removeAllObjects];
    currentPage = 1;
    applyItem = nil;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    AGENT.delegate = self;
    ApplyItemParams_Builder* pb = [ApplyItemParams builder];
    
    [pb setApplyItemId:applyItemId];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemGet param:[pb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
    
}

-(void)refreshAction {
    [self refesh];
}

-(void)clickLeftButton:(id)sender {
    
    if (applyItemReply != nil){
        if (delegate != nil && [delegate respondsToSelector:@selector(refresh:)]) {
            [delegate refresh:applyItem];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)createBottomBar {
      //是否有审批
    
        if (!button1) {
            button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button1 setTitle:@"回复" forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button1.titleLabel.font = [UIFont systemFontOfSize:14];
            [button1 setFrame:CGRectMake(0, 0, MAINWIDTH/3, 45)];
            [button1 addTarget:self action:@selector(toReply) forControlEvents:UIControlEventTouchUpInside];
            [bottom addSubview:button1];
        }
        
        if (!line2) {
            line2 = [[UIView alloc] initWithFrame:CGRectMake(MAINWIDTH/3, 0, 1, 45)];
            [line2 setBackgroundColor:[UIColor lightGrayColor]];
            [bottom addSubview:line2];
            [line2 release];
        }
        
        
        if (!button2) {
            button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button2 setTitle:@"审批" forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button2.titleLabel.font = [UIFont systemFontOfSize:14];
            [button2 setFrame:CGRectMake(MAINWIDTH/3, 0, MAINWIDTH/3, 45)];
            [button2 addTarget:self action:@selector(toAudit) forControlEvents:UIControlEventTouchUpInside];
            [bottom addSubview:button2];
        }
        
    
        if (!line3) {
            line3 = [[UIView alloc] initWithFrame:CGRectMake(MAINWIDTH *2/3, 0, 1, 45)];
            [line3 setBackgroundColor:[UIColor lightGrayColor]];
            [bottom addSubview:line3];
            [line3 release];
        }
        
    
        if (!button3) {
            button3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button3 setTitle:@"上传" forState:UIControlStateNormal];
            [button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            button3.titleLabel.font = [UIFont systemFontOfSize:14];
            [button3 setFrame:CGRectMake(MAINWIDTH*2/3, 0, MAINWIDTH/3, 45)];
            [button3 addTarget:self action:@selector(toUpload) forControlEvents:UIControlEventTouchUpInside];
            [bottom addSubview:button3];

        }
    
     if (!hasAuditBool) {
         button1.frame = CGRectMake(0, 0, MAINWIDTH/2, 45);
         button2 .hidden = YES;
         line2.frame = CGRectMake(MAINWIDTH/2, 0, 1, 45);
         line3.hidden = YES;
         button3.frame = CGRectMake(MAINWIDTH/2, 0, MAINWIDTH/2, 45);
     }else {
         button1.frame = CGRectMake(0, 0, MAINWIDTH/3, 45);
         button2 .hidden = NO;
         line2.frame = CGRectMake(MAINWIDTH/3, 0, 1, 45);
         line3.hidden = NO;
         button3.frame = CGRectMake(MAINWIDTH*2/3, 0, MAINWIDTH/3, 45);
     }
}

-(void)toUpload {
    ApplyViewController *applyVC = [[ApplyViewController alloc]init];
    applyVC.showListImageBool = NO;
    NSMutableArray* applyTypes = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getApplyCategories]];
    NSMutableArray *cateIDs = [[NSMutableArray alloc] init];
    
    [applyTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cateIDs addObject:@(((ApplyCategory*)obj).id)];
    }];
    if ([cateIDs containsObject:@(applyItem.category.id)]) {
        applyVC.currentApplyCategory = applyItem.category;
    }else{
        ApplyCategory_Builder *ab = [ApplyCategory builder];
        [ab setName:@"请选择"];
        [ab setId:-1];
        [ab setUsersArray:nil];
        ApplyCategory *bb = [ab build];
        applyVC.currentApplyCategory = bb;
    
    }
   
    [self.navigationController pushViewController:applyVC animated:YES];
    
}

- (void) _show {
    imageFiles = [[NSMutableArray alloc] init];
    for (int i = 0; i<[applyItem.filePath count]; i++) {
        [imageFiles addObject:[applyItem.filePath objectAtIndex:i]];
    }
    
    if ([self hasApplyPermission:applyItem]){
        
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    [tableView reloadData];
}

- (void) _getApplyItem {
    tableView.pullLastRefreshDate = [NSDate date];
    tableView.pullTableIsRefreshing = YES;
    ApplyItemParams_Builder* pb = [ApplyItemParams builder];
    [pb setApplyItemId:applyItemId];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemGet param:[pb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void) _getApplyItemReply {
    ApplyItemParams_Builder* pb = [ApplyItemParams builder];
    [pb setApplyItemId:applyItemId];
    [pb setPage:currentPage];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeApplyItemReplyList param:[pb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void)didFinishInput:(int)tag Input:(NSString *)input {
    (APPDELEGATE).agent.delegate = self;
    [self dismissKeyBoard];
    
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

    
    if([NSString stringContainsEmoji:input.trim]){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    ApplyItemReply_Builder* wb = [ApplyItemReply builder];
    
    [wb setContent:input.trim];
    [wb setCreateDate:[NSDate getCurrentTime]];
    [wb setSender:USER];
    [wb setApplyItemId:applyItem.id];
    [wb setId:-1];
    
    ApplyItemReply* wr = [wb build];
    applyItemReply = [wr retain];
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeApplyItemReply param:wr]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
    
}

-(void)toAudit {
    ApplyAuditViewController *auditViewVC = [[ApplyAuditViewController alloc] init];
    auditViewVC.applyTtemId = self.applyItemId;
    [self.navigationController pushViewController:auditViewVC animated:YES];
    [auditViewVC release];

}

-(void)toReply {
    if (![self hasApplyPermission:applyItem]){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"reply_error_no_permission", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    ctrl.delegate = self;
    ctrl.bNeedBack = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)toSave:(id)sender {
    (APPDELEGATE).agent.delegate = self;
    [self dismissKeyBoard];
    
    if (tvReplyCell.textView.text.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"worklog_hint_reply", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if([NSString stringContainsEmoji:tvReplyCell.textView.text]){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    ApplyItemReply_Builder* wb = [ApplyItemReply builder];
    [wb setContent:tvReplyCell.textView.text];
    [wb setCreateDate:[NSDate getCurrentTime]];
    [wb setApplyItemId:applyItem.id];
    [wb setId:-1];
    
    ApplyItemReply* wr = [wb build];
    applyItemReply = [wr retain];
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeApplyItemReply param:wr]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }
    
    tvReplyCell.textView.editable = NO;
    tvOldReplyCell.textView.editable = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            return 40;
        }
            break;
        case 1:{
            return 88;
        }
            break;
        case 2:
            return 120.f;
        case 3:{
            NSString* text = ((ApplyAudit*)[auditMulArray objectAtIndex:indexPath.row]).comment;
            CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
            
            CGFloat height = MAX(size.height + 90.0f, 100.0f);
            
            
            ApplyAudit *audit = [auditMulArray objectAtIndex:indexPath.row];
            NSMutableArray *nameArray = [[NSMutableArray alloc] init];
            for (User*uu in audit.users) {
            [nameArray addObject:[NSString stringWithFormat:@"%@(%@)",uu.realName,uu.userName]];
            }
           
            NSString* text2 = [nameArray componentsJoinedByString:@""];
            CGSize size2 = [super rebuildSizeWithString:text2 ContentWidth:235.0f FontSize:FONT_SIZE + 1];
            
            CGFloat height2 = MAX(size2.height + 50, 30.0f);
            
            
            return height + height2 ;
           
        }
            break;
        case 4:{
            NSString* text = ((ApplyItemReply*)[replies objectAtIndex:indexPath.row]).content;
            CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
            
            CGFloat height = MAX(size.height + 45.0f, 75.0f);
            return height;
        }
            break;
        default:
            break;
    }
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0;
    }
    return 30;

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *heardView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 30)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, MAINWIDTH, 0.5)];
    lineView.backgroundColor = WT_GRAY;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MAINWIDTH, 30)];
    label.backgroundColor = WT_WHITE;
    label.textColor = [UIColor orangeColor];
    label.font = [UIFont systemFontOfSize:14];
    if (section == 2) {
        label.text = @" 内容";
    }
    
    if (section == 3) {
        label.text = @" 审批信息";
    }
    if (section == 4) {
        label.text = @" 回复信息";
    }
    [heardView addSubview:lineView];
    [heardView addSubview:label];
    
    return heardView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }else if (section == 3){
        return auditMulArray.count;

    }else if (section == 4){
     return replies.count;
        
    }  else{
        return 1;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath {
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0){
                
                InputCell *userCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                if (userCell == nil) {
                    NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                    for (id oneObject in nib) {
                        if ([oneObject isKindOfClass:[InputCell class]]) {
                            userCell = (InputCell *)oneObject;
                        }
                    }
                    userCell.title.text = NSLocalizedString(@"title_apply_user", nil);
                    
                    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    userCell.inputField.enabled = NO;
                    userCell.inputField.text = applyItem.user.realName;
                }
                return userCell;

                
            }else if(indexPath.row == 1){
                
                InputCell *typeCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                if (typeCell == nil) {
                    NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                    for (id oneObject in nib) {
                        if ([oneObject isKindOfClass:[InputCell class]]) {
                            typeCell = (InputCell *)oneObject;
                        }
                    }
                    typeCell.title.text = NSLocalizedString(@"title_apply_type", nil);
                    
                    typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIToolbar *topView = [[self createToolbar] retain];
                    [typeCell.inputField setInputAccessoryView:topView];
                    [topView release];
                    typeCell.inputField.enabled = NO;
                    typeCell.inputField.text = applyItem.category.name;
                }
                
                return typeCell;
            }else if(indexPath.row == 2){
                
                InputCell *titleCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                if (titleCell == nil) {
                    NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                    for (id oneObject in nib) {
                        if ([oneObject isKindOfClass:[InputCell class]]) {
                            titleCell = (InputCell *)oneObject;
                        }
                    }
                    titleCell.title.text = NSLocalizedString(@"title_base_number", nil);
                    
                    titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIToolbar *topView = [[self createToolbar] retain];
                    [titleCell.inputField setInputAccessoryView:topView];
                    [topView release];
                    titleCell.inputField.enabled = NO;
                    titleCell.inputField.text = applyItem.number;
                }
                
                return titleCell;
            }else if(indexPath.row == 3){
                
                InputCell *titleCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                if (titleCell == nil) {
                    NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                    for (id oneObject in nib) {
                        if ([oneObject isKindOfClass:[InputCell class]]) {
                            titleCell = (InputCell *)oneObject;
                        }
                    }
                    titleCell.title.text = NSLocalizedString(@"title_apply_title", nil);
                    
                    titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIToolbar *topView = [[self createToolbar] retain];
                    [titleCell.inputField setInputAccessoryView:topView];
                    [topView release];
                    titleCell.inputField.enabled = NO;
                    titleCell.inputField.text = applyItem.title;
                }
                
                return titleCell;
            
            }}
            break;
        case 1:{
            liveImageCell = [[LiveImageCell alloc] initWithImages:imageFiles];
            liveImageCell.delegate = self;
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
            TextViewCell *textViewCell= [[TextViewCell alloc] init];
            textViewCell.textView.text = applyItem.content;
            textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
            textViewCell.textView.editable = NO;
            return textViewCell;
        }
            break;
        case 3:{
            AuditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuditTableViewCell"];
            if (cell == nil) {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AuditTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            ApplyAudit *audit = [auditMulArray objectAtIndex:indexPath.row];
            User *u = (User*)[audit.users objectAtIndex:0];
            if (auditMulArray.count) {
                NSString* avtar = @"";
                if (((User*)[audit.users objectAtIndex:0 ]).avatars.count > 0) {
                    avtar = [u.avatars objectAtIndex:0];
                }
                //
                if (audit.hasAuditUser){
                 [cell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
                }else {
                    cell.icon.image =[UIImage imageNamed:@"ic_unknow_avatar"];
                }
               
                cell.icon.layer.cornerRadius = 30.f;
                cell.icon.layer.masksToBounds = YES;
                NSMutableArray *nameArray = [[NSMutableArray alloc] init];
                for (User*uu in audit.users) {
                    [nameArray addObject:[NSString stringWithFormat:@"%@(%@)",uu.realName,uu.userName]];
                }
                
                CGSize size2 = [super rebuildSizeWithString:[nameArray componentsJoinedByString:@""] ContentWidth:235.0f FontSize:FONT_SIZE + 1];
                
                CGFloat height2 = MAX(size2.height, 30.0f);
                
                CGRect rect2 = cell.name.frame;
                UILabel* lContent2 = [[UILabel alloc] initWithFrame:CGRectMake(rect2.origin.x, rect2.origin.y + 3,rect2.size.width,height2)];
                lContent2.backgroundColor = WT_CLEARCOLOR;
                lContent2.numberOfLines = 0;
                 lContent2.lineBreakMode = NSLineBreakByCharWrapping;
                lContent2.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
                lContent2.text = [nameArray componentsJoinedByString:@""];
                [cell.contentView addSubview:lContent2];
                [lContent2 release];
                lContent2 = nil;
                cell.name.hidden = YES;

                cell.auditName.y = height2 + 15;
                cell.status.y = height2 + 15;
                 if (audit.hasAuditUser) {
                     cell.auditName.text =[NSString stringWithFormat:@"%@(%@)",audit.auditUser.realName,audit.auditUser.userName] ;
                }else{
                    
                    cell.auditName.text = @"待审核";
                    
                    cell.status.textColor = WT_GRAY;
                }
                if ([audit.status isEqualToString:@"1"]) {
                    cell.status.text = @"同意";
                    cell.status.textColor = WT_GREEN;
                }else if ([audit.status isEqualToString:@"0"]){
                     cell.status.text = @"拒绝";
                     cell.status.textColor = WT_RED;

                } else {
                    cell.status.text = @"";
                }
                cell.time.y = height2 + 40;
                cell.comment.y  = height2 + 55;
                cell.time.text = audit.createDate;
                NSString* text = audit.comment;
                CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
                
                CGFloat height = MAX(size.height + 50, 42.0f);
                
                CGRect rect = cell.comment.frame;
                UILabel* lContent = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 3,rect.size.width,height)];
                lContent.backgroundColor = WT_CLEARCOLOR;
                lContent.numberOfLines = 0;
                lContent.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
               // lContent.textColor = WT_GRAY;
                lContent.text = audit.comment;
                [cell.contentView addSubview:lContent];
                [lContent release];
                lContent = nil;
                
             }
            return cell;

            
        }
            break;
        case 4:{
            PatrolDetailReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolDetailReplyCell"];
            if (cell == nil) {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolDetailReplyCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            ApplyItemReply *reply = [replies objectAtIndex:indexPath.row];
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
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)openPhoto:(int)index {
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [imageFiles objectAtIndex:index];
    ctrl.functionName = [NSString stringWithFormat:@"[%@]%@",applyItem.category.name,applyItem.user.realName];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        return NO;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

-(UIToolbar*)createToolbar {
    UIToolbar * topView = [[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [doneButton release];
    [btnSpace release];
    [helloButton release];
    
    [topView setItems:buttonsArray];
    return topView;
}

-(IBAction)dismissKeyBoard {
    if (tvReplyCell.textView != nil) {
        [tvReplyCell.textView resignFirstResponder];
    }
}


-(IBAction)clearInput {
    tvReplyCell.textView.text = @"";
    
}

- (void)dealloc {
    [rightView release];
    [tableView release];
    [tvReplyCell release];
    [super dealloc];
}

- (void)viewDidUnload {
    [rightView release];
    rightView = nil;
    [tableView release];
    tableView = nil;
    [tvReplyCell release];
    tvReplyCell = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clearTable {
    if (replies.count > 0){
        [replies removeAllObjects];
    }
}

- (void) didReceiveMessage:(id)message {
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeApplyItemReply:{
            HUDHIDE;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                if (applyItemReply != nil){

                    [replies insertObject:applyItemReply atIndex:0];
                    
                    ApplyItem_Builder* wb = [applyItem toBuilder];
                    [wb setReplyCount:replies.count];
                    [applyItem release];
                    applyItem = nil;
                    applyItem = [[wb build] retain];
                    [self.navigationController popViewControllerAnimated:YES];
                    [tableView reloadData];
                }
                
            }
            
            [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"applyreply_msg_saved", @"")];
        }
            break;
            
        case ActionTypeApplyItemGet:{
            HUDHIDE;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [auditMulArray removeAllObjects];
                ApplyItem* a = [ApplyItem parseFromData:cr.data];
                for (ApplyAudit *ad in a.applyAudits) {
                    [auditMulArray addObject:ad];
  
                }
                //判断是否是我审核
                if (a.auditUsers.count) {
                    
                    NSMutableArray *userId = [[NSMutableArray alloc] init];
                    for (User *u in a.auditUsers){
                        [userId addObject:@(u.id)];
                    }
                    
                    if ([userId containsObject:@(USER.id)]) {
                       hasAuditBool = YES;
                    }else {
                      hasAuditBool = NO;
                    }
                    }else {
                     hasAuditBool = NO;
                  }
                     [self createBottomBar];
                
                if ([super validateData:a]) {
                    applyItem = [a retain];
                    lblFunctionName.text = TITLENAME_STR(FUNC_APPROVE_DES, applyItem.title);
                    [self _getApplyItemReply];
                }
                
            }
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",applyItemId]];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
        }
            break;
        case ActionTypeApplyItemReplyList:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                Pagination* pageReply = [Pagination parseFromData:cr.data];
                
                pageSize = pageReply.pageSize;
                totleSize = pageReply.totalSize;
                if (currentPage == 1) {
                    [self clearTable];
                }
                for (int i = 0; i < pageReply.datas.count; ++i) {
                    ApplyItemReply* wr = [ApplyItemReply parseFromData:[pageReply.datas objectAtIndex:i]];
                    if (![super validateData:wr]) {
                        continue;
                    }else{
                        [replies addObject:wr];
                    }
                }
                [self _show];
                [tableView reloadData];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
            
        }
            break;
            
        default:
            break;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeApplyItemReplyList) || (INT_ACTIONCODE(cr.code) != ActionCodeDone)) {
        tableView.pullTableIsRefreshing = NO;
        tableView.pullTableIsLoadingMore = NO;
    }
    isButtonRefreshing = NO;
}

- (void) didFailWithError:(NSError *)error {
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    isButtonRefreshing = NO;
    [super didFailWithError:error];
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    isButtonRefreshing = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable {
    if (isButtonRefreshing) {
        return;
    }
    tableView.pullLastRefreshDate = [NSDate date];
    tableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    [self _getApplyItem];
}

- (void) loadMoreDataToTable {
    if (isButtonRefreshing) {
        return;
    }
    tableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        
        [self _getApplyItemReply];
    }else{
        tableView.pullTableIsLoadingMore = NO;
    }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}

@end
