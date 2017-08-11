//
//  VideoListViewController.m
//  SalesManager
//
//  Created by Administrator on 15/11/10.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "VideoListViewController.h"
#import "HeaderSearchBar.h"
#import "VideoListCell.h"
#import "VIdeoDetailViewController.h"
#import "InputViewController.h"
#import "DepartmentViewController.h"
#import "VideoTypeViewController.h"
#import "NameFilterViewController.h"
#import "UIView+Util.h"
#import "NSDate+Util.h"

@interface VideoListViewController ()<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,VideoListCellDelegate,InputFinishDelegate,HeaderSearchBarDelegate,DepartmentViewControllerDelegate,VideoTypeDelegate,NameFilterViewControllerDelegate,RefreshDelegate,InputFinishDelegate>

@end

@implementation VideoListViewController
{
    HeaderSearchBar         *_headerBar;
    NSMutableArray          *_searchViews;
    NSMutableArray          *_departments;
    NSMutableArray          *_checkDepartments;
    VideoCategory           *_videoCategory;
    NSString                *_userName;
    NSString                *_formTime;
    NSString                *_endTime;
    
    
    int    _replyVideoID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _videoList = [[NSMutableArray alloc] init];
    _searchViews = [[NSMutableArray alloc] initWithCapacity:2];
    _departments = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getDepartments]];
    _checkDepartments = [[NSMutableArray alloc] init];
    //搜索栏
    _headerBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    _headerBar.titles = @[@"部门",@"视频类型",@"筛选"];
    _headerBar.icontitles = @[@"",@"",@""];
    _headerBar.backgroundColor = WT_WHITE;
    _headerBar.delegate = self;
    [self.view addSubview:_headerBar];
    [_headerBar release];
    
    CGFloat rectY = _headerBar.frame.origin.y + _headerBar.frame.size.height;
    CGRect rect = CGRectMake(0, rectY, MAINWIDTH, MAINHEIGHT - rectY);
    
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = _departments;
    departmentVC.view.frame = rect;
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    
    //类型
    VideoTypeViewController *typeVC = [[VideoTypeViewController alloc] init];
    typeVC.view.frame = rect;
    typeVC.delegate  = self;
    typeVC.bSearch = YES;//搜索调用 加入不限类型
    [self addChildViewController:typeVC];
    [_searchViews addObject:self.childViewControllers[1].view];
    [typeVC release];
    
    //筛选
    NameFilterViewController *filterVC = [[[NSBundle mainBundle] loadNibNamed:@"NameFilterViewController" owner:self options:nil] lastObject];
    filterVC.delegate = self;
    filterVC.frame  = rect;
    [self initFilterViewParams:filterVC];
    [_searchViews addObject:filterVC];
    
    //表格部分
    //_tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT - 45) style:UITableViewStyleGrouped];
    _tableView.frame = CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT - 45);
    _tableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    _tableView.backgroundColor = WT_WHITE;
    _tableView.backgroundView = nil;
    _tableView.pullBackgroundColor = WT_YELLOW;
    _tableView.pullTextColor  = WT_BLACK;
    _tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.lblFunctionName.text = TITLENAME_LIST(FUNC_VIDEO_DES);
    
    [self.view addSubview:_tableView];
    [_tableView release];
    
    if (_videoParams != nil) {
        [self refreshTable];
    }else{
        [self refreshParamsAndTable];
    }
}

-(void) initFilterViewParams:(NameFilterViewController *) vc{
    if (_videoParams.paramUsers.count > 0) {
        vc._txtName.text = ((User *)[_videoParams.paramUsers objectAtIndex:0]).realName;
    }
}


-(void) refreshParams{
    VideoTopicParams_Builder *v = [VideoTopicParams builder];
    [v setPage:_index];
    if (_checkDepartments != nil && _checkDepartments.count > 0) {
        [v setDepartmentsArray:_checkDepartments];
    }
    if (_videoCategory != nil) {
        [v setCategory:_videoCategory];
    }
    if (_userName.length > 0) {
        User_Builder *ub = [User builder];
        [ub setId:-1];
        [ub setRealName:_userName];
        [v setParamUsersArray:@[[ub build]]];
    }
    if (_formTime.length > 0) {
        [v setStartDate:_formTime];
    }
    if (_endTime.length > 0) {
        [v setEndDate:_endTime];
    }
    _videoParams = [[v build] retain];
}

