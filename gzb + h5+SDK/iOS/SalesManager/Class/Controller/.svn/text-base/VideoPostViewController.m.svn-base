//
//  VideoPostViewController.m
//  SalesManager
//
//  Created by Administrator on 15/11/3.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "VideoPostViewController.h"
#import "Constant.h"
#import "SelectCell.h"
#import "InputCell.h"
#import "LocationCell.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "BottomBtnBar.h"
#import "NSDate+Util.h"
#import "MBProgressHUD.h"
#import "UploadListViewController.h"
#import "FileHelper.h"
#import "VideoListViewController.h"
#import "BottomButtonView.h"
#import "VideoDurationTypeController.h"

@interface VideoPostViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,PickerVideoDelegate,UITextFieldDelegate,VideoDurationTypeDelegate>

@end

@implementation VideoPostViewController
{
    NSString *_takeDurantionTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];

    [self initData];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) style:UITableViewStylePlain];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = WT_WHITE;
    //    //去掉分割线
    //    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_VIDEO_DES)];
    //按钮
    
    
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    UILabel* listBtn = [[UILabel alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    UIImageView *listImageView = [[UIImageView alloc] init];
    listImageView.frame = CGRectMake(100, 17, 25, 25);
    UIImage *listImage = [UIImage imageNamed:@"ab_icon_search.png"];
    listImageView.image = listImage;
    listBtn.tag = 1;
    listBtn.backgroundColor = [UIColor clearColor];
    
    listBtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
    listBtn.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listTouch)];
    gesture.numberOfTapsRequired = 1;
    [listBtn addGestureRecognizer:gesture];
    [gesture release];
    listBtn.userInteractionEnabled = YES;
    [rightView addSubview:listImageView];
    [listImageView release];
    [rightView addSubview:listBtn];
    [listBtn release];
    
    UIImageView *uploadImageView = [[UIImageView alloc] init];
    uploadImageView.frame = CGRectMake(60, 17, 25, 25);
    UIImage *uploadImage = [UIImage imageNamed:@"ab_icon_preupload.png"];
    uploadImageView.image = uploadImage;
    UILabel* uploadListBtn = [[UILabel alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    uploadListBtn.tag = 1;
    uploadListBtn.backgroundColor = [UIColor clearColor];
   
    uploadListBtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
    uploadListBtn.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer* uploadListBtnGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadListBtnTouch)];
    uploadListBtnGesture.numberOfTapsRequired = 1;
    [uploadListBtn addGestureRecognizer:uploadListBtnGesture];
    [uploadListBtnGesture release];
    uploadListBtn.userInteractionEnabled = YES;
    [rightView addSubview:uploadImageView];
    [uploadImageView release];
    [rightView addSubview:uploadListBtn];
    [uploadListBtn release];
    
    if (self.hidenImageBool) {
        uploadImageView.hidden = YES;
        listImageView.hidden = YES;
        listBtn.hidden = YES;
        uploadListBtn.hidden = YES;
    }
    
    UIBarButtonItem* rightButn = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = rightButn;
    [rightView release];
    [rightButn release];
    
    [self createButton];
}

-(void)syncTitle {
  [lblFunctionName setText:TITLENAME_REPORT(FUNC_VIDEO_DES)];
}

-(void) createButton{
    BottomButtonView *bottomBtns = [[BottomButtonView alloc] initWithFrame:CGRectMake(0, MAINHEIGHT - 45, MAINWIDTH, 45)];
    bottomBtns.titles = @[NSLocalizedString(@"save_cache_title", nil),NSLocalizedString(@"upload_title", nil)];
    bottomBtns.buttonSelected = ^(NSInteger index){
        NSLog(@"buttonIndex:%d",index);
        if (index == 0) {
            [self btnToSaveCache];
        }else{
            [self btnToSave];
        }
    };
    [self.view addSubview:bottomBtns];
    [bottomBtns release];
}

-(void) initData{
    _videoType = [[[LOCALMANAGER getVideoCategories] firstObject] retain];
    _bDeleding = NO;
    _name = @"";
    _videoTypeCell = nil;
    _pickVideoCell = nil;
    _txtviewcell = nil;
    //加载是 初始化不会出现卡顿
    if (_txtviewcell == nil) {
        _txtviewcell = [[CommonPhrasesTextViewCell alloc] init];
        _txtviewcell.textView.placeHolder = NSLocalizedString(@"video_txtview_tip", nil);
    }
    [self getDefaultDuration];
    
    if (!_bCache && _videoPath && _imagePath) {
        //上传后清除缓存
        [LOCALMANAGER clearImagesWithFiles:[NSMutableArray arrayWithArray:@[_videoPath,_imagePath]]];
        _videoPath = nil;
        _imagePath = nil;
    }
}

