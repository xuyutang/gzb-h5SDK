//
//  DashboardViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-4-22.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "DashboardViewController.h"
#import "NAMenuView.h"
#import "MainTopView.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "DashboardTableHeader.h"
#import "DBMessageCell.h"
#import "SDImageView+SDWebCache.h"
#import "NSDate+Util.h"
#import "UploadListViewController.h"
#import "PushOrderMsg.h"
#import "MJExtension.h"
#import "PaperViewController.h"
#import "CompanySpacePageViewController.h"
#import "UIColor+hex.h"

@interface DashboardViewController (){
    
    MainTopView *top1;
    MainTopView *top2;
    UIImageView *toptop;
    UILabel *lblGrayline;
    UIView *topView;
    NAMenuView *menuView;
    NSMutableArray *functionItems;
    int lastPosition;
    BOOL bTopSwitch;
    UIView *rightView;
    
    NSMutableArray* messages;
    NSMutableArray* announces;
    NSMutableArray* users;
    
    NAMenuItem *spaceItem;
}

@end

@implementation DashboardViewController

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(syncFunction)
                                                 name:@"sync_function_menu"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_NOTIFICATION object:nil];
    //首次登陆跳转同步界面,方便同步界面返回到主界面
    if (self.bToSyncUI) {
        
        [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_SYNC Object:nil Delegate:nil NeedBack:YES];
        
        self.bToSyncUI = NO;
    }
}

-(void)syncFunction {
    [self createMenuItems];
}

-(void)initUI{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        //self.view.window.frame = CGRectMake(0, 20, self.view.window.frame.size.width, self.view.window.frame.size.height - 20);
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        //[self setNeedsStatusBarAppearanceUpdate];
    });
   
    
    self.navigationController.navigationBar.clipsToBounds = YES;    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 1)];
    label.backgroundColor = WT_RED;
    [self.view addSubview:label];
    [self.leftView setHidden:NO];
    leftImageView.hidden = YES;
    
    self.title = @"";
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    //右上角设置
    UIImageView *freshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [freshImageView setImage:[UIImage imageNamed:@"ic_setting"]];
       //[freshImageView setImage:[UIImage imageNamed:@"ic_conf"]];
    freshImageView.userInteractionEnabled = YES;
    //UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMessage)];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toConfig)];
    [tapGesture2 setNumberOfTapsRequired:1];
    freshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [freshImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:freshImageView];
    
       //[rightView.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [self setRightButton:btRight];
    [tapGesture2 release];
    [freshImageView release];
    [btRight release];
    [rightView release];
    [self initMenu];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect frame = _tableView.frame;
    [_tableView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, MAINHEIGHT-50)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initMenu)
                                                 name:SYNC_NOTIFICATION_MENU object:nil];
}

-(void)tapView{

}

#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

-(void) loadMessage{
    users = [[LOCALMANAGER getUsersByMessage] retain];
    Announce* a = ([LOCALMANAGER getUnReadAnnouncesCount] > 0) ? [LOCALMANAGER getLastestUnReadAnnounce] : [LOCALMANAGER getLastestAnnounce];
    if (a != nil)
        [users insertObject:a atIndex:0];
    int cacheCount = [LOCALMANAGER getCacheCount];
    if (cacheCount > 0) {
        NSString* cache = [NSString stringWithFormat:@"%d",cacheCount];
        [users insertObject:cache atIndex:0];
    }
}

