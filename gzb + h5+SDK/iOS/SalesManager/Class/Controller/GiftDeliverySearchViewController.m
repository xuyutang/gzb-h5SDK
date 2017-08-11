//
//  GiftDeliverySearchViewController.m
//  SalesManager
//
//  Created by 章力 on 14-9-23.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "GiftDeliverySearchViewController.h"
#import "SelectCell.h"
#import "DatePicker.h"
#import "UserSelectViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "NSDate+Util.h"

@interface GiftDeliverySearchViewController ()

@end

@implementation GiftDeliverySearchViewController
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
    [btSearch setFrame:CGRectMake(8, 280+30, 305, 40)];
    [btSearch setBackgroundImage:[UIImage createImageWithColor:RGBA(231,76,60,1)] forState:UIControlStateNormal];
    [btSearch setTitle:NSLocalizedString(@"search_label", @"") forState:UIControlStateNormal];
    [btSearch addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btSearch];
    
    name = [[NSString alloc ] initWithString:@""];
    fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
    toTime = [[NSString alloc] initWithString:[NSDate getCurrentTime]];
    //currentUser = [(APPDELEGATE).currentUser copy];
    
    //GiftProductCategory_Builder *tmpCategory = [GiftProductCategory builder];
    //[tmpCategory setId:0];
    //[tmpCategory setName:@"全部"];
    
    //currentGiftProductCategory = [[tmpCategory build] retain];//[[[LOCALMANAGER getPatrolCategories] objectAtIndex:0] retain];
    
    //currentUser = [[[[currentUser toBuilder] setId:0] setRealName:@"全部"] build];
    //currentCustomer = [[[[[currentCustomer toBuilder] setId:0] setName:@"全部"] build] retain];
    //currentPatrolCategory = [[[[[currentPatrolCategory toBuilder] setId:0] setName:@"全部"] build] retain];
    
    [lblFunctionName setText:NSLocalizedString(@"search_label_title", @"")];
}

-(void)clickLeftButton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)toSearch{
    GiftDeliveryParams_Builder* pb = [GiftDeliveryParams builder];

    if (currentGiftProductCategory != nil) {
        [pb setGiftCategory:currentGiftProductCategory];
    }
    
    if (currentApplyCategory != nil) {
        [pb setApplyCategory:currentApplyCategory];
    }
    
    if (nameCell.inputField.text != nil && nameCell.inputField.text.length >0) {
        [pb setGiftName:nameCell.inputField.text];
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
    
    if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]){
        if(currentIndexPath.row == 4)
            fromTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
        else if (currentIndexPath.row == 5)
            toTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    }else{
        if(currentIndexPath.row == 3)
            fromTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
        else if (currentIndexPath.row == 4)
            toTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
        
    }
    
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

- (void)giftTypeSearch:(GiftTypeViewController *)controller didSelectWithObject:(id)aObject{
    
    currentGiftProductCategory = (GiftProductCategory *)aObject;
    
    if (currentGiftProductCategory == nil) {
        currentGiftProductCategory = [[[LOCALMANAGER getGiftProductCategories] objectAtIndex:0] retain];
        GiftProductCategory_Builder* gcb = [currentGiftProductCategory toBuilder];
        [gcb setId:0];
        [gcb setName:@"全部"];
        
        currentGiftProductCategory = [[gcb build] retain];
    }
    [tableView reloadData];
}

-(void)applyTypeSearch:(ApplyTypeViewController *)controller didSelectWithObject:(id)aObject{
    
    currentApplyCategory = (ApplyCategory *)aObject;
    
    if (currentApplyCategory == nil) {
        currentApplyCategory = [[[LOCALMANAGER getApplyCategories] objectAtIndex:0] retain];
        ApplyCategory_Builder* gcb = [currentApplyCategory toBuilder];
        [gcb setId:0];
        [gcb setName:@"全部"];
        currentApplyCategory = [[gcb build] retain];
    }
    [tableView reloadData];
    
}

-(void)userSearch:(UserSelectViewController *)controller didSelectWithObject:(id)aObject{
    currentUser = (User *)aObject;
    [tableView reloadData];
}

