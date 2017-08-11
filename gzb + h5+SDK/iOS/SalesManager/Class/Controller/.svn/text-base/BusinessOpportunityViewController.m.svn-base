//
//  BusinessOpportunityViewController.m
//  SalesManager
//
//  Created by liuxueyan on 4/5/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "BusinessOpportunityViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "SelectCell.h"
#import "ExpandCell.h"
#import "NSString+Helpers.h"
#import "BusinessOpportunityListViewController.h"

@interface BusinessOpportunityViewController ()

@end

@implementation BusinessOpportunityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData{
    remarks = [[NSString alloc] initWithString:@""];
    customerName = [[NSString alloc] initWithString:@""];
    contactName = [[NSString alloc] initWithString:@""];
    contactTel = [[NSString alloc] initWithString:@""];
    otherBizOppSummary = [[NSString alloc] initWithString:@""];
    otherBizOppDecision = [[NSString alloc] initWithString:@""];
    otherActionPlan = [[NSString alloc] initWithString:@""];
    otherExpectedCost = [[NSString alloc] initWithString:@""];
    otherbizOppRemark = [[NSString alloc] initWithString:@""];
    signTime = [[NSString alloc] initWithString:@""];
    bizOppName = [[NSString alloc] initWithString:@""];
    bizOppPrincipal = [[NSString alloc] initWithString:@""];
    currentCustomer = nil;
    textViewCell.textView.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    [self initData];
    
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_search"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
       [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.rightButton = btRight;
    [btRight release];
    
    
	
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.tableFooterView = [[UIView alloc]init];
    [tableView setBackgroundColor:[UIColor whiteColor]];
   // tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    pickerView = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0.0, MAINHEIGHT, 320.0, 251.0) tag:self];
    [self.view addSubview:pickerView];
    
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_BIZOPP_DES)];
    
    AGENT.delegate = self;
    
    if (bNeedBack) {
        leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
    if (self.customer != nil) {
        currentCustomer = [self.customer retain];
    }
}

