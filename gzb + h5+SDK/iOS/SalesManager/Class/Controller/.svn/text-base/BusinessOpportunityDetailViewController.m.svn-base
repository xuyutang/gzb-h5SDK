//
//  BusinessOpportunityDetailViewController.m
//  SalesManager
//
//  Created by liuxueyan on 6/5/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "BusinessOpportunityDetailViewController.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "SDImageView+SDWebCache.h"
#import "InputViewController.h"
#import "PatrolDetailReplyCell.h"

@interface BusinessOpportunityDetailViewController ()<InputFinishDelegate>{
    NSMutableArray *replies;
}

@end

@implementation BusinessOpportunityDetailViewController
@synthesize currentBizOpp,delegate,bizoppId,msgType;

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
    
    [self.navigationController setNavigationBarHidden:NO];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_BIZOPP_DES)];
    AGENT.delegate = self;
    
    if (currentBizOpp != nil) {
        [self _show];
    }else{
        [self _getBizOpp];
    }
}

- (void) _show{
    if ((currentBizOpp.user.id != APPDELEGATE.currentUser.id) && (currentBizOpp.businessOpportunityReplies.count == 0)){
        /*rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
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
        [btRight release];*/
    }
    self.lblFunctionName.text = TITLENAME_STR(FUNC_BIZOPP_DES,currentBizOpp.user.realName);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT - 45) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    //tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    [self createBottomBar];
}

- (void) _getBizOpp{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    BusinessOpportunityParams_Builder* pb = [BusinessOpportunityParams builder];
    
    [pb setId:bizoppId];

    if (DONE != [AGENT sendRequestWithType:ActionTypeBusinessopportunityGet param:[pb build]]){
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
    [button1 setTitle:@"批复" forState:UIControlStateNormal];
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
    
    BusinessOpportunityReply_Builder* prb = [BusinessOpportunityReply builder];
    
    [prb setContent:input.trim];
    [prb setCreateDate:[NSDate getCurrentTime]];
    [prb setSender:USER];
    [prb setBusinessOpportunityId:currentBizOpp.id];
    [prb setId:-1];
    
    BusinessOpportunityReply* bor = [prb build];
    bizReply = [bor retain];
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeBusinessopportunityReply param:bor]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
    }

}


-(void)toReply{
    if (USER.id == currentBizOpp.user.id) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:@"不能对自己进行批复"
                                 type:MessageBarMessageTypeInfo
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    if (currentBizOpp.businessOpportunityReplies.count > 0) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:@"已批复，不能重复提交批复"
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
    if (bizReply != nil){
        if (delegate != nil && [delegate respondsToSelector:@selector(refresh:)]) {
            [delegate refresh:currentBizOpp];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


-(void)toSave:(id)sender{
    (APPDELEGATE).agent.delegate = self;
    [self dismissKeyBoard:nil];
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
    
    BusinessOpportunityReply_Builder* prb = [BusinessOpportunityReply builder];
    
    [prb setContent:sBizReply];
    [prb setCreateDate:[NSDate getCurrentTime]];
    [prb setBusinessOpportunityId:currentBizOpp.id];
    [prb setId:-1];
        
    BusinessOpportunityReply* bor = [prb build];
    bizReply = [bor retain];
        
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeBusinessopportunityReply param:bor]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
    }
    tvReplyCell.textView.editable = NO;
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
    // Return the number of sections.
    if (currentBizOpp.user.id == (APPDELEGATE).currentUser.id){
        if (currentBizOpp.businessOpportunityReplies.count > 0)
            return 5;
        else
            return 4;
    }

    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 2) {
                return 51;
            }
            return 40;
        }
            break;
