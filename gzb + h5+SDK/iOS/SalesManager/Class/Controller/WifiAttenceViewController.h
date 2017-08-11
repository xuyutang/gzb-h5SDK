//
//  WifiAttenceViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/11/13.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "LiveImageCell.h"
#import "PullTableView.h"
#import "WifiAttenceCell.h"
#import "ChangeDateTableViewCell.h"
#import "DatePicker2.h"
#import "CheckInShiftModel.h"
@class AppDelegate;


@interface WifiAttenceViewController : BaseViewController<LiveImageCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RequestAgentDelegate,PullTableViewDelegate,DatePicker2Delegate>{
    UIView *rightView;
    TextFieldCell *txtCell;
    LocationCell *locationCell;
    LiveImageCell *liveImageCell;
    WifiAttenceCell *wifiAttenceCell;
    ChangeDateTableViewCell *changeDateCell;
    UITableViewCell *wifiCell;
    NSMutableArray *imageFiles;
    NSString *remarks;
    AppDelegate* appDelegate;
    NSMutableArray *btAttendances;
    UIScrollView *scrollView;
    NSString *wifiName;
    DatePicker2 *datePicker;
    NSString *currentDate;
    NSString *weekString;
    int status;
    
    
    CheckInShift *checkInShift;
    NSMutableArray *checkInShiftMulArray;
    NSMutableArray *holidayMulArray;
    NSString* checkTypeStr;
    NSMutableArray *dataArr;
    NSMutableArray *statusMulArray;
    NSMutableArray *trackMulArray;
    NSMutableArray *remarkMulArray;
    BOOL hasTrackBool;
    CheckInShiftModel *statusmodel;
    BOOL fillCardBool;
    NSString *remark;
    int indexInt;
    NSString *workTypeStr;
    BOOL checkDateBool;
}

@property (nonatomic,retain) UITableView *WifitableView;
@property (nonatomic,retain) UIViewController *parentCtrl;
@property (nonatomic, strong)  UITableView *pullTableView;

@end
