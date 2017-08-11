//
//  InspectionSearchViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-11-27.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InspectionSearchViewController.h"
#import "SelectCell.h"
#import "PatrolTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "DatePicker.h"
#import "UserSelectViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "NSDate+Util.h"

@interface InspectionSearchViewController ()

@end

@implementation InspectionSearchViewController
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
    [btSearch setFrame:CGRectMake(8, 310, 305, 40)];
    [btSearch setBackgroundImage:[UIImage createImageWithColor:WT_RED] forState:UIControlStateNormal];
    [btSearch setTitle:NSLocalizedString(@"search_label", @"") forState:UIControlStateNormal];
    [btSearch addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btSearch];
    
    fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
    toTime = [[NSString alloc] initWithString:[NSDate getCurrentTime]];
    //currentUser = [(APPDELEGATE).currentUser copy];
    
    //InspectionReportCategory_Builder *tmpCategory = [InspectionReportCategory builder];
    //[tmpCategory setId:0];
    //[tmpCategory setName:@"全部"];
    
    //currentCategory = [[tmpCategory build] retain];//[[[LOCALMANAGER getPatrolCategories] objectAtIndex:0] retain];
    
    //currentUser = [[[[currentUser toBuilder] setId:0] setRealName:@"全部"] build];
    //currentCategory = [[[[[currentCategory toBuilder] setId:0] setName:@"全部"] build] retain];
    
    [lblFunctionName setText:NSLocalizedString(@"search_label_title", @"")];
}

-(void)clickLeftButton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)toSearch{
    InspectionReportParams_Builder* pbparam = [InspectionReportParams builder];
    if (currentCategory != nil) {
        [pbparam setInspectionReportCategory:currentCategory];
    }
    if (currentTargetType != nil) {
        [pbparam setInspectionType:currentTargetType];
    }
    
    if (targetCell != nil && targetCell.inputField.text.length > 0) {
        InspectionTarget_Builder *itb = [InspectionTarget builder];
        [itb setName:targetCell.inputField.text];
        [itb setId:-1];
        [pbparam setInspectionTarget:[itb build]];
    }
    
    [pbparam setStartDate:fromTime];
    [pbparam setEndDate:toTime];
    
    if (delegate != nil && [delegate respondsToSelector:@selector(didFinishedSearchWithResult:)]) {
        [delegate didFinishedSearchWithResult:pbparam];
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

- (void)inspectionSearch:(InspectionTypeViewController *)controller didSelectWithObject:(id)aObject{
    
    currentCategory = (InspectionReportCategory *)aObject;
    
    if (currentCategory == nil) {
        currentCategory = [[[LOCALMANAGER getInspectionCategories] objectAtIndex:0] retain];
        
        InspectionReportCategory_Builder* gcb = [currentCategory toBuilder];
        [gcb setId:0];
        [gcb setName:@"全部"];
        
        currentCategory = [[gcb build] retain];

    }
    [tableView reloadData];
}

-(void)targetTypeSearch:(InspectionTargetTypeViewController *)controller didSelectWithObject:(id)aObject{
    currentTargetType = (InspectionType *)aObject;
    
    if (currentTargetType == nil) {
        currentTargetType = [[[LOCALMANAGER getInspectionTypes] objectAtIndex:0] retain];
        InspectionType_Builder* gcb = [currentTargetType toBuilder];
        [gcb setId:0];
        [gcb setName:@"全部"];
        currentTargetType = [[gcb build] retain];

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
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath :(NSIndexPath *)indexPath{
    currentIndexPath = [indexPath retain];
    switch (indexPath.row) {
        case 0:{
            [self datePickerDidCancel];
            UserSelectViewController *ctrl = [[UserSelectViewController alloc] init];
            ctrl.delegate = self;
            ctrl.bAllUsers = FALSE;
            UINavigationController *userNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:userNavCtrl animated:YES completion:nil];
        }
            break;
        case 1:{
            [self datePickerDidCancel];
            InspectionTypeViewController *ctrl = [[InspectionTypeViewController alloc] init];
            ctrl.delegate = self;
            ctrl.bFavorate = NO;
            ctrl.bNeedAll = YES;
            UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:patrolNavCtrl animated:YES completion:nil];
        }
            break;
        case 2:{
            [self datePickerDidCancel];
            InspectionTargetTypeViewController *ctrl = [[InspectionTargetTypeViewController alloc] init];
            ctrl.delegate = self;
            ctrl.bFavorate = NO;
            ctrl.bNeedAll = YES;
            UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:patrolNavCtrl animated:YES completion:nil];
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
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
                selectCell.title.text = NSLocalizedString(@"inspection_label_category", nil);
                selectCell.value.text = currentCategory.name;
                
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
                selectCell.title.text = NSLocalizedString(@"target_label_category", nil);
                selectCell.value.text = currentTargetType.name;
                
            }
            cell = selectCell;
        }
            break;
        case 3:{
            targetCell=(InputCell *)[tableView dequeueReusableCellWithIdentifier:@"targetCell"];
            if(targetCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"InputCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[InputCell class]])
                        targetCell=(InputCell *)oneObject;
                }
                targetCell.title.text = NSLocalizedString(@"customer_label_name", nil);

            }
            return targetCell;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