#pragma -mark RightView按钮事件
//列表
-(void) listTouch{
    VideoListViewController *listVC = [[VideoListViewController alloc] init];
    listVC.bNeedBack = YES;
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];
}

//保存事件
-(void) saveTouch{
    NSLog(@"保存");
    
    //验证参数
    if (![self validate]) {
        return;
    }
    
    //提醒
    UIActionSheet* alter = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"note", nile)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"no", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"upload_title", nil)
                                              otherButtonTitles:NSLocalizedString(@"save_cache_title", nil), nil];
    alter.delegate = self;
    [alter showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    [alter release];
}

//上传任务
-(void) uploadListBtnTouch{
    UploadListViewController* uploadVC = [[UploadListViewController alloc] init];
    [self.navigationController pushViewController:uploadVC animated:YES];
    [uploadVC release];
}

//验证数据
-(BOOL) validate{
    
    if (!_videoType) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_hint_category_empty", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return  NO;
    }
    if (!_duration) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_select_duration_hint", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return NO;
    }
    if (_name.length == 0) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_hint_title_empty", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return  NO;
    }
    if (_name.length > 50) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_hint_title_length", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return NO;
    }
    if ([NSString stringContainsEmoji:_name]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_hint_title_emoji", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return NO;
    }
    if (_videoPath.length == 0) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_hint_video_empty", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return  NO;
    }
    if ([_txtviewcell.textView.text isEqualToString:NSLocalizedString(@"video_txtview_tip", nil)]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_hint_text_empty", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return  NO;
    }
    if (_txtviewcell.textView.text.length == 0) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_hint_content", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return NO;
    }
    if (_txtviewcell.textView.text.length > 1000) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_hint_content_length", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return NO;
    }
    if ([NSString stringContainsEmoji:_txtviewcell.textView.text]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                          description:NSLocalizedString(@"video_hint_content_emoji", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return NO;
    }
    return YES;
}

#pragma -mark VideoDurationTypeDelegate
-(VideoDurationCategory *)VideoDurationTypeSlectedItme:(UIViewController *)controller duration:(VideoDurationCategory *)duartion{
    if (duartion != nil) {
        _duration = duartion;
        //设置默认
        [LOCALMANAGER favVideoDurationCategory:duartion.id];
        [_tableView reloadData];
    }
}

#pragma -mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"index:%d",buttonIndex);
    if (buttonIndex == 0) {
        //上传
        _bCache = NO;
        [self toSave:[self createVideoTopic]];
    }else if(buttonIndex == 1){
        //缓存至本地
        _bCache = YES;
        VideoTopic* video = [self createVideoTopic];
        [self toSaveCache:video];
    }else{
        //取消操作
    }
}

//上传
-(void) toSave:(VideoTopic*) videoTopic{
    AGENT.delegate = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", nil);
    if (DONE != [AGENT sendRequestWithType:ActionTypeVideoTopicSave param:videoTopic]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)                          description:NSLocalizedString(@"error_connect_server", nil)
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void) btnToSave{
    if (![self validate]) {
        return  ;
    }
    _bCache = NO;
    [self toSave:[self createVideoTopic]];
}

-(void)didReceiveMessage:(id)message{
    SessionResponse *sr = [SessionResponse parseFromData:message];
    HUDHIDE2;
    if ([super validateSessionResponse:sr]) {
        return;
    }
    if (INT_ACTIONTYPE(sr.type) == ActionTypeVideoTopicSave) {
        
        if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]){
            [self initData];
            [_tableView reloadData];
        }
        [super showMessage2:sr Title:TITLENAME(FUNC_VIDEO_DES)
                Description:NSLocalizedString(@"video_msg_saved", @"")];
    }
    else if (INT_ACTIONTYPE(sr.type) == ActionTypeSyncBaseData){
        if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeDone)]) {
            SyncData *data = [SyncData parseFromData:sr.data];
            NSLog(@"同步数据%d:",data.videoCategories.count);
        }
        [super showMessage2:sr Title:TITLENAME(FUNC_VIDEO_DES)
                Description:@""];
    }
    if ([sr.code isEqual:NS_ACTIONCODE(ActionCodeErrorServer)]) {
        [super showMessage2:sr Title:TITLENAME(FUNC_VIDEO_DES)
                Description:@""];
    }
}