-(void)syncTitle {
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_BIZOPP_DES)];
}
-(void)clickLeftButton:(id)sender{
    if (bNeedBack){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [super clickLeftButton:sender];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length == 0) {
        return NO;
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)dismissKeyBoard
{
    if (currentTextField != nil) {
        [currentTextField resignFirstResponder];
        currentTextField = nil;
    }else if (currentTextView != nil) {
        [currentTextView resignFirstResponder];
        currentTextView = nil;
    }
}

-(IBAction)clearInput{
    
    if (currentTextField != nil) {
        currentTextField.text = @"";
    }else if (currentTextView != nil) {
        currentTextView.text = @"";
    }
    
}

-(void)toList:(id)sender{
    [self dismissKeyBoard];
    BusinessOpportunityListViewController *ctrl = [[BusinessOpportunityListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

-(void)toPicture:(id)sender{
    [self dismissKeyBoard];
    //ResearchPictureListViewController *ctrl = [[ResearchPictureListViewController alloc] init];
    //[self.navigationController pushViewController:ctrl animated:YES];
    
}

-(void)toSave:(id)sender{
    [self dismissKeyBoard];
    if(currentCustomer == nil){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)
                          description:NSLocalizedString(@"patrol_hint_customer_select", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (bizOppPrincipal.length>50) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"business_opportunity_bizOppPrincipal", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if (bizOppName.length>200) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)
                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"business_opportunity_bizOppName", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if (bizOppName == nil || [bizOppName isEqual:@""]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)
                          description:NSLocalizedString(@"bizoppname_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;

    }
    
    if (bizOppPrincipal == nil || [bizOppPrincipal isEqual:@""]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)
                          description:NSLocalizedString(@"bizoppprincipal_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
        
    }
    
    if (otherBizOppSummary.length>1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)
                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title_other_bizoppsummary", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (otherBizOppDecision.length>1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)
                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title_other_bizoppdecision", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (otherActionPlan.length>1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)
                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title_other_actionplan", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if([NSString stringContainsEmoji:otherActionPlan] ||
       [NSString stringContainsEmoji:otherBizOppDecision] ||
       [NSString stringContainsEmoji:otherBizOppSummary] ||
       [NSString stringContainsEmoji:bizOppPrincipal] ||
       [NSString stringContainsEmoji:bizOppName] ||
       [NSString stringContainsEmoji:customerName]){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    Customer_Builder *cb = [currentCustomer toBuilder];
    BusinessOpportunity_Builder* bo = [BusinessOpportunity builder];
    [bo setId:-1];
    
    if (bizOppName != nil && bizOppName.length>0) {
        [bo setBizOppName:bizOppName];
    }
    
    if(remarks != nil && remarks.length>0){
        [bo setBizOppRemark:remarks];
    }
    
    if(bizOppPrincipal != nil && bizOppPrincipal.length>0){
        [bo setBizOppPrincipal:bizOppPrincipal];
    }
    
    if(otherBizOppSummary != nil && otherBizOppSummary.length>0){
        [bo setBizOppSummary:otherBizOppSummary];
    }
    
    if(otherBizOppDecision != nil && otherBizOppDecision.length>0){
        [bo setBizOppDecision:otherBizOppDecision];
    }
    
    if(otherActionPlan != nil && otherActionPlan.length>0){
        [bo setActionPlan:otherActionPlan];
    }
    
    if(otherExpectedCost != nil && otherExpectedCost.length>0){
        [bo setExpectedCost:otherExpectedCost];
    }
    
    if(signTime != nil && signTime.length>0){
        [bo setExpectedSignTime:signTime];
    }

    [bo setCustomer:[[cb build] retain]];
    [bo setUser:USER];
    
    if (APPDELEGATE.myLocation != nil){
        [bo setLocation:APPDELEGATE.myLocation];
    }
    
    AGENT.delegate = self;
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeBusinessopportunitySave param: [bo build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_BIZOPP_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
}
#pragma -mark - CustomerSelectDelegate
- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject{
    currentCustomer = [(Customer *)aObject retain];
    [tableView reloadData];
}

- (void)customerSearchDidCanceled:(CustomerSelectViewController *)controller{
    
}

- (void)newCustomerDidFinished:(CustomerSelectViewController *)controller newCustomer:(id)aObject{
    currentCustomer = [[(Customer_Builder *)aObject build] retain];
    [tableView reloadData];
}

#pragma -mark - TableViewDelegate
#pragma mark numberOfSectionsInTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 2;
}

#pragma mark heightForHeaderInSection
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell* )cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row) {
            if (IOS8) {
            [cell setLayoutMargins:UIEdgeInsetsMake(1,MAINWIDTH,1,1)];
            }
         

        }
        }
}
#pragma mark heightForRowAtIndexPath
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 1) {
                return 55;
            }
            
            return 40;
        }
            break;
        case 1:{
            if(indexPath.row == 0){
                return 40;
            
            }
            return 120;
        }
            break;
        default:
            break;
    }
    return 40;
}

#pragma mark titleForHeaderInSection
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:{
            return NSLocalizedString(@"title_customer_info", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"title_bizopp_info", nil);
        }
            break;
//        case 2:{
//            return NSLocalizedString(@"title_other_info", nil);
//        }
//            break;
//        case 3:{
//            return NSLocalizedString(@"memo", nil);
//        }
//            break;
//        case 4:{
//            return NSLocalizedString(@"title_location_info", nil);
//        }
//            break;
//            
        default:
            break;
    }
    return @"";
}

#pragma mark numberOfRowsInSection
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if(section == 1){
        if (expandCell != nil && expandCell.bExpand) {
            return 1;
        }
    }
    return 9;
}

#pragma mark didSelectRowAtIndexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                CustomerSelectViewController *custVC = [[CustomerSelectViewController alloc] init];
                custVC.delegate = self;
                UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:custVC];
                [self presentViewController:navCtrl animated:YES completion:nil];
                [navCtrl release];
                [custVC release];
            }
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                [self dismissKeyBoard];
                [tableView reloadData];
            }else if( indexPath.row == 7){
                [self datePickerDidCancel];
                datePicker = [[DatePicker alloc] init];
                datePicker.tag = indexPath.row;
                [self.view addSubview:datePicker];
                [datePicker setDelegate:self];
                [datePicker setCenter:CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height-datePicker.frame.size.height*.5)];
                CGRect tableFrame = tableView.frame;
                distance = IS_IPHONE5?0:80;
                tableFrame.origin.y -= distance;
                [tableView setFrame:tableFrame];
                [datePicker release];

                
            }
        }
            break;
    }
    
}

