//
//  MyViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-4-27.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "MyViewController.h"
#import "MyInfoItemCell.h"
#import "MyInfoTopCell.h"
#import "NearPersonViewController.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "SDImageView+SDWebCache.h"
#import "UIView+Util.h"
#import "NSString+Util.h"
#import "UIView+CNKit.h"
//ic_unknow_avatar
@interface MyViewController (){
    User *user;
    CountData* countData;
    
    NSMutableArray *functionItems;
    int firstSectionRow;
    int secondSectionRow;
    UIImage* avtor;
}

@end

@implementation MyViewController
@synthesize user;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    if (user != nil) {
        if (user.id != USER.id) {
            [self _getUserInfo];
        }
    }
    
    [self _getUserCountData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData)
                                                 name:SYNC_NOTIFICATION_MENU object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshCatogry) name:@"syncAttendanceCatogry" object:nil];
}

-(void)reFreshCatogry {
    [self _loadFunctions];
    [_tableView reloadData];

}

-(void)initUI{
    int height ;
    if (SCREENHEIGHT == 480) {
     height = SCREENHEIGHT - 64;
    }else{
     height = SCREENHEIGHT - 44;
    }
    _tableView = [[PullTableView alloc]initWithFrame: CGRectMake(0, 0, MAINWIDTH, height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    _tableView.pullBackgroundColor = WT_YELLOW;
    [self.view addSubview:_tableView];
//    _tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
//    self.navigationController.navigationBarHidden = YES;
   // self.navigationController.navigationBar.hidden = YES;
    
    
    if (bNeedBack) {
        leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
        [self.leftView setHidden:NO];
        leftImageView.hidden = NO;
        
    }else{
        [self.leftView setHidden:NO];
        leftImageView.hidden = YES;
        self.navigationController.navigationBar.hidden = YES;
    }
    
    self.title = @"";
}

-(void)initData{
    if (user == nil) {
        user = [[LOCALMANAGER getLoginUser] retain];
    }

    [self _loadFunctions];
    [_tableView reloadData];
    
    if (user != nil) {
        if (user.id == USER.id) {
            lblFunctionName.text = APPTITLE;
            lblFunctionName.textAlignment = NSTextAlignmentCenter;
        }else{
            lblFunctionName.text = [NSString stringWithFormat:@"%@",user.realName];
        }
    }
}

-(void) _getUserInfo{
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = YES;
    
    UserParams_Builder* cpb = [UserParams builder];
    [cpb setUser:user];
    UserParams *userParams= [[cpb build] retain];
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeUserInfoGet param:userParams]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
        
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
    }

}

