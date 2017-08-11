//
//  VIdeoDetailViewController.m
//  SalesManager
//
//  Created by Administrator on 15/11/9.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "VIdeoDetailViewController.h"
#import "PatrolDetailCustomerCell.h"
#import "PatrolDetailHeader.h"
#import "PlayVideViewController.h"
#import "VideoCustomerDetailCell.h"
#import "PatrolDetailReplyCell.h"
#import "SDImageView+SDWebCache.h"
#import "InputViewController.h"
#import "VideoPostViewController.h"
#import "PlayVideoCell.h"
#import "NSDate+Util.h"
#import "VideoListViewController.h"
#import "UploadListViewController.h"
#import "BottomButtonView.h"
#import "LableCell.h"

@interface VideoDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate,InputFinishDelegate,AppBecomeActiveDelegate>

@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    _replys = [[NSMutableArray alloc] init];
    
    if (_video != nil) {
        self.lblFunctionName.text = TITLENAME_STR(FUNC_VIDEO_DES, _video.user.realName);
    }else{
        self.lblFunctionName.text = TITLENAME_DETAIL(FUNC_VIDEO_DES);
    }
    
    CGFloat tableHeight = _bNetwork ? MAINHEIGHT - 45 : MAINHEIGHT;
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, tableHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    _tableView.backgroundView = nil;
    _tableView.pullBackgroundColor = [UIColor yellowColor];
    _tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *reFreshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [reFreshImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    reFreshImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshV)];
    [tapGesture setNumberOfTapsRequired:1];
    reFreshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [reFreshImageView addGestureRecognizer:tapGesture];
    [rightView addSubview:reFreshImageView];
    [reFreshImageView release];
    [tapGesture release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.rightButton = btRight;
    [btRight release];
    
    [self createBottomBar];
    [self refreshData];
    //返回后 继续播放
    APPDELEGATE.appBeComeActiveDelegate = self;
}

-(void)appBeComeActive{
    if (_playVideoCell.player != nil && _playVideoCell.player.currentItem != nil && _playVideoCell.bPlayEnd == NO) {
        [_playVideoCell.player play];
    }
    [super appBeComeActive];
}

-(void)refreshV{
    _index = 1;
    
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    //网络数据绑定
    if (_bNetwork && _videoId > 0) {
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullLastRefreshDate = [NSDate date];
        VideoTopicParams_Builder *v = [VideoTopicParams builder];
        [v setSource:[NSString stringWithFormat:@"%d",_videoId]];
        VideoTopicParams * params = [[v build] retain];
        NSLog(@"详情ID：%d",_videoId);
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicGet param:params]) {
            _tableView.pullTableIsLoadingMore = NO;
            _tableView.pullTableIsRefreshing = NO;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_video_detail", nil)
                              description:NSLocalizedString(@"error_connect_server", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:RELOAD_DELAY];
        }
    }else{
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
    }
}

-(void)clickLeftButton:(id)sender{
    @try {
        [_playVideoCell.player pause];
        [_playVideoCell.player replaceCurrentItemWithPlayerItem:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"暂停播放异常.....");
    }
    //回调刷新
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refresh:)]) {
        [_delegate refresh:_video];
    }
    [_playVideoCell removeFromSuperview];
    _playVideoCell = nil;
    [super clickLeftButton:sender];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma -mark 页面方法

