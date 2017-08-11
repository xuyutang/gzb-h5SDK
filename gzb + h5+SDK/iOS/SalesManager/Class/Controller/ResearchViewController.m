//
//  ResearchViewController.m
//  SalesManager
//
//  Created by ZhangLi on 14-1-13.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "ResearchViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "SelectCell.h"
//#import "ResearchPictureListViewController.h"
#import "ResearchListViewController.h"
#import "ExpandCell.h"
#import "NSString+Helpers.h"


@interface ResearchViewController ()

@end

@implementation ResearchViewController

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
    otherArea = [[NSString alloc] initWithString:@""];
    otherTotal = [[NSString alloc] initWithString:@""];
    otherProduct = [[NSString alloc] initWithString:@""];
    otherCategory = [[NSString alloc] initWithString:@""];
    otherScale = [[NSString alloc] initWithString:@""];
    
    
    if ([imageFiles count]>0) {
        [LOCALMANAGER clearImagesWithFiles:imageFiles];
        [imageFiles removeAllObjects];
    }
    currentCustomer = nil;
    imageFiles = [[NSMutableArray alloc] init];
  CommonPhrasesCell.textView.text = @"";
    CommonPhrasesCell.textView.placeHolder = @"必填（1000字以内）";
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

//    UIImageView *picListImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 50, 30)];
//    [picListImageView setImage:[UIImage imageNamed:@"topbar_button_pic"]];
//    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPicture:)];
//    [tapGesture3 setNumberOfTapsRequired:1];
//    picListImageView.userInteractionEnabled = YES;
//    picListImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [picListImageView addGestureRecognizer:tapGesture3];
//    [rightView addSubview:picListImageView];
//    [picListImageView release];
    
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_search"]];
       UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.contentMode = UIViewContentModeScaleAspectFit;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
   
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
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
    //tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor whiteColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    pickerView = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0.0, MAINHEIGHT, 320.0, 251.0) tag:self];
    [self.view addSubview:pickerView];
    
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_RESEARSH_DES)];
    
    AGENT.delegate = self;
    
    if (bNeedBack) {
        leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
    if (self.customer != nil) {
        currentCustomer = [self.customer retain];
    }
}

