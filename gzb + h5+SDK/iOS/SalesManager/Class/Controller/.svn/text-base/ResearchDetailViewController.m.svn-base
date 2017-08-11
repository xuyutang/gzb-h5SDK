//
//  ResearchDetailViewController.m
//  SalesManager
//
//  Created by liu xueyan on 1/24/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "ResearchDetailViewController.h"
#import "BigImageViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "InputViewController.h"
#import "PatrolDetailReplyCell.h"
#import "SDImageView+SDWebCache.h"

@interface ResearchDetailViewController ()<InputFinishDelegate>{
    NSMutableArray *replies;
}
@end

@implementation ResearchDetailViewController
@synthesize currentMarketResearch,martketresearchId,delegate,msgType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData{
    marketResearchReply = nil;
    strMarketResearchReply = @"";
    imageFiles = [[NSMutableArray alloc] init];
    for (int i = 0; i<[currentMarketResearch.filePath count]; i++) {
        [imageFiles addObject:[currentMarketResearch.filePath objectAtIndex:i]];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT - 45) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    //tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];

    
    AGENT.delegate = self;
    
    if (currentMarketResearch != nil) {
        [self _show];
    }else{
        [self _getMarketResearch];
    }
    [self createBottomBar];
    [lblFunctionName setText:TITLENAME(FUNC_RESEARSH_DES)];
}

