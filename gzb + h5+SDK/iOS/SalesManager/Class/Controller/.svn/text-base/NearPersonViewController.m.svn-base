//
//  NearPersonViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-7.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "NearPersonViewController.h"

#import "LocationCell.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "NearPersonCell.h"
#import "SDImageView+SDWebCache.h"
#import "HeaderSearchNearView.h"
#import "DropMenu.h"
#import "DepartmentViewController.h"
#import "UIView+Util.h"

@interface NearPersonViewController ()<DepartmentViewControllerDelegate,DropMenuDelegate,HeaderSearchNearViewDelegate,UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>{
    UIView *rightView;

    
    NSMutableArray* userArray;
    UserParams* userParams;
    NSMutableArray *departmentArray;
    NSMutableArray *checkedDepartmentArray;
    
    HeaderSearchNearView *searchView;
    NSMutableArray *_searchViews;
    NSMutableArray *distances;
    DropMenu *dropMenu2;
    
    int currentPage;
    int pageSize;
    int totleSize;
    int currentMenuIndex;
}


@end

@implementation NearPersonViewController
@synthesize tableView,parentController;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];
    [self initUI];
    userArray = [[NSMutableArray alloc] init];
}

-(void)initUI{
    _searchViews = [[NSMutableArray alloc] init];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    [lblFunctionName setText:@"人员列表"];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = WT_WHITE;
    tableView.pullDelegate = self;
    tableView.pullBackgroundColor = WT_YELLOW;
    tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.title = @"";
    
    departmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    checkedDepartmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    [departmentArray removeAllObjects];
    [departmentArray addObjectsFromArray:[[LOCALMANAGER getDepartments] retain]];

    distances = [[NSMutableArray alloc] initWithArray:[NSMutableArray arrayWithObjects:@"距离不限", @"1千米", @"3千米", @"5千米", @"10千米",nil]];
    
    searchView = [[HeaderSearchNearView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    searchView.delegate = self;
    searchView.backgroundColor = WT_WHITE;
    [self.view addSubview:searchView];
    
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = departmentArray;
    departmentVC.view.frame = CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT - 45);
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        searchView.icon1.text = [NSString fontAwesomeIconStringForEnum:ICON_TAB_CITY];
        searchView.icon2.text = [NSString fontAwesomeIconStringForEnum:ICON_TAB_DISTANCE];
        searchView.icon3.text = [NSString fontAwesomeIconStringForEnum:ICON_CUSTOMER];
        //"search_title_department"="部门";
       // "search_title_distance"="距离";
        [searchView.bt1 setTitle:NSLocalizedString(@"search_title_department", nil) forState:UIControlStateNormal];
        [searchView.bt2 setTitle:NSLocalizedString(@"search_title_distance", nil) forState:UIControlStateNormal];
        [searchView.bt3 setTitle:NSLocalizedString(@"search_title_staff", nil) forState:UIControlStateNormal];
    });
    
    AGENT.delegate = self;
    
    currentPage = 1;
    UserParams_Builder* up = [UserParams builder];

    if (APPDELEGATE.myLocation != nil) {
        [up setLocation:APPDELEGATE.myLocation];
    }
    [up setPage:currentPage];
    userParams = [[up build] retain];
    
    [self refreshTable];
}

-(void)clickLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickButtunIndex:(int)index{
    if (currentMenuIndex == index) {

        [dropMenu2 removeFromSuperview];
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        currentMenuIndex = 0;
        return;
    }
    currentMenuIndex = index;
    if (index == 1) {
        [UIView addSubViewToSuperView:self.view subView:_searchViews[0]];
    }else if (index == 2) {
        
        if (dropMenu2 == nil) {
            dropMenu2 = [[DropMenu alloc] initWithFrame:CGRectMake(0, 45, MAINWIDTH, tableView.frame.size.height)];
            dropMenu2.delegate = self;
            dropMenu2.menuCount = 1;
            dropMenu2.array1 = [[NSMutableArray alloc] initWithArray:distances];
            [dropMenu2 initMenu];
        }
        [self.view addSubview:dropMenu2];
        
    }else if (index == 3){
        userArray = [[LOCALMANAGER getUsers] retain];
        [tableView reloadData];
    }
}

