//
//  PlayVideViewController.m
//  阿里巴巴趣拍
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 Administrator. All rights reserved.
//

#import "PlayVideViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayVideViewController ()

@end

@implementation PlayVideViewController
{
    MPMoviePlayerViewController* _video;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频播放";
    
    NSURL* url;
    if (_bNetWork) {
        url = [NSURL URLWithString:_videoPath];
    }else{
        url =[NSURL URLWithString:[NSString stringWithFormat:@"file://localhost/private%@",_videoPath]];
    }
    _video = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    _video.view.frame = self.view.frame;
    [self.view addSubview:_video.view];
    
    //监听播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinshiedPlayer:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

/*
 *播放完成
 */
-(void) didFinshiedPlayer:(NSNotification*) obj{
    NSLog(@"操作者:%@",obj.userInfo);
    NSLog(@"播放完成");
    if ([[obj.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue] == 2) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(MPMoviePlayerPlayback)]) {
            [_delegate MPMoviePlayerPlayback];
        }
        //注销通知
        [[NSNotificationCenter defaultCenter] removeObserver:MPMoviePlayerPlaybackDidFinishNotification];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