-(void)initMenu{
    if (top1 != nil) {
        [top1 removeFromSuperview];
        [top1 release];
        top1 = nil;
    }
    if (top2 != nil) {
        [top2 removeFromSuperview];
        [top2 release];
        top2 = nil;
    }
    if (topView != nil) {
        [topView removeFromSuperview];
        [topView release];
        topView = nil;
    }
    topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 90)];
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainTopView"
                                                   owner:nil
                                                 options:nil];
    
    
    top1 = [(MainTopView *)[array objectAtIndex:0] retain];
    [top1 setFrame:CGRectMake(0, 0, MAINWIDTH, 90)];
    NSString* cAvtar = @"";
    if (USER.company.filePath > 0) {
        cAvtar = [USER.company.filePath objectAtIndex:0];
        //保存企业logo
        //if (!cAvtar.isEmpty) {
            //NSData* data = [NSData dataWithContentsOfURL:[[NSURL alloc] initWithString:cAvtar]];
            //[LOCALMANAGER updateCompanyWithAvatar:data];
        //}
    }
    [top1.icon setImageWithURL:[NSURL URLWithString:cAvtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_company_avatar"]];
    
    
    
//    UITapGestureRecognizer *iconCompanyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTapped:)];
//    [top1.icon addGestureRecognizer:iconCompanyTap];//点击图片事件
//    top1.icon.userInteractionEnabled = YES;
//    NSLog(@"haha");
    
    
    top1.title.text = USER.company.name;
    top1.title.frame = CGRectMake(8, 0, 213, 54);
    ;
    top1.title.numberOfLines = 0;
    top1.title.lineBreakMode = NSLineBreakByTruncatingTail;

    top1.title.font = [UIFont systemFontOfSize:15.0f];
       top1.subTitle.text = USER.company.idea.isEmpty ? NSLocalizedString(@"company_idea_default", @"") : USER.company.idea;
    top1.subTitle.frame = CGRectMake(8, 50, 213, 25);
    top1.subTitle.font = [UIFont systemFontOfSize:13.0f];
    top1.infoView.backgroundColor = WT_BLUE;
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [top1.layer addAnimation:animation forKey:@"animation"];
    
    NSArray *array2 = [[NSBundle mainBundle] loadNibNamed:@"MainTopView"
                                                    owner:nil
                                                  options:nil];
    
    top2 = [(MainTopView *)[array2 objectAtIndex:0] retain];
    [top2 setFrame:CGRectMake(0, 0, MAINWIDTH, 90)];
    [top2.layer addAnimation:animation forKey:@"animation"];
    //获取用户头像
//    NSString* avtar = @"";
//    if (USER.avatars.count > 0) {
//        avtar = [USER.avatars objectAtIndex:0];
//    }
//    [top2.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
    top2.title.text = [NSString stringWithFormat:NSLocalizedString(@"dashboard_user_info", ""),USER.realName,USER.userName];
    top2.subTitle.text = [NSString stringWithFormat:@"部门：%@",USER.department.name];
    top2.subTitle2.text = [NSString stringWithFormat:@"职位：%@",USER.position.name];
     top2.title.font = [UIFont systemFontOfSize:15.0f];
     top2.subTitle.font = [UIFont systemFontOfSize:13.0f];
     top2.subTitle2.font = [UIFont systemFontOfSize:13.0f];
//    top2.subTitle.text = [NSString stringWithFormat:NSLocalizedString(@"dashboard_user_depart_job", ""),USER.department.name,USER.position.name];
//    
    top2.infoView.backgroundColor = RGBA(129, 208, 0, 1.0);
    [topView addSubview:top1];
    bTopSwitch = NO;
    UITapGestureRecognizer *oneTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)] autorelease];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    [topView addGestureRecognizer:oneTap];
    
    lblFunctionName.text = APPTITLE;
    lblFunctionName.textAlignment = NSTextAlignmentCenter;
    [self createMenuItems];
    
    if (menuView != nil) {
        [menuView removeFromSuperview];
        [menuView release];
        menuView = nil;
    }
    
    toptop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 91,89)];
    [toptop setImageWithURL:[NSURL URLWithString:cAvtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_company_avatar"]];
    UITapGestureRecognizer *iconCompanyTapTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTapped:)];
    [toptop addGestureRecognizer:iconCompanyTapTop];//点击图片事件
    toptop.userInteractionEnabled = YES;
    
    lblGrayline = [[UILabel alloc] initWithFrame:CGRectMake(0, 89, MAINWIDTH, 1)];
    lblGrayline.backgroundColor = RGBA(170, 170, 170, 1.0);

    int scrollViewHeight = (functionItems.count/3+1)*110;
    menuView = [[NAMenuView alloc] init];
    [menuView setFrame:CGRectMake(0, -20, MAINWIDTH, scrollViewHeight)];
    [menuView setBackgroundColor:[UIColor clearColor]];
    menuView.delegate = self;
    menuView.menuDelegate = self;
    menuView.showsVerticalScrollIndicator = NO;
    menuView.scrollEnabled = NO;
   // menuView.itemSize = CGSizeMake(100, 50);
