//
//  PatrolSearchViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/4/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "PatrolSearchViewController.h"
#import "SelectCell.h"
#import "PatrolTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "DatePicker.h"
#import "UserSelectViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "NSDate+Util.h"

@interface PatrolSearchViewController ()

@end

@implementation PatrolSearchViewController
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
    
    [leftImageView setImage:[UIImage imageNamed:@"topbar_button_goback"]];
	tableView = [[UTTableView alloc] initWithFrame:CGRectMake(0, 15, 320, 300) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    UIButton *btSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btSearch setFrame:CGRectMake(8, 250, 305, 40)];
    [btSearch setBackgroundImage:[UIImage imageNamed:@"bg_button_long"] forState:UIControlStateNormal];
    [btSearch setTitle:NSLocalizedString(@"search_label", @"") forState:UIControlStateNormal];
    [btSearch addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btSearch];
    
    fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
    toTime = [[NSString alloc] initWithString:[NSDate getCurrentTime]];
    //currentUser = [(APPDELEGATE).currentUser copy];

    NSMutableArray *tmp = [LOCALMANAGER getCustomers];
    if (tmp == nil || [tmp count]<1) {
        Customer_Builder *customer = [Customer builder];
        CustomerV1_Builder* cv1 = [CustomerV1 builder];
        
        [cv1 setId:0];
        [cv1 setName:@"全部"];
        if ((APPDELEGATE).myLocation != nil){
            [cv1 setLocation:(APPDELEGATE).myLocation];
        }
        CustomerCategory_Builder *tmpCategory = [CustomerCategory builder];
        CustomerCategoryV1_Builder* ccv1 = [CustomerCategoryV1 builder];
        [ccv1 setId:0];
        [ccv1 setName:@"全部"];
        [tmpCategory setVersion:ccv1.version];
        [tmpCategory setV1:[ccv1 build]];
        
        [cv1 setCategory:[[tmpCategory build] retain]];
        [customer setVersion:cv1.version];
        [customer setV1:[cv1 build]];
        currentCustomer = [[customer build] retain];
    }else{
        currentCustomer = [[[LOCALMANAGER getCustomers] objectAtIndex:0] retain];
    }
    
    PatrolCategory_Builder *tmpCategory = [PatrolCategory builder];
    PatrolCategoryV1_Builder* pcv1 = [PatrolCategoryV1 builder];
    
    [pcv1 setId:0];
    [pcv1 setName:@"全部"];
    [tmpCategory setVersion:pcv1.version];
    [tmpCategory setV1:[pcv1 build]];

    currentPatrolCategory = [[tmpCategory build] retain];
    
    Customer_Builder* cb = [currentCustomer toBuilder];
    CustomerV1_Builder* cbv1 = [cb.v1 toBuilder];
    [cbv1 setId:0];
    [cbv1 setName:@"全部"];
    [cb setVersion:cbv1.version];
    [cb setV1:[cbv1 build]];
    
    currentCustomer = [[cb build] retain];
    
    PatrolCategory_Builder* pb = [currentPatrolCategory toBuilder];
    PatrolCategoryV1_Builder* pbv1 = [pb.v1 toBuilder];
    [pbv1 setId:0];
    [pbv1 setName:@"全部"];
    
    currentPatrolCategory = [[pb build] retain];
    
    [lblFunctionName setText:NSLocalizedString(@"search_label_title", @"")];
}

-(void)clickLeftButton:(id)sender{

    [self dismissModalViewControllerAnimated:YES];
}