-(void)createBottomBar{
    
    
    if (!_bNetwork) {
        
        //保存按钮
        UIButton *rightButtonView = [[UIButton alloc] initWithFrame:CGRectMake(0,15, 30, 30)];
        [rightButtonView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
        [rightButtonView setTitle:[NSString fontAwesomeIconStringForEnum:ICON_SAVE] forState:UIControlStateNormal];
        [rightButtonView setTitleColor:WT_RED forState:UIControlStateNormal];
        [rightButtonView addTarget:self action:@selector(toSave) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.rightButton = rightButton;
        [rightButtonView release];
        [rightButton release];
        
    }else{
        BottomButtonView *bottomBtns = [[BottomButtonView alloc] initWithFrame:CGRectMake(0, MAINHEIGHT - 45, MAINWIDTH, 45)];
        bottomBtns.titles = @[NSLocalizedString(@"title_reply", nil),NSLocalizedString(@"上传", nil)];
        bottomBtns.buttonSelected = ^(NSInteger index){
            NSLog(@"buttonIndex:%d",index);
            if (index == 0) {
                [self toReply];
            }else{
                [self toUpload];
            }
        };
        [self.view addSubview:bottomBtns];
        [bottomBtns release];
    }
}

-(void) toSave{
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString* vurl =[PATH_OF_DOCUMENT stringByAppendingPathComponent:[_video.videoPaths objectAtIndex:0]];
    NSString* iurl = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[_video.filePaths objectAtIndex:0]];
    if (![fileManager fileExistsAtPath:vurl]
        || ![fileManager fileExistsAtPath:iurl]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_video_detail", nil)
                          description:NSLocalizedString(@"cache_file_notfind", nil)
                                 type:MessageBarMessageTypeInfo forDuration:INFO_MSG_DURATION];
        [fileManager release];
        return;
    }
    [fileManager release];
    
    SHOWHUD2WINDOW;
    
    VideoTopic_Builder *v = [_video toBuilder];
    [v setUploadDate:[NSDate getCurrentDateTime]];
    if (APPDELEGATE.myLocation != nil) {
        [v setUploadLocation:APPDELEGATE.myLocation];
    }
    
    NSData *data = [NSData dataWithContentsOfFile:iurl];
    [v setFilesArray:@[data]];
    data = [NSData dataWithContentsOfFile:vurl];
    [v setVideosArray:@[data]];
    NSLog(@"video address:%@",_video.location.address);
    
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicSave param:[v build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_video_detail", nil)
                          description:NSLocalizedString(@"error_connect_server", nil)
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void)didReceiveMessage:(id)message{
    SessionResponse *sr = [SessionResponse parseFromData:message];
    HUDHIDE2;
    //上传缓存
    if ([super validateSessionResponse:sr]) {
        return;
    }
    if (INT_ACTIONTYPE(sr.type) == ActionTypeVideoTopicSave) {
        if ([NS_ACTIONCODE(ActionCodeDone) isEqual:sr.code]) {
            [self showMessage2:sr Title:NSLocalizedString(@"bar_video_detail", nil)
                   Description:NSLocalizedString(@"video_msg_saved", nil)];
            //清除文件缓存
            [LOCALMANAGER clearImagesWithFiles:[NSMutableArray arrayWithObjects:[_video.filePaths objectAtIndex:0],[_video.videoPaths objectAtIndex:0], nil]];
            //清除数据缓存
            [LOCALMANAGER deleteCache:FUNC_VIDEO Content:_video.dataStream];
            //回调刷新
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refresh:)]) {
                [_delegate refresh:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showMessage2:sr Title:NSLocalizedString(@"note", nil) Description:@""];
        }
        
        //详情拉取
    }else if (INT_ACTIONTYPE(sr.type) == ActionTypeVideoTopicGet){
        if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
            _video = [[VideoTopic parseFromData:sr.data] retain];
            self.lblFunctionName.text = TITLENAME_STR(FUNC_VIDEO_DES, _video.user.realName);
            [_tableView reloadData];
            [self getRplys];
        }else{
            [self showMessage2:sr Title:NSLocalizedString(@"note", nil) Description:@""];
        }
        
        //回复视频
    }else if (INT_ACTIONTYPE(sr.type) == ActionTypeVideoTopicReply){
        HUDHIDE2;
        if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
            if (_reply != nil) {
                [_replys insertObject:_reply atIndex:0];
            }
            VideoTopic_Builder *v = [_video toBuilder];
            [v setReplyCount:_replys.count];
            _video = [[v build] retain];
            [self.navigationController popViewControllerAnimated:YES];
            [_tableView reloadData];
            [self showMessage2:sr Title:NSLocalizedString(@"note", nil)
                   Description:NSLocalizedString(@"video_msg_reply_saved", nil)];
            return ;
        }else{
            [self showMessage2:sr Title:NSLocalizedString(@"note", nil) Description:@""];
        }
        
        //视频回复列表拉取
    }else if (INT_ACTIONTYPE(sr.type) == ActionTypeVideoTopicReplyList){
        if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
            Pagination *page = [Pagination parseFromData:sr.data];
            _totalSize = page.totalSize;
            _pageSize = page.pageSize;
            if (_index == 1) {
                [_replys removeAllObjects];
            }
            for (int i = 0; i < page.datas.count; i++) {
                VideoTopicReply *item = [VideoTopicReply parseFromData:[page.datas objectAtIndex:i]];
                [_replys addObject:item];
            }
            [_tableView reloadData];
        }else{
            [self showMessage2:sr Title:NSLocalizedString(@"note", nil) Description:@""];
        }
    }
    
    if (INT_ACTIONTYPE(sr.type) == ActionTypeVideoTopicReplyList || ![sr.code isEqualToString:NS_ACTIONCODE(ActionCodeDone)]) {
        _tableView.pullTableIsLoadingMore = NO;
        _tableView.pullTableIsRefreshing = NO;
    }
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    _tableView.pullTableIsRefreshing = NO;
    
    _tableView.pullTableIsLoadingMore = NO;
    [super didFailWithError:error];
}