//缓存
-(void) toSaveCache:(VideoTopic*) videoTopic{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", nil);
    
    BOOL res = [LOCALMANAGER saveCache:FUNC_VIDEO Content:videoTopic.dataStream];
    
    HUDHIDE2;
    if (res) {
        [self initData];
        [_tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                              description:NSLocalizedString(@"cache_msg_saved", @"")
                                     type:MessageBarMessageTypeSuccess
                              forDuration:SUCCESS_MSG_DURATION];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                              description:NSLocalizedString(@"cache_msg_fail", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        });
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
}

-(void) btnToSaveCache{
    if (![self validate]) {
        return  ;
    }
    _bCache = YES;
    [self toSaveCache:[self createVideoTopic]];
}

//封装对象
-(VideoTopic*) createVideoTopic{
    VideoTopic_Builder* v  = [VideoTopic builder];
    [v setId:0];
    [v setUser:USER];
    if (APPDELEGATE.myLocation != nil) {
        [v setLocation:APPDELEGATE.myLocation];
    }
    [v setCreateDate:[NSDate getCurrentDateTime]];
    [v setCategory:_videoType];
    [v setTitle:_name];
    [v setComment:_txtviewcell.textView.text];
    NSString* fileSize = [FileHelper getFileSize:_videoPath];
    [v setVideoSizesArray:@[fileSize]];
    [v setVideoDurationCategoriesArray:@[_duration]];
    [v setVideoDurationsArray:@[_duration.durationValue]];
    [v setVideoPixelsArray:@[NSLocalizedString(@"video_pixels", nil)]];
    
    if (!_bCache) {
        if (APPDELEGATE.myLocation != nil) {
            [v setUploadLocation:APPDELEGATE.myLocation];
        }
        [v setUploadDate:[NSDate getCurrentDateTime]];
        NSData* video = [NSData dataWithContentsOfFile:_videoPath];
        [v setVideosArray:@[video]];
        NSData* image = [NSData dataWithContentsOfFile:_imagePath];
        [v setFilesArray:@[image]];
    }else{
        [v setFilePathsArray:@[[_imagePath lastPathComponent]]];
        [v setVideoPathsArray:@[[_videoPath lastPathComponent]]];
    }
    return [v build];
}


#pragma -mark 拍摄回调PickerVideoCellDelegate
-(void)PickerVideoTouch:(NSString *)videPath photoPath:(NSString *)photoPath{
    if (videPath == nil && photoPath == nil) {
        if (_videoPath.length > 0 && _imagePath.length > 0) {
            //   _pickVideoCell.icon.text = [NSString fontAwesomeIconStringForEnum:ICON_PLAY];
            //[UIView addSubViewToSuperView:_pickVideoCell subView:_pickVideoCell.icon];
            [_pickVideoCell.icon setHidden:NO];
            [_pickVideoCell.icon setImage:[UIImage imageNamed:@"video_play"]];
            [_pickVideoCell.icon setContentMode:UIViewContentModeScaleAspectFit];
        }else{
            //    _pickVideoCell.icon.text = [NSString fontAwesomeIconStringForEnum:ICON_VIDEO];
            //[UIView addSubViewToSuperView:_pickVideoCell subView:_pickVideoCell.icon];
            [_pickVideoCell.icon setHidden:NO];
            [_pickVideoCell.icon setImage:[UIImage imageNamed:@"video_record"]];
            [_pickVideoCell.icon setContentMode:UIViewContentModeScaleAspectFit];
        }
        
    }else{
        //[UIView removeViewFormSubViews:-1 views:@[_pickVideoCell.icon]];
        // _pickVideoCell.icon.text = [NSString fontAwesomeIconStringForEnum:ICON_PLAY];
        //[UIView addSubViewToSuperView:_pickVideoCell subView:_pickVideoCell.icon];
        [_pickVideoCell.icon setHidden:NO];
        [_pickVideoCell.icon setImage:[UIImage imageNamed:@"video_play"]];
        [_pickVideoCell.icon setContentMode:UIViewContentModeScaleAspectFit];
        _videoPath = videPath;
        _imagePath = photoPath;
    }
    
    [_tableView reloadData];
}

