//
//  NewCustomerView.m
//  SalesManager
//
//  Created by liu xueyan on 9/6/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "NewCustomerView.h"
#import "ZSYPopoverListView.h"
#import "LocalManager.h"
#import "Constant.h"
#import "MapTaggingViewController.h"

@implementation NewCustomerView
@synthesize txtTel,txtCustomerName,txtCustomerCategory,txtContact,btConfirm,btCancel,pickerView,btDone,lblCustomerCategory,lblCustomerName,lMark,lLocation,btnLocation,lblLocation;
@synthesize selectedIndex,customerCategories;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)initView{

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
    
    txtContact.delegate = self;
    txtCustomerName.delegate = self;
    txtTel.delegate = self;
    [btCategory addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    [lblCustomerName setText:NSLocalizedString(@"customer_label_name0", @"")];
    [lblCustomerCategory setText:NSLocalizedString(@"customer_label_category0", @"")];
    customerCategories = [[LOCALMANAGER getCustomerCategories] retain];
    pickerView = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0.0, MAINHEIGHT+64, 320.0, 251.0) tag:self];
    [self addSubview:pickerView];
    btConfirm.backgroundColor = WT_RED;
    
    lMark.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
    [lMark setText:[NSString fontAwesomeIconStringForEnum:ICON_LOCATION_ARROW]];
    [lMark setTextColor:WT_GRAY];
    
    if (APPDELEGATE.myLocation != nil) {
        if (!APPDELEGATE.myLocation.address.isEmpty) {
            lLocation.text = APPDELEGATE.myLocation.address;
        }else{
            lLocation.text = [NSString stringWithFormat:@"%f,%f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude];
        }
        
    }
    lMark.hidden = YES;
    btnLocation.hidden = YES;
    lLocation.hidden = YES;
    lblLocation.hidden = YES;
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
    else{
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
    currentCategory = [customerCategories objectAtIndex:row];
    selectedIndex = row;
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
    self.frame = CGRectOffset(self.frame, 0, movement);
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
    [lblLocation release];
    [super dealloc];
}
@end