- (void)newCustomerDidFinished:(CustomerSelectViewController *)controller newCustomer:(id)aObject{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]) return 6;
    else return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndex :(int)index{
    switch (index) {
        case 0:{
            [self datePickerDidCancel];
            UserSelectViewController *ctrl = [[UserSelectViewController alloc] init];
            ctrl.delegate = self;
            UINavigationController *userNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:userNavCtrl animated:YES completion:nil];
        }
            break;
        case 1:{
            [self datePickerDidCancel];
            ApplyTypeViewController *ctrl = [[ApplyTypeViewController alloc] init];
            ctrl.delegate = self;
            ctrl.bFavorate = NO;
            ctrl.bNeedAll = YES;
            UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:patrolNavCtrl animated:YES completion:nil];
        }
            break;
        case 2:{
            [self datePickerDidCancel];
            GiftTypeViewController *ctrl = [[GiftTypeViewController alloc] init];
            ctrl.delegate = self;
            ctrl.bNeedAll = YES;
            UINavigationController *customerNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:customerNavCtrl animated:YES completion:nil];
        }
            break;
            
        case 4:
        case 5:{
            [self datePickerDidCancel];
            datePicker = [[DatePicker alloc] init];
            datePicker.tag = index;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    currentIndexPath = [indexPath retain];
    switch (indexPath.row) {
        case 0:{
            [self tableView:tableView didSelectRowAtIndex:0];
        }
            break;
        case 1:{
            if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]) {
                [self tableView:tableView didSelectRowAtIndex:1];
            }else{
                [self tableView:tableView didSelectRowAtIndex:2];
            }
        }
            break;
        case 2:{
            if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]) {
                [self tableView:tableView didSelectRowAtIndex:2];
            }else{
                [self tableView:tableView didSelectRowAtIndex:3];
            }
        }
            break;
        case 3:
            if (![LOCALMANAGER hasFunction:FUNC_APPROVE_DES]){
                [self tableView:tableView didSelectRowAtIndex:4];
            }
        case 4:{
            if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]) {
                [self tableView:tableView didSelectRowAtIndex:4];
            }else{
                [self tableView:tableView didSelectRowAtIndex:5];
            }
        }
            break;
        case 5:{
            [self tableView:tableView didSelectRowAtIndex:5];
        }
            break;
            
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndex:(int)index{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (index) {
            
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
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                selectCell.title.text = NSLocalizedString(@"apply_label_category", nil);
                selectCell.value.text = currentApplyCategory.name;
                
            }
            cell = selectCell;
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
                selectCell.title.text = NSLocalizedString(@"gift_label_category", nil);
                selectCell.value.text = currentGiftProductCategory.name;
            }
            cell = selectCell;
        }
            
            break;
        case 3:{
            nameCell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:@"InputCell"];
            if (nameCell == nil) {
                NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil];
                for (id oneObject in nib) {
                    if ([oneObject isKindOfClass:[InputCell class]]) {
                        nameCell = (InputCell *)oneObject;
                    }
                }
                nameCell.title.text = NSLocalizedString(@"gift_name", nil);
                UIToolbar *topView = [[self createToolbar] retain];
                [nameCell.inputField setInputAccessoryView:topView];
                [topView release];
                nameCell.inputField.text = name;
                nameCell.inputField.tag = 1;
                nameCell.inputField.delegate = self;
                nameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell = nameCell;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
            
        case 0:{
            return [self tableView:tableView cellForRowAtIndex:0];
        }
            break;
        case 1:{
            if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]) {
                return [self tableView:tableView cellForRowAtIndex:1];
            }else{
                return [self tableView:tableView cellForRowAtIndex:2];
            }
        }
            break;
        case 2:{
            if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]) {
                return [self tableView:tableView cellForRowAtIndex:2];
            }else{
                return [self tableView:tableView cellForRowAtIndex:3];
            }
        }
            
            break;
        case 3:{
            if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]) {
                return [self tableView:tableView cellForRowAtIndex:3];
            }else{
                return [self tableView:tableView cellForRowAtIndex:4];
            }
        }
            break;
            
        case 4:{
            if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]) {
                return [self tableView:tableView cellForRowAtIndex:4];
            }else{
                return [self tableView:tableView cellForRowAtIndex:5];
            }
            
        }
            break;
        case 5:{
            
            if ([LOCALMANAGER hasFunction:FUNC_APPROVE_DES]) {
                return [self tableView:tableView cellForRowAtIndex:5];
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    name = [textField.text retain];
}

-(IBAction)dismissKeyBoard
{
    name = nameCell.inputField.text;
    if (nameCell.inputField != nil) {
        [nameCell.inputField resignFirstResponder];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
