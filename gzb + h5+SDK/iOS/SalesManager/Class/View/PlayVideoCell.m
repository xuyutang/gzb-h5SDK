//
//  PlayVideoCell.m
//  SalesManager
//
//  Created by Administrator on 15/11/11.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "PlayVideoCell.h"
#import "Constant.h"
#import "UIView+Util.h"
#import "SDImageView+SDWebCache.h"
#import "UIView+Util.h"

@interface PlayVideoCell()



@end

@implementation PlayVideoCell
{
    UIButton *_playBtn;
    UIView *_container;
    UIProgressView *_progress;
    AVPlayerLayer *playLayer;
    BOOL bShowHUD;
    BOOL bFirstPlay;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bNetwork:(BOOL) bNetwork{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bNetwork = bNetwork;
        bFirstPlay = YES;
        //[self initView];
    }
    return self;
}

-(void) initView{
    if (_container == nil) {
        _container = [[UIView alloc] initWithFrame:self.frame];
        
        
        _player = [AVPlayer playerWithPlayerItem:[self getPlayItem]];
        playLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playLayer.frame = _container.frame;
        [_container.layer addSublayer:playLayer];
        [self addSubview:_container];
        [_container release];
        
        float iosHeight;
        if (IOS7) {
            iosHeight = 3;
        }else{
            iosHeight = 10;
        }
        
        _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - iosHeight, self.frame.size.width, 3)];
        [self addSubview:_progress];
        [_progress release];
        
        CGFloat point = self.frame.size.width / 3;
        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(point,point,point,point)];
        _playBtn.backgroundColor = WT_CLEARCOLOR;
        _playBtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:50];
        [_playBtn setTitleColor:WT_BLACK forState:UIControlStateNormal];
        [_playBtn setTitle:[NSString fontAwesomeIconStringForEnum:ICON_PLAY] forState:UIControlStateNormal];
        
        [_playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        
        //播放进度
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current=CMTimeGetSeconds(time);
            float total=CMTimeGetSeconds([_player.currentItem duration]);
            NSLog(@"当前已经播放%.2fs.",current);
            if (bShowHUD) {
                _container.backgroundColor = WT_CLEARCOLOR;
                [MBProgressHUD hideHUDForView:self animated:YES];
                bShowHUD = NO;
            }
            if (current) {
                [_progress setProgress:(current/total) animated:YES];
            }
        }];
    }
    if (_player.rate == 0) {
        [self addSubview:_playBtn];
    }else{
        [_playBtn removeFromSuperview];
        
    }
    //[_playBtn release];
}

//监控播放完成
-(void) playEnd:(NSNotification*) notifaction{
    NSLog(@"播放完成,幻蝶");
    _bPlayEnd = YES;
    AVPlayerItem *item = (AVPlayerItem*)notifaction.object;
    [item seekToTime:kCMTimeZero];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [UIView addSubViewToSuperView:self subView:_playBtn];
}

-(void)deallocPlayer{
    [_player replaceCurrentItemWithPlayerItem:nil];
    _player = nil;
}

//初始化
-(void)setVideoPath:(NSString *)videoPath{
    _videoPath = videoPath;
    if (_videoPath.length == 0) {
        return;
    }
    [self initView];
}

//播放
-(void) playVideo{
    if (_player.rate == 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        if (_player == nil || _player.currentItem == nil) {
            [UIView removeViewFormSubViews:-1 views:@[_playBtn]];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = NSLocalizedString(@"loading", nil);
            bShowHUD = YES;
            [_player replaceCurrentItemWithPlayerItem:[self getPlayItem]];
        }else{
            [UIView removeAllSubViews:_container];
            [UIView removeViewFormSubViews:-1 views:@[_playBtn]];
        }
        _bPlayEnd = NO;
        [_player play];
    }
}


//暂停
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_player != nil && _player.rate == 1) {
        _bPlayEnd = YES;
        [UIView addSubViewToSuperView:self subView:_playBtn];
        [_player pause];
    }
}

//获取播放项目
-(AVPlayerItem*) getPlayItem{
    NSURL* url = nil;
    if (!_bNetwork) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/private%@",[PATH_OF_DOCUMENT stringByAppendingPathComponent:_videoPath]]];
        NSLog(@"本地播放视频");
    }else{
        if (bFirstPlay && _container.backgroundColor != WT_CLEARCOLOR) {
            UIImageView  *img = [[UIImageView alloc] initWithFrame:self.frame];
            NSString *url = _imgPath;
            [img setImageWithURL:[NSURL URLWithString:url] refreshCache:NO placeholderImage:[UIImage imageNamed:@"bg_default_rect_pic"]];
            img.contentMode = UIViewContentModeScaleAspectFill;
            //_container.backgroundColor = [UIColor colorWithPatternImage:img.image];
            [_container addSubview:img];
            [img release];
            bFirstPlay = NO;
            return nil;
        }
        NSString *urlStr= _videoPath;
        NSLog(@"网络视频地址:%@",_videoPath);
        urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        url=[NSURL URLWithString:urlStr];
    }
    return [AVPlayerItem playerItemWithURL:url];
}

@end