//        case 1:{
//            return 40;
//        }
//            break;
//        case 2:{
//            switch (indexPath.row) {
//                case 0:
//                    return 120;
//                    break;
//                case 1:
//                    return 120;
//                    break;
//                case 2:
//                    return 120;
//                    break;
//                case 3:
//                    return 120;
//                    break;
//                case 4:
//                    return 40;
//                    break;
//                case 5:
//                    return 40;
//                    break;
//                default:
//                    break;
//            }
//        }
//            break;
//        case 3:{
//            return 120;
//        }
//            break;
            
        case 4:{
            NSString* text = ((BusinessOpportunityReply*)[currentBizOpp.businessOpportunityReplies objectAtIndex:indexPath.row]).content;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:{
            return NSLocalizedString(@"title_customer_info", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"title_bizopp_info", nil);
        }
            break;
        case 2:{
            return NSLocalizedString(@"title_other_info", nil);
        }
            break;
        case 3:{
            return NSLocalizedString(@"memo", nil);
        }
            break;
        case 4:{
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
    }else if(section == 2){
       // if (expandCell != nil && !expandCell.bExpand) {
            return 5;
      //  }
    }else if (section == 1){
        return 2;
    }else if(section == 4){
        return currentBizOpp.businessOpportunityReplies.count;
    }
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 2:{
            if (indexPath.row == 0) {
                [tableView reloadData];
            }
        }
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    InputCell *categorySelectCell =(InputCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectCell00"];
                    if(categorySelectCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InputCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[InputCell class]])
                                categorySelectCell=(InputCell *)oneObject;
                        }
                        categorySelectCell.inputField.placeholder = @"";
                        categorySelectCell.inputField.enabled = NO;
                        categorySelectCell.title.text = NSLocalizedString(@"customer_label_category", nil);
                    }
                    categorySelectCell.inputField.text = currentBizOpp.customer.category.name;
                    categorySelectCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return categorySelectCell;
                }
                    
                    break;
                case 1:{
                    InputCell *customerNameCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                    if (customerNameCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[InputCell class]]) {
                                customerNameCell = (InputCell *)oneObject;
                            }
                        }
                        customerNameCell.title.text = NSLocalizedString(@"customer_label_name", nil);
                    }
                    customerNameCell.inputField.placeholder = @"";
                    customerNameCell.inputField.enabled = NO;
                    customerNameCell.inputField.text = currentBizOpp.customer.name;
                    customerNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return customerNameCell;
                }
                    break;
                case 2:{
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
                    if (!currentBizOpp.location.address.isEmpty) {
                        [locationCell.lblAddress setText:currentBizOpp.location.address];
                    }else{
                        [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",currentBizOpp.location.latitude,currentBizOpp.location.longitude]];
                    }
                    return locationCell;
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    
                    TextFieldCell *bizOppNameCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (bizOppNameCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                bizOppNameCell = (TextFieldCell *)oneObject;
                            }
                        }
                        bizOppNameCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppName", nil)];
                        
                        CGRect frame = bizOppNameCell.txtField.frame;
                        [bizOppNameCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        bizOppNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        bizOppNameCell.txtField.editable = NO;
                    }
                    bizOppNameCell.txtField.text = currentBizOpp.bizOppName;
                    return bizOppNameCell;
                    
                }
                    break;

                case 1:{
                    
                    TextFieldCell *bizOppPrincipalCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (bizOppPrincipalCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                bizOppPrincipalCell = (TextFieldCell *)oneObject;
                            }
                        }
                        bizOppPrincipalCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppPrincipal", nil)];
                        
                        CGRect frame = bizOppPrincipalCell.txtField.frame;
                        [bizOppPrincipalCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        bizOppPrincipalCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        bizOppPrincipalCell.txtField.editable = NO;
                    }
                    bizOppPrincipalCell.txtField.text = currentBizOpp.bizOppPrincipal;
                    return bizOppPrincipalCell;
                    
                }
                    break;

                    
            }
        }
            
            break;
        case 2:{
            
            switch (indexPath.row) {
//                case 0:{
//                    expandCell = (ExpandCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpandCell"];
//                    if (expandCell == nil) {
//                        expandCell = [[ExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpandCell"];
//                        expandCell.textLabel.text = [NSString stringWithFormat:@"   %@",NSLocalizedString(@"title_bizopp_other_title", nil)];
//                        expandCell.textLabel.font = [UIFont systemFontOfSize:14];
//                    }
//                    return expandCell;
//                }
//                    break;
                case 0:{
                    TextFieldCell *otherBizOppSummaryCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherBizOppSummaryCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherBizOppSummaryCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherBizOppSummaryCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppSummary", nil)];
                        
                        CGRect frame = otherBizOppSummaryCell.txtField.frame;
                        [otherBizOppSummaryCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherBizOppSummaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherBizOppSummaryCell.txtField.editable = NO;
                    }
                    otherBizOppSummaryCell.txtField.text = currentBizOpp.bizOppSummary;
                    return otherBizOppSummaryCell;
                    
                }
                    break;
                case 1:{
                    TextFieldCell *otherBizOppDecisionCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherBizOppDecisionCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherBizOppDecisionCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherBizOppDecisionCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppDecision", nil)];
                        
                        CGRect frame = otherBizOppDecisionCell.txtField.frame;
                        [otherBizOppDecisionCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherBizOppDecisionCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherBizOppDecisionCell.txtField.editable = NO;
                    }
                    otherBizOppDecisionCell.txtField.text = currentBizOpp.bizOppDecision;
                    return otherBizOppDecisionCell;
                }
                    break;
                case 2:{
                    TextFieldCell *otherActionPlanCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherActionPlanCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherActionPlanCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherActionPlanCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_actionPlan", nil)];
                        CGRect frame = otherActionPlanCell.txtField.frame;
                        [otherActionPlanCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherActionPlanCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherActionPlanCell.txtField.editable = NO;
                    }
                    otherActionPlanCell.txtField.text = currentBizOpp.actionPlan;
                    return otherActionPlanCell;
                }
                    break;
                case 3:{
                    TextFieldCell *otherExpectedCostCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherExpectedCostCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherExpectedCostCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherExpectedCostCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_expectedCost", nil)];
                        CGRect frame = otherExpectedCostCell.txtField.frame;
                        [otherExpectedCostCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherExpectedCostCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherExpectedCostCell.txtField.editable = NO;
                    }
                    otherExpectedCostCell.txtField.text = currentBizOpp.expectedCost;
                    return otherExpectedCostCell;
                }
                    break;

                case 4:{
                    TextFieldCell *otherSignTimeCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherSignTimeCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherSignTimeCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherSignTimeCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_expectedSignTime", nil)];
                        CGRect frame = otherSignTimeCell.txtField.frame;
                        [otherSignTimeCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherSignTimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherSignTimeCell.txtField.editable = NO;
                    }
                    otherSignTimeCell.txtField.text = currentBizOpp.expectedSignTime;
                    return otherSignTimeCell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:{
//            TextViewCell *textViewCell = (TextViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TextViewCell"];
//            if (textViewCell == nil) {
//                textViewCell = [[TextViewCell alloc] init];
//                
//            }
//            if (currentBizOpp.bizOppRemark !=nil && currentBizOpp.bizOppRemark.length>0) {
//                textViewCell.textView.text = currentBizOpp.bizOppRemark;
//            }
//            return textViewCell;
//            
//        }
//            break;
            TextFieldCell *textViewCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
            if (textViewCell == nil) {
                NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                        textViewCell = (TextFieldCell *)oneObject;
                    }
                }
                textViewCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppRemark", nil)];
                
                CGRect frame = textViewCell.txtField.frame;
                [textViewCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                textViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
                textViewCell.txtField.editable = NO;
            }
            textViewCell.txtField.text = currentBizOpp.bizOppRemark;
            return textViewCell;
            
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
            BusinessOpportunityReply *reply = [replies objectAtIndex:indexPath.row];
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
            return cell;
    }
}

-(void) textViewDidChange:(UITextView *)textView{
    sBizReply = [textView.text retain];
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeBusinessopportunityReply:{
            HUDHIDE;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                if (bizReply != nil){
                    [replies addObject:bizReply];
                    BusinessOpportunity_Builder* pb = [currentBizOpp toBuilder] ;
                    [pb setBusinessOpportunityRepliesArray:replies];
                    
                    BusinessOpportunity* bo = [[pb build] retain];
                    [currentBizOpp release];
                    currentBizOpp = nil;
                    currentBizOpp = bo;
                    [self.navigationController popViewControllerAnimated:YES];
                    [tableView reloadData];
                }
            }
            //rightView.hidden = YES;
            [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"bizoppreply_msg_saved", @"")];
        }
            break;
            
        case ActionTypeBusinessopportunityGet:{
            HUDHIDE;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                BusinessOpportunity* b  = [BusinessOpportunity parseFromData:cr.data];
                if ([super validateData:b]) {
                    currentBizOpp = [b retain];
                    replies = [[NSMutableArray alloc] init];
                    for (int i = 0; i < currentBizOpp.businessOpportunityReplies.count; ++i) {
                        [replies addObject:[currentBizOpp.businessOpportunityReplies objectAtIndex:i]];
                    }
                    
                    [self _show];
                }
            }
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",bizoppId]];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
            
        }
            break;
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
