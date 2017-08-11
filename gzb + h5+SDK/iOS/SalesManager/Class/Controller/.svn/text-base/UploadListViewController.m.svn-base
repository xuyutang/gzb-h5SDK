//
//  UploadListViewController.m
//  SalesManager
//
//  Created by Administrator on 15/11/5.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "UploadListViewController.h"
#import "UploadVideoCell.h"
#import "VideoDetailViewController.h"
#import "SWTableViewCell.h"
#import "NSDate+Util.h"
#import "NSDate+Util.h"

@interface UploadListViewController ()<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,SWTableViewCellDelegate,RefreshDelegate,UIActionSheetDelegate>

@end

@implementation UploadListViewController{
    SWTableViewCell *selectedCell;
}

- (void)viewDidLoad {
    bNeedBack = YES;
    [super viewDidLoad];
    lblFunctionName.text = NSLocalizedString(@"bar_video_post_task", nil);
    _tableView.frame = CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT);
    _tableView.delegate = self;
    _tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    _tableView.pullBackgroundColor = [UIColor yellowColor];
    _tableView.pullTextColor = [UIColor blackColor];
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    _tableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    _tableView.userInteractionEnabled = YES;
    _tableView.scrollEnabled = YES;
    _tableView.backgroundColor = WT_WHITE;
    _tableView.backgroundView = nil;

    
//    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
//    
//    UILabel* editBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 50, 30)];
//    editBtn.tag = 1;
//    editBtn.textColor = WT_RED;
//    editBtn.text = [NSString fontAwesomeIconStringForEnum:ICON_LIST];
//    editBtn.textAlignment = UITextAlignmentCenter;
//    editBtn.font = [UIFont fontWithName:@"FontAwesome" size:25];
//    editBtn.contentMode = UIViewContentModeScaleAspectFit;
//    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTouch)];
//    gesture.numberOfTapsRequired = 1;
//    [editBtn addGestureRecognizer:gesture];
//    [gesture release];
//    editBtn.userInteractionEnabled = YES;
//    [rightView addSubview:editBtn];
//    [editBtn release];
//    
//    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//    self.rightButton = rightBtn;
//    [rightView release];
//    [rightBtn release];
    
    //[self initData];
    [self performSelector:@selector(initData) withObject:nil afterDelay:RELOAD_DELAY];
}


-(void) initData{
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, RELOAD_DELAY * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        _index = 1;
        _uploadFiles = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getCacheWithFuncId:FUNC_VIDEO Index:_index]];
        NSLog(@"缓存条数:%d",_uploadFiles.count);
        if (_uploadFiles.count == 0) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_video_post_task", nile)
                              description:NSLocalizedString(@"noresult", nil)
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
        }
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
        [_tableView reloadData];
    });
}

//无下拉动画加载
-(void) callbackReloadData{
    _uploadFiles = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getCacheWithFuncId:FUNC_VIDEO Index:_index]];
    [_tableView reloadData];
}


-(void) loadMoreDataToTable{
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = YES;
    _index++;
    NSMutableArray* moreData = [LOCALMANAGER getCacheWithFuncId:FUNC_VIDEO Index:_index];
    if (moreData.count > 0) {
        [_uploadFiles addObjectsFromArray:moreData];
    }
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullTableIsLoadingMore = NO;
    [_tableView reloadData];
}

-(void) editTouch{
    
}