-(void)autorefreshLocation {
    [super refreshLocation];
    [_tableView reloadData];
}

#pragma -mark 拓展方法

-(void) refreshLocation{
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [_tableView reloadData];
    
    [hud hide:YES afterDelay:1.0];
}

#pragma -mark 窗体方法

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1000) {
        if (textField.text) {
            _name = [textField.text retain];
        }else{
            _name = @"";
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [UIView removeViewFormSubViews:-1 views:@[_pickVideoCell.container]];
        [_pickVideoCell.icon setImage:[UIImage imageNamed:@"video_record"]];
        [UIView addSubViewToSuperView:_pickVideoCell subView:_pickVideoCell.icon];
        
        _pickVideoCell.bPickerVideo = NO;
        //清除缓存
        if (_videoPath != nil && _imagePath != nil
            && _videoPath.length > 0 && _imagePath.length > 0) {
            
            NSLog(@"清楚缓存");
            [LOCALMANAGER clearImagesWithFiles:[NSMutableArray arrayWithObjects:_videoPath,_imagePath, nil]];
            _videoPath = nil;
            _imagePath = nil;
        }
        [_tableView reloadData];
    }
}

//长按删除图片
-(void) longPress{
    if (_bDeleding) {
        return;
    }
    
    if (_pickVideoCell.bPickerVideo) {
        _bDeleding = YES;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"note", nil)
                                                        message:NSLocalizedString(@"video_del_info", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"no", nil)
                                              otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
        [alert show];
        [alert release];
        _bDeleding = NO;
    }
    
}

-(void) getDefaultDuration{
    //拍摄时长
    VideoDurationCategory *duration = [LOCALMANAGER getFavVideoDurationCategory];
    if (duration == nil) {
        duration = [[LOCALMANAGER getVideoDurationCategories] firstObject];
    }
    
    _duration = [duration retain];
}

-(NSString *) getDurantionStr:(VideoDurationCategory *) duration{
    NSString *str;
    if (duration == nil) {
        str = [[NSString stringWithFormat:NSLocalizedString(@"video_duration_to_seconds", nil),@"0"] retain];
    }else{
        str = [[NSString stringWithFormat:NSLocalizedString(@"video_duration_to_seconds", nil),duration.durationValue] retain];
    }
    return str;
}