-(void)toSearch{
    PatrolParams_Builder* pbparam = [PatrolParams builder];
    PatrolParamsV1_Builder* pbv1 = [PatrolParamsV1 builder];
    
    BaseSearchParamsV1_Builder* bsv1 = [BaseSearchParamsV1 builder];
    
    [pbv1 setCategory:currentPatrolCategory];
    if (currentCustomer.v1.id == -1) {
        [bsv1 setCustomerCategoryArray:[[NSArray alloc] initWithObjects: currentCustomer.v1.category,nil]];
    }else{
        [bsv1 setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
    }

    [bsv1 setStartDate:fromTime];
    [bsv1 setEndDate:toTime];
    [pbv1 setBaseParams:[bsv1 build]];
    
    [pbparam setVersion:pbv1.version];
    [pbparam setV1:[pbv1 build]];
    
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


    if(currentIndexPath.row == 3)
        fromTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    else if (currentIndexPath.row == 4)
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

- (void)patrolSearch:(PatrolTypeViewController *)controller didSelectWithObject:(id)aObject{
    
    currentPatrolCategory = (PatrolCategory *)aObject;
    
    if (currentPatrolCategory == nil) {
        currentPatrolCategory = [[[LOCALMANAGER getPatrolCategories] objectAtIndex:0] retain];
        PatrolCategory_Builder* pb = [currentPatrolCategory toBuilder];
        PatrolCategoryV1_Builder* pbv1 = [pb.v1 toBuilder];
        [pbv1 setId:0];
        [pbv1 setName:@"全部"];
        [pb setVersion:pbv1.version];
        [pb setV1:[pbv1 build]];
        currentPatrolCategory = [[pb build] retain];
    }
    [tableView reloadData];
    
}

- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject{
    currentCustomer = (Customer *)aObject;
    if (currentCustomer == nil) {
        NSMutableArray *tmp = [LOCALMANAGER getCustomers];
        if (tmp == nil || [tmp count]<1) {
            Customer_Builder *customer = [Customer builder];
            CustomerV1_Builder* cv1 = [CustomerV1 builder];
            
            [cv1 setId:0];
            [cv1 setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [cv1 setLocation:(APPDELEGATE).myLocation];
            }

            CustomerCategory_Builder *tmpCategory = [CustomerCategory builder];
            CustomerCategoryV1_Builder* ccv1 = [CustomerCategoryV1 builder];
            [ccv1 setId:0];
            [ccv1 setName:@"全部"];
            [tmpCategory setVersion:ccv1.version];
            [tmpCategory setV1:[ccv1 build]];
            
            [cv1 setCategory:[[tmpCategory build] retain]];
            [customer setVersion:cv1.version];
            [customer setV1:[cv1 build]];
            
            currentCustomer = [[customer build] retain];
        }else{
            currentCustomer = [[[LOCALMANAGER getCustomers] objectAtIndex:0] retain];
        }
        Customer_Builder* cb = [currentCustomer toBuilder];
        CustomerV1_Builder* cbv1 = [cb.v1 toBuilder];
        [cbv1 setId:0];
        [cbv1 setName:@"全部"];
        [cb setVersion:cbv1.version];
        [cb setV1:[cbv1 build]];
        
        currentCustomer = [[cb build] retain];
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
    return 5;
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
            [self datePickerDidCancel];
            PatrolTypeViewController *ctrl = [[PatrolTypeViewController alloc] init];
            ctrl.delegate = self;
            ctrl.bFavorate = NO;
            ctrl.bNeedAll = YES;
            UINavigationController *patrolNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:patrolNavCtrl animated:YES completion:nil];
        }
            break;
        case 2:{
            [self datePickerDidCancel];
            CustomerSelectViewController *ctrl = [[CustomerSelectViewController alloc] init];
            ctrl.delegate = self;
            ctrl.bNeedAll = YES;
            UINavigationController *customerNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:customerNavCtrl animated:YES completion:nil];
        }
            break;
        case 3:
        case 4:{
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
                    selectCell.value.text = currentUser.v1.realName;
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
                selectCell.title.text = NSLocalizedString(@"patrol_label_category", nil);
                selectCell.value.text = currentPatrolCategory.v1.name;
                
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
                selectCell.title.text = NSLocalizedString(@"customer_label_name", nil);
                if (currentCustomer != nil) {
                    selectCell.value.text = currentCustomer.v1.name;
                }else{
                    selectCell.value.text = @"全部";
                }
                
                
            }
            cell = selectCell;
        }
            
            break;
        case 3:{
            
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
        case 4:{
            
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
