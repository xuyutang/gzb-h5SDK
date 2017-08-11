//
//  LeaveManagerViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/9/30.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "LeaveManagerViewController.h"
#import "LeaveTypeBtn.h"
#import "LeaveApplyViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "AuditViewController.h"
#import "AppliedViewController.h"
#import "UIView+CNKit.h"

@interface LeaveManagerViewController ()

@end

@implementation LeaveManagerViewController {
    UIScrollView *_menuView;
    UIView *rightView;
    LeaveTypeBtn *btn;
    NSMutableArray *holidayCategories;
    NSMutableArray * menuTitles ;
    int index;
    BOOL valueBool;
    LeaveApplyViewController * approveVC ;

}


#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    valueBool = YES;
    
    holidayCategories= [[NSMutableArray alloc]init];
    holidayCategories =  [[LOCALMANAGER getHolidayCategories] retain];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    
    UIImageView *applyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 15, 25, 25)];
    [applyImageView setImage:[UIImage imageNamed:@"ab_icon_apply"]];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toApplyList:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    applyImageView.userInteractionEnabled = YES;
    applyImageView.contentMode = UIViewContentModeScaleAspectFit;
    [applyImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:applyImageView];
    [applyImageView release];
    
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_audi"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(examineList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.contentMode = UIViewContentModeScaleAspectFit;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = btRight;
    [btRight release];
    [lblFunctionName setText:TITLENAME(FUNC_HOLIDAY_DES)];

}

-(void)viewDidAppear:(BOOL)animated {
    holidayCategories =  [LOCALMANAGER getHolidayCategories];
    [btn removeFromSuperview];
    [self createLeaveTypeBtn];
}

#pragma mark 创建调休按钮
-(void) createLeaveTypeBtn {
    //调休类型
    menuTitles = [[NSMutableArray alloc]init];
    [holidayCategories enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [menuTitles addObject:((HolidayCategory*)obj).name];
    }];

    CGFloat menuViewW = MAINWIDTH ;
    CGFloat spacing   = 2;
    CGFloat menuW = (menuViewW - (spacing * 4)) / 3;
    CGFloat menuH = menuW;
    CGFloat menuViewH = menuH * 3 + 2 * spacing + 20;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    _menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, menuViewW, MAINHEIGHT)];
    if (menuTitles.count % 3 == 0) {
        _menuView.contentSize = CGSizeMake(MAINWIDTH, menuTitles.count/3 * (menuH + 2*spacing));
    }else {
        _menuView.contentSize = CGSizeMake(MAINWIDTH, menuTitles.count/3  * (menuH + 2*spacing) + menuH + spacing);
        
    }
    _menuView.backgroundColor = WT_WHITE;
    for(NSInteger i = 0 ; i < holidayCategories.count; i ++)
    {
        x = (i % 3) * (spacing + menuW);
        if(i > 0 && i % 3 == 0)
        {
            x = 0 ;
            y = y + menuH + spacing;
        }
        
       btn = [[LeaveTypeBtn alloc] initWithFrame:CGRectMake(x, y, menuW, menuH)];
        if (i == 2) {
            btn.width = menuW +spacing;
        }
       
        [btn.label setFrame:CGRectMake(0,0,50,50)];
        [btn.label setCenter:CGPointMake(menuW/2 + 5, menuW/2)];
        btn.label.font = [UIFont fontWithName:kFontAwesomeFamilyName size:35];
          btn.label.text = [NSString fontAwesomeIconStringForEnum:FACalendar];
        btn.label.textColor = WT_RED;
     
        [btn.titlelabel setFrame:CGRectMake(50,0,menuW - 10,65)];
        [btn.titlelabel setCenter:CGPointMake(menuW/2, menuW + 10)];
        btn.titlelabel.lineBreakMode = UILineBreakModeWordWrap;
        btn.titlelabel.numberOfLines = 0;
        btn.titlelabel.font = [UIFont systemFontOfSize:15];
        btn.titlelabel.text = menuTitles[i];
        
        [btn.titlelabel sizeToFit];
        btn.titlelabel.centerX = menuW/2 -5;
        btn.titlelabel.textAlignment = 1;
        btn.backgroundColor = [UIColor whiteColor];
        
        btn.tag = 1000 + i;
        
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"%@", NSStringFromCGRect(btn.frame));
        [_menuView addSubview:btn];
    
    }
    [self.view addSubview:_menuView];
}

#pragma mark调休类型按钮点击
-(void)menuClick:(UIButton*)sender {
    index = sender.tag - 1000;

    //进行网络请求，判断该用户是否有该调休类型
    [self checkHasHolidayType];

    approveVC = [[LeaveApplyViewController alloc]init];
       holidayCategories =  [LOCALMANAGER getHolidayCategories];
    approveVC.holidayCaregory = holidayCategories[sender.tag - 1000];
    approveVC.titleString = menuTitles[sender.tag -1000];
   
}

#pragma mark 是否拥有该调休类型
-(void)checkHasHolidayType {
   
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
   
    HolidayCategory_Builder *pb = [HolidayCategory builder];
     holidayCategories =  [LOCALMANAGER getHolidayCategories] ;
    [pb setName:((HolidayCategory*)holidayCategories[index]).name];
    [pb setId:((HolidayCategory*)holidayCategories[index]).id];
       
    if (DONE != [AGENT sendRequestWithType:ActionTypeIsExistHolidayCategoryFlow param:[pb build]]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"leave_mangerment", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }

}

-(void)didReceiveMessage:(id)message {
     SessionResponse* cr = [SessionResponse parseFromData:message];
 
    if ([super validateResponse:cr]) {
        return;
    }
    valueBool = [cr.value boolValue];
    
    if (valueBool) {
       approveVC.hasProcessBool = YES;
         [self.navigationController pushViewController:approveVC animated:YES];
    }else {
        //没有假休管理时，自己选择审批人；
        approveVC.hasProcessBool = NO;
         [self.navigationController pushViewController:approveVC animated:YES];
//        [MESSAGE showMessageWithTitle:NSLocalizedString(@"leave_mangerment", @"")
//                          description:NSLocalizedString(@"leave_noexist_text", @"")
//                                 type:MessageBarMessageTypeError
//                          forDuration:ERR_MSG_DURATION];
//        return;
    }
    
}

#pragma mark 去往申请列表
-(void)toApplyList:(id)sender {
    NSLog(@"去往申请列表");
    AppliedViewController *apply = [[AppliedViewController alloc]init];
    [self.navigationController pushViewController:apply animated:YES];
    
}

#pragma mark 去往审核列表
-(void)examineList:(id)sender {
 NSLog(@"去往审核列表");
    AuditViewController *audi = [[AuditViewController alloc]init];
    [self.navigationController pushViewController:audi animated:YES];
}

#pragma mark didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