//    @property (nonatomic) NSUInteger columnCountPortrait; // default is 3
//    @property (nonatomic) NSUInteger columnCountLandscape; // default is 4
//    @property (nonatomic) CGSize itemSize; // default is 100x100.
    [self loadMessage];
    [_tableView reloadData];
}

- (void)iconTapped:(id)sender{
    NAMenuItem *item = spaceItem;
    [APPDELEGATE.leftSideDrawerViewController selectCell:item.functionId];
    BaseViewController *viewController = (BaseViewController *)[spaceItem viewCtrl];
    [APPDELEGATE.drawerController setCenterViewController:viewController withCloseAnimation:YES completion:nil];
    [self.parentController.navigationController pushViewController:APPDELEGATE.drawerController animated:YES];
    
    
//    NSLog(@"hhe");
//    self.hidesBottomBarWhenPushed=YES;
//    CompanySpacePageViewController *compSpaceVC = [[CompanySpacePageViewController alloc] init];
//    compSpaceVC.bNeedBack = YES;
//    [self.parentController.navigationController pushViewController:compSpaceVC animated:YES];
//    [compSpaceVC release];
//    self.hidesBottomBarWhenPushed=NO;

    
//    [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_SPACE Object:nil Delegate:nil NeedBack:YES];
}

- (void)toConfig {
    [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_SETTING Object:nil Delegate:nil NeedBack:YES];
}