- (void) _loadFunctions {
    if (functionItems.count > 0){
        [functionItems removeAllObjects];
        [functionItems release];
        functionItems = nil;
    }
    functionItems = [[NSMutableArray alloc] initWithCapacity:12];
    NSMutableArray* userFunc = [LOCALMANAGER getFunctions];
    
    firstSectionRow = 3;
    secondSectionRow = 0;
    if (user.id == USER.id) {
        //置顶上传任务
        Function_Builder* f = [Function builder];
        [f setId:FUNC_VIDEO_TASK_LIST];
        [f setName:NSLocalizedString(@"bar_video_post_task", nil)];
        [f setValue:FUNC_VIDEO_TASK_DES];
        ++secondSectionRow;
        [functionItems addObject:[f build]];
    }
    //功能菜单
    NSMutableArray *attendanceTypes = [LOCALMANAGER getAttendanceTypes];
    
       for (Function* f in userFunc){
        if ([FUNC_COMPANY_CONTACT_DES isEqual: f.value] || [f.value isEqual: FUNC_CUSTOMER_CONTACT_DES]){
            firstSectionRow = 4;
        }
        if ([f.value isEqual: FUNC_VIDEO_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_ATTENDANCE_DES]){
            [attendanceTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
            if ([((AttendanceType*)obj).value isEqualToString:@"ATTENDANCE"]) {
                        Function_Builder* f = [Function builder];
                        [f setId:FUNC_ATTENDANCE_ATTENDANCE_LIST];
                        [f setName:NSLocalizedString(@"sign_attendance", nil)];
                        [f setValue:FUNC_ATTENDANCE_ATTENDANCET_LIST_DES];
                        ++secondSectionRow;
                        [functionItems addObject:[f build]];
                    }
            if ([((AttendanceType*)obj).value isEqualToString:@"CHECK_IN"]) {
                        Function_Builder* f = [Function builder];
                        [f setId:FUNC_ATTENDANCE_CHECK_IN_LIST];
                        [f setName:NSLocalizedString(@"chenk_in_attendance", nil)];
                        [f setValue:FUNC_ATTENDANCE_CHECK_IN_LIST_DES];
                        ++secondSectionRow;
                        [functionItems addObject:[f build]];
                    }
                    
                }];

            }
           
        if ([f.value isEqual: FUNC_PATROL_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_TASK_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_INSPECTION_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_WORKLOG_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_RESEARSH_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_BIZOPP_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_COMPETITION_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual: FUNC_SELL_TODAY_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual:FUNC_SELL_ORDER_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual:FUNC_SELL_STOCK_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual:FUNC_SELL_REPORT_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual:FUNC_APPROVE_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        if ([f.value isEqual:FUNC_PAPER_POST_DES]){
            ++secondSectionRow;
            [functionItems addObject:f];
        }

        if ([f.value isEqual:FUNC_GIFT_DES]){
            Function_Builder* f = [Function builder];
            [f setId:FUNC_GIFT_PURCHASE_LIST];
            [f setName:NSLocalizedString(@"bar_gift_purchase", nil)];
            [f setValue:FUNC_GIFT_PURCHASE_LIST_DES];
            ++secondSectionRow;
            [functionItems addObject:[f build]];
            
            Function_Builder* f1 = [Function builder];
            [f1 setId:FUNC_GIFT_DELIVERY_LIST];
            [f1 setName:NSLocalizedString(@"bar_gift_delivery", nil)];
            [f1 setValue:FUNC_GIFT_DELIVERY_LIST_DES];
            ++secondSectionRow;
            [functionItems addObject:[f1 build]];
            
            Function_Builder* f2 = [Function builder];
            [f2 setId:FUNC_GIFT_DISTRIBUTE_LIST];
            [f2 setName:NSLocalizedString(@"gift_distibute", nil)];
            [f2 setValue:FUNC_GIFT_DISTRIBUTE_LIST_DES];
            ++secondSectionRow;
            [functionItems addObject:[f2 build]];
            
            Function_Builder* f3 = [Function builder];
            [f3 setId:FUNC_GIFT_STOCK_LIST];
            [f3 setName:NSLocalizedString(@"bar_gift_stock", nil)];
            [f3 setValue:FUNC_GIFT_STOCK_LIST_DES];
            ++secondSectionRow;
            [functionItems addObject:[f3 build]];
        }
        if ([f.value isEqual:FUNC_PATROL_TASK_DES]) {
            ++secondSectionRow;
            [functionItems addObject:f];
        }
        
    }
    
    if (user.id != USER.id) {
        Function_Builder* f = [Function builder];
        [f setId:FUNC_TRACK_LIST];
        [f setName:NSLocalizedString(@"menu_fuction_tack", "")];
        [f setValue:NSLocalizedString(@"menu_fuction_tack", "")];
        ++secondSectionRow;
        [functionItems insertObject:[f build] atIndex:0];
    }

    return;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(_getUserInfo) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(_getUserInfo) withObject:nil afterDelay:RELOAD_DELAY];
}


