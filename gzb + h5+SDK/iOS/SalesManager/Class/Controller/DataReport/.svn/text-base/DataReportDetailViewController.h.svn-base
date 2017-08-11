//
//  DataReportDetailViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/8/23.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "TextFieldCell.h"
#import "LocationCell.h"

typedef NS_ENUM(NSInteger,DataReportType) {
    TEXT = 0,
    DIGITAL = 1,
    DATE = 2,
    RADIO = 3,
    CHECKBOX = 4,
    PHOTO_LIVE = 5,
    PHOTO_ANY = 6,
    CUSTOMER = 7
};

@class AppDelegate;
@interface DataReportDetailViewController : BaseViewController
{
    //UIView *rightView;
    UITableView *tableView;
    TextViewCell *tvReplyCell;
    TextFieldCell *txtCell;
    LocationCell *locationCell;
    
    NSString *typeString ;
    
    AppDelegate* appDelegate;
    
    
//    NSMutableArray *imageFiles;
    
}
@property(nonatomic,copy) NSString *paperNameString;
@property(nonatomic,retain) PaperPost *currentPaperPost;
@property(nonatomic,assign) int paperPostId;
@property(nonatomic,strong) id<RefreshDelegate> delegate;
@property(nonatomic,assign) int msgType;
@end