-(void)selectedDropMenuIndex:(int)index row:(int)row{

    
    if (dropMenu2 != nil) {
        [dropMenu2 removeFromSuperview];
    }
    
    if (currentMenuIndex == 2) {
        [searchView.bt2 setTitle:[dropMenu2.array1 objectAtIndex:row] forState:UIControlStateNormal];
        
        if (row == 0) {
            UserParams_Builder* cpb = [userParams toBuilder];
            
            [cpb clearLocation];
            userParams = [[cpb build] retain];
        }else{
            UserParams_Builder* cpb = [userParams toBuilder];
            
            Location_Builder *lb = [cpb.location builder];
            
            if (row == 1) {
                [lb setDistance:@"1000"];
            }else if (row == 2){
                [lb setDistance:@"3000"];
            }else if (row == 3){
                [lb setDistance:@"5000"];
            }else if (row == 4){
                [lb setDistance:@"10000"];
            }
            
            if (lb.latitude == 0) {
                [lb setLatitude:0.00f];
                [lb setLongitude:0.00f];
            }
            
            [cpb setLocation:[lb build]];
            userParams = [[cpb build] retain];
        }
        [self refreshTable];
        currentMenuIndex = 0;
    }
    
    
}

-(void)didFnishedCheck:(NSMutableArray *)departments{
    
    checkedDepartmentArray = [departments retain];
    NSString *depTitle = @"";
    for (Department *department in checkedDepartmentArray) {
        if (depTitle.length <1) {
            depTitle = department.name;
        }else{
            depTitle = [NSString stringWithFormat:@"%@,%@",depTitle,department.name];
        }
    }
    if (depTitle.length <1) {
        depTitle = NSLocalizedString(@"search_title_department", nil);
    }
    [searchView.bt1 setTitle:depTitle forState:UIControlStateNormal];
    
    UserParams_Builder* cpb = [userParams toBuilder];
    
    [cpb setDepartmentArray:checkedDepartmentArray];
    userParams = [[cpb build] retain];
    [self refreshTable];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
}