- (void) _getUserCountData{
    CountParams_Builder* bs = [CountParams builder];
    [bs setUsersArray:[[NSArray alloc] initWithObjects:user, nil]];
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeCountDataGet param:[bs build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE;
    if ([super validateResponse:cr]) {
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeCountDataGet) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        countData = [[CountData parseFromData:cr.data] retain];
        if ([super validateData:countData]) {
            [_tableView reloadData];
        }
        
    }else if ((INT_ACTIONTYPE(cr.type) == ActionTypeUserInfoGet) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        
        User* u = [User parseFromData:cr.data];
        if ([super validateData:u]){
            user = [u retain];
        }
        [self _getUserCountData];
        
    }else if ((INT_ACTIONTYPE(cr.type) == ActionTypeUserInfoUpdate) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        
        User* u = [User parseFromData:cr.data];
        if ([super validateData:u]){
            if (u.avatars.count > 0) {
                User_Builder* ub = [user toBuilder];
                [ub setAvatarsArray:[[NSArray alloc] initWithObjects:[u.avatars objectAtIndex:0], nil]];
                user = [[ub build] retain];
                [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
            }
            
        }
    }
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullTableIsLoadingMore = NO;
}

- (void) didFailWithError:(NSError *)error{
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullTableIsLoadingMore = NO;
    
    [super didFailWithError:error];
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullTableIsLoadingMore = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        if (user.id == USER.id) {
            return firstSectionRow;
        }else{
            return 1;
        }
        
    }
    return secondSectionRow;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row == 0) {
        return 220.f;
    }
    
    return 40.0f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 1.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20.0f;
    }
    return 1.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NearPersonViewController *vctrl = [[NearPersonViewController alloc] init];
    //[self.parentController.navigationController pushViewController:vctrl animated:YES];
    UIViewController* vctrl = self;
    if (self.parentController != nil) {
        vctrl = self.parentController;
    }

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
            }
                break;
            case 1:{
               [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_FAVORATE Object:nil Delegate:nil NeedBack:YES];
            }
                break;
            /*case 2:{
                [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_CUSTOMER_LIST Object:USER Delegate:nil NeedBack:YES];
            }
                break;*/
            case 2:{
                [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_CONTACTS Object:nil Delegate:nil NeedBack:YES];
            }
                break;
            case 3:{
                [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_NEARBY_LIST Object:user Delegate:nil NeedBack:YES];
            }
                break;
            
            default:
                break;
        }
    }else{
        Function* f = [functionItems objectAtIndex:indexPath.row];
        if (f.id == FUNC_TRACK_LIST){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_TRACK_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_VIDEO_TASK_DES]) {
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_VIDEO_TASK_LIST Object:nil Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual: FUNC_VIDEO_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_VIDEO_LIST Object:user Delegate:nil NeedBack:YES];
        }
       
        if ([f.value isEqual: FUNC_PATROL_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_PATROL_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual: FUNC_TASK_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_ATTENDANCE Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual: FUNC_INSPECTION_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_INSPECTION_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual: FUNC_WORKLOG_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_WORKLOG_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual: FUNC_RESEARSH_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_RESEARSH_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual: FUNC_BIZOPP_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_BIZOPP_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual: FUNC_COMPETITION_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_COMPETITION_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual: FUNC_SELL_TODAY_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_SELL_TODAY_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_SELL_ORDER_DES]){
            
            //如果是自己则查询所有订单
            User *u = self.user.id == USER.id ? nil : self.user;
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_NEW_ORDER_LIST Object:u Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_SELL_STOCK_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_SELL_STOCK_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_SELL_REPORT_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_ATTENDANCE Object:user Delegate:nil  NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_APPROVE_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_APPROVE_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_GIFT_DISTRIBUTE_LIST_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_GIFT_DISTRIBUTE_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_GIFT_DELIVERY_LIST_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_GIFT_DELIVERY_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_GIFT_PURCHASE_LIST_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_GIFT_PURCHASE_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_GIFT_STOCK_LIST_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_GIFT_STOCK_LIST Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_PATROL_TASK_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_TASK Object:user Delegate:nil NeedBack:YES];
        }
        if ([f.value isEqual:FUNC_PAPER_POST_DES]){
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNK_PAPER_POST_LIST Object:user Delegate:nil NeedBack:YES];
        }

        if ([f.value isEqual:FUNC_ATTENDANCE_ATTENDANCET_LIST_DES]) {
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_ATTENDANCE_ATTENDANCE_LIST Object:user Delegate:nil NeedBack:YES];
        }
        
        if ([f.value isEqual:FUNC_ATTENDANCE_CHECK_IN_LIST_DES]) {
            [VIEWCONTROLLER create:vctrl.navigationController ViewId:FUNC_ATTENDANCE_CHECK_IN_LIST Object:user Delegate:nil NeedBack:YES];
        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
       MyInfoTopCell *topCell=(MyInfoTopCell *)[tableView dequeueReusableCellWithIdentifier:@"MyInfoTopCell"];
        if(topCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyInfoTopCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[MyInfoTopCell class]])
                    topCell=(MyInfoTopCell *)oneObject;
            }
        }
        topCell.icon.layer.cornerRadius = 40.f;
        topCell.icon.layer.masksToBounds = YES;
        topCell.icon.backgroundColor = WT_WHITE;
        UIImage *bgImage = [UIImage imageNamed:@"favorite_topbar_bg_orange"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        [bgImageView setFrame:CGRectMake(0, 0, MAINWIDTH,174.0)];
        bgImageView.contentMode = UIViewContentModeScaleToFill;
        topCell.backgroundView = bgImageView;
        
        //[topCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"favorite_topbar_bg_orange"]]];
        
        if (avtor != nil) {
            [topCell.icon setImage:avtor];
        }else{
            NSString* avtorUrl = @"";
            if (user.avatars.count > 0) {
                avtorUrl = [user.avatars objectAtIndex:0];
            }
            [topCell.icon setImageWithURL:[NSURL URLWithString:avtorUrl] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
        }
        [topCell.btPhoto addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        [topCell.name setText:user.realName];
        [topCell.tel setText:user.userName];
//        [topCell.info setText:[NSString stringWithFormat:@"部门：%@  职位：%@",user.department.name,user.position.name]];
        [topCell.info setText:[NSString stringWithFormat:@"部门：%@",user.department.name]];
        [topCell.Info2 setText:[NSString stringWithFormat:@"职位：%@", user.position.name]];
        [topCell.btPhone addTarget:self action:@selector(selectCall) forControlEvents:UIControlEventTouchUpInside];
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = topCell;
    }else{
        MyInfoItemCell *itemCell=(MyInfoItemCell *)[tableView dequeueReusableCellWithIdentifier:@"MyInfoItemCell"];
        if(itemCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MyInfoItemCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[MyInfoItemCell class]])
                    itemCell=(MyInfoItemCell *)oneObject;
            }
        }
        [self _buildCell:(NSIndexPath *)indexPath MyInfoItemCell:itemCell];
        cell = itemCell;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(void)selectPhoto{
    if (USER.id == user.id) {
        UIActionSheet *actionSheet =[[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"msg_update_user_avtor", @"")
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"no", @"")
                                     destructiveButtonTitle:NSLocalizedString(@"msg_take_a_photo", @"")
                                     otherButtonTitles:NSLocalizedString(@"msg_select_from_album", @""),nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag = 0;
        [actionSheet showInView:self.view];
    }
}

