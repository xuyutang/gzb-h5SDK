//
//  InspectionDetailViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-12-4.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "InspectionTypeViewController.h"

@protocol RefreshTableViewDelegate <NSObject>

- (void) refresh:(InspectionReport*) inspection;

@end

@interface InspectionDetailViewController: BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,RequestAgentDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    TextViewCell *textViewCell;
    LiveImageCell *liveImageCell;
    TextViewCell *tvReplyCell;
    
    NSMutableArray *imageFiles;
    InspectionReport *inspection;
    int inspectionId;
    UITextView *textView;
    
    InspectionReportReply *inspectionReply;
    NSString *strInspectionReply;
    id<RefreshTableViewDelegate> delegate;
}

@property(nonatomic,assign) id<RefreshTableViewDelegate> delegate;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) InspectionReport *inspection;
@property(nonatomic,assign) int inspectionId;
@property(nonatomic,assign) int msgType;
-(id)init;
@end