-(void)syncTitle{
  [lblFunctionName setText:TITLENAME_REPORT(FUNC_RESEARSH_DES)];

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
    ResearchListViewController *ctrl = [[ResearchListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];

}

-(void)toPicture:(id)sender{
    [self dismissKeyBoard];
    //ResearchPictureListViewController *ctrl = [[ResearchPictureListViewController alloc] init];
    //[self.navigationController pushViewController:ctrl animated:YES];
    
}

-(void)toSave:(id)sender{
    [self dismissKeyBoard];
    remarks = CommonPhrasesCell.textView.text;
    if(remarks.length == 0){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:NSLocalizedString(@"patrol_hint_content", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    
    if(currentCustomer == nil){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:NSLocalizedString(@"patrol_hint_customer_select", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if (imageFiles == nil || [imageFiles count]<1) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:NSLocalizedString(@"patrol_hint_files", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (otherScale.length>1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title_other_scale", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (otherCategory.length>1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title_other_category", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if (otherProduct.length>1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title_other_product", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if (otherTotal.length>200) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title_other_total", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if (otherArea.length>1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"title_other_area", nil),NSLocalizedString(@"input_limit_over", @"")]
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    if([NSString stringContainsEmoji:customerName] ||
       [NSString stringContainsEmoji:otherArea] ||
       [NSString stringContainsEmoji:otherTotal] ||
       [NSString stringContainsEmoji:otherProduct] ||
       [NSString stringContainsEmoji:otherCategory] ||
       [NSString stringContainsEmoji:otherScale]
       ){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        
        return;
    }
    
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    Customer_Builder *cb = [currentCustomer toBuilder];
    MarketResearch_Builder* pb = [MarketResearch builder];
    [pb setId:-1];
    if (otherArea != nil && otherArea.length>0) {
        [pb setBusinessArea:otherArea];
    }
    if (otherCategory != nil && otherCategory.length>0) {
        [pb setBusinessCategory:otherCategory];
    }
    if (otherProduct != nil && otherProduct.length>0) {
        [pb setPrimaryProduct:otherProduct];
    }
    if (otherScale != nil && otherScale.length>0) {
        [pb setBusinessSize:otherScale];
    }
    if (otherArea != nil && otherArea.length>0) {
        [pb setBusinessArea:otherArea];
    }
    if (otherTotal != nil && otherTotal.length>0) {
        [pb setTurnover:otherTotal];
    }
    
    if(remarks != nil && remarks.length>0){
        [pb setRemarks:remarks];
    }
    [pb setCustomer:[[cb build] retain]];
    [pb setUser:USER];
    if (APPDELEGATE.myLocation != nil){
        [pb setLocation:APPDELEGATE.myLocation];
    }
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *file in liveImageCell.imageFiles) {
        UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
        NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
        [images addObject:dataImg];
    }
    [pb setFilesArray:images];
    
    AGENT.delegate = self;
    
    if (DONE != [AGENT sendRequestWithType:ActionTypeMarketresearchSave param:[pb build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_RESEARSH_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

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
            return 120;
        }
            break;
        case 2:{
            return 140;
        }

        case 3:{
            switch (indexPath.row) {
                case 0:
                    return 40;
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
                case 5:
                    return 120;
                    break;
                    
                default:
                    break;
            }
        }
            break;
                   break;
        
//        case 4:{
//            return 80;
//        }
//            break;
            
        default:
            break;
    }
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:{
            return NSLocalizedString(@"title_customer_info", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"title_live_image", nil);
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
            return NSLocalizedString(@"title_location_info", nil);
        }
            break;
            
        default:
            break;
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 3){
        if (expandCell != nil && !expandCell.bExpand) {
            return 6;
        }
    }
    return 1;
}

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
        case 3:{
            if (indexPath.row == 0) {
                [self dismissKeyBoard];
                [tableView reloadData];
//                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
//                
//                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
               
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
                        
                    }
                    if (currentCustomer != nil) {
                        customerSelectCell.value.text = currentCustomer.name;
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
                    
                    locationCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    
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
        case 1:{
            
            if(liveImageCell==nil){
                liveImageCell = [[LiveImageCell alloc] init];
                liveImageCell.delegate = self;
            }
            liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return liveImageCell;
        }
            break;
        case 2:{
            if (CommonPhrasesCell == nil) {
               // CommonPhrasesCell.textView.placeHolder = @"";
                CommonPhrasesCell = [[CommonPhrasesTextViewCell alloc] init];
                CommonPhrasesCell.textView.delegate = self;
                CommonPhrasesCell.textView.text = remarks;
                CommonPhrasesCell.textView.tag = 30;
                
                UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
                [topView setBarStyle:UIBarStyleBlack];
                UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
                UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
                UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
                
                NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
                [doneButton release];
                [btnSpace release];
                [helloButton release];
                
                [topView setItems:buttonsArray];
                //[textViewCell.textView setInputAccessoryView:topView];
                textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
                [topView release];
            }
            
            return CommonPhrasesCell;
            
        }
            break;


        case 3:{
        
            switch (indexPath.row) {
                case 0:{
                    expandCell = (ExpandCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpandCell"];
                    if (expandCell == nil) {
                        expandCell = [[ExpandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpandCell"];
                        expandCell.titleLabel.text = [NSString stringWithFormat:@"   %@",NSLocalizedString(@""@"title_other_title", nil)];
//                        expandCell.textLabel.text = NSLocalizedString(@""@"title_other_title", nil);
                        expandCell.titleLabel.font = [UIFont systemFontOfSize:14];
                    }
                    return expandCell;
                }
                    break;
                case 1:{
                    otherScaleCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherScaleCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherScaleCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherScaleCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"title_other_scale", nil)];
                        otherScaleCell.txtField.text = @"选填（1000字以内）" ;
                        otherScaleCell.txtField.textColor = [UIColor grayColor];
                        [otherScaleCell addSubview:[self setView]];
                        CGRect frame = otherScaleCell.txtField.frame;
                        [otherScaleCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherScaleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //UIToolbar *topView = [[self createToolbar] retain];
                        //[otherScaleCell.txtField setInputAccessoryView:topView];
                        //[topView release];
                        otherScaleCell.txtField.tag = 21;
                        otherScaleCell.txtField.delegate = self;
                        
                    }
                    if (otherScale !=nil && otherScale.length>0)otherScaleCell.txtField.text = otherScale;
                    return otherScaleCell;
                }
                    break;
                case 2:{
                    otherCategoryCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherCategoryCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherCategoryCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherCategoryCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"title_other_category", nil)];
                        
                        otherCategoryCell.txtField.text = @"选填（1000字以内）" ;
                        otherCategoryCell.txtField.textColor = [UIColor grayColor];
                          [otherCategoryCell addSubview:[self setView]];
                        CGRect frame = otherCategoryCell.txtField.frame;
                        [otherCategoryCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherCategoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //UIToolbar *topView = [[self createToolbar] retain];
                        //[otherCategoryCell.txtField setInputAccessoryView:topView];
                        //[topView release];
                        otherCategoryCell.txtField.tag = 22;
                        otherCategoryCell.txtField.delegate = self;
                    }
                    if (otherCategory !=nil && otherCategory.length>0 && otherCategoryCell != nil)otherCategoryCell.txtField.text = otherCategory;
                    return otherCategoryCell;
                }
                    break;
                case 3:{
                    otherProductCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherProductCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherProductCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherProductCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"title_other_product", nil)];
                        otherProductCell.txtField.text = @"选填（1000字以内）" ;
                        otherProductCell.txtField.textColor = [UIColor grayColor];

                        [otherProductCell addSubview:[self setView]];
                         CGRect frame = otherProductCell.txtField.frame;
                        [otherProductCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherProductCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //UIToolbar *topView = [[self createToolbar] retain];
                        //[otherProductCell.txtField setInputAccessoryView:topView];
                        //[topView release];
                        otherProductCell.txtField.tag = 23;
                        otherProductCell.txtField.delegate = self;
                    }
                    if (otherProduct !=nil && otherProduct.length>0&& otherProductCell != nil)otherProductCell.txtField.text = otherProduct;
                    return otherProductCell;
                }
                    break;
                case 4:{
                    
                    
                    otherTotalCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherTotalCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherTotalCell = (TextFieldCell *)oneObject;
                            }
                        }
                        otherTotalCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"title_other_total", nil)];
                        otherTotalCell.txtField.text = @"选填（200字以内）" ;
                        otherTotalCell.txtField.textColor = [UIColor grayColor];
                        [otherTotalCell addSubview:[self setView]];
                        CGRect frame = otherTotalCell.txtField.frame;
                        [otherTotalCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherTotalCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        //UIToolbar *topView = [[self createToolbar] retain];
                        //[otherCategoryCell.txtField setInputAccessoryView:topView];
                        //[topView release];
                        otherTotalCell.txtField.tag = 24;
                        otherTotalCell.txtField.delegate = self;
                    }
                    if (otherCategory !=nil && otherCategory.length>0 && otherTotalCell != nil)otherTotalCell.txtField.text = otherCategory;
                    return otherTotalCell;
                }
                    break;

                case 5:{
                    otherAreaCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
                    if (otherAreaCell == nil) {
                        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil];
                        for (id oneObject in nib) {
                            if ([oneObject isKindOfClass:[TextFieldCell class]]) {
                                otherAreaCell = (TextFieldCell *)oneObject;
                            }
                        }
                       
                        otherAreaCell.txtField.text = @"选填（1000字以内）" ;
                        otherAreaCell.txtField.textColor = [UIColor grayColor];
                         otherAreaCell.title.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"title_other_area", nil)];
                     

                        [otherAreaCell addSubview:[self setView]];
                        
                        CGRect frame = otherAreaCell.txtField.frame;
                        [otherAreaCell.txtField setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 80)];
                        otherAreaCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                        //UIToolbar *topView = [[self createToolbar] retain];
                        //[otherAreaCell.txtField setInputAccessoryView:topView];
                        //[topView release];
                        otherAreaCell.txtField.tag = 25;
                        otherAreaCell.txtField.delegate = self;
                    }
                    
                    if (otherArea !=nil && otherArea.length>0 && otherAreaCell != nil)otherAreaCell.txtField.text = otherArea;
                    return otherAreaCell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell* )cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        if (indexPath.row) {
            if (IOS8) {
                 [cell setLayoutMargins:UIEdgeInsetsMake(1,MAINWIDTH,1,1)];
            }
        }
    }
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self dismissKeyBoard];
    

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    currentTextField = textField;
    currentTextView = nil;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
   
    if (textField.tag == 1) {
        customerName = [textField.text copy];
    }else
    if (textField.tag == 3) {
        contactTel = [textField.text copy];
    }else
    if (textField.tag == 2) {
        contactName = [textField.text copy];
    }

}
-(void)textViewDidBeginEditing:(UITextView *)textView{
      CommonPhrasesCell.textView.placeHolder = @"";
    textView.textColor = [UIColor blackColor];
//    if ([textView.text  isEqual: @"必填（1000字以内）"]) {
//        textView.text = @"";
//        
//    }
    if ([textView.text  isEqual: @"选填（1000字以内）"]) {
        textView.text = @"";
        
    }

    if ([textView.text  isEqual: @"选填（200字以内）"]) {
        textView.text = @"";
        
    }
    currentTextField = nil;
    currentTextView = textView;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 21) {
        otherScale = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（1000字以内）";
            textView.textColor = [UIColor grayColor];
        }

    }
    if (textView.tag == 23) {
        otherProduct = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（1000字以内）";
            textView.textColor = [UIColor grayColor];
        }

    }
    if (textView.tag == 22) {
        otherCategory = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（1000字以内）";
            textView.textColor = [UIColor grayColor];
        }

    }
    if (textView.tag == 24) {
        otherTotal = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（200字以内）";
            textView.textColor = [UIColor grayColor];
        }

    }

    if (textView.tag == 25) {
        otherArea = [textView.text copy];
        if (textView.text.length<1) {
            textView.text = @"选填（1000字以内）";
            textView.textColor = [UIColor grayColor];
        }

    }
    if (textView.tag == 30) {
        remarks = [textView.text copy];
        if (textView.text.length<1) {
             CommonPhrasesCell.textView.placeHolder = @"必填（1000字以内）";
//            textView.text = @"必填（1000字以内）";
//            textView.textColor = [UIColor grayColor];

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

-(void)addPhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:NO];
        [self presentModalViewController:cameraVC animated:YES];
        [cameraVC release];
        
    }else {
        NSLog(@"Camera is not available.");
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Obtain the path to save to
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFile = [[NSString alloc] initWithString:[NSString UUID]];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageFile]];
    
    // Extract image from the picker and save it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [self fitSmallImage:[info objectForKey:UIImagePickerControllerOriginalImage]] ;
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);//UIImagePNGRepresentation(image);
        [data writeToFile:imagePath atomically:YES];
    }
    [imageFiles addObject:imagePath];
    [liveImageCell insertPhoto:imagePath];
    
    //[imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
    [picker dismissModalViewControllerAnimated:YES];
    [imageFile release];
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage *)fitSmallImage:(UIImage *)image
{
    if (nil == image)
    {
        return nil;
    }
    if (image.size.width<720 && image.size.height<960)
    {
        return image;
    }
    CGSize size = [self fitsize:image.size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newing;
}
- (CGSize)fitsize:(CGSize)thisSize
{
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/720;
    CGFloat hscale = thisSize.height/960;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    return newSize;
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    //NSLog(@"image.size.width=%f  image.size.height=%f",image.size.width,image.size.height);
    if (image.size.width > image.size.height) {
        newSize.width = (newSize.height/image.size.height) *image.size.width;
    }else{
        newSize.height = (newSize.width/image.size.width) *image.size.height;
    }
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeMarketresearchSave:{
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
                
                
                [liveImageCell clearCell];
                [self initData];
                [tableView reloadData];
            }
            [super showMessage2:cr Title:TITLENAME(FUNC_RESEARSH_DES)Description:NSLocalizedString(@"research_msg_saved", @"")];
            
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