-(void)selectCall{
    if (USER.id != user.id) {
        UIActionSheet *actionSheet =[[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"msg_user_call", @"")
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"no", @"")
                                     destructiveButtonTitle:user.userName
                                     otherButtonTitles:nil,nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
    }
}

- (void) _buildCell:(NSIndexPath *)indexPath MyInfoItemCell:(MyInfoItemCell*) cell{
    cell.icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    [cell.icon setTextColor:[UIColor grayColor]];
    [cell.count setTextColor:[UIColor grayColor]];
    cell.title.font = [UIFont systemFontOfSize:14.0f];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 1:
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_FAV]];
                [cell.title setText:NSLocalizedString(@"my_favorate", "")];
                [cell.count setText:@""];
                break;
            /*case 2:
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_CUSTOMER]];
                [cell.title setText:NSLocalizedString(@"my_customer", "")];
                [cell.count setText:[NSString countNumAndChangeformat:countData.favCustomerCount]];
                break;*/
            case 2:
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_PHONE]];
                [cell.title setText:NSLocalizedString(@"contacts", "")];
                [cell.count setText:@""];
                break;
            case 3:
                [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_PROFILE]];
                [cell.title setText:NSLocalizedString(@"my_nearby", "")];
                [cell.count setText:@""];
                break;
            
            default:
                break;
        }
    }else{
        Function* f = [functionItems objectAtIndex:indexPath.row];
        cell.tag = f.id;
        if (f.id == FUNC_TRACK_LIST) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_LOCATION_MARKER]];
            [cell.title setText:f.name];
            [cell.count setText:@""];
        }
        if ([f.value isEqual:FUNC_VIDEO_TASK_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD]];
            [cell.title  setText:f.name];
            [cell.count setText:[NSString stringWithFormat:@"%d",[LOCALMANAGER getCacheCountWithFuncId:FUNC_VIDEO]]];
        }
        if ([f.value isEqual:FUNC_VIDEO_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_VIDEO]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.videoUploadCount]];
        }
        if ([f.value isEqual:FUNC_PATROL_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_PATROL]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.patrolCount] ];
        }
        if ([f.value isEqual:FUNC_WORKLOG_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_WORKLOG]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.workLogCount]];
        }
        if ([f.value isEqual:FUNC_SELL_ORDER_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_SELL_ORDER]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.orderGoodsCount]];
        }
        if ([f.value isEqual:FUNC_SELL_STOCK_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_SELL_STOCK]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.stockCount]];
        }
        if ([f.value isEqual:FUNC_SELL_TODAY_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_SELL_TODAY]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.saleGoodsCount]];
        }
        if ([f.value isEqual:FUNC_RESEARSH_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_MARKET_RESEARCH]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.marketResearchCount]];
        }
        if ([f.value isEqual:FUNC_COMPETITION_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_COMPETITION]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.competitionGoodsCount]];
        }
        