- (void)createMenuItems {
    if (functionItems.count > 0){
        [functionItems removeAllObjects];
        [functionItems release];
        functionItems = nil;
    }
    functionItems = [[NSMutableArray alloc] initWithCapacity:11];
    NSMutableArray* userFunc = [LOCALMANAGER getFavFunctions];
    
    for (Function* f in userFunc) {
        
        //通讯录合并 单独处理
//        if ([FUNC_COMPANY_CONTACT_DES isEqual: f.value]){
//            NAMenuItem *item9 = [[NAMenuItem alloc] initWithTitle:f.name
//                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_CONTACT]
//                                                        iconColor:WT_RED
//                                                   viewController:(APPDELEGATE).companyContactNavCtrl];//
//            item9.functionId = FUNC_COMPANY_CONTACT;
//            [functionItems addObject:item9];
//            
//        }
//        if ([f.value isEqual: FUNC_CUSTOMER_CONTACT_DES]){
//            NAMenuItem *item10 = [[NAMenuItem alloc] initWithTitle:f.name
//                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_CUSTOMER_CONTACT]iconColor:WT_RED
//                                                    viewController:(APPDELEGATE).endContactNavCtrl];//
//            item10.functionId = FUNC_CUSTOMER_CONTACT;
//            [functionItems addObject:item10];
//        }
        
        if ([f.value isEqual: FUNC_ATTENDANCE_DES]){
            
            NAMenuItem *item1 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_ATTENDANCE] iconColor:WT_RED
                                                   viewController:(APPDELEGATE).attendanceNavCtrl];//
            item1.functionId  = FUNC_ATTENDANCE;
            [functionItems addObject:item1];
            
        }
    
        
        if ([f.value isEqual: FUNC_PATROL_DES]){
            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_PATROL]
                                                            iconColor:WT_RED
                                                   viewController:(APPDELEGATE).patrolNavCtrl];//
            item2.functionId = FUNC_PATROL;
            [functionItems addObject:item2];
        }
    
        
        if ([f.value isEqual: FUNC_PATROL_TASK_DES]){
            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL]
                                                        iconColor:WT_RED
                                                   viewController:(APPDELEGATE).patrolTaskNavCtrl];//
            item2.functionId = FUNC_PATROL_TASK;
            [functionItems addObject:item2];
        }
    
        
        if ([f.value isEqual: FUNC_INSPECTION_DES]){
            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_INPECTION]
                                                        iconColor:WT_RED
                                                   viewController:(APPDELEGATE).inspectionNavCtrl];//
            item2.functionId = FUNC_INSPECTION;
            [functionItems addObject:item2];
        }
    
        if ([f.value isEqual: FUNC_PAPER_POST_DES]){
            if ([LOCALMANAGER getFavPaperTempate] == nil) {
                NAMenuItem *item22 = [[NAMenuItem alloc] initWithTitle:f.name
                                                              iconFile:[NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD]
                                                             iconColor:WT_RED
                                                        viewController:(APPDELEGATE).paperNavCtrl];//
                item22.functionId = FUNC_PAPER_POST;
                [functionItems addObject:item22];


            }else {
                NAMenuItem *item22 = [[NAMenuItem alloc] initWithTitle:f.name
                                                              iconFile:[NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD]
                                                             iconColor:WT_RED
                                                        viewController:(APPDELEGATE).dataReportNavCtrl];//
                              
                item22.functionId = FUNC_PAPER_POST;
                [functionItems addObject:item22];
            }
            
        
        }
        if ([f.value isEqual: FUNC_HOLIDAY_DES]) {
            NAMenuItem *item23 = [[NAMenuItem alloc] initWithTitle:f.name
                                                          iconFile:[NSString fontAwesomeIconStringForEnum:FAPlane]
                                                         iconColor:WT_RED
                                                    viewController:(APPDELEGATE).LeaveNavCtrl];//
            item23.functionId = FUNC_PAPER_POST;
            [functionItems addObject:item23];

        }
        
        if ([f.value isEqual: FUNC_WORKLOG_DES]){
            NAMenuItem *item5 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_WORKLOG]
                                                        iconColor:WT_RED
                                                   viewController:(APPDELEGATE).worklogNavCtrl];//
            item5.functionId = FUNC_WORKLOG;
            [functionItems addObject:item5];
        }
    
        
        if ([f.value isEqual: FUNC_RESEARSH_DES]){
            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_MARKET_RESEARCH]
                                                            iconColor:WT_RED
                                                   viewController:(APPDELEGATE).researchNavCtrl];//
            item2.functionId = FUNC_RESEARSH;
            [functionItems addObject:item2];
        }
    
        
        if ([f.value isEqual: FUNC_BIZOPP_DES]){
            NAMenuItem *item2 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_BUSSINESS_OPPORTUNITY]
                                                            iconColor:WT_RED
                                                   viewController:(APPDELEGATE).bizOppNavCtrl];//
            item2.functionId = FUNC_BIZOPP;
            [functionItems addObject:item2];
        }
    
        
        if ([f.value isEqual: FUNC_COMPETITION_DES]){
            NAMenuItem *item5 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_COMPETITION]
                                                            iconColor:WT_RED
                                                   viewController:(APPDELEGATE).competitionNavCtrl];//
            item5.functionId = FUNC_COMPETITION;
            [functionItems addObject:item5];
        }
    
        if ([f.value isEqual: FUNC_SELL_TODAY_DES]){
            
            NAMenuItem *item7 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_SELL_TODAY]
                                                    iconColor:WT_RED
                                                   viewController:(APPDELEGATE).saleNavCtrl];//
            item7.functionId = FUNC_SELL_TODAY;
            [functionItems addObject:item7];
        }
    
        if ([f.value isEqual:FUNC_SELL_ORDER_DES]){
            
            NAMenuItem *item6 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_SELL_ORDER]
                                                    iconColor:WT_RED
                                                   viewController:(APPDELEGATE).orderNavCtrl];//
            item6.functionId = FUNC_SELL_ORDER;
            [functionItems addObject:item6];
        }
   
        
        if ([f.value isEqual:FUNC_SELL_STOCK_DES]){
            NAMenuItem *item3 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_SELL_STOCK]
                                                    iconColor:WT_RED
                                                   viewController:(APPDELEGATE).stockNavCtrl];//
            item3.functionId = FUNC_SELL_STOCK;
            [functionItems addObject:item3];
        }
    
        
        if ([f.value isEqual:FUNC_SELL_REPORT_DES]){
            NAMenuItem *item4 = [[NAMenuItem alloc] initWithTitle:f.name
                                                         iconFile:[NSString fontAwesomeIconStringForEnum:ICON_SELL_ORDER]
                                                    iconColor:WT_RED
                                                   viewController:(APPDELEGATE).salestatisticsNavCtrl];//
            item4.functionId = FUNC_SELL_REPORT;
            [functionItems addObject:item4];
            
        }
        
        if ([f.value isEqual:FUNC_APPROVE_DES]){
            NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:f.name
                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_APPROVE]
                                                        iconColor:WT_RED
                                                    viewController:(APPDELEGATE).applyNavCtrl];//
            item12.functionId = FUNC_APPROVE;
            [functionItems addObject:item12];
        }
    
        
        if ([f.value isEqual:FUNC_GIFT_DES]){
            NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:f.name
                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]
                                                    iconColor:WT_RED
                                                    viewController:(APPDELEGATE).giftNavCtrl];//
            item12.functionId = FUNC_GIFT;
            [functionItems addObject:item12];
        }
    
        
        if ([f.value isEqual:FUNC_MESSAGE_DES]){
            NAMenuItem *item10 = [[NAMenuItem alloc] initWithTitle:f.name
                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_MESSAGE]
                                                    iconColor:WT_RED
                                                    viewController:(APPDELEGATE).myMessageNavCtrl];//
            item10.functionId = FUNC_MESSAGE;
            [functionItems addObject:item10];
        }
        if ([f.value isEqual:FUNC_FAVORATE_DES]){
            NAMenuItem *item11 = [[NAMenuItem alloc] initWithTitle:f.name
                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_FAV]
                                                    iconColor:WT_RED
                                                    viewController:(APPDELEGATE).myfavorateNavCtrl];//
            item11.functionId = FUNC_FAVORATE;
            [functionItems addObject:item11];
        }
        if ([f.value isEqual:FUNC_SYNC_DES]){
            NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:f.name
                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_DATA_SYNC]
                                                        iconColor:WT_RED
                                                    viewController:(APPDELEGATE).datasyncNavCtrl];//
            item12.functionId = FUNC_SYNC;
            [functionItems addObject:item12];
        }
        if ([f.value isEqual:FUNC_SPACE_DES]){
            NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:f.name
                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_COMPANY_SPACE]
                                                         iconColor:WT_RED
                                                    viewController:(APPDELEGATE).spaceNavCtrl];//
            item12.functionId = FUNC_SPACE;
            [functionItems addObject:item12];
            
            spaceItem = item12;
        }
        
        if ([f.value isEqual:FUNC_ALARM_DES]){
            NAMenuItem *item12 = [[NAMenuItem alloc] initWithTitle:f.name
                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_ALARM]
                                                         iconColor:WT_RED
                                                    viewController:nil];//
            item12.functionId = FUNC_ALARM;
            [functionItems addObject:item12];
        }
        if ([f.value isEqual:FUNC_VIDEO_DES]){
            NAMenuItem *item = [[NAMenuItem alloc] initWithTitle:f.name
                                                          iconFile:[NSString fontAwesomeIconStringForEnum:ICON_VIDEO]
                                                         iconColor:WT_RED
                                                    viewController:(APPDELEGATE).videoNavCtrl];
            item.functionId = FUNC_VIDEO;
            [functionItems addObject:item];
            
        }
    }
    
    
    
    NAMenuItem *item13 = [[NAMenuItem alloc] initWithTitle:@""
                                                  iconFile:[NSString fontAwesomeIconStringForEnum:ICON_EDIT]
                                            iconColor:[UIColor colorWithWhite:0.5 alpha:0.2]
                                            viewController:nil];//
    item13.functionId = FUNC_EDIT;
    [functionItems addObject:item13];
    
    //通讯录合并
    int index = [self hasContactFunc];
    if (index > 0) {
        NAMenuItem *item = [[NAMenuItem alloc] initWithTitle:NSLocalizedString(@"contacts", nil)
                                                    iconFile:[NSString fontAwesomeIconStringForEnum:ICON_CONTACT]
                                                   iconColor:WT_RED
                                              viewController:(APPDELEGATE).contactsPageNavCtrl];//
        item.functionId = FUNC_CONTACT;
        [functionItems insertObject:item atIndex:index];
    }
    return;
}

