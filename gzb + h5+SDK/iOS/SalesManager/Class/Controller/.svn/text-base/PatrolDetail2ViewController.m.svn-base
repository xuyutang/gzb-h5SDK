//
//  PatrolDetail2ViewController.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-11.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "PatrolDetail2ViewController.h"
#import "TopicImageCell.h"
#import "PatrolDetailCustomerCell.h"
#import "TextViewCell.h"
#import "PatrolDetailHeader.h"
#import "SDImageView+SDWebCache.h"
#import "InputViewController.h"
#import "PatrolDetailReplyCell.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "NSDate+Util.h"
#import "PatrolViewController.h"
#import "BigImageViewController.h"
#import "PullTableView.h"
#import "BottomButtonView.h"
@interface PatrolDetail2ViewController ()<UITableViewDataSource,UITableViewDelegate,EScrollerViewDelegate,InputFinishDelegate,PullTableViewDelegate>{
    PullTableView *_tableView;
    PatrolReply *patrolReply;
    TopicImageCell *topCell;
    NSMutableArray* replies;
    UIView *rightView;
    
    int currentPage;
    int pageSize;
    int totleSize;
}

@end

@implementation PatrolDetail2ViewController
@synthesize patrolId,msgType,delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh)];
    saveImageView.userInteractionEnabled = YES;
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [tapGesture2 release];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = rightButton;
    [saveImageView release];
    [rightButton release];
    [rightView release];
    

    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT-45) style:UITableViewStylePlain];
    _tableView.pullBackgroundColor = [UIColor yellowColor];
    _tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pullDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
    [self createBottomBar];
    
    if (_patrol != nil) {
        [self _show];
    }else{
        [self _getPatrol];
    }
    lblFunctionName.text = TITLENAME(FUNC_PATROL_DES);
    
    replies = [[NSMutableArray alloc] init];
}

-(void)_show{
    [_tableView reloadData];
}

-(void)refresh {
    _tableView.contentOffset = CGPointMake(0, 0);
    currentPage = 1;
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = NO;
    
    PatrolParams_Builder* pb = [PatrolParams builder];
    
    [pb setId:patrolId];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypePatrolGet param:[pb build]]){
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }

    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
}

- (void) _getPatrol{
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = YES;
    
    PatrolParams_Builder* pb = [PatrolParams builder];
    
    [pb setId:patrolId];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypePatrolGet param:[pb build]]){
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void) _getPatrolReply{
    PatrolParams_Builder* pb = [PatrolParams builder];
    [pb setId:patrolId];
    [pb setPage:currentPage];
    
    if (DONE != [AGENT sendRequestWithType:ActionTypePatrolReplyList param:[pb build]]){
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void)appBeComeActive{
    if (_playVideoCell.player != nil && _playVideoCell.player.currentItem != nil && _playVideoCell.bPlayEnd == NO) {
        [_playVideoCell.player play];
    }
    [super appBeComeActive];
}

-(void)clickLeftButton:(id)sender{
    @try {
        [_playVideoCell.player pause];
        [_playVideoCell.player replaceCurrentItemWithPlayerItem:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"暂停播放异常.....");
    }
    [_playVideoCell removeFromSuperview];
    _playVideoCell = nil;
    if (delegate != nil && [delegate respondsToSelector:@selector(refresh:)]) {
        [delegate refresh:_patrol];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)createBottomBar{
    BottomButtonView *bottomBtns = [[BottomButtonView alloc] initWithFrame:CGRectMake(0, MAINHEIGHT - 45, MAINWIDTH, 45)];
    bottomBtns.titles = @[NSLocalizedString(@"title_reply", nil),NSLocalizedString(@"title_upload", nil)];
    bottomBtns.buttonSelected = ^(NSInteger index){
        NSLog(@"buttonIndex:%d",index);
        if (index == 0) {
            [self toReply];
        }else{
            [self toPatrol];
        }
    };
    [self.view addSubview:bottomBtns];
    [bottomBtns release];
}

-(void)toReply{
    InputViewController *ctrl = [[InputViewController alloc] init];
    ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
    //ctrl.tag = view.tag;
    ctrl.delegate = self;
    ctrl.bNeedBack = YES;
    //[self presentViewController:ctrl animated:YES completion:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)toPatrol{
    PatrolViewController *vctrl = [[PatrolViewController alloc] init];
    vctrl.hideListImagViewBool = YES;
    vctrl.taskCustomer = _patrol.customer;
    vctrl.bNeedBack = YES;
    [self.navigationController pushViewController:vctrl animated:YES];
}

-(void)didFinishInput:(int)tag Input:(NSString *)input{
    APPDELEGATE.agent.delegate = self;

    NSString *strReply = input.trim;
    
   if (strReply.length == 0) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"worklog_hint_reply", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];

        return;
    }
    
    if (strReply.length >1000) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                          description:NSLocalizedString(@"input_limit_1000", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
   
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"loading", @"");
        
        PatrolReply_Builder* prb = [PatrolReply builder];
        
        [prb setContent:strReply];
        [prb setCreateDate:[NSDate getCurrentTime]];
        [prb setSender:USER];

        [prb setId:-1];
        [prb setPatrolId:_patrol.id];
        
        PatrolReply* pr = [[prb build] retain];
        patrolReply = [pr retain];
        
        if (DONE != [APPDELEGATE.agent sendRequestWithType:ActionTypePatrolReply param:pr]){
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"worklog_label_reply", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }

}

