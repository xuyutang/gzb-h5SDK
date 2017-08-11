//
//  TaskViewController.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-14.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "TextViewCell.h"
#import "UTTableView.h"
#import "DatePicker.h"
#import "SWTableViewCell.h"

@class NewTaskCell;
@interface TaskViewController : BaseViewController<SWTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,SMWebSocketDelegate,DatePickerDelegate>{
    
    UIView *rightView;
    
    UTTableView *tableView;
    NewTaskCell *newTaskCell;
    TextViewCell *memoTextViewCell;
    NSString *fromTime;
    NSString *toTime;
    int status;
    NSIndexPath *currentIndexPath;
    DatePicker* datePicker;
    int distance;
    
    NSMutableArray* taskArray;
}


@end
