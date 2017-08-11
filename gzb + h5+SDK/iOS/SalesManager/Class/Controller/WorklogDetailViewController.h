//
//  WorklogDetailViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-7.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextViewCell.h"
#import "PullTableView.h"

@interface WorklogDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RequestAgentDelegate,RefreshDelegate,PullTableViewDelegate>{
    UIView *rightView;
    
//    UITableViewCell *tvTodayCell;
//    UITableViewCell *tvTomorrowCell;
//    UITableViewCell *tvQuestionCell;
    TextViewCell *tvReplyCell;
    UITextView *textView;
    
    WorkLog *worklog;
    int worklogId;
    
    WorkLogReply* worklogReply;
    NSString* sWorklogReply;
}
@property(nonatomic,retain) PullTableView *tableView;
@property(nonatomic,retain) WorkLog *worklog;
@property(nonatomic,assign) int worklogId;
@property(nonatomic,assign) int msgType;
@property(nonatomic,strong) id<RefreshDelegate> delegate;

-(id)init;

@end
