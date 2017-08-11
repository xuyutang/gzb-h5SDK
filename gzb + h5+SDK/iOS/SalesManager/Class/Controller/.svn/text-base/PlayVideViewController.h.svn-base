//
//  PlayVideViewController.h
//  阿里巴巴趣拍
//
//  Created by Administrator on 15/11/2.
//  Copyright © 2015年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPMoviePlayerPlayDelegate <NSObject>

//播放完成回调
-(void)MPMoviePlayerPlayback;

@end

@interface PlayVideViewController : UIViewController

@property (nonatomic) BOOL bNetWork;
@property (nonatomic,retain) NSString* videoPath;
@property (nonatomic,assign) id<MPMoviePlayerPlayDelegate> delegate;
@end
