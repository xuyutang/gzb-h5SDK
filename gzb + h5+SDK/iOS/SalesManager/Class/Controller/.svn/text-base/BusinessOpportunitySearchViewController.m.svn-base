//
//  BusinessOpportunitySearchViewController.m
//  SalesManager
//
//  Created by liuxueyan on 5/5/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "BusinessOpportunitySearchViewController.h"
#import "SelectCell.h"
#import "DatePicker.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "UserSelectViewController.h"
#import "DepartmentViewController.h"

@interface BusinessOpportunitySearchViewController ()<DepartmentViewControllerDelegate>{
    NSMutableArray *departmentArray;
    NSMutableArray *checkedDepartmentArray;
}


@end

@implementation BusinessOpportunitySearchViewController

@synthesize delegate;

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
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, 320, 300) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    UIButton *btSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btSearch setFrame:CGRectMake(8, 250+70, 305, 40)];
    [btSearch setBackgroundImage:[UIImage createImageWithColor:RGBA(231,76,60,1)] forState:UIControlStateNormal];
    [btSearch setTitle:NSLocalizedString(@"search_label", @"") forState:UIControlStateNormal];
    [btSearch addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btSearch];
    
    fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
    toTime = [[NSString alloc] initWithString:[NSDate getCurrentTime]];
    
    NSMutableArray *tmp = [LOCALMANAGER getCustomers];
    if (tmp == nil || [tmp count]<1) {
        Customer_Builder *c = [Customer builder];
        
        [c setId:0];
        [c setName:@"全部"];
        if ((APPDELEGATE).myLocation != nil){
            [c setLocation:(APPDELEGATE).myLocation];
        }
        CustomerCategory_Builder *cc = [CustomerCategory builder];
        [cc setId:0];
        [cc setName:@"全部"];
        
        [c setCategory:[[cc build] retain]];
        currentCustomer = [[c build] retain];
    }else{
        currentCustomer = [[[LOCALMANAGER getCustomers] objectAtIndex:0] retain];
    }
    [lblFunctionName setText:NSLocalizedString(@"search_label_title", @"")];
    pickerView = [[CategoryPickerView alloc] initWithFrame:CGRectMake(0.0, MAINHEIGHT, 320.0, 251.0) tag:self];
    [self.view addSubview:pickerView];
    
    if ([customerCategories count]>0) {
        [customerCategories removeAllObjects];
    }
    
    customerCategories = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getCustomerCategories]];
    CustomerCategory_Builder *cc = [CustomerCategory builder];
    
    [cc setId:0];
    [cc setName:@"全部"];
    [customerCategories insertObject:[[cc build] retain] atIndex:0];
    currentCustomerCategory = [customerCategories objectAtIndex:0];
    
    departmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    checkedDepartmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    [departmentArray removeAllObjects];
    [departmentArray addObjectsFromArray:[[LOCALMANAGER getDepartments] retain]];
}

-(void)clickLeftButton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)toSearch{
    BusinessOpportunityParams_Builder* pb = [BusinessOpportunityParams builder];
    
    [pb setCustomerCategoryArray:[[NSArray alloc] initWithObjects:currentCustomerCategory, nil]];
    if (currentTextField != nil && currentTextField.text.length>0) {
        Customer_Builder *cb = [Customer builder];
        [cb setId:-1];
        [cb setName:currentTextField.text];
        [cb setCategory:currentCustomerCategory];
        
        [pb setCustomersArray:[[NSArray alloc] initWithObjects:[[cb build] retain], nil]];
    }
    
    if (checkedDepartmentArray != nil && checkedDepartmentArray.count >0) {
        [pb setDepartmentsArray:checkedDepartmentArray];
    }else{
        [pb clearDepartments];
    }
    [pb setStartDate:fromTime];
    [pb setEndDate:toTime];
    
    
    if (delegate != nil && [delegate respondsToSelector:@selector(didFinishedSearchWithResult:)]) {
        [delegate didFinishedSearchWithResult:pb];
    }
    [self dismissModalViewControllerAnimated:YES];
    
}


