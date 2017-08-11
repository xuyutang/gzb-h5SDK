//
//  WifiAttendanceDetailViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/12/1.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "TextFieldCell.h"
#import "LocationCell.h"

@class AppDelegate;
@interface WifiAttendanceDetailViewController : BaseViewController< LiveImageCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RequestAgentDelegate>{
    UIView *rightView;
    UITableView *tableView;
    TextViewCell *tvReplyCell;
    TextFieldCell *txtCell;
    LocationCell *locationCell;
    
    AppDelegate* appDelegate;
    
    
    CheckInTrackReply *checkinTrackReply;
    NSString *strAttendanceReply;
    NSMutableArray *imageFiles;
    
    id<RefreshDelegate> delegate;
}
@property(nonatomic,retain) CheckInTrack *checkInTrack;
@property(nonatomic,assign) int checkInTrackId;
@property(nonatomic,strong) id<RefreshDelegate> delegate;
@property(nonatomic,assign) int msgType;


@end
