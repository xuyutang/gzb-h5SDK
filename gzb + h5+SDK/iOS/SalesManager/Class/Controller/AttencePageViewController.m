//
//  AttencePageViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/11/13.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "AttencePageViewController.h"
#import "DAPagesContainer.h"
#import "AttendanceViewController.h"
#import "Constant.h"
#import "WifiAttenceViewController.h"
#import "UIView+CNKit.h"
#import "AttendanceListViewViewController.h"
#import "WifiAttendanceListViewController.h"
#import "AddWifiViewController.h"
#import "Constant.h"
#import "WifiListViewController.h"

@interface AttencePageViewController ()<DAPagesContainerDelegate>{
    AttendanceViewController *spaceViewController1;
    WifiAttenceViewController *spaceViewController2;
}
@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation AttencePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_search"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    
    [listImageView release];
    
    UIImageView *reFreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [reFreshImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
 
    reFreshImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_refresh:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    reFreshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [reFreshImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:reFreshImageView];
    [reFreshImageView release];
    [tapGesture2 release];                                                                                                                                                                                                                                                                                                  
    
    _addWifiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 25, 25)];
    [_addWifiImageView setImage:[UIImage imageNamed:@"ab_icon_wifi"]];
    
    _addWifiImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addWifi:)];
    [tapGesture3 setNumberOfTapsRequired:1];
    _addWifiImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_addWifiImageView addGestureRecognizer:tapGesture3];
    [rightView addSubview:_addWifiImageView];
    [_addWifiImageView release];
    [tapGesture3 release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_ATTENDANCE_DES)];
    
    
    spaceViewController1 = [[AttendanceViewController alloc] init];
    
    if (_parentController != nil) {
        spaceViewController1.parentCtrl = self.parentController;
    }else{
        spaceViewController1.parentCtrl = self;
    }
    
    spaceViewController2 = [[WifiAttenceViewController alloc] init];
    if (_parentController != nil) {
        spaceViewController2.parentCtrl = self.parentController;
    }else{
        spaceViewController2.parentCtrl = self;
    }
    spaceViewController1.title = NSLocalizedString(@"sign_attendance", @"");
    spaceViewController2.title = NSLocalizedString(@"chenk_in_attendance", @"");
    attendanceTypeMularray = [[NSMutableArray alloc]init];
    checkInChannelMularray = [[NSMutableArray alloc]init];
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, MAINWIDTH, MAINHEIGHT + 40);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];

    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;
    
    contrlArray =[[NSMutableArray alloc] initWithCapacity:2];
    [self getAttenceType];
    
    appDelegate = APPDELEGATE;
    //类型同步
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshCatogry) name:@"syncAttendanceCatogry" object:nil];
    
    
}

-(void)reFreshCatogry {
    if(self.pagesContainer != nil){
        
        [self.pagesContainer.view removeFromSuperview];
        [self.pagesContainer release];
    }
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;
    [contrlArray removeAllObjects];
    [self getAttenceType];


}

#pragma mark 获取考勤类型
-(void)getAttenceType {
    attendanceTypeMularray = [[LOCALMANAGER getAttendanceTypes] retain];
    checkInChannelMularray = [LOCALMANAGER getCheckInChannels];
  
    // 获取考勤类型
    //ATTENDANCE
    //CHECK_IN
    //ATTENDANCE/CHECK_IN
    if (attendanceTypeMularray.count == 0) {
        return;
    }
    if (attendanceTypeMularray.count == 2) {
        [contrlArray addObject:spaceViewController1];
        [contrlArray addObject:spaceViewController2];
      }else {
        if ([((AttendanceType*)[attendanceTypeMularray firstObject]).value isEqualToString:@"ATTENDANCE"]) {
            [contrlArray addObject:spaceViewController1];
            self.pagesContainer.topBarHeight = 0;
            self.pagesContainer.scrollView.y = 0;
        }
        
        if ([((AttendanceType*)[attendanceTypeMularray firstObject]).value isEqualToString:@"CHECK_IN"]) {
            [contrlArray addObject:spaceViewController2];
            self.pagesContainer.topBarHeight = 0;
            self.pagesContainer.scrollView.y = 0;
        }
        
    }
    self.pagesContainer.viewControllers = contrlArray;
    [self addChildViewController:self.pagesContainer];
    [self.pagesContainer setSelectedIndex:_selectItem animated:YES];
}

- (void) didSelected:(int) index {
     _selectItem = index;
    if (attendanceTypeMularray.count == 2) {
        if (index == 0) {
            _addWifiImageView.hidden = YES;
        }else {
            _addWifiImageView.hidden = NO;
            
        }
    }else {
        if ([((AttendanceType*)[attendanceTypeMularray firstObject]).value isEqualToString:@"ATTENDANCE"]) {
            _addWifiImageView.hidden = YES;
        }else {
           _addWifiImageView.hidden = NO;
        
        }
    }
}

-(void)toList:(id)sender {
    if (attendanceTypeMularray.count == 2) {
        if (_selectItem == 0 ) {
            AttendanceListViewViewController *attenceListVC = [[AttendanceListViewViewController alloc]init];
            [self.navigationController pushViewController:attenceListVC animated:YES];
            
        } else {
            //WiFi考勤列表
            WifiAttendanceListViewController *wifiListVC = [[WifiAttendanceListViewController alloc] init];
            [self.navigationController pushViewController:wifiListVC animated:YES];
            
        }

    }else {
        if ([((AttendanceType*)[attendanceTypeMularray firstObject]).value isEqualToString:@"ATTENDANCE"]) {
            AttendanceListViewViewController *attenceListVC = [[AttendanceListViewViewController alloc]init];
            [self.navigationController pushViewController:attenceListVC animated:YES];

        }else {
            //WiFi考勤列表
            WifiAttendanceListViewController *wifiListVC = [[WifiAttendanceListViewController alloc] init];
            [self.navigationController pushViewController:wifiListVC animated:YES];
        
        }
    
    
    }
}

#pragma mark 添加wifi
-(void)addWifi:(id)sender {
    NSLog(@"Wifi列表");
    WifiListViewController *addWifiVC = [[WifiListViewController alloc]init];
    [self.navigationController pushViewController:addWifiVC animated:YES];
}

-(void)_refresh:(id)sender {
    if (attendanceTypeMularray.count == 2) {
        if (_selectItem == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAttenceCatogory" object:nil];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_daywork" object:nil];
            
        }

    }else {
        if ([((AttendanceType*)[attendanceTypeMularray firstObject]).value isEqualToString:@"ATTENDANCE"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAttenceCatogory" object:nil];
        }else {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_daywork" object:nil];
        
        }
    
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
