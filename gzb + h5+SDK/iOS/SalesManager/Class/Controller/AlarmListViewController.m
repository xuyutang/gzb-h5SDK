//
//  AlarmListViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15/6/9.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "AlarmListViewController.h"
#import "Alarm.h"
#import "Repetition.h"
#import "Alarm+Extensions.h"
#import "AlarmDetailViewController.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "SWTableViewCell.h"

@interface AlarmListViewController ()<AlarmDetailViewControllerDelegate,SWTableViewCellDelegate>{
}
@end

@implementation AlarmListViewController
@synthesize alarms;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:NO];
    
    [leftImageView setImage:[UIImage imageNamed:@"topbar_button_goback"]];
    [leftView addSubview:leftImageView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 60)];
    UIImageView *freshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 50, 25)];
    [freshImageView setImage:[UIImage imageNamed:@"ic_add_red"]];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newAlarm)];
    [tapGesture2 setNumberOfTapsRequired:1];
    freshImageView.userInteractionEnabled = YES;
    freshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [freshImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:freshImageView];
    [freshImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.navigationItem.rightBarButtonItem = btRight;
    [btRight release];

    _managedObjectContext = LOCALMANAGER.managedObjectContext;
    alarms = [[Alarm getAlarmsWithManagedObjectContext:self.managedObjectContext] retain];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsMultipleSelectionDuringEditing = NO;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    
    lblFunctionName.text = NSLocalizedString(@"menu_function_alarm", @"");
}

-(void)newAlarm{
    AlarmDetailViewController *vctrl = [[AlarmDetailViewController alloc] init];
    vctrl.bNeedBack = YES;
    vctrl.delegate = self;
    [self.navigationController pushViewController:vctrl animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return alarms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlarmItemCell *cell = (AlarmItemCell *)[tableView dequeueReusableCellWithIdentifier:@"AlarmItemCell"];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons addUtilityButtonWithColor:WT_RED icon:[UIImage imageNamed:@"ic_delete_grey"]];
    cell = [[AlarmItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlarmItemCell" containingTableView:tableView rowHeight:44 leftUtilityButtons:nil rightUtilityButtons:rightUtilityButtons];
    
    Alarm *item = [alarms objectAtIndex:indexPath.row];

    cell.title.text = item.title;
    /*NSString* hour = item.hour.stringValue;
    if (item.hour.intValue < 10) {
        hour = [NSString stringWithFormat:@"0%@",item.hour.stringValue];
    }
    NSString* minute = item.minute.stringValue;
    if (item.minute.intValue < 10) {
        minute = [NSString stringWithFormat:@"0%@",item.minute.stringValue];
    }*/
    cell.time.text = item.displayTime;
    [cell.onoff setOn:[item.on boolValue]];
    cell.onoff.tag = indexPath.row;
    [cell.onoff addTarget:self action:@selector(setOnoff:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    return cell;
}

-(void)setOnoff:(id)sender{
    UISwitch *onoff = (UISwitch *)sender;
    Alarm *item = alarms[onoff.tag];
    item.on = [NSNumber numberWithBool:onoff.on];
    [self save:item Curd:UPDATE];
    [_tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AlarmDetailViewController *vctrl = [[AlarmDetailViewController alloc] init];
    vctrl.alarmItem = [alarms objectAtIndex:indexPath.row];
    vctrl.bNeedBack = YES;
    vctrl.delegate = self;
    [self.navigationController pushViewController:vctrl animated:YES];
}

-(void)save:(Alarm *)alarmItem Curd:(int)curd{
    if (alarmItem != nil) {
        if (curd == CREATE) {
            [alarms addObject:alarmItem];
        }
        if (curd == DELETE) {
            [alarms removeObject:alarmItem];
            [self.managedObjectContext deleteObject:alarmItem];
        }
        if (curd == UPDATE) {
            for (int i = 0; i < alarms.count; ++i) {
                if ([alarms objectAtIndex:i] == alarmItem) {
                    [alarms removeObject:alarmItem];
                    [alarms insertObject:alarmItem atIndex:i];
                    break;
                }
            }
        }
        
    }
    
    if(self.managedObjectContext.hasChanges)
    {
        NSError *error;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"save failed: %@", error);
        }
        
    }
    
    //  self.activationButton.enabled = [self.alarm.on boolValue];
    /*
     [self.activationButton setSelectedSegmentIndex:![self.alarm.on boolValue]];
     
     [self.timeButton setTitle:[self.alarm displayTime] forState:UIControlStateNormal];
     [self.repeatButton setTitle:[self.alarm displayRepitions] forState:UIControlStateNormal];
     [self.soundButton setTitle:[self.alarm displaySound] forState:UIControlStateNormal];
     [self.alarm displayAddress:^(NSArray *placemarks, NSError *error){
     CLPlacemark *placemark = placemarks.lastObject;
     if (placemark) {
     
     NSString *address = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
     [self.locationButton setTitle:address forState:UIControlStateNormal];
     }
     }];
     */
    if (alarmItem.on.intValue == 1 && curd != DELETE) {
        [alarmItem createAlarmNotification];
    }
    if (alarmItem.on.intValue == 0 || curd == DELETE) {
        [alarmItem cancelAlarmNotification];
    }
    if (alarms.count == 0) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

-(void)finishedEdit:(Alarm *)alarmItem Curd:(int)curd{
    [self save:alarmItem Curd:curd];

    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SW Table View Cell Delegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
    
}
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    Alarm* a = [alarms objectAtIndex:indexPath.row];
    [self save:a Curd:DELETE];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

@end