//        if ([f.value isEqual:FUNC_GIFT_DELIVERY_LIST_DES]) {
//            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
//            [cell.title setText:f.name];
//            [cell.count setText:[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%d",(int)countData.giftDeliveryCount.intValue]]];
//        }

        if ([f.value isEqual:FUNC_ATTENDANCE_ATTENDANCET_LIST_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_ATTENDANCE]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.attendanceCount]];
            
        }
        
        if ([f.value isEqual:FUNC_ATTENDANCE_CHECK_IN_LIST_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_ATTENDANCE]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.checkinCount]];
            
        }

        
        if ([f.value isEqual:FUNC_TASK_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.taskPatrolCount]];
        }
        if ([f.value isEqual:FUNC_BIZOPP_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_BUSSINESS_OPPORTUNITY]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.businessOpportunityCount]];
        }
        if ([f.value isEqual:FUNC_APPROVE_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_APPROVE]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.applyItemCount]];
        }
        if ([f.value isEqual:FUNC_GIFT_DELIVERY_LIST_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%d",(int)countData.giftDeliveryCount.intValue]]];
        }
        if ([f.value isEqual:FUNC_GIFT_DISTRIBUTE_LIST_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%d",(int)countData.giftDistributeCount.intValue]]];
        }
        if ([f.value isEqual:FUNC_GIFT_PURCHASE_LIST_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%d", (int)countData.giftPurchaseCount.intValue]]];
        }
        if ([f.value isEqual:FUNC_GIFT_STOCK_LIST_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_GIFT]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%d",(int)countData.giftStockCount.intValue]]];
        }
        if ([f.value isEqual:FUNC_INSPECTION_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_INPECTION]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.inspectionReportCount]];
        }
        if ([f.value isEqual:FUNC_PATROL_TASK_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.taskPatrolCount]];
        }
        if ([f.value isEqual:FUNC_PAPER_POST_DES]) {
            [cell.icon setText:[NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD]];
            [cell.title setText:f.name];
            [cell.count setText:[NSString countNumAndChangeformat:countData.paperPostCount]];
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
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 0) {
        switch (buttonIndex) {
            case 0:{
                [self _takeAPhotoWithCamera];
            }
                break;
            case 1:{
                [self _takeAPhotoWithAlbum];
            }
                break;
            default:
                break;
        }
    }
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:{
                NSString* tel = [NSString stringWithFormat:@"tel://%@",user.userName];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
            }
                break;
            default:
                break;
        }
    }
}

-(void) _takeAPhotoWithCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:NO];
        cameraVC.hidesBottomBarWhenPushed = YES;
        //显示Camera VC
        
        self.hidesBottomBarWhenPushed = YES;
        [self presentModalViewController:cameraVC animated:YES];
        [cameraVC release];
        
    }else {
        NSLog(@"Camera is not available.");
    }
}

-(void) _takeAPhotoWithAlbum{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
        [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
        [imgPickerVC setDelegate:self];
        [imgPickerVC setAllowsEditing:NO];
        //显示Image Picker
        [self presentModalViewController:imgPickerVC animated:YES];
        
        [imgPickerVC release];
    }else {
        NSLog(@"Album is not available.");
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // Extract image from the picker and save it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        //icon = [[UIView fitSmallImage:[info objectForKey:UIImagePickerControllerOriginalImage]] retain];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        CropImageViewController *vctrl = [[CropImageViewController alloc] init];
        vctrl.image = [[UIView fitSmallImage:[info objectForKey:UIImagePickerControllerOriginalImage]] retain];
        vctrl.delegate = self;
        if (self.parentController != nil) {
            [self.parentController.navigationController pushViewController:vctrl animated:YES];
        }else{
            [self.navigationController pushViewController:vctrl animated:YES];
        }
        
        [vctrl release];
    }];
}

- (void)cropImageController:(CropImageViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    avtor = [[UIView scaleToSize:croppedImage size:AVATAR_SIZE] retain];
    //avtor = [[UIView fitSmallImage:croppedImage] retain];
    [_tableView reloadData];
    
    [self _sendAvtor];
}

- (void) _sendAvtor{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    User_Builder* ub = [USER toBuilder];
    NSData *img = UIImageJPEGRepresentation(avtor,AVATAR_COMPRESS_QUALITY);
    [ub setAvatarFileArray:[[NSArray alloc] initWithObjects:img, nil]];
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeUserInfoUpdate param:[ub build]]) {
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"dashboard_title_2", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void)dealloc {
    [avtor release];
    [_tableView release];
    [super dealloc];
}

@end
