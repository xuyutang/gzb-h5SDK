//
//  PickerVideoCell.m
//  SalesManager
//
//  Created by Administrator on 15/11/3.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "PickerVideoCell.h"
#import "Constant.h"
#import "PlayVideViewController.h"
#import <CoreMedia/CoreMedia.h>

@implementation PickerVideoCell
{
    AVPlayerLayer *playerLayer;
}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 320, 230);
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake((MAINWIDTH - 161)/ 2 + 20, 60, 130, 80)];
    [_icon setImage:[UIImage imageNamed:@"video_record"]];
    [_icon setContentMode:UIViewContentModeScaleAspectFit];
    UILabel *expainLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 150, 200, 40)];
    expainLabel.textColor = [UIColor grayColor];
    expainLabel.text = @"点击拍摄视频";
    expainLabel.font = [UIFont systemFontOfSize:12];
//    _icon.text = [NSString fontAwesomeIconStringForEnum:ICON_VIDEO];
//    [_icon setTextAlignment:UITextAlignmentCenter];
//    _icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:68.0f];
//    _icon.backgroundColor = WT_CLEARCOLOR;
//    _icon.textColor = WT_BLACK;
    
    [self addSubview:_icon];
    [self addSubview:expainLabel];
    [_icon release];
    [expainLabel release];
}

-(void) initPlayerView{
    if (_container == nil) {
        _player = [[AVPlayer alloc] initWithPlayerItem:[self getPlayerItem]];
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        if (!IOS7) {
            x = 5;
            y = .5f;
            w = self.frame.size.width - 15;
            h = 230.5;
        }
        _container = [[UIView alloc] initWithFrame:CGRectMake(x,y,w,h)];
        _container.userInteractionEnabled = YES;
        
        [self addSubview:_container];
        //[_container release];
        
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame = _container.frame;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        if (!IOS7) {
            _container.layer.cornerRadius = 8.f;
            _container.layer.masksToBounds = YES;
            playerLayer.cornerRadius = 8.f;
            playerLayer.masksToBounds = YES;
        }
        [_container.layer addSublayer:playerLayer];
        //[_container release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }else{
        [_player replaceCurrentItemWithPlayerItem:[self getPlayerItem]];
        [UIView addSubViewToSuperView:self subView:_container];
    }
}

-(AVPlayerItem*) getPlayerItem{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/private%@",_videoPath]];
    return [AVPlayerItem playerItemWithURL:url];
}

-(void) playerEnd{
    NSLog(@"播放完成");
    [_player replaceCurrentItemWithPlayerItem:[self getPlayerItem]];
    
    //[UIView removeViewFormSubViews:-1 views:@[_icon]];
    [_icon setHidden:NO];
    [_icon setImage:[UIImage imageNamed:@"video_play"]];
    [_icon setContentMode:UIViewContentModeScaleAspectFit];
    [UIView addSubViewToSuperView:self subView:_icon];
}

/*
 *拍摄|播放
 */