-(void) refreshParamsAndTable{
    [self refreshParams];
    [self refreshTable];
}

#pragma -mark NameFilterViewControllerDelegate
-(void)NameFilterViewControllerSearch:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"%@<%@<%@",name,formTime,endTime);
    _userName = name;
    _formTime = formTime;
    _endTime = endTime;
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerBar setColor:2];
    [self refreshParamsAndTable];
}

#pragma -mark VideoTypeDelegate
-(void)videoTypeSearch:(VideoTypeViewController *)controller didSelectWithObject:(id)aObject{
    UIButton *btn = _headerBar.buttons[1];
    if (aObject != nil)
    {
        _videoCategory = (VideoCategory*)aObject;
        [btn setTitle:_videoCategory.name forState:UIControlStateNormal];
        if (_videoCategory.id == -1) {
            _videoCategory = nil;
        }
    }else{
        [btn setTitle:_headerBar.titles[1] forState:UIControlStateNormal];
    }
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerBar setColor:1];
    [self refreshParamsAndTable];
}

#pragma -mark DepartmentViewControllerDelegate
-(void)didFnished:(NSMutableArray *)departments{
    NSLog(@"%d",departments.count);
    _checkDepartments = [departments retain];
    NSMutableString *ms = [[[NSMutableString alloc] init] autorelease];
    int i = 0;
    for (Department *item in departments) {
        if (i > 5) {
            break;
        }
        [ms appendFormat:@"%@,",item.name];
        i++;
    }
    UIButton *btn = _headerBar.buttons[0];
    [btn setTitle:departments.count > 0 ? [ms substringToIndex:ms.length - 1] : _headerBar.titles[0] forState:UIControlStateNormal];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerBar setColor:-1];
    [self refreshParamsAndTable];
}

#pragma -mark HeaderSearchBarDelegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    if (index == current) {
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        return;
    }
    [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
    [UIView removeViewFormSubViews:index views:_searchViews];
}

#pragma -mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{\
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _videoList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWHEADERHEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"VideoListCell";
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoListCell" owner:self options:nil] lastObject];
        [cell.videoReplyCount addTarget:self action:@selector(VideoListCellReplyTouch:) forControlEvents:UIControlEventTouchUpInside];
        cell.videoReplyCount.userInteractionEnabled = NO;
    }
    VideoTopic *video = _videoList[indexPath.row];
    cell.delegate = self;
    cell.videoReplyCount.tag = video.id;
    cell.video = video;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoDetailViewController *detailVC = [[VideoDetailViewController alloc] init];
    VideoTopic *video = _videoList[indexPath.row];
    detailVC.bNeedBack = YES;
    detailVC.bNetwork = YES;
    detailVC.videoId = video.id;
    detailVC.video = video;
    detailVC.delegate = self;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

#pragma -mark InputFinishDelegate

-(void)refresh:(id)obj{
    if (obj == nil) {
        return;
    }
    VideoTopic *video = nil;
    if ([obj isKindOfClass:[VideoTopic class]]) {
        video = obj;
    }
    for (int i = 0; i < _videoList.count; i ++ ) {
        VideoTopic *vt = _videoList[i];
        if (vt.id == video.id) {
            [_videoList removeObjectAtIndex:i];
            [_videoList insertObject:video atIndex:i];
            break;
        }
    }
    [_tableView reloadData];
}