#pragma mark cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    customerSelectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectCell00"];
                    if(customerSelectCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[SelectCell class]])
                                customerSelectCell=(SelectCell *)oneObject;
                        }
                
                        customerSelectCell.title.text = NSLocalizedString(@"customer_label_name", nil);
                       
                        customerSelectCell.value.text = @"";
                        if ( [customerSelectCell.value.text isEqualToString:@""]) {
                               customerSelectCell.value.text = @"请选择客户";
                            customerSelectCell.value.textColor = WT_GRAY;

                        }
                    }
                    if (currentCustomer != nil) {
                        customerSelectCell.value.text = currentCustomer.name;
                        customerSelectCell.value.textColor = WT_BLACK;
                    }
                    customerSelectCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return customerSelectCell;
                }
                case 1:{
                    locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if(locationCell==nil){
                        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
                        for(id oneObject in nib)
                        {
                            if([oneObject isKindOfClass:[LocationCell class]])
                                locationCell=(LocationCell *)oneObject;
                        }
                    }
                    
                    if (APPDELEGATE.myLocation != nil) {
                        if (!APPDELEGATE.myLocation.address.isEmpty) {
                            [locationCell.lblAddress setText:APPDELEGATE.myLocation.address];
                        }else{
                            [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude]];
                        }
                    }
                    [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
                    return locationCell;
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
//        case 1:{
//            
//            switch (indexPath.row) {
//                case 0:{
//                    bizOppNameCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
//                    if (bizOppNameCell == nil) {
//                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
//                        for (id oneObject in nib) {
//                            if ([oneObject isKindOfClass:[InputCell class]]) {
//                                bizOppNameCell = (InputCell *)oneObject;
//                            }
//                        }
//                        bizOppNameCell.title.text = NSLocalizedString(@"business_opportunity_bizOppName", nil);
//                        //UIToolbar *topView = [[self createToolbar] retain];
//                        //[bizOppNameCell.inputField setInputAccessoryView:topView];
//                        //[topView release];
//                        bizOppNameCell.inputField.tag = 11;
//                        bizOppNameCell.inputField.delegate = self;
//                       //                    if (bizOppName !=nil && bizOppName.length>0)bizOppNameCell.inputField.text = bizOppName;
//                    bizOppNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    return bizOppNameCell;
//                }
//                    break;
//                case 1:{
//                    bizOppPrincipalCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
//                    if (bizOppPrincipalCell == nil) {
//                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
//                        for (id oneObject in nib) {
//                            if ([oneObject isKindOfClass:[InputCell class]]) {
//                                bizOppPrincipalCell = (InputCell *)oneObject;
//                            }
//                        }
//                        bizOppPrincipalCell.title.text = NSLocalizedString(@"business_opportunity_bizOppPrincipal", nil);
//                        //UIToolbar *topView = [[self createToolbar] retain];
//                        //[bizOppPrincipalCell.inputField setInputAccessoryView:topView];
//                        //[topView release];
//                        bizOppPrincipalCell.inputField.tag = 12;
//                        bizOppPrincipalCell.inputField.delegate = self;
//                        bizOppPrincipalCell.inputField.placeholder = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"please_input", nil),NSLocalizedString(@"business_opportunity_bizOppPrincipal", nil)];
//                    }
//                    if (bizOppPrincipal !=nil && bizOppPrincipal.length>0)bizOppPrincipalCell.inputField.text = bizOppPrincipal;
//                    bizOppPrincipalCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    return bizOppPrincipalCell;
//                }
//                    break;
//                    
//            }
//        }
//            
//            break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    expandCell = (ExpandCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpandCell"];
                    if (expandCell == nil) {
                        expandCell = [[ExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpandCell"];
                        expandCell.titleLabel.text =[NSString stringWithFormat:@"   %@",NSLocalizedString(@"title_bizopp_info", nil)];NSLocalizedString(@"title_bizopp_info", nil);
                        expandCell.bExpand = YES;
                        expandCell.titleLabel.font = [UIFont systemFontOfSize:14];
                    }
                    return expandCell;
                }
                    break;
                case 1:{
                    bizOppNameCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    
                   
                    if (bizOppNameCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                bizOppNameCell = (TextFieldCell *)oneObject;
                            }
                        }
                        
                        [bizOppNameCell addSubview:[self setView]];
                        
                        bizOppNameCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppName", nil)];
                        bizOppNameCell.txtField.textColor = [UIColor grayColor];
                        bizOppNameCell.txtField.text = @"必填（200字以内）";
                        CGRect frame = bizOppNameCell.txtField.frame;
                        [bizOppNameCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        bizOppNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
                        bizOppNameCell.txtField.tag = 40;
                        bizOppNameCell.txtField.delegate = self;
                        
                    }
                    
                    if (bizOppName !=nil && bizOppName.length>0)bizOppNameCell.txtField.text = bizOppName;
                    return bizOppNameCell;
                }
                    break;
                case 2:{
                    bizOppPrincipalCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (bizOppPrincipalCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                bizOppPrincipalCell = (TextFieldCell *)oneObject;
                            }
                        }
                        [bizOppPrincipalCell addSubview:[self setView]];
                        bizOppPrincipalCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppPrincipal", nil)];
                        
                        bizOppPrincipalCell.txtField.textColor = [UIColor grayColor];
                        bizOppPrincipalCell.txtField.text = @"必填（50字以内）";
                        CGRect frame = bizOppPrincipalCell.txtField.frame;
                        [bizOppPrincipalCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        bizOppPrincipalCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        bizOppPrincipalCell.txtField.tag = 41;
                        bizOppPrincipalCell.txtField.delegate = self;
                        
                    }
                    if (bizOppPrincipal !=nil && bizOppPrincipal.length>0)bizOppPrincipalCell.txtField.text = bizOppPrincipal;
                    return bizOppPrincipalCell;
                }
                    break;


                case 3:{
                    otherBizOppSummaryCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherBizOppSummaryCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherBizOppSummaryCell = (TextFieldCell *)oneObject;
                            }
                        }
                        [otherBizOppSummaryCell addSubview:[self setView]];
                        otherBizOppSummaryCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppSummary", nil)];
                        otherBizOppSummaryCell.txtField.textColor = [UIColor grayColor];
                        otherBizOppSummaryCell.txtField.text = @"选填（1000字以内）";
                        CGRect frame = otherBizOppSummaryCell.txtField.frame;
                        [otherBizOppSummaryCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherBizOppSummaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        otherBizOppSummaryCell.txtField.tag = 21;
                        otherBizOppSummaryCell.txtField.delegate = self;
                        
                    }
                    if (otherBizOppSummary !=nil && otherBizOppSummary.length>0)otherBizOppSummaryCell.txtField.text = otherBizOppSummary;
                    return otherBizOppSummaryCell;
                }
                    break;
                case 4:{
                    otherBizOppDecisionCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherBizOppDecisionCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherBizOppDecisionCell = (TextFieldCell *)oneObject;
                            }
                        }
                        [otherBizOppDecisionCell addSubview:[self setView]];
                        otherBizOppDecisionCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppDecision", nil)];
                        
                        otherBizOppDecisionCell.txtField.textColor = [UIColor grayColor];
                        otherBizOppDecisionCell.txtField.text = @"选填（1000字以内）";
                        CGRect frame = otherBizOppDecisionCell.txtField.frame;
                        [otherBizOppDecisionCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherBizOppDecisionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
                        otherBizOppDecisionCell.txtField.tag = 22;
                        otherBizOppDecisionCell.txtField.delegate = self;
                    }
                    if (otherBizOppDecision !=nil && otherBizOppDecision.length>0 && otherBizOppDecisionCell != nil)otherBizOppDecisionCell.txtField.text = otherBizOppDecision;
                    return otherBizOppDecisionCell;
                }
                    break;
                case 5:{
                    otherActionPlanCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherActionPlanCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherActionPlanCell = (TextFieldCell *)oneObject;
                            }
                        }
                        [otherActionPlanCell addSubview:[self setView]];
                        otherActionPlanCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_actionPlan", nil)];
                        otherActionPlanCell.txtField.textColor = [UIColor grayColor];
                        otherActionPlanCell.txtField.text = @"选填（1000字以内）";
                        CGRect frame = otherActionPlanCell.txtField.frame;
                        [otherActionPlanCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherActionPlanCell.selectionStyle =                         otherActionPlanCell.txtField.tag = 23;
                        otherActionPlanCell.txtField.delegate = self;
                    }
                    if (otherActionPlan !=nil && otherActionPlan.length>0&& otherActionPlanCell != nil)otherActionPlanCell.txtField.text = otherActionPlan;
                    return otherActionPlanCell;
                }
                    break;
                case 6:{
                     otherExpectedCostCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherExpectedCostCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherExpectedCostCell = (TextFieldCell *)oneObject;
                            }
                        }
                        [otherExpectedCostCell addSubview:[self setView]];
                        otherExpectedCostCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_expectedCost", nil)];
                        otherExpectedCostCell.txtField.textColor = [UIColor grayColor];
                        otherExpectedCostCell.txtField.text = @"选填（200字以内）";
                        CGRect frame = otherExpectedCostCell.txtField.frame;
                        [otherExpectedCostCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherExpectedCostCell.selectionStyle = UITableViewCellSelectionStyleNone;

                        otherExpectedCostCell.txtField.tag = 43;
                        otherExpectedCostCell.txtField.delegate = self;
                    }
                    if (otherExpectedCost !=nil && otherExpectedCost.length>0&& otherExpectedCostCell != nil)otherExpectedCostCell.txtField.text = otherExpectedCost;
                    return otherExpectedCostCell;
                }
                    break;
                case 7:{
                    selectCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (selectCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                selectCell = (TextFieldCell *)oneObject;
                            }
                        }
                        [selectCell addSubview:[self setView]];
                           UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
                        [tapGesture1 setNumberOfTapsRequired:1];
                        selectCell.userInteractionEnabled = YES;
                        [selectCell addGestureRecognizer:tapGesture1];
                        selectCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_expectedSignTime", nil)];
                        
                        CGRect frame = otherExpectedCostCell.txtField.frame;
                        [selectCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        selectCell.txtField.editable = NO;
                        selectCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        selectCell.txtField.tag = 44;
                        selectCell.txtField.delegate = self;
                    }
                    if (signTime !=nil && signTime.length>0&& selectCell != nil)
                        
                        selectCell.txtField.text = signTime;
                    return selectCell;
                }
                    break;
                    
          
             case 8:{
                 otherbizOppRemarkCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                 if (otherbizOppRemarkCell == nil) {
                     NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                     for (id oneObject in nib) {
                         if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                             otherbizOppRemarkCell = (TextFieldCell *)oneObject;
                         }
                     }
                     [otherbizOppRemarkCell addSubview:[self setView]];
                     otherbizOppRemarkCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"business_opportunity_bizOppRemark", nil)];
                     otherbizOppRemarkCell.txtField.textColor = [UIColor grayColor];
                     otherbizOppRemarkCell.txtField.text = @"选填（1000字以内）";
                     CGRect frame = otherExpectedCostCell.txtField.frame;
                     [otherbizOppRemarkCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                     otherbizOppRemarkCell.selectionStyle = UITableViewCellSelectionStyleNone;
                     //UIToolbar *topView = [[self createToolbar] retain];
                     //[otherActionPlanCell.txtField setInputAccessoryView:topView];
                     //[topView release];
                     otherbizOppRemarkCell.txtField.tag = 45;
                     otherbizOppRemarkCell.txtField.delegate = self;
                 }
                 
                 if (remarks !=nil && remarks.length>0&& otherbizOppRemarkCell != nil)
                     
                     otherbizOppRemarkCell.txtField.text = remarks;
                 return otherbizOppRemarkCell;
             }
                    break;
            default:
            break;
            }
            break;
          
        }
    }
      return cell;
}