#pragma -mark UITableViewDelegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _uploadFiles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWHEADERHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellid = @"UploadVideoCell";
    UploadVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
        [buttons addUtilityButtonWithColor:WT_RED title:NSLocalizedString(@"cell_delete", nil)];
        cell = [[UploadVideoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellid
                                  containingTableView:tableView
                                            rowHeight:80.f
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:buttons];
        [cell.btnUpload addTarget:self action:@selector(toSave:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.btnUpload.tag = indexPath.section;
    VideoTopic* video = _uploadFiles[indexPath.section];
    cell.parentView = self;
    cell.delegate = self;
    cell.video = video;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//本地查看功能移除
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    VideoTopic *v = _uploadFiles[indexPath.section];
//    VideoDetailViewController *detailVC = [[VideoDetailViewController alloc] init];
//    detailVC.video = [v retain];
//    detailVC.bNeedBack = YES;
//    detailVC.bNetwork = NO;
//    detailVC.delegate = self;
//    [self.navigationController pushViewController:detailVC animated:YES];
//    [detailVC release];
//}

#pragma -mark 保存数据
-(void) toSave:(UIButton*) icon{
    VideoTopic *video = _uploadFiles[icon.tag];
    _cacheVideo = [video retain];
    NSString* iurl = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[video.filePaths objectAtIndex:0]];
    NSString* vurl = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[video.videoPaths objectAtIndex:0]];
    //缓存文件检查
    NSFileManager *io = [[NSFileManager alloc] init];
    if (![io fileExistsAtPath:iurl]
        || ![io fileExistsAtPath:vurl]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_video_post_task", nil)
                          description:NSLocalizedString(@"cache_file_notfind", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:MSG_DONTROUTE];
        [io release];
        return;
    }
    [io release];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", nil);
    
    VideoTopic_Builder *v = [video toBuilder];
    [v setUploadDate:[NSDate getCurrentDateTime]];
    if (APPDELEGATE.myLocation != nil) {
        [v setUploadLocation:APPDELEGATE.myLocation];
    }
    NSData *data = [NSData dataWithContentsOfFile:iurl];
    [v setFilesArray:@[data]];
    data = [NSData dataWithContentsOfFile:vurl];
    [v setVideosArray:@[data]];
    video = [v build];
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicSave param:video]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_video_post_task", nil)
                          description:NSLocalizedString(@"error_connect_server", nil)
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void)didReceiveMessage:(id)message{
    SessionResponse *sr = [SessionResponse parseFromData:message];
    HUDHIDE2;
    if ([super validateSessionResponse:sr]) {
        return;
    }
    switch (INT_ACTIONTYPE(sr.type)) {
        case ActionTypeVideoTopicSave:
        {
            
            if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
                if (_cacheVideo != nil) {
                    //清楚缓存文件
                    [LOCALMANAGER clearImagesWithFiles:[NSMutableArray arrayWithObjects:[_cacheVideo.filePaths objectAtIndex:0],[_cacheVideo.videoPaths objectAtIndex:0], nil]];
                    //清除缓存数据
                    [LOCALMANAGER deleteCache:FUNC_VIDEO Content:_cacheVideo.dataStream];
                    [_uploadFiles removeObject:_cacheVideo];
                    [_tableView reloadData];
                }
                [_cacheVideo release];
                _cacheVideo = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
            }
            [self showMessage2:sr
                         Title:NSLocalizedString(@"bar_video_post_task", nil)
                   Description:NSLocalizedString(@"video_msg_saved", nil)];
            break;
        }
        default:
            break;
    }
}

#pragma -mark SWTableViewCellDelegate
-(void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    selectedCell = cell;
    NSIndexPath *indexPath = [_tableView indexPathForCell:selectedCell];
    VideoTopic* delCacheVideo = _uploadFiles[indexPath.section];
    if (delCacheVideo != nil && delCacheVideo.videoPaths > 0) {
        NSMutableArray* delArrays =[NSMutableArray arrayWithArray:@[[delCacheVideo.filePaths objectAtIndex:0],
                                                                    [delCacheVideo.videoPaths objectAtIndex:0]]];
        [LOCALMANAGER clearImagesWithFiles:delArrays];
    }
    [LOCALMANAGER deleteCache:FUNC_VIDEO Content:delCacheVideo.dataStream];
    [_uploadFiles removeObjectAtIndex:indexPath.section];
    //[_tableView reloadData];
    NSLog(@"%d,%d",indexPath.section,indexPath.row);
    [_tableView beginUpdates];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:indexPath.section];
    [_tableView deleteSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
}


#pragma -mark 刷新下拉
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView{
    [self performSelector:@selector(initData) withObject:nil afterDelay:RELOAD_DELAY];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}

#pragma -mark VideoDetailDelegate
-(void)refresh:(id)obj{
    [self performSelector:@selector(callbackReloadData) withObject:nil afterDelay:0];
}

-(void)dealloc{
    [_tableView release];
    [_uploadFiles release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [_tableView release];
    [_uploadFiles release];
    _tableView = nil;
    _uploadFiles = nil;
    [super didReceiveMemoryWarning];
}

@end
