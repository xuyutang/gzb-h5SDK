//
//  AttendanceViewController.h
//  SalesManager
//
//  Created by liu xueyan on 7/31/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "LiveImageCell.h"

@class AppDelegate;
@interface AttendanceViewController : BaseViewController<LiveImageCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RequestAgentDelegate>{
    UIView *rightView;
    UITableView *tableView;
    
    TextFieldCell *txtCell;
    LocationCell *locationCell;
    LiveImageCell *liveImageCell;
    
    NSMutableArray *imageFiles;
    NSString *remarks;
    
    AppDelegate* appDelegate;
    NSMutableArray *btAttendances;
    NSMutableArray *categories;
    UIScrollView *scrollView;
}

@property(nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) UIViewController *parentCtrl;

@end
