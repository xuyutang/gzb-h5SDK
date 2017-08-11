//
//  OrderSearchViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "CompetitionSearchViewController.h"
#import "SelectCell.h"
#import "NSDate+Util.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "DepartmentViewController.h"


@interface CompetitionSearchViewController ()<DepartmentViewControllerDelegate>{
    NSMutableArray *departmentArray;
    NSMutableArray *checkedDepartmentArray;
}


@end

@implementation CompetitionSearchViewController
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
    
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, 320, 260) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    UIButton *btSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btSearch setFrame:CGRectMake(8, 210+70, 305, 40)];
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
    Customer_Builder* cb = [currentCustomer toBuilder];
    [cb setId:0];
    [cb setName:@"全部"];
    
    departmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    checkedDepartmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    [departmentArray removeAllObjects];
    [departmentArray addObjectsFromArray:[[LOCALMANAGER getDepartments] retain]];
    
    currentCustomer = [[cb build] retain];
    
    [lblFunctionName setText:NSLocalizedString(@"search_label_title", @"")];
}

-(void)clickLeftButton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)toSearch{
    CompetitionGoodsParams_Builder* bs = [CompetitionGoodsParams builder];
    
    if (currentCustomer.id > 0) {
        [bs setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
    }
    
    if (checkedDepartmentArray != nil && checkedDepartmentArray.count >0) {
        [bs setDepartmentsArray:checkedDepartmentArray];
    }else{
        [bs clearDepartments];
    }
    [bs setStartDate:fromTime];
    [bs setEndDate:toTime];

    if (delegate != nil && [delegate respondsToSelector:@selector(didFinishedSearchWithResult:)]) {
        [delegate didFinishedSearchWithResult:bs];
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
- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject{
    currentCustomer = (Customer *)aObject;
    [tableView reloadData];
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
            CustomerSelectViewController *ctrl = [[CustomerSelectViewController alloc] init];
            ctrl.delegate = self;
            ctrl.bNeedAll = YES;
            UINavigationController *customerNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:customerNavCtrl animated:YES completion:nil];
        }
            break;
        case 2:{
            DepartmentViewController *vctl = [[DepartmentViewController alloc] init];
            vctl.delegate = self;
            vctl.departmentArray = departmentArray;
            vctl.selectedArray = checkedDepartmentArray;
            vctl.bNeedBack = YES;
            [self.navigationController pushViewController:vctl animated:YES];
            [vctl release];
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
            distance = IS_IPHONE5?0:30;//(tableFrame.origin.y+tableFrame.size.height)-datePicker.frame.origin.y;
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
                selectCell.title.text = NSLocalizedString(@"customer_label_name", nil);
                if (currentCustomer != nil) {
                    selectCell.value.text = currentCustomer.name;
                }else{
                    selectCell.value.text = @"全部";
                }
                
                
            }
            cell = selectCell;
        }
            
            break;
        case 2:{
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

-(void)didFnishedCheck:(NSMutableArray *)departments{
    
    checkedDepartmentArray = [departments retain];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
