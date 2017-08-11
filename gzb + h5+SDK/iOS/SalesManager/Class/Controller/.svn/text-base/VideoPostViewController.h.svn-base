//
//  VideoPostViewController.h
//  SalesManager
//
//  Created by Administrator on 15/11/3.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "PickerVideoCell.h"
#import "VideoTypeViewController.h"
#import "CommonPhrasesTextViewCell.h"

@class SelectCell;
@interface VideoPostViewController : BaseViewController<UIAlertViewDelegate,VideoTypeDelegate>
{
    UITableView*        _tableView;
    SelectCell*         _timeDurationCell;
    CommonPhrasesTextViewCell*       _txtviewcell;
    SelectCell*         _videoTypeCell;
    InputCell*          _videoName;
    VideoTypeViewController* _typeView;
    
    
    PickerVideoCell*    _pickVideoCell;
    NSString*           _videoPath;
    NSString*           _imagePath;
    BOOL                _bDeleding;
    BOOL                _bCache;
    
    VideoCategory*      _videoType;
    VideoDurationCategory *_duration;
    NSString*           _name;
}
@property(nonatomic,assign)BOOL hidenImageBool;

@end