-(void) getRplys{
    //继续拉取视频 回复
    VideoTopicParams_Builder *v = [VideoTopicParams builder];
    [v setSource:[NSString stringWithFormat:@"%d",_videoId]];
    [v setPage:_index];
//    [[v build] retain];
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicReplyList param:[v build]]) {
        _tableView.pullTableIsLoadingMore = NO;
        _tableView.pullTableIsRefreshing = NO;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_video_detail", nil)
                          description:NSLocalizedString(@"error_connect_server", nil)
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void) toReply{
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"title_video_reply", nil);
    ctrl.delegate = self;
    ctrl.bNeedBack = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void) toUpload{
    VideoPostViewController *postVC = [[VideoPostViewController alloc] init];
    postVC.bNeedBack = YES;
    postVC.hidenImageBool = YES;
    [self.navigationController pushViewController:postVC animated:YES];
    [postVC release];
}

-(void) playVideo{
    NSLog(@"播放视频");
    PlayVideViewController *playVC = [[PlayVideViewController alloc] init];
    NSString *videoUrl = [_video.videoPaths objectAtIndex:0];
    playVC.videoPath = videoUrl;
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:playVC];
    navCtrl.navigationBarHidden = YES;
    [self presentViewController:navCtrl animated:YES completion:nil];
    [playVC release];
    [navCtrl release];
}

-(void) loadMoreData{
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullTableIsLoadingMore = YES;
    if (_index * _pageSize < _totalSize) {
        _index++;
        [self getRplys];
    }else{
        _tableView.pullTableIsLoadingMore = NO;
    }
}

-(void) refreshData{
    _index = 1;
    //网络数据绑定
    if (_bNetwork && _videoId > 0) {
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullLastRefreshDate = [NSDate date];
        VideoTopicParams_Builder *v = [VideoTopicParams builder];
        [v setSource:[NSString stringWithFormat:@"%d",_videoId]];
        VideoTopicParams * params = [[v build] retain];
        NSLog(@"详情ID：%d",_videoId);
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicGet param:params]) {
            _tableView.pullTableIsLoadingMore = NO;
            _tableView.pullTableIsRefreshing = NO;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_video_detail", nil)
                              description:NSLocalizedString(@"error_connect_server", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:RELOAD_DELAY];
        }
    }else{
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
    }
}

#pragma -mark 回复回调
-(void)didFinishInput:(int)tag Input:(NSString *)input{
    NSLog(@"回复内容:%@",input);
    if (input.length == 0) {
        return;
    }
    if (_bNetwork && _videoId > 0) {
        SHOWHUD2VIEW;
        VideoTopicReply_Builder *v = [VideoTopicReply builder];
        [v setSender:USER];
        [v setCreateDate:[NSDate getCurrentDateTime]];
        [v setContent:input];
        [v setId:0];
        [v setVideoTopicId:_videoId];
        
        _reply = [[v build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicReply param:_reply]) {
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"title_video_reply", nil)
                              description:NSLocalizedString(@"video_reply_empty", nil)
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
        }
    }
    
}