-(void)toMessage{
    [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_ANNOUNCE_LIST Object:nil Delegate:nil NeedBack:YES];
    //[_tableView setContentOffset:CGPointMake(0.0, topView.frame.size.height+menuView.frame.size.height) animated:YES];
    //[rightView setHidden:YES];
    
    //[self setInfoViewFrame:YES];
}

-(void)closeTest{
   // [self setInfoViewFrame:NO];
}

/*
- (void)setInfoViewFrame:(BOOL)isDown{
    if(isDown == NO)
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             [testView setFrame:CGRectMake(0, MAINHEIGHT+430, MAINWIDTH, 430)];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationCurveEaseIn
                                              animations:^{
                                                  [testView setFrame:CGRectMake(0, MAINHEIGHT, MAINWIDTH, 430)];
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
        
    }else
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:0
                         animations:^{
                             [testView setFrame:CGRectMake(0, MAINHEIGHT-430+16, MAINWIDTH, 430)];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                                   delay:0.0
                                                 options:UIViewAnimationCurveEaseIn
                                              animations:^{
                                                  [testView setFrame:CGRectMake(0, MAINHEIGHT-430, MAINWIDTH, 430)];
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
    }
}

*/

#pragma mark - NAMenuViewDelegate Methods

- (NSUInteger)menuViewNumberOfItems:(id)menuView {
    return functionItems.count;
}