-(void)clearTable{
    if (replies.count > 0){
        [replies removeAllObjects];
    }
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE;
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypePatrolReply:{
            HUDHIDE;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                if (patrolReply != nil){
                    [replies insertObject:patrolReply atIndex:0];
                }
                Patrol_Builder* wb = [_patrol toBuilder];
                [wb setReplyCount:replies.count];
                [_patrol release];
                _patrol = nil;
                _patrol = [[wb build] retain];
            }
            [self.navigationController popViewControllerAnimated:YES];
            [_tableView reloadData];
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:NSLocalizedString(@"patrolreply_msg_saved", @"")];
        }
            break;
            
        case ActionTypePatrolGet:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                Patrol* p = [Patrol parseFromData:cr.data];
                if ([super validateData:p]) {
                    _patrol = [p retain];
                    self.lblFunctionName.text = TITLENAME_STR(FUNC_PATROL_DES, _patrol.user.realName);
                    [self _getPatrolReply];
                }
            }
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",patrolId]];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
        }
            break;
        case ActionTypePatrolReplyList:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                Pagination* pageReply = [Pagination parseFromData:cr.data];
                
                pageSize = pageReply.pageSize;
                totleSize = pageReply.totalSize;
                if (currentPage == 1) {
                    [self clearTable];
                }
                for (int i = 0; i < pageReply.datas.count; ++i) {
                    PatrolReply* wr = [PatrolReply parseFromData:[pageReply.datas objectAtIndex:i]];
                    if (![super validateData:wr]) {
                        continue;
                    }else{
                        [replies addObject:wr];
                    }
                }
                [_tableView reloadData];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
            
        }
            break;
        default:
            break;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypePatrolReplyList) || (INT_ACTIONCODE(cr.code) != ActionCodeDone)){
        _tableView.pullTableIsRefreshing = NO;
        _tableView.pullTableIsLoadingMore = NO;
    }
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }if (section == 2) {
        return replies.count;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([_patrol.mediaType isEqualToString:PATROL_FUNC_VIDEO]) {
                return 320.f;
            }
            return 150.f;
        }else{
            return 60.f;
        }
    }else if (indexPath.section == 1){
        return 110.f;
    }else{
        NSString* text = ((PatrolReply*)[replies objectAtIndex:indexPath.row]).content;
        CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
        
        CGFloat height = MAX(size.height + 45.0f, 75.0f);
        return height;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1.f;
    }else{
        return 35.f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolDetailHeader" owner:self options:nil];
    PatrolDetailHeader *header = [nib objectAtIndex:0];
    if (section == 1) {
        header.title.text = NSLocalizedString(@"title_live_info", nil);
    }else if(section == 2){
        if (replies.count) {
            header.title.text = @"巡访回复";
        }else {
        
         header.title.text = @"";
        }
        
    }else{
        header.title.text = @"";
    }
    return header;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([_patrol.mediaType isEqualToString:PATROL_FUNC_PICTURE]) {
                topCell = [tableView dequeueReusableCellWithIdentifier:@"TopicImageCell"];
                if (topCell == nil) {
                    topCell = [[TopicImageCell alloc] init];
                }
                topCell.selectionStyle = UITableViewCellSelectionStyleNone;
                topCell.accessoryType = UITableViewCellAccessoryNone;
                
                NSMutableArray *imageFiles = [[NSMutableArray alloc] init];
                NSMutableArray *titles = [[NSMutableArray alloc] init];
                for (int i = 0; i<[_patrol.filePath count]; i++) {
                    [imageFiles addObject:[_patrol.filePath objectAtIndex:i]];
                    [titles addObject:_patrol.customer.name];
                }
                if (imageFiles.count >0) {
                    [topCell initTopicWithTitle:titles Images:imageFiles];
                    topCell.imgScrollView.delegate = self;
                }
                return topCell;
            }
            _playVideoCell = [[[PlayVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlayVideoCell" bNetwork:YES] retain];
            _playVideoCell.frame = CGRectMake(0, 0,MAINWIDTH, MAINWIDTH);
            _playVideoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _playVideoCell.imgPath = [_patrol.filePath objectAtIndex:0];
            _playVideoCell.videoPath = [_patrol.videoPaths objectAtIndex:0];
            return _playVideoCell;
            
        }else{
            PatrolDetailCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolDetailCustomerCell"];
            if (cell == nil) {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolDetailCustomerCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        
            if (!_patrol.location.address.isEmpty) {
                [cell.address setText:_patrol.location.address];
            }else{
                [cell.address setText:[NSString stringWithFormat:@"%f   %f",_patrol.location.latitude,_patrol.location.longitude]];
            }

            cell.category.text = _patrol.category.name;
            cell.user.text = _patrol.user.realName;
            cell.time.text = _patrol.createDate;
            return cell;
        }
    }else if(indexPath.section == 1){
        TextViewCell *textViewCell = [[TextViewCell alloc] init];

        //textViewCell.textView.delegate=self;
        textViewCell.textView.text = _patrol.content;
        [textViewCell.textView setEditable:NO];
        textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return textViewCell;
    }else{
        PatrolDetailReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolDetailReplyCell"];
        if (cell == nil) {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PatrolDetailReplyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        PatrolReply *reply = [replies objectAtIndex:indexPath.row];
        if (reply.content != nil && reply.content.length >0) {
            NSString* avtar = @"";
            if (reply.sender.avatars.count > 0) {
                avtar = [reply.sender.avatars objectAtIndex:0];
            }

            [cell.icon setImageWithURL:[NSURL URLWithString:avtar] refreshCache:NO placeholderImage:[UIImage imageNamed:@"ic_unknow_avatar"]];
            cell.icon.layer.cornerRadius = 30.f;
            cell.icon.layer.masksToBounds = YES;
            cell.name.text = reply.sender.realName;
            cell.time.text = reply.createDate;
            NSString* text = reply.content;
            CGSize size = [super rebuildSizeWithString:text ContentWidth:235.0f FontSize:FONT_SIZE + 1];
            
            CGFloat height = MAX(size.height, 42.0f);
            
            CGRect rect = cell.content.frame;
            UILabel* lContent = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + 3,rect.size.width,height)];
            lContent.backgroundColor = WT_CLEARCOLOR;
            lContent.numberOfLines = 0;
            lContent.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
            lContent.textColor = WT_GRAY;
            lContent.text = reply.content;
            [cell.contentView addSubview:lContent];
            [lContent release];
            lContent = nil;
            cell.content.hidden = YES;
            cell.content.text = reply.content;
            
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
        BigImageViewController *ctrl = [[BigImageViewController alloc] init];
        int index = topCell.imgScrollView.currentPageIndex;
        if (index >= _patrol.filePath.count) {
            index = 0;
        }
        ctrl.filePath = [_patrol.filePath objectAtIndex:index];
        ctrl.functionName = [NSString stringWithFormat:@"[%@]%@",_patrol.customer.name,_patrol.user.realName];
        ctrl.bNeedBack = YES;
        //[self.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:ctrl animated:YES];
        [ctrl release];
    }
//    else if (indexPath.section > 1) {
//        PatrolReply *reply = [replies objectAtIndex:indexPath.row];
//        InputViewController *ctrl = [[InputViewController alloc] init];
//        ctrl.functionName = NSLocalizedString(@"worklog_label_reply", nil);
//        ctrl.atUser = reply.sender.realName;
//        ctrl.delegate = self;
//        ctrl.bNeedBack = YES;
//        //[self presentViewController:ctrl animated:YES completion:nil];
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
}

-(void)EScrollerViewDidClicked:(NSUInteger)index{
    NSLog(@"scroll image view index:%d",index);
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [_patrol.filePath objectAtIndex:index];
    ctrl.functionName = [NSString stringWithFormat:@"[%@]%@",_patrol.customer.name,_patrol.user.realName];
    ctrl.bNeedBack = YES;
    //[self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    [self _getPatrol];
}

- (void) loadMoreDataToTable
{
    _tableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        
        [self _getPatrolReply];
    }else{
        _tableView.pullTableIsLoadingMore = NO;
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

@end