-(NSString *)intToDoubleString:(int)d{
    
    if (d<10) {
        return [NSString stringWithFormat:@"0%d",d];
    }
    return [NSString stringWithFormat:@"%d",d];
    
}
-(void)datePickerDidDone:(DatePicker*)picker{
    
    
    if(currentIndexPath.row == 4)
        fromTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    else if (currentIndexPath.row == 5)
        toTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    
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

-(void)userSearch:(UserSelectViewController *)controller didSelectWithObject:(id)aObject{
    currentUser = (User *)aObject;
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    currentIndexPath = [indexPath retain];
    switch (indexPath.row) {
        case 0:{
            [self datePickerDidCancel];
            UserSelectViewController *ctrl = [[UserSelectViewController alloc] init];
            ctrl.delegate = self;
            UINavigationController *userNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:userNavCtrl animated:YES completion:nil];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            [self datePickerDidCancel];
            [self dismissKeyBoard];
            [self showPicker];
        }
            break;
        case 3:{
            DepartmentViewController *vctl = [[DepartmentViewController alloc] init];
            vctl.delegate = self;
            vctl.departmentArray = departmentArray;
            vctl.selectedArray = checkedDepartmentArray;
            vctl.bNeedBack = YES;
            [self.navigationController pushViewController:vctl animated:YES];
            [vctl release];
        }
            break;
        case 4:
        case 5:{
            [self datePickerDidCancel];
            datePicker = [[DatePicker alloc] init];
            datePicker.tag = indexPath.row;
            [self.view addSubview:datePicker];
            [datePicker setDelegate:self];
            [datePicker setCenter:CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height-datePicker.frame.size.height*.5)];
            CGRect tableFrame = tableView.frame;
            distance = IS_IPHONE5?0:80;//(tableFrame.origin.y+tableFrame.size.height)-datePicker.frame.origin.y;
            tableFrame.origin.y -= distance;
            [tableView setFrame:tableFrame];
            [datePicker release];
            
        }
            break;
            
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
            
        case 0:{
            
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                selectCell.title.text = NSLocalizedString(@"user_label_name", nil);
                if (currentUser != nil) {
                    selectCell.value.text = currentUser.realName;
                }else{
                    selectCell.value.text =@"全部";
                }
                
            }
            cell = selectCell;
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
                UIToolbar *topView = [[self createToolbar] retain];
                [customerNameCell.inputField setInputAccessoryView:topView];
                [topView release];
                customerNameCell.inputField.tag = 1;
                customerNameCell.inputField.delegate = self;
                customerNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //if (customerName !=nil && customerName.length>0)customerNameCell.inputField.text = customerName;
            
            cell = customerNameCell;
        }
            break;
        case 2:{
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                selectCell.title.text = NSLocalizedString(@"customer_label_category", nil);
                if (currentCustomerCategory != nil) {
                    selectCell.value.text = currentCustomerCategory.name;
                }else{
                    selectCell.value.text = @"全部";
                }
                
            }
            cell = selectCell;
        }
            
            break;
        case 3:{
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectCell"];
            //if(selectCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[SelectCell class]])
                    selectCell=(SelectCell *)oneObject;
            }
            //}
            
            selectCell.title.text = NSLocalizedString(@"gift_delivery_select_department", nil);
            
            if (checkedDepartmentArray != nil && checkedDepartmentArray.count>0) {
                Department *tmpDepart = (Department *)[checkedDepartmentArray objectAtIndex:0];
                NSString *strDepartments = tmpDepart.name;
                for (int i = 1; i < 3 && i<checkedDepartmentArray.count; i++) {
                    tmpDepart = (Department *)[checkedDepartmentArray objectAtIndex:i];
                    strDepartments = [NSString stringWithFormat:@"%@,%@",strDepartments,tmpDepart.name];
                }
                selectCell.value.text = strDepartments;
            }else{
                selectCell.value.text = NSLocalizedString(@"gift_hint_select_department", nil);
            }
            
            selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return selectCell;
            
        }
            break;

        case 4:{
            
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                selectCell.title.text = NSLocalizedString(@"search_label_start_date", nil);
                selectCell.value.text = fromTime;
            }
            cell = selectCell;
        }
            break;
            
        case 5:{
            
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                selectCell.title.text = NSLocalizedString(@"search_label_end_date", nil);
                selectCell.value.text = toTime;
            }
            cell = selectCell;
        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)didFnishedCheck:(NSMutableArray *)departments{
    
    checkedDepartmentArray = [departments retain];
    [tableView reloadData];
}

#pragma mark - picker

-(void)dismiss{
    [self closePicker];
}

-(void)confirm{
    [self closePicker];
}

-(void)showPicker{
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
    if (pickerView.frame.origin.y == MAINHEIGHT) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(0, MAINHEIGHT, 320, 260);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    if (currentCustomerCategory != nil && ![currentCustomerCategory.name isEqual:@""])
        [tableView reloadData];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView

{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    return [customerCategories count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    return ((CustomerCategory *)[customerCategories objectAtIndex:row]).name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    currentCustomerCategory = [customerCategories objectAtIndex:row];
    //[self closePicker];
    /*
     NSString *result = [pickerView pickerView:pickerView titleForRow:row forComponent:component];
     NSLog(@"result: %@",result);
     [result release];
     */
}

-(IBAction)dismissKeyBoard
{
    if (currentTextField != nil) {
        [currentTextField resignFirstResponder];
    }
}

-(IBAction)clearInput{
    
    if (currentTextField != nil) {
        currentTextField.text = @"";
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
