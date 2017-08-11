//
//  SearchViewController.m
//  SalesManager
//
//  Created by ZhangLi on 14-1-13.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "SearchViewController.h"
#import "SelectCell.h"
#import "NSDate+Util.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize delegate,param;
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
    [btSearch setFrame:CGRectMake(8, 210+30, 305, 40)];
    [btSearch setBackgroundImage:[UIImage createImageWithColor:RGBA(231,76,60,1)] forState:UIControlStateNormal];
    [btSearch setTitle:NSLocalizedString(@"search_label", @"") forState:UIControlStateNormal];
    [btSearch addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btSearch];
    
    fromTime = [[NSString alloc] initWithString:[NSDate getYesterdayTime]];
    toTime = [[NSString alloc] initWithString:[NSDate getCurrentTime]];
    
    NSMutableArray *tmp = [LOCALMANAGER getCustomers];
    if (tmp == nil || [tmp count]<1) {
        Customer_Builder *cv1 = [Customer builder];
        
        [cv1 setId:0];
        [cv1 setName:@"全部"];
        if ((APPDELEGATE).myLocation != nil){
            [cv1 setLocation:(APPDELEGATE).myLocation];
        }
        CustomerCategory_Builder *ccv1 = [CustomerCategory builder];
        [ccv1 setId:0];
        [ccv1 setName:@"全部"];
        
        [cv1 setCategory:[[ccv1 build] retain]];
        currentCustomer = [[cv1 build] retain];
    }else{
        currentCustomer = [[[LOCALMANAGER getCustomers] objectAtIndex:0] retain];
    }
    Customer_Builder* cbv1 = [currentCustomer toBuilder];
    [cbv1 setId:0];
    [cbv1 setName:@"全部"];
    
    currentCustomer = [[cbv1 build] retain];
    [lblFunctionName setText:NSLocalizedString(@"search_label_title", @"")];
}

-(void)toSearch{
    NSObject* p = nil;
    if (param != nil) {
        if ([param isKindOfClass:[OrderGoodsParams class]]){
            OrderGoodsParams_Builder* spv1 = [(OrderGoodsParams*)param toBuilder];
            if (currentCustomer.id > 0) {
                [spv1 setCustomersArray:[[NSArray alloc] initWithObjects:currentCustomer,nil]];
            }
            [spv1 setStartDate:fromTime];
            [spv1 setEndDate:toTime];
            p = [spv1 build];
        }
    }
        
    if (delegate != nil && [delegate respondsToSelector:@selector(didFinishedSearchWithResult:)]) {
        [delegate didFinishedSearchWithResult:p];
    }
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)clickLeftButton:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(NSString *)intToDoubleString:(int)d{
    
    if (d<10) {
        return [NSString stringWithFormat:@"0%d",d];
    }
    return [NSString stringWithFormat:@"%d",d];
    
}
-(void)datePickerDidDone:(DatePicker*)picker{
    
    if(currentIndexPath.row == 2)
        fromTime = [[NSString stringWithFormat:@"%d-%@-%@ %@:%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue],[self intToDoubleString:datePicker.hourValue],[self intToDoubleString:datePicker.minuteValue]] retain];
    else if (currentIndexPath.row == 3)
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
    if (currentCustomer == nil) {
        NSMutableArray *tmp = [LOCALMANAGER getCustomers];
        if (tmp == nil || [tmp count]<1) {
            Customer_Builder *cv1 = [Customer builder];
            
            [cv1 setId:0];
            [cv1 setName:@"全部"];
            if ((APPDELEGATE).myLocation != nil){
                [cv1 setLocation:(APPDELEGATE).myLocation];
            }
            
            CustomerCategory_Builder *ccv1 = [CustomerCategory builder];
            [ccv1 setId:0];
            [ccv1 setName:@"全部"];
            
            [cv1 setCategory:[[ccv1 build] retain]];
            
            currentCustomer = [[cv1 build] retain];
        }else{
            currentCustomer = [[[LOCALMANAGER getCustomers] objectAtIndex:0] retain];
        }
        Customer_Builder* cbv1 = [currentCustomer toBuilder];
        [cbv1 setId:0];
        [cbv1 setName:@"全部"];
        
        currentCustomer = [[cbv1 build] retain];
    }
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
    return 4;
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
        case 2:
        case 3:{
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
        case 3:{
            
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