-(UIView*)setView {

    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, MAINWIDTH - 100, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, MAINWIDTH - 40, 0.5)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 20 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
   
    return contView;
}

-(void)tapAction {
    [self datePickerDidCancel];
    datePicker = [[DatePicker alloc] init];
    [self.view addSubview:datePicker];
    [datePicker setDelegate:self];
    [datePicker setCenter:CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height-datePicker.frame.size.height*.5)];
    CGRect tableFrame = tableView.frame;
    distance = IS_IPHONE5?0:80;
    tableFrame.origin.y -= distance;
    [tableView setFrame:tableFrame];
    [datePicker release];


}

-(void)autorefreshLocation {
    [super refreshLocation];
    [tableView reloadData];
}

- (void)refreshLocation{
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [tableView reloadData];
    
    [hud hide:YES afterDelay:1.0];
}

-(NSString *)intToDoubleString:(int)d{
    
    if (d<10) {
        return [NSString stringWithFormat:@"0%d",d];
    }
    return [NSString stringWithFormat:@"%d",d];
    
}
-(void)datePickerDidDone:(DatePicker*)picker{
    signTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    
    [self datePickerDidCancel];
    [tableView reloadData];
}
-(void)datePickerDidCancel{
    
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[DatePicker class]]){
            
            [view removeFromSuperview];
        }
    }
    
    CGRect tableFrame = tableView.frame;
    tableFrame.origin.y += distance;
    distance = 0;
    [tableView setFrame:tableFrame];
    // [datePicker removeFromSuperview];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self dismissKeyBoard];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    currentTextView = nil;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 11) {
        bizOppName = [textField.text copy];
    }else if (textField.tag == 12){
        bizOppPrincipal = [textField.text copy];
    }else if (textField.tag == 24) {
        otherExpectedCost = [textField.text copy];
    }else if (textField.tag == 1) {
        customerName = [textField.text copy];
    }else if (textField.tag == 3) {
        contactTel = [textField.text copy];
    }else if (textField.tag == 2) {
        contactName = [textField.text copy];
    }
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
    if ([textView.text  isEqual: @"必填（200字以内）"]) {
        textView.text = @"";

    }
    if ([textView.text isEqualToString:@"必填（50字以内）"]) {
        textView.text = @"";
    }
    if ([textView.text isEqualToString:@"选填（1000字以内）"]) {
        textView.text = @"";
    }
    if ([textView.text isEqualToString:@"选填（200字以内）"]) {
        textView.text = @"";
    }
    
    
    currentTextField = nil;
    currentTextView = textView;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 40) {
        bizOppName = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"必填（200字以内）";
              textView.textColor = [UIColor grayColor];
        }
    }

    if (textView.tag == 41) {
        bizOppPrincipal = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（200字以内）";
             textView.textColor = [UIColor grayColor];
        }

        
    }
    if (textView.tag == 43) {
        otherExpectedCost = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"必填（200字以内）";
             textView.textColor = [UIColor grayColor];
        }

    }
    if (textView.tag == 44) {
        signTime = [textView.text copy];
    }

    if (textView.tag == 45) {
        remarks = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（1000字以内）";
             textView.textColor = [UIColor grayColor];
        }
    }

    if (textView.tag == 21) {
        otherBizOppSummary = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（1000字以内）";
             textView.textColor = [UIColor grayColor];
        }

        
    }
    if (textView.tag == 22) {
        otherBizOppDecision = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（1000字以内）";
             textView.textColor = [UIColor grayColor];
        }

    }
    if (textView.tag == 23) {
        otherActionPlan = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（1000字以内）";
             textView.textColor = [UIColor grayColor];
        }

    }
}

-(UIToolbar*)createToolbar{
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
- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeBusinessopportunitySave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                if (cr.hasData) {
                    Customer* c = [Customer parseFromData:cr.data];
                    if ([super validateData:c]) {
                        if (c != nil){
                            [LOCALMANAGER saveCustomer:c];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_NOTIFICATION object:nil];
                        }
                    }
                }
                
                [self initData];
                [tableView reloadData];
            }
            [super showMessage2:cr Title:TITLENAME(FUNC_BIZOPP_DES)
          Description:NSLocalizedString(@"research_msg_saved", @"")];
            
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


@end
