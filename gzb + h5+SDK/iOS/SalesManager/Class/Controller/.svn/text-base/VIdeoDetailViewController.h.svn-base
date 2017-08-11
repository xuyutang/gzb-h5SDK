//
//  VIdeoDetailViewController.h
//  SalesManager
//
//  Created by Administrator on 15/11/9.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "Constant.h"
#import "PullTableView.h"

@protocol VideoDetailViewControllerDelegate <NSObject>

@optional
-(void)VideoDetailSavedBack;

@end
@class PlayVideoCell;
@interface VideoDetailViewController : BaseViewController
{
    UIView *rightView;
    PlayVideoCell *_playVideoCell;
    PullTableView*          _tableView;
    NSMutableArray*         _replys;
    VideoTopicReply*      _reply;
    
    int _index;
    int _pageSize;
    int _totalSize;
}

@property (assign ,nonatomic) int   videoId;
@property (retain ,nonatomic) VideoTopic* video;
@property (assign ,nonatomic) id<RefreshDelegate> delegate;
@property (assign ,nonatomic) BOOL bNetwork;    //是否网络视频

@end