#pragma -mark TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;

}
//只隐藏第一个section的分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell* )cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0||indexPath.section == 2) {
        //        if (indexPath.row) {
        if (IOS8) {
            [cell setLayoutMargins:UIEdgeInsetsMake(1,MAINWIDTH,1,1)];

        }
        
        //        }
    }
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    switch (section) {
//        case 0:
//            return NSLocalizedString(@"title_video_info", nil);
//        case 1:
//        {
//
//        }
//            //return _takeDurantionTitle;
//            return NSLocalizedString(@"video_table_cell_take", nil);
//        case 2:
//            return NSLocalizedString(@"title_live_info", nil);
//        default:
//            break;
//    }
//    return @"";
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 4;
        case 1:
        case 2:
            return 1;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 3) {
                return 50;
            }
            return 40;
        case 1:
            return 230;
        case 2:
            return 140;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                _videoTypeCell = [tableView dequeueReusableCellWithIdentifier:@"SelectCell"];
                if (_videoTypeCell == nil) {
                    _videoTypeCell = [[[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:self options:nil] lastObject];
                    _videoTypeCell.tag = 1001;
                }
                _videoTypeCell.title.text = NSLocalizedString(@"video_label_category", nil);
                _videoTypeCell.value.text = _videoType ? _videoType.name : @"";
                //添加必填(50字以内)下面的view
                [_videoTypeCell addSubview:[self setView]];
                return _videoTypeCell;
            }else if (indexPath.row == 1){
                _timeDurationCell = [tableView dequeueReusableCellWithIdentifier:@"TimeDurationCell"];
                if (_timeDurationCell == nil) {
                    _timeDurationCell = [[[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:self options:nil] lastObject];
                    _timeDurationCell.tag = 1002;
                }
                _timeDurationCell.title.text = NSLocalizedString(@"video_lable_duration", nil);
                _timeDurationCell.value.text = [self getDurantionStr:_duration];
                return _timeDurationCell;
            }else if (indexPath.row == 2){
                _videoName = [tableView dequeueReusableCellWithIdentifier:@"InputCell"];
                
                if (!_videoName) {
                    _videoName = [[[NSBundle mainBundle] loadNibNamed:@"InputCell" owner:self options:nil] lastObject];
                }
                _videoName.inputField.placeholder = @"必填(50字以内)";
                _videoName.title.text = NSLocalizedString(@"video_label_title", nil);
                _videoName.inputField.text = _name.length > 0 ? _name : @"";
                _videoName.inputField.delegate = self;
                _videoName.inputField.tag = 1000;
                //                [_videoName addSubview:[self setView]];
                return _videoName;
            }else if(indexPath.row == 3){
                LocationCell* locationcell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
                if (locationcell == nil) {
                    locationcell = [[[NSBundle mainBundle] loadNibNamed:@"LocationCell" owner:self options:nil] lastObject];
                }
                locationcell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (APPDELEGATE.myLocation != nil) {
                    if (!APPDELEGATE.myLocation.address.isEmpty) {
                        [locationcell.lblAddress setText:APPDELEGATE.myLocation.address];
                    }else{
                        [locationcell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude]];
                    }
                }
                [locationcell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
                return locationcell;
            }
        case 1:
        {
            
            if (!_pickVideoCell) {
                _pickVideoCell = [[PickerVideoCell alloc] init];
            }
            UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
            longPress.minimumPressDuration = 1.0f;
            longPress.allowableMovement = 50.0f;
            [_pickVideoCell.container addGestureRecognizer:longPress];
            [longPress release];
            _pickVideoCell.parentVC = self;
            _pickVideoCell.delegate = self;
            _pickVideoCell.pickVideoType = PickerVideoTypeVideo;
            return _pickVideoCell;
        }
        case 2:
        {
            return _txtviewcell;
        }
        default:
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*  cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                _typeView = [[VideoTypeViewController alloc] init];
                _typeView.videoTypes = [LOCALMANAGER getVideoCategories];
                _typeView.delegate = self;
                _typeView.bSearch = NO;
                UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:_typeView];
                [self presentViewController:navCtrl animated:YES completion:nil];
                [_typeView release];
                [navCtrl release];
            }
            else if (indexPath.row == 1){
                if (_pickVideoCell.bPickerVideo) {
                    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)                                      description:NSLocalizedString(@"video_duration_selected_hint", nil)
                                             type:MessageBarMessageTypeInfo
                                      forDuration:INFO_MSG_DURATION];
                    return;
                }
                VideoDurationTypeController *durationTypeVC = [[VideoDurationTypeController alloc] init];
                durationTypeVC.bNeedBack = YES;
                durationTypeVC.delegate = self;
                UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:durationTypeVC];
                [self presentViewController:navCtrl animated:YES completion:nil];
                [durationTypeVC release];
                [navCtrl release];
            }
            break;
        case 1:
        {
            //打开拍摄视频
            PickerVideoCell* pv = [tableView cellForRowAtIndexPath:indexPath];
            pv.selected = NO;
            [pv playOrPickerVide];
            break;
        }
        default:
            break;
    }
}


-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(60, 100, MAINWIDTH - 220, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 15, MAINWIDTH - 100, 0.5)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 80 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
}

#pragma -mark VideTypeDelegate
-(void)videoTypeSearch:(VideoTypeViewController *)controller didSelectWithObject:(id)aObject{
    _videoType = (VideoCategory*)aObject;
    
    if (_videoType) {
        NSLog(@"%d,%@",_videoType.id,_videoType.name);
        _videoTypeCell.value.text = _videoType.name;
    }else{
        _videoTypeCell.value.text = @"";
    }
}


#pragma -mark 窗体事件
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)dealloc{
    [_videoName release];
    [_videoTypeCell release];
    [_tableView release];
    [_txtviewcell release];
    _pickVideoCell = nil;
    [_typeView release];
    [super dealloc];
}

-(void)viewDidUnload{
    
    [_videoName release];
    _videoName = nil;
    [_videoTypeCell release];
    _videoTypeCell = nil;
    [_tableView release];
    _tableView = nil;
    [_txtviewcell release];
    _txtviewcell = nil;
    
    _pickVideoCell = nil;
    
    [_typeView release];
    _typeView = nil;
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
