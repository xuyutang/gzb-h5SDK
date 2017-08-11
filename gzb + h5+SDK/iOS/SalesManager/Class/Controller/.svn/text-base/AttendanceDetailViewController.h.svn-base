//
//  AttendanceDetailViewController.h
//  SalesManager
//
//  Created by liuxueyan on 20/5/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "TextFieldCell.h"
#import "LocationCell.h"

@class AppDelegate;
@interface AttendanceDetailViewController : BaseViewController< LiveImageCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RequestAgentDelegate>{
    UIView *rightView;
    UITableView *tableView;
    TextViewCell *tvReplyCell;
    TextFieldCell *txtCell;
    LocationCell *locationCell;
    
    AppDelegate* appDelegate;
    
    
    AttendanceReply *attendanceReply;
    NSString *strAttendanceReply;
    NSMutableArray *imageFiles;
    
    id<RefreshDelegate> delegate;
}
@property(nonatomic,retain) Attendance *attendance;
@property(nonatomic,assign) int attendanceId;
@property(nonatomic,strong) id<RefreshDelegate> delegate;
@property(nonatomic,assign) int msgType;

@end
