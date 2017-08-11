//
//  UploadListViewController.h
//  SalesManager
//
//  Created by Administrator on 15/11/5.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//


#import "HeaderSearchBar.h"
#import "BaseViewController.h"
#import "PullTableView.h"

@interface UploadListViewController : BaseViewController
{
    NSMutableArray*         _uploadFiles;
    VideoTopic            *_cacheVideo;
    
    BOOL _bEditing;
    int  _index;
}
@property (retain, nonatomic) IBOutlet PullTableView *tableView;
@end
