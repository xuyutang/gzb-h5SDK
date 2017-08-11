//
//  NewCustomerViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-28.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "NewCustomerViewController.h"
#import "NSString+Helpers.h"
#import "Constant.h"
#import "MapTaggingViewController.h"
#import "CityViewController.h"

@interface NewCustomerViewController ()<RefreshDelegate,CustTagSelectControllerDelegate>{
    Location* customerLocation;
    NSMutableArray *paramTags;
}

@end

@implementation NewCustomerViewController
@synthesize txtTel,txtCustomerName,txtCustomerCategory,txtContact,btConfirm,btCancel,pickerView,btDone,lblCustomerCategory,lblCustomerName,lMark,btnLocation,lLocation;
@synthesize selectedIndex,customerCategories;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WT_WHITE;
    [self initView];
    
    if (APPDELEGATE.myLocation != nil) {
        customerLocation = [APPDELEGATE.myLocation retain];
    }else{
        customerLocation = nil;
    }
}

-(void)initView{
    paramTags = [[NSMutableArray alloc] initWithCapacity:0];
    selectArray = [[NSMutableArray alloc] init];
    [lblFunctionName setText:NSLocalizedString(@"new_customer_title", @"")];
    
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
    //[txtTel setInputAccessoryView:topView];
    //[txtCustomerName setInputAccessoryView:topView];
    //[txtCustomerCategory setInputAccessoryView:topView];
    //[txtContact setInputAccessoryView:topView];
    txtCustomerCategory.enabled = NO;
    _txtCustTag.enabled = NO;
    txtContact.delegate = self;
    txtCustomerName.delegate = self;
    txtTel.delegate = self;
    [btCategory addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    [lblCustomerName setText:NSLocalizedString(@"customer_label_name0", @"")];
    [lblCustomerCategory setText:NSLocalizedString(@"customer_label_category0", @"")];
    customerCategories = [[LOCALMANAGER getCustomerCategories] retain];
    pickerView = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0.0, MAINHEIGHT+64, 320.0, 251.0) tag:self];
    [self.view addSubview:pickerView];
    [btConfirm setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateNormal];
    [btConfirm addTarget:self action:@selector(toConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    lMark.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
    [lMark setText:[NSString fontAwesomeIconStringForEnum:ICON_LOCATION_ARROW]];
    [lMark setTextColor:WT_GRAY];
    
    [btnLocation addTarget:self action:@selector(toMapTagging) forControlEvents:UIControlEventTouchUpInside];
    if (APPDELEGATE.myLocation != nil) {
        if (!APPDELEGATE.myLocation.address.isEmpty) {
            lLocation.text = APPDELEGATE.myLocation.address;
        }else{
            lLocation.text = [NSString stringWithFormat:@"%f,%f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude];
        }
        customerLocation = [APPDELEGATE.myLocation retain];
    }else{
        customerLocation = nil;
    }
}

-(void)refresh:(id)obj{
    if ([obj isKindOfClass:[Location class]]) {
        customerLocation = [(Location*)obj retain];
        if (!customerLocation.address.isEmpty) {
            lLocation.text = customerLocation.address;
        }else{
            lLocation.text = [NSString stringWithFormat:@"%f,%f",customerLocation.latitude,customerLocation.longitude];
        }
    }
}
- (IBAction)selectCustTagAction:(id)sender {
    CustTagSelectViewController *custTagVC = [[CustTagSelectViewController alloc] init];
    custTagVC.bNeedBack = YES;
    custTagVC.bSingle = YES;
    custTagVC.delegate = self;
    custTagVC.selectedArray = selectArray;
    [self.navigationController pushViewController:custTagVC animated:YES];
    [custTagVC release];
}
- (IBAction)selectCityAction:(id)sender {
    CityViewController *cityVC = [[CityViewController alloc] init];
    cityVC.bNeedBack = YES;
    cityVC.selected = ^(id p,id c,id a){
        self.city.text = [a valueForKey:@"name"];
    };
    [self.navigationController pushViewController:cityVC animated:YES];
    [cityVC release];
}

#pragma -mark -- CustTagSelecDelegate
-(void)custTagTreeDidFnishedCheck:(NSMutableArray *)array{
    paramTags = [array retain] ;
}

-(void)custTagSelectDidFnished:(NSMutableArray *)array{
    selectArray = [array retain];
    [self.txtCustTag setText:[[self createCustTagNameWithArray:array] retain]];
}


-(NSMutableString *) createCustTagNameWithArray:(NSMutableArray *) array{
    NSMutableString *ms = [[NSMutableString alloc] init];
    int i = 1;
    for (id item in array) {
        if ([item isKindOfClass:[CustomerTag class]]) {
            CustomerTag *tmp = (CustomerTag*)item;
            [ms appendString:tmp.name];
        }else if ([item isKindOfClass:[CustomerTagValue class]]){
            CustomerTagValue *tmp = (CustomerTagValue *)item;
            [ms appendString:tmp.name];
        }
        if (i < selectArray.count) {
            [ms appendString:@","];
        }
        i++;
    }
    return ms;
}

-(void)toMapTagging{
    MapTaggingViewController *ctrl = [[MapTaggingViewController alloc] init];
    ctrl.bNeedBack = YES;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)toConfirm{
    if (txtCustomerCategory.text.length == 0){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_type", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (txtCustomerName.text.length == 0){
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_name", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (![txtCustomerName.text isValid:IdentifierTypeName]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_right_name", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (![txtContact.text isValid:IdentifierTypeName]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_right_contact", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (txtTel.text.length <= 0) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_phone_non_null", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (![txtTel.text isValid:IdentifierTypePhone]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_right_phone", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    Customer_Builder* cb = [Customer builder];
    [cb setId:0];
    [cb setName:txtCustomerName.text];
    if ((APPDELEGATE).myLocation != nil){
        [cb setLocation:(APPDELEGATE).myLocation];
    }
    
    [cb setCategory:[customerCategories objectAtIndex:selectedIndex]];
    [cb setName:txtCustomerName.text];
    
    Contact_Builder* c = [Contact builder];
    [c setName:txtContact.text];
    [c setPhoneArray:[[NSArray alloc] initWithObjects:txtTel.text, nil]];
    [cb setContactsArray:[[NSArray alloc] initWithObjects:[c build], nil]];
    if (customerLocation != nil) {
        [cb setLocation:customerLocation];
    }
    if (paramTags.count > 0) {
        [cb setTagsArray:paramTags];
    }
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    if (DONE != [AGENT sendRequestWithType:ActionTypeCustomerSave param:[cb build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
    }
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE2;
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE( cr.type)) {
        case ActionTypeCustomerSave:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                Customer* c = nil;
                if (cr.hasData) {
                    c = [Customer parseFromData:cr.data];
                    if ([super validateData:c]) {
                        if (c != nil){
                            [LOCALMANAGER saveCustomer:c];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_NOTIFICATION object:nil];
                        }
                    }
                }

                if (_delegate != nil && [_delegate respondsToSelector:@selector(didFinishedInput:)]) {
                    [_delegate didFinishedInput:c == nil ? nil : [c toBuilder]];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:NSLocalizedString(@"customer_new_saved", @"")];
            
        }
            break;
            
            
        default:
            break;
    }
}


#pragma mark - picker

-(void)dismiss{
    [self closePicker];
}

-(void)confirm{
    [self confirmPicker];
}

-(void)showPicker{
    [self dismissKeyBoard];
    if (pickerView.frame.origin.y == MAINHEIGHT-251) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(0, MAINHEIGHT-251, 320, 251);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)closePicker{
    if (pickerView.frame.origin.y == MAINHEIGHT+64) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(0, MAINHEIGHT+64, 320, 260);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)confirmPicker{
    [self closePicker];
    if (currentCategory != nil && ![currentCategory.name isEqual:@""])
        txtCustomerCategory.text = currentCategory.name;
    else if(customerCategories.count > 0){
        currentCategory = [customerCategories objectAtIndex:0];
        txtCustomerCategory.text = currentCategory.name;
        selectedIndex = 0;
    }
    
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [customerCategories count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return ((CustomerCategory*)[customerCategories objectAtIndex:row]).name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (customerCategories.count) {
        currentCategory = [customerCategories objectAtIndex:row];
        selectedIndex = row;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    if (currentTextField == txtCustomerCategory) {
        [self showPicker];
    }else{
        [self closePicker];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == txtCustomerCategory) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoBoardHidden:) name:UIKeyboardWillShowNotification object:nil];
    }else{
        [self closePicker];
    }
    return YES;
}

- (void)keyBoBoardHidden:(NSNotification *)Notification{
    [txtCustomerCategory resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    currentTextField = nil;
}

-(IBAction)dismissKeyBoard
{
    if (currentTextField != nil) {
        [currentTextField resignFirstResponder];
    }
}

-(IBAction)clearInput{
    
    currentTextField.text = @"";
    
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}


-(IBAction) slideFrameUp
{
    [self slideFrame:YES];
}

-(IBAction) slideFrameDown
{
    [self slideFrame:NO];
}

-(void) slideFrame:(BOOL) up
{
    const int movementDistance = 140; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (void)dealloc {
    [txtCustomerCategory release];
    [txtCustomerName release];
    [txtContact release];
    [txtTel release];
    [btConfirm release];
    [btCancel release];
    [pickerView release];
    [btCancel release];
    [btConfirm release];
    [btDone release];
    [btCategory release];
    [lblCustomerName release];
    [lblCustomerCategory release];
    [lLocation release];
    [lMark release];
    [btnLocation release];
    [_txtCustTag release];
    [_city release];
    [super dealloc];
}

@end