- (NAMenuItem *)menuView:(NAMenuView *)menuView itemForIndex:(NSUInteger)index {
    return [functionItems objectAtIndex:index];
}

- (void)menuView:(NAMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index {
    
    if (AGENT.bUserIdChanged) {
        [super showMessage:ActionCodeErrorAccountException Title:NSLocalizedString(@"error_operation", @"") Description:@""];
        return;
    }
    NAMenuItem *item = [functionItems objectAtIndex:index];
    
    [APPDELEGATE.leftSideDrawerViewController selectCell:item.functionId];
    BaseViewController *viewController = (BaseViewController *)[[functionItems objectAtIndex:index] viewCtrl];

    if (item.functionId == FUNC_EDIT) {
        [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_EDIT Object:nil Delegate:nil NeedBack:NO];
    }else if (item.functionId == FUNC_ALARM) {
        [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_ALARM Object:nil Delegate:nil NeedBack:NO];
    }else{
        [APPDELEGATE.drawerController setCenterViewController:viewController withCloseAnimation:YES completion:nil];
        [self.parentController.navigationController pushViewController:APPDELEGATE.drawerController animated:YES];
        if (item.functionId == FUNC_ATTENDANCE) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshChenkInshit" object:nil];   
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    //NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]) {
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.7;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        if (bTopSwitch) {
            [top2 removeFromSuperview];
            [top1.layer addAnimation:animation forKey:@"animation"];
            [topView addSubview:top1];
            
        }else{
            [top1 removeFromSuperview];
            [top2.layer addAnimation:animation forKey:@"animation"];
            [topView addSubview:top2];
        }
        bTopSwitch = !bTopSwitch;

        return NO;
    }
    return  YES;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }
    
    return users.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 90;
    }else if (indexPath.section==1) {
        return menuView.frame.size.height;
    }
    return 85.0f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 0;
    }
    return 30.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"DashboardTableHeader" owner:self options:nil];
    DashboardTableHeader *header = [nibViews objectAtIndex:0];
    //[header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
    header.title.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
    [header.title setTextColor:WT_RED];
    [header.title setText:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:ICON_MESSAGE],@"消息通知"]];
    header.subTitle.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
    [header.subTitle setTextColor:[UIColor blackColor]];
    [header.subTitle setText:[NSString fontAwesomeIconStringForEnum:ICON_GO]];
    UITapGestureRecognizer *tapSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMessage)];
    [tapSectionGesture setNumberOfTapsRequired:1];
    header.userInteractionEnabled = YES;
    [header addGestureRecognizer:tapSectionGesture];
    tapSectionGesture.view.tag = section;
    if (!users.count) {
        header.hidden = YES;
    }
    return header;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        }
    }
    if (indexPath.section == 2) {
        if ([[users objectAtIndex:indexPath.row] isKindOfClass:[Announce class]]) {
            [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_ANNOUNCE_LIST Object:nil Delegate:nil NeedBack:YES];
        }
        if ([[users objectAtIndex:indexPath.row] isKindOfClass:[User class]]) {
            
            User* u = [users objectAtIndex:indexPath.row];
            [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_MESSAGE_LIST Object:u Delegate:nil NeedBack:YES];
        }
        if ([[users objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
            //[VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_VIDEO Object:nil Delegate:nil NeedBack:YES];
            UploadListViewController *uploadListVC = [[UploadListViewController alloc] init];
            uploadListVC.bNeedBack = YES;
            [self.parentController.navigationController pushViewController:uploadListVC animated:YES];
            [uploadListVC release];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {

            cell=[tableView dequeueReusableCellWithIdentifier:@"cell00"];
            if(cell==nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell00"];
            }
            [cell addSubview:topView];
            [cell addSubview:toptop];
        [cell addSubview:lblGrayline];
    }else if(indexPath.section == 1){
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell01"];
        if(cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell01"];
        }
        [cell addSubview:menuView];
    } else {
        DBMessageCell *msgCell = (DBMessageCell *)[tableView dequeueReusableCellWithIdentifier:@"DBMessageCell"];
        if (!msgCell) {
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            //图片形式按钮
            //[rightUtilityButtons addUtilityButtonWithColor:WT_RED icon:[UIImage imageNamed:@"ic_delete_grey"]];
            [rightUtilityButtons addUtilityButtonWithColor:WT_RED title:NSLocalizedString(@"cell_delete", nil)];
            msgCell = [[DBMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DBMessageCell" containingTableView:tableView rowHeight:85 leftUtilityButtons:nil rightUtilityButtons:rightUtilityButtons];
        }
        
        
        NSString* avtar = @"";
        int count = 0;
        User* u = nil;
        NSString* title = @"";
        NSString* subTitle = @"";
        NSString* createDate = @"";
        //企业公告
        if ([[users objectAtIndex:indexPath.row] isKindOfClass:[Announce class]]) {
            u = USER;
            if (USER.company.filePath.count > 0){
               // avtar = [USER.company.filePath objectAtIndex:0];
            }
            count = [LOCALMANAGER getUnReadAnnouncesCount];
            
           // NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
           // NSString *realName = [ user objectForKey:@"announceRealName"];
            
//            User *sender = [[LOCALMANAGER getAnnouncesenders] objectAtIndex:[LOCALMANAGER getAnnouncesenders].count - 1 - indexPath.row];
//            title = sender.realName;
//            
//            if (sender.avatars.count > 0){
//                avtar = [sender.avatars objectAtIndex:0];
//            }
            [msgCell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
            msgCell.flag.frame = CGRectMake(94,58,21,21);
            msgCell.flag.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
            msgCell.flag.textAlignment = UITextAlignmentLeft;
            msgCell.flag.textColor = [UIColor colorWithHexString:@"#783207"];          msgCell.flag.text = [NSString fontAwesomeIconStringForEnum:FABullhorn];
            if (count > 0){
                
                Announce* a = [LOCALMANAGER getLastestUnReadAnnounce];
                title = a.creator.realName;
                subTitle = a.subject;
                createDate = a.createDate;
                if (a.creator.avatars.count > 0){
                    avtar = [a.creator.avatars objectAtIndex:0];
                
                }
                
                [msgCell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
                msgCell.flag.frame = CGRectMake(94,58,21,21);
                msgCell.flag.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
                msgCell.flag.textAlignment = UITextAlignmentLeft;
                msgCell.flag.textColor = [UIColor colorWithHexString:@"#783207"];          msgCell.flag.text = [NSString fontAwesomeIconStringForEnum:FABullhorn];
                
                
            }else{
                Announce* a = [LOCALMANAGER getLastestAnnounce];
                title = a.creator.realName;
                if (a.creator.avatars.count > 0){
                    avtar = [a.creator.avatars objectAtIndex:0];
                    
                }
                
                [msgCell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
                msgCell.flag.frame = CGRectMake(94,58,21,21);
                msgCell.flag.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
                msgCell.flag.textAlignment = UITextAlignmentLeft;
                msgCell.flag.textColor = [UIColor colorWithHexString:@"#783207"];          msgCell.flag.text = [NSString fontAwesomeIconStringForEnum:FABullhorn];
                if (a == nil){
                    subTitle = NSLocalizedString(@"noannounce", "");
                    createDate = @"";
                }else{
                    subTitle = a.subject;
                    createDate = a.createDate;
                }
            }
        }
        //用户消息通知
        if ([[users objectAtIndex:indexPath.row] isKindOfClass:[User class]]) {
            u = [users objectAtIndex:indexPath.row];
            if (u.avatars.count > 0){
                avtar = [u.avatars objectAtIndex:0];
            }
            count = [LOCALMANAGER getUnReadMessageCountWithUser:u.id];
            title = u.realName;
            if (count > 0){
                SysMessage* m = (SysMessage*)[[LOCALMANAGER getUnReadMessagesWithUser:u.id] objectAtIndex:0];
                subTitle = [APPDELEGATE getContentWithMessage:m];
                createDate = m.createDate;
            }else{
                SysMessage* m = [LOCALMANAGER getLastestMessage:u.id];
                subTitle = [APPDELEGATE getContentWithMessage:m];
                createDate = m.createDate;
                 
            }
            //
            msgCell.flag.frame = CGRectMake(94,58,21,21);
            msgCell.flag.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];
            msgCell.flag.textAlignment = UITextAlignmentLeft;
            msgCell.flag.textColor = [UIColor colorWithHexString:@"#783207"];            msgCell.flag.text = [NSString fontAwesomeIconStringForEnum:FAEnvelopeO];

            msgCell.icon.userInteractionEnabled = YES;
            msgCell.icon.tag = indexPath.row;
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toUser:)];
            [msgCell.icon addGestureRecognizer:singleTap1];
            [singleTap1 release];
        }
        //本地消息通知
        if ([[users objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
            if (USER.avatars.count > 0){
                avtar = [USER.avatars objectAtIndex:0];
            }
            count = [(NSString*)[users objectAtIndex:indexPath.row] intValue];
            title = USER.realName;
            subTitle = [NSString stringWithFormat:NSLocalizedString(@"cache_msg_unupload", @""),count];
            createDate = [NSDate getCurrentDateTime];
        }
        [msgCell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
        if (count == 0) {
            msgCell.count.hidden = YES;
        }else{
            msgCell.count.hidden = NO;
            msgCell.count.text = [NSString stringWithFormat:@"%d",count];
        }
        if (count >= 3) {
            [msgCell.count setBackgroundColor:WT_RED];
        }else{
            [msgCell.count setBackgroundColor:WT_RED];
        }
        [msgCell.count setTextColor:[UIColor whiteColor]];
        msgCell.count.layer.cornerRadius = 10;
        msgCell.count.layer.masksToBounds = YES;
        msgCell.title.text = title;
        msgCell.subTitle.text = subTitle;
     //  msgCell.flag.hidden = YES;
        msgCell.time.text = createDate;
        msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        msgCell.delegate = self;
        
        return msgCell;
    }
    return cell;
}


- (void)toUser:(id)sender{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    int index = tapGesture.view.tag;
    if ([[users objectAtIndex:index] isKindOfClass:[User class]]) {
        User* u = [users objectAtIndex:index];
        [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_OTHER_USER_DETAIL Object:u Delegate:nil NeedBack:YES];
    }
    
}

#pragma mark - SW Table View Cell Delegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
    
}
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if ([[users objectAtIndex:indexPath.row] isKindOfClass:[Announce class]]) {
        [LOCALMANAGER deleteAnnounce];
    }
    if ([[users objectAtIndex:indexPath.row] isKindOfClass:[User class]]) {
        [LOCALMANAGER deleteMessage:((User*)[users objectAtIndex:indexPath.row]).id];
    }
    [users removeObjectAtIndex:indexPath.row];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}

#pragma -mark - 私有方法

-(int) hasContactFunc{
    int index = 0;
    for (Function *item in [LOCALMANAGER getFavFunctions]) {
        if ([item.value isEqualToString:FUNC_COMPANY_CONTACT_DES] ||
            [item.value isEqualToString:FUNC_CUSTOMER_CONTACT_DES]) {
            return index;
        }
        index++;
    }
    return -1;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