#pragma mark -tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return userArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 51;
    }
    return 80.0f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        User* u = [userArray objectAtIndex:indexPath.row];
        if (u.permissions) {
            for (Permission *p in u.permissions ) {
                
                if ([p.value isEqualToString:USER_PERMISSION_VIEW_VAL]) {
                    [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_OTHER_USER_DETAIL Object:u Delegate:nil NeedBack:YES];
                    
                }else {
                    [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                                      description:[NSString stringWithFormat:NSLocalizedString(@"msg_no_permission", @"")]
                                             type:MessageBarMessageTypeInfo
                                      forDuration:ERR_MSG_DURATION];
                    return;
                
                }
            }}else {
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                                  description:[NSString stringWithFormat:NSLocalizedString(@"msg_no_permission", @"")]
                                         type:MessageBarMessageTypeInfo
                                  forDuration:ERR_MSG_DURATION];
                return;

            
            }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        const NSString *CellIdentifier = @"LocationCell";
        LocationCell *locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(locationCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[LocationCell class]])
                    locationCell=(LocationCell *)oneObject;
            }
        }
        if (APPDELEGATE.myLocation != nil) {
            if (!APPDELEGATE.myLocation.address.isEmpty) {
                [locationCell.lblAddress setText:APPDELEGATE.myLocation.address];
            }else{
                [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude]];
            }
        }
        [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
        
        cell = locationCell;
    }else if(indexPath.section == 1){
        const NSString *CellIdentifier = @"CustomerListCell";
        NearPersonCell *personCell=(NearPersonCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(personCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"NearPersonCell" owner:self options:nil];
            personCell = [nib objectAtIndex:0];
        }
        User* u = [userArray objectAtIndex:indexPath.row];
        for (Permission *p  in u.permissions) {
            if ([p.value isEqualToString:USER_PERMISSION_VIEW_VAL]) {
                //personCell.backgroundColor = WT_LIGHT_YELLOW;
                [personCell.lView setBackgroundColor:WT_GREEN];
                personCell.lView.layer.cornerRadius = 7 ;
                personCell.lView.layer.masksToBounds = YES;
                [personCell.lView setText:@""];
            }
        }
       
        NSString* avtar = @"";
        if (u.avatars.count > 0){
            avtar = [u.avatars objectAtIndex:0];
        }
        [personCell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
        
        personCell.name.text = u.realName;
        personCell.department.text = u.department.name;
        personCell.department.textColor = WT_KHAKI;
        personCell.distance.text = u.location.distance;
        personCell.address.text = u.location.address;
        personCell.time.text = u.location.createTime;
        personCell.icLocal.font = [UIFont fontWithName:kFontAwesomeFamilyName size:14];;
        [personCell.icLocal setTextColor:WT_GRAY];
        personCell.icLocal.text = [NSString fontAwesomeIconStringForEnum:ICON_LOCATION_MARKER];
        personCell.icLocal.hidden = YES;
        personCell.address.hidden = YES;
        cell = personCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)autorefreshLocation {
    [super refreshLocation];
    [tableView reloadData];
}

- (void)refreshLocation{
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [tableView reloadData];
    
    [hud hide:YES afterDelay:1.0];
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    tableView.pullLastRefreshDate = [NSDate date];
    tableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    if (userParams != nil){
        UserParams_Builder* cpb = [userParams toBuilder];
        [cpb setPage:1];
        if (APPDELEGATE.myLocation != nil) {
            Location_Builder* lb = [userParams.location toBuilder];
            
            [lb setLongitude:APPDELEGATE.myLocation.longitude];
            [lb setLatitude:APPDELEGATE.myLocation.latitude];
            
            [cpb setLocation:[lb build]];
        }
        
        userParams = [[cpb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeUserList param:userParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            tableView.pullTableIsRefreshing = NO;
            tableView.pullTableIsLoadingMore = NO;
        }
        
    }
}

- (void) loadMoreDataToTable
{
    tableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        UserParams_Builder* cpb = [userParams toBuilder];
        [cpb setPage:currentPage];
        if (APPDELEGATE.myLocation != nil) {
            Location_Builder* lb = [userParams.location toBuilder];
            
            [lb setLongitude:APPDELEGATE.myLocation.longitude];
            [lb setLatitude:APPDELEGATE.myLocation.latitude];
            
            [cpb setLocation:[lb build]];
        }
        
        userParams = [[cpb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeUserList param:userParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            tableView.pullTableIsRefreshing = NO;
            tableView.pullTableIsLoadingMore = NO;
        }
        
    }else{
        tableView.pullTableIsLoadingMore = NO;
    }
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}


- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        tableView.pullTableIsRefreshing = NO;
        tableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeUserList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageUser* pageUser = [PageUser parseFromData:cr.data];
        if ([super validateData:pageUser]) {
            int userCount = pageUser.users.count;
            if (currentPage == 1)
                [userArray removeAllObjects];
            
            for (int i = 0 ;i < userCount;i++){
                User* c = (User*)[[pageUser users] objectAtIndex:i];
                [userArray addObject:c];
                
            }
            pageSize = pageUser.page.pageSize;
            totleSize = pageUser.page.totalSize;
            
            if (userArray.count == 0) {
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                                  description:NSLocalizedString(@"noresult", @"")
                                         type:MessageBarMessageTypeInfo
                                  forDuration:INFO_MSG_DURATION];
                
            }
            [tableView reloadData];
        }
    }
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
}

- (void) didFailWithError:(NSError *)error{
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    
    [super didFailWithError:error];
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [tableView release];
    [super dealloc];
}
@end
