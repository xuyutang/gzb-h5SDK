//
//  TaskManageViewController.m
//  SalesManager
//
//  Created by ZhangLi on 14-1-14.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "TaskManageViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "Constant.h"
#import "SearchViewController.h"
#import "TaskViewController.h"

@interface TaskManageViewController ()<SearchDelegate>

@end

@implementation TaskManageViewController

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

    [lblFunctionName setText:NSLocalizedString(@"bar_task_list", @"")];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 50, 30)];
    [searchImageView setImage:[UIImage imageNamed:@"topbar_button_search"]];
    searchImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSearch)];
    [tapGesture1 setNumberOfTapsRequired:1];
    searchImageView.contentMode = UIViewContentModeScaleAspectFit;
    [searchImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:searchImageView];
    [searchImageView release];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 15, 50, 30)];
    [saveImageView setImage:[UIImage imageNamed:@"topbar_button_add"]];
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAdd)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = btRight;
    [btRight release];
    
    myTaskCtrl = [[TaskListViewController alloc] init];
    myTaskCtrl.myTask = YES;
    CGRect frame = myTaskCtrl.view.frame;
    [myTaskCtrl.view setFrame:CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,MAINHEIGHT)];
    CGRect tableFrame = myTaskCtrl.tableView.frame;
    [myTaskCtrl.tableView setFrame:tableFrame];
    
    otherTaskCtrl = [[TaskListViewController alloc] init];
    otherTaskCtrl.myTask = NO;
    frame = otherTaskCtrl.view.frame;
    [otherTaskCtrl.view setFrame:CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,MAINHEIGHT)];
    tableFrame = otherTaskCtrl.tableView.frame;
    [otherTaskCtrl.tableView setFrame:tableFrame];
    [self.view addSubview:myTaskCtrl.view];
    [self.view addSubview:otherTaskCtrl.view];
    otherTaskCtrl.view.hidden = YES;
    
    taskSegmentCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:@[NSLocalizedString(@"task_mine", nil), NSLocalizedString(@"task_receive", nil)]];
    
    [taskSegmentCtrl setFrame:CGRectMake(0, MAINHEIGHT - 44, 320, 44)];
    [taskSegmentCtrl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
    taskSegmentCtrl.selectionIndicatorMode = HMSelectionIndicatorFillsSegment;
    taskSegmentCtrl.textColor = [UIColor whiteColor];
    taskSegmentCtrl.selectionIndicatorColor = [UIColor colorWithRed:244 green:235 blue:0 alpha:0.8];
    [taskSegmentCtrl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:taskSegmentCtrl];
}

-(void)toSearch{
    SearchViewController *ctrl = [[SearchViewController alloc] init];
    ctrl.delegate = self;
    UINavigationController *searchNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentModalViewController:searchNavCtrl animated:YES];
}

-(void)toAdd{
    TaskViewController* ctrl = [[TaskViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)didFinishedSearchWithResult:(NSObject *)result{
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    switch (taskSegmentCtrl.selectedIndex) {//[sender selectedSegmentIndex]
        case 0:{
            [myTaskCtrl reload];
        }
            break;
        case 1:{
            [otherTaskCtrl reload];
        }
            break;
    }
}

-(void)segmentAction:(id)sender{
    switch (taskSegmentCtrl.selectedIndex) {//[sender selectedSegmentIndex]
        case 0:{
            myTaskCtrl.view.hidden = NO;       //显示controller1
            otherTaskCtrl.view.hidden = YES;
            [myTaskCtrl reload];
        }
            break;
        case 1:{
            otherTaskCtrl.view.hidden = NO;       //显示controller1
            myTaskCtrl.view.hidden = YES;
            [otherTaskCtrl reload];
        }
            break;
            
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