-(void) playOrPickerVide{
    if (_bPickerVideo) {
        NSLog(@"播放视频");
        if (_player != nil) {
            [_player play];
        }
        [_icon setHidden:YES];
        //[UIView removeViewFormSubViews:-1 views:@[_icon]];
    }else{
        //首次点击播放
        if (self.firstClick) {
            self.firstClick(self);
        }
        NSLog(@"拍摄视频");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parentVC.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"loading", nil);
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            
            //阿里巴巴趣拍初始化
            [[TaeSDK sharedInstance] asyncInit:^{
                NSLog(@"阿里巴巴趣拍初始化ok");
            } failedCallback:^(NSError *error) {
                NSLog(@"TaeSDK init failed!!!");
            }];
            
            
        });
        
        float pickTimes = [self getPickerVideoTimes];
        if (pickTimes == -1) return;
        _taeSDK =[[TaeSDK sharedInstance] getService:@protocol(ALBBQuPaiPluginPluginServiceProtocol)];
        [_taeSDK setDelegte:self];
        _pickerView = [_taeSDK createRecordViewControllerWithMaxDuration:pickTimes
                                                                 bitRate:600000
                                             thumbnailCompressionQuality:.8f
                                                          watermarkImage:nil
                                                       watermarkPosition:QupaiSDKWatermarkPositionTopRight
                                                               tintColor:[UIColor clearColor]
                                                         enableMoreMusic:NO
                                                            enableImport:NO
                                                       enableVideoEffect:NO];
        //遮罩多余功能
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 220, 42)];
        maskView.backgroundColor = WT_BLACK;
        [_pickerView.view addSubview:maskView];
        
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 100, 100, 100)];
        maskView.backgroundColor = WT_BLACK;
        [_pickerView.view  addSubview:maskView];
        [maskView release];
        UINavigationController* pickNavCtrl = [[UINavigationController alloc] initWithRootViewController:_pickerView];
        pickNavCtrl.navigationBarHidden = YES;
        [self.parentVC presentViewController:pickNavCtrl animated:YES completion:nil];
        
        [MBProgressHUD hideHUDForView:_parentVC.view animated:YES];
    }
}

-(float) getPickerVideoTimes{
    //视频管理
    if (_pickVideoType == PickerVideoTypeVideo) {
        return [self getVideoPickerDurantion];
    //巡访报告拍摄时间
    }
    return [self getPatorlVideoPickerDurantion];
}



#pragma -mark 趣拍Delegate
-(void)qupaiSDK:(id<ALBBQuPaiPluginPluginServiceProtocol>)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath{
    NSString *vurl = nil;
    NSString *iurl = nil;
    if (!videoPath && !thumbnailPath) {
        NSLog(@"取消拍摄");
    }else{
        NSData *data = [[NSData alloc] initWithContentsOfFile:videoPath];
        vurl = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[videoPath lastPathComponent]];
        [data writeToFile:vurl atomically:YES];
        iurl = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[thumbnailPath lastPathComponent]];
        data = [[NSData alloc] initWithContentsOfFile:thumbnailPath];
        [data writeToFile:iurl atomically:YES];
        [data release];
        
        [LOCALMANAGER clearImagesWithFiles:[NSMutableArray arrayWithObjects:videoPath,thumbnailPath, nil]];
        _videoPath = vurl;
        _bPickerVideo = YES;
        [self initPlayerView];
        
      //  _icon.text = [NSString fontAwesomeIconStringForEnum:ICON_PLAY];
        [self addSubview:_icon];
    }
    
    [_pickerView dismissViewControllerAnimated:YES completion:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(PickerVideoTouch:photoPath:)]) {
        [_delegate PickerVideoTouch:[vurl retain] photoPath:[iurl retain]];
    }
}
#pragma -mark - 私有方法

/**
 *获取视频管理拍摄时间
 */
-(float) getVideoPickerDurantion{
    VideoDurationCategory *duration = [LOCALMANAGER getFavVideoDurationCategory];
    if (duration == nil) {
        duration = [[LOCALMANAGER getVideoDurationCategories] firstObject];
        if (duration == nil) {
            [MBProgressHUD hideHUDForView:_parentVC.view animated:YES];
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                              description:NSLocalizedString(@"video_duration_category_sync_info", nil)
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION ];
            return -1;
        }
    }
    return duration.durationValue.floatValue;
}

/**
 *获取视频管理拍摄时间
 */
-(float) getPatorlVideoPickerDurantion{
    PatrolVideoDurationCategory *duration = [LOCALMANAGER getFavPatrolVideoDurationCategory];
    if (duration == nil) {
        duration = [[LOCALMANAGER getPatrolVideoDurationCategories] firstObject];
        if (duration == nil) {
            [MBProgressHUD hideHUDForView:_parentVC.view animated:YES];
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_VIDEO_DES)
                              description:NSLocalizedString(@"video_duration_category_sync_info", nil)
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION ];
            return -1;
        }
    }
    
    return duration.durationValue.floatValue;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    [super dealloc];
}
@end