- (void) _show{
    [self initData];
    /*
    if ((currentMarketResearch.user.id != USER.id) && (currentMarketResearch.marketResearchReplies.count == 0)){
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
    self.lblFunctionName.text = TITLENAME_STR(FUNC_RESEARSH_DES, currentMarketResearch.user.realName);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    [tableView reloadData];
}

- (void) _getMarketResearch{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    MarketResearchParams_Builder* pb = [MarketResearchParams builder];
    
    [pb setId:martketresearchId];

    if (DONE != [AGENT sendRequestWithType:ActionTypeMarketresearchGet param:[pb build]]){
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
    [self.view bringSubviewToFront:bottom];
    [bottom release];
}


-(IBAction)dismissKeyBoard:(UIBarButtonItem *)sender
{
    if (tvReplyCell.textView != nil) {
        [tvReplyCell.textView resignFirstResponder];
    }
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
    
    if (strReply.length > 1000){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"input_limit_1000", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"loading", @"");
        
        MarketResearchReply_Builder* prb = [MarketResearchReply builder];
        
        [prb setContent:input.trim];
        [prb setCreateDate:[NSDate getCurrentTime]];
        [prb setSender:USER];
        [prb setMarketResearchId:currentMarketResearch.id];
        [prb setId:-1];
        
        MarketResearchReply* pr = [prb build];
        marketResearchReply = [pr retain];
        
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeMarketresearchReply param:marketResearchReply]){
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }
        tvReplyCell.textView.editable = NO;
    
}


-(void)toReply{
    if (USER.id == currentMarketResearch.user.id) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"reply_error_self", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:ERR_MSG_DURATION];
        return;
    }
    if (currentMarketResearch.marketResearchReplies.count > 0) {
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
        
        MarketResearchReply_Builder* prb = [MarketResearchReply builder];
        
        [prb setContent:strReply];
        [prb setCreateDate:[NSDate getCurrentTime]];
        [prb setMarketResearchId:currentMarketResearch.id];
        [prb setId:-1];

        MarketResearchReply* pr = [prb build];
        marketResearchReply = [pr retain];
        
        if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeMarketresearchReply param:marketResearchReply]){
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }
        tvReplyCell.textView.editable = NO;
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)clickLeftButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (currentMarketResearch.user.id == USER.id){
        if (currentMarketResearch.marketResearchReplies.count > 0)
            return 5;
        else
            return 4;
    }
    return 5;
    // Return the number of sections.
    //return 4;
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
        case 3:{
            switch (indexPath.row) {
                case 0:
                    return 120;
                    break;
                case 1:
                    return 120;
                    break;
                case 2:
                    return 120;
                    break;
                case 3:
                    return 120;
                    break;
                case 4:
                    return 120;
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:{
            return 120;
        }
            break;
            
        case 4:{
            NSString* text = ((MarketResearchReply*)[currentMarketResearch.marketResearchReplies objectAtIndex:indexPath.row]).content;
            CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
            
            CGFloat height = MAX(size.height + 45.0f, 75.0f);
            return height;
        }
            break;
            
        default:
            break;
    }
    return 40;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    switch (section) {
//        case 0:{
//            return NSLocalizedString(@"title_customer_info", nil);
//        }
//            break;
//        case 1:{
//            return NSLocalizedString(@"title_live_image", nil);
//        }
//            break;
//        case 3:{
//            return NSLocalizedString(@"title_other_info", nil);
//        }
//            break;
//        case 2:{
//            return NSLocalizedString(@"memo", nil);
//        }
//            break;
//        case 4:{
//            return NSLocalizedString(@"worklog_label_reply", nil);
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return @"";
//}
//
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if(section == 3){
       // if (expandCell != nil && !expandCell.bExpand) {
            return 5;
     //   }
    }else if(section == 4){
        return currentMarketResearch.marketResearchReplies.count;
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
                    categorySelectCell.inputField.text = currentMarketResearch.customer.category.name;
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
                    customerNameCell.inputField.text = currentMarketResearch.customer.name;
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
                    
                    locationCell.btnRefresh.hidden = YES;
                    if (!currentMarketResearch.location.address.isEmpty) {
                        [locationCell.lblAddress setText:currentMarketResearch.location.address];
                    }else{
                        [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",currentMarketResearch.location.latitude,currentMarketResearch.location.longitude]];
                    }
                    return locationCell;
                }
                    break;

                /*
                case 2:{
                    InputCell *contactNameCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                    if (contactNameCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[InputCell class]]) {
                                contactNameCell = (InputCell *)oneObject;
                            }
                        }
                        contactNameCell.title.text = NSLocalizedString(@"contacts_name", nil);
                    }
                    contactNameCell.inputField.placeholder = @"";
                    contactNameCell.inputField.enabled = NO;
                    contactNameCell.inputField.text = currentMarketResearch.customer.contact;
                    contactNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return contactNameCell;
                }
                    break;
                case 3:{
                    InputCell *contactTelCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                    if (contactTelCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[InputCell class]]) {
                                contactTelCell = (InputCell *)oneObject;
                            }
                        }
                        contactTelCell.title.text = NSLocalizedString(@"contacts_tel", nil);
                        
                    }
                    contactTelCell.inputField.placeholder = @"";
                    contactTelCell.inputField.enabled = NO;
                    contactTelCell.inputField.text = currentMarketResearch.customer.phone;
                    contactTelCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return contactTelCell;
                }
                    break;
                */
                    
                default:
                    break;
            }
            
        }
            break;
        case 1:{
            LiveImageCell *liveImageCell = [[LiveImageCell alloc] initWithImages:imageFiles];
            liveImageCell.delegate = self;
            if(liveImageCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LiveImageCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[LiveImageCell class]])
                        liveImageCell=(LiveImageCell *)oneObject;
                }
            }
            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return liveImageCell;
        }
            break;
        case 3:{
            
            switch (indexPath.row) {
//                case 0:{
//                    expandCell = (ExpandCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpandCell"];
//                    if (expandCell == nil) {
//                        expandCell = [[ExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpandCell"];
//                        expandCell.textLabel.text = NSLocalizedString(@"title_other_title", nil);
//                        expandCell.textLabel.font = [UIFont systemFontOfSize:14];
//                        
//                    }
//                    return expandCell;
//                }
//                    break;
                case 0:{
                    TextFieldCell *otherScaleCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherScaleCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherScaleCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherScaleCell.title.text = NSLocalizedString(@"title_other_scale", nil);
                        
                        CGRect frame = otherScaleCell.txtField.frame;
                        [otherScaleCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherScaleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherScaleCell.txtField.editable = NO;
                    }
                    otherScaleCell.txtField.text = currentMarketResearch.businessSize;
                    return otherScaleCell;
                }
                    break;
                case 1:{
                    TextFieldCell *otherCategoryCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherCategoryCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherCategoryCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherCategoryCell.title.text = NSLocalizedString(@"title_other_category", nil);
                        CGRect frame = otherCategoryCell.txtField.frame;
                        [otherCategoryCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherCategoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherCategoryCell.txtField.editable = NO;
                    }
                    otherCategoryCell.txtField.text = currentMarketResearch.businessCategory;
                    return otherCategoryCell;
                }
                    break;
                case 2:{
                    TextFieldCell *otherProductCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherProductCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherProductCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherProductCell.title.text = NSLocalizedString(@"title_other_product", nil);
                        
                        CGRect frame = otherProductCell.txtField.frame;
                        [otherProductCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherProductCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherProductCell.txtField.editable = NO;
                    }
                    otherProductCell.txtField.text = currentMarketResearch.primaryProduct;
                    return otherProductCell;
                }
                    break;
                case 3:{
                    InputCell *otherTotalCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                    if (otherTotalCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[InputCell class]]) {
                                otherTotalCell = (InputCell *)oneObject;
                            }
                        }
                        otherTotalCell.inputField.placeholder = @"";
                        otherTotalCell.inputField.enabled = NO;
                        otherTotalCell.title.text = NSLocalizedString(@"title_other_total", nil);
                        otherTotalCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    otherTotalCell.inputField.text = currentMarketResearch.turnover;
                    return otherTotalCell;
                }
                    break;
                case 4:{
                    TextFieldCell *otherAreaCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherAreaCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherAreaCell = (TextFieldCell *)oneObject;
                            }
                        }
                        CGRect frame = otherAreaCell.txtField.frame;
                        [otherAreaCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherAreaCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        otherAreaCell.title.text = NSLocalizedString(@"title_other_area", nil);
                        otherAreaCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherAreaCell.txtField.editable = NO;
                        
                    }
                        otherAreaCell.txtField.text = currentMarketResearch.businessArea;
                    return otherAreaCell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:{
            TextViewCell *textViewCell = (TextViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TextViewCell"];
            if (textViewCell == nil) {
                textViewCell = [[TextViewCell alloc] init];
            }
                textViewCell.textView.text = currentMarketResearch.remarks;
            textViewCell.textView.editable = NO;
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
            MarketResearchReply *reply = [currentMarketResearch.marketResearchReplies objectAtIndex:indexPath.row];
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
    strMarketResearchReply = [textView.text retain];
}


-(void)openPhoto:(int)index{
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [imageFiles objectAtIndex:index];
    ctrl.functionName = [NSString stringWithFormat:@"%@",currentMarketResearch.customer.name];
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
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeMarketresearchGet:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                MarketResearch* marketResearch = [MarketResearch parseFromData:cr.data];
                if ([super validateData:marketResearch]) {
                    currentMarketResearch = [marketResearch retain];
                    replies = [[NSMutableArray alloc] init];
                    for (int i = 0; i < currentMarketResearch.marketResearchReplies.count; ++i) {
                        [replies addObject:[currentMarketResearch.marketResearchReplies objectAtIndex:i]];
                    }
                    
                    [self _show];
                }
                
            }
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",martketresearchId]];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
            
        }
            break;
        case ActionTypeMarketresearchReply:{
            HUDHIDE;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                if (marketResearchReply != nil){

                    [replies addObject:marketResearchReply];
                    MarketResearch_Builder* mb = [currentMarketResearch toBuilder];
                    [mb setMarketResearchRepliesArray:replies];
                    MarketResearch* p = [[mb build] retain];
                    [currentMarketResearch release];
                    currentMarketResearch = nil;
                    currentMarketResearch = p;
                }
                [self.navigationController popViewControllerAnimated:YES];
                [tableView reloadData];
            }
            
            [super showMessage2:cr Title:NSLocalizedString(@"worklog_label_reply", @"") Description:NSLocalizedString(@"research_msg_reply", @"")];
            
        }
            break;
            
        default:
            break;
    }
}

@end
