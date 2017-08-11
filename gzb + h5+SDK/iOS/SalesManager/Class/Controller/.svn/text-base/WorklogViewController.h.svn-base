//
//  WorklogViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/5/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextViewCell.h"

@class AppDelegate;
@interface WorklogViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RequestAgentDelegate>{

    UIView *rightView;
    
    UITableView *tableView;
    TextViewCell *tvTodayCell;
    TextViewCell *tvTomorrowCell;
    TextViewCell *tvQuestionCell;
    UITextView *textView;
    BOOL bHasKeyboard;
    
    AppDelegate* appDelegate;
}

@property (nonatomic,assign) BOOL showListImageBool ;
@end