#pragma -mark UITableViewCellDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 3) {
        return _replys.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1.f;
    }
    return 35.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 320.f;
        }
        VideoCustomerDetailCell *cell = [[[VideoCustomerDetailCell alloc] init] autorelease];
        return [cell getCellHeight:_video.location.address cacheAdd:_video.uploadLocation.address];
    }
    if (indexPath.section == 1) {
        return 36.f;
    }
    if (indexPath.section == 2) {
        CGSize size = [super rebuildSizeWithString:_video.comment ContentWidth:MAINWIDTH FontSize:FONT_SIZE + 1];
        return MAX(size.height + 10, 110.f);
    }
    if (indexPath.section == 3) {
        CGSize size = [super rebuildSizeWithString:((VideoTopicReply*)_replys[indexPath.row]).content ContentWidth:MAINWIDTH - 35 FontSize:FONT_SIZE + 1];
        return MAX(size.height + 45.f, 75.f);
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PatrolDetailHeader* header = [[[NSBundle mainBundle] loadNibNamed:@"PatrolDetailHeader" owner:self options:nil] lastObject];
    if (section == 1) {
        header.title.text = NSLocalizedString(@"video_label_title", nil);
    }else if(section == 2){
        header.title.text = NSLocalizedString(@"title_live_info", nil);
    }else if (section == 3){
        header.title.text = NSLocalizedString(@"title_live_reply", nil);
    }else{
        header.title.text = @"";
    }
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellid = @"VidelPlayCell";
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                _playVideoCell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if (_playVideoCell == nil) {
                    _playVideoCell = [[[PlayVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid bNetwork:_bNetwork] retain];
                    _playVideoCell.frame = CGRectMake(0, 0,MAINWIDTH, MAINWIDTH);
                    _playVideoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                _playVideoCell.imgPath = [_video.filePaths objectAtIndex:0];
                _playVideoCell.videoPath = [_video.videoPaths objectAtIndex:0];
                return _playVideoCell;
            }else{
                VideoCustomerDetailCell* cell = (VideoCustomerDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"VideoCustomerDetailCell"];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoCustomerDetailCell" owner:self options:nil] lastObject];
                }
                cell.bNetwork = _bNetwork;
                cell.video = _video;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        case 1:
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellTitle"];
            UILabel *videoTitle = nil;
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellTitle" ];
                videoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MAINWIDTH - 35, 36)];
                [videoTitle setBackgroundColor:[UIColor clearColor]];
                videoTitle.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
                videoTitle.textAlignment = UITextAlignmentLeft;
                videoTitle.numberOfLines = 2;
                [cell addSubview:videoTitle];
                [videoTitle release];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            videoTitle.text = _video.title;
            return cell;
        }
        case 2:
        {
            LableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellComment"];
            if (cell == nil) {
                cell = [[LableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellComment"];
            }
            CGSize tmpSize = [super rebuildSizeWithString:_video.comment ContentWidth:MAINWIDTH - 10 FontSize:FONT_SIZE + 1];
            [cell setText:_video.comment size:tmpSize];
            return cell;
        }
        case 3:
        {
            PatrolDetailReplyCell *detailCell  = [tableView dequeueReusableCellWithIdentifier:@"PatrolDetailReplyCell"];
            if (detailCell == nil) {
                detailCell = [[[NSBundle mainBundle] loadNibNamed:@"PatrolDetailReplyCell" owner:self options:nil] lastObject];
            }
            detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            detailCell.accessoryType = UITableViewCellAccessoryNone;
            VideoTopicReply *reply = _replys[indexPath.row];
            NSString* avatar = @"";
            if (reply.content != nil && reply.content.length > 0) {
                if (reply.sender.avatars.count > 0) {
                    avatar = [reply.sender.avatars objectAtIndex:0  ];
                }
                [detailCell.icon setImageWithURL:[NSURL URLWithString:avatar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
                detailCell.icon.layer.cornerRadius = 30.f;
                detailCell.icon.layer.masksToBounds = YES;
                detailCell.name.text = reply.sender.realName;
                detailCell.time.text = reply.createDate;
                CGSize size = [super rebuildSizeWithString:reply.content ContentWidth:MAINWIDTH - 35 FontSize:FONT_SIZE + 1];
                CGFloat height = MAX(size.height, 42.f);
                CGRect rect = detailCell.content.frame;
                UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 3, rect.size.width, height)];
                lable.backgroundColor = [UIColor clearColor];
                lable.text = reply.content;
                lable.numberOfLines = 0;
                lable.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
                lable.textColor = WT_GRAY;
                [detailCell.contentView addSubview:lable];
                [lable release];
                lable = nil;
                detailCell.content.hidden = YES;
                detailCell.content.text = reply.content;
            }
            detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return detailCell;
        }
        default:
            break;
    }
    return nil;
}

#pragma -mark 上啦下来
-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView{
    [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:RELOAD_DELAY];
}

-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView{
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