-(void)VideoListCellReplyTouch:(UIButton*) button{
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"title_video_reply", nil);
    ctrl.delegate = self;
    ctrl.bNeedBack = YES;
    ctrl.tag = button.tag;
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)didFinishInput:(int)tag Input:(NSString *)input{
    NSLog(@"回复内容:%@",input);
    if (input.length == 0) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", nil);
    
    VideoTopicReply_Builder *v = [VideoTopicReply builder];
    [v setSender:USER];
    [v setCreateDate:[NSDate getCurrentDateTime]];
    [v setContent:input];
    [v setId:0];
    [v setVideoTopicId:tag];
    _replyVideoID = tag;
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicReply param:[v build]]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"title_video_reply", nil)
                          description:NSLocalizedString(@"video_reply_empty", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
    }
}

#pragma -mark 加载&刷新

-(void) loadMoreData{
    _tableView.pullTableIsLoadingMore = YES;
    _tableView.pullTableIsRefreshing = NO;
    if (_index * _pageSize < _totalSize) {
        _index ++;
        VideoTopicParams_Builder *v = [_videoParams toBuilder];
        [v setPage:_index];
        _videoParams = [[v build] retain];
//        _videoParams = [v build];
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicList param:_videoParams]) {
            _tableView.pullTableIsLoadingMore = NO;
            _tableView.pullTableIsRefreshing = NO;
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                              description:NSLocalizedString(@"error_connect_server", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            return;
        }
    }else{
        _tableView.pullTableIsLoadingMore = NO;
    }
    
}

-(void) refreshTable{
    _tableView.pullTableIsRefreshing = YES;
    _tableView.pullLastRefreshDate = [NSDate date];
    _index = 1;
    if (_videoParams != nil) {
        VideoTopicParams_Builder *v = [_videoParams toBuilder];
        [v setPage:_index];
        _videoParams = [v build];
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicList param:_videoParams]) {
            _tableView.pullTableIsLoadingMore = NO;
            _tableView.pullTableIsRefreshing = NO;
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                              description:NSLocalizedString(@"error_connect_server", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }
    }
}

#pragma -mark WebSocketDelegate

-(void)didReceiveMessage:(id)message{
    SessionResponse *sr = [SessionResponse parseFromData:message];
    if ([super validateSessionResponse:sr]) {
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
        return;
    }
    switch (INT_ACTIONTYPE(sr.type)) {
        case ActionTypeVideoTopicList:    //列表拉取
        {
            if([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
                PageVideoTopic *page = [PageVideoTopic parseFromData:sr.data];
                if (_index == 1 && _videoList.count > 0) {
                    [_videoList removeAllObjects];
                }
                _pageSize = page.page.pageSize;
                _totalSize = page.page.totalSize;
                for (int i = 0; i < page.videoTopics.count; i++) {
                    [_videoList addObject:[page.videoTopics objectAtIndex:i]];
                }
                if (_videoList.count == 0) {
                    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)                                      description:NSLocalizedString(@"noresult", nil)
                                             type:MessageBarMessageTypeInfo
                                      forDuration:INFO_MSG_DURATION];
                }
            }
            [_tableView reloadData];
            [self showMessage2:sr Title:TITLENAME(FUNC_VIDEO_DES)
                   Description:@""];
            break;
        }
        case ActionTypeVideoTopicReply:   //消息回复
        {
            HUDHIDE2;
            if([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]){
                for (int i = 0; i < _videoList.count; i ++) {
                    VideoTopic *video = _videoList[i];
                    if (video.id == _replyVideoID) {
                        VideoTopic_Builder *pb = [video toBuilder];
                        [pb setReplyCount:video.replyCount + 1];
                        [_videoList removeObjectAtIndex:i];
                        [_videoList insertObject:[pb build] atIndex:i];
                        break;
                    }
                }
                [_tableView reloadData];
            }
            [self showMessage2:sr Title:TITLENAME(FUNC_VIDEO_DES)                   Description:NSLocalizedString(@"video_msg_reply_saved", nil)];
            break;
        }
        default:
            break;
    }
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
    [super didFailWithError:error];
}
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}

#pragma -mark PullTableViewDelegate
-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView{
    [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:RELOAD_DELAY];
}

-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [_tableView release];
    [_tableView release];
    [super dealloc];
}
@end
