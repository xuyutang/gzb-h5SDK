//
//  GiftViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-15.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextViewCell.h"
#import "InputCell.h"
#import "LiveImageCell.h"
#import "SelectCell.h"
#import "ApplyTypeViewController.h"

@class AppDelegate;
@interface ApplyViewController : BaseViewController<ApplyTypeDelegate,LiveImageCellDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,RequestAgentDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    TextViewCell *textViewCell;
    InputCell *titleCell;
    LiveImageCell *liveImageCell;
    SelectCell *chosePersonCell;
    NSMutableArray *imageFiles;
    BOOL bHasKeyboard;
    NSString *applyTitle;
    NSString *applyContent;
    NSMutableArray *applyCategories;
    AppDelegate* appDelegate;
    BOOL bHasSync;
    // 是否有流程
    BOOL hasProcessBool;
    NSMutableArray *userMuarray;
    BOOL checkBool;
}

@property (nonatomic,assign) BOOL showListImageBool ;
@property (nonatomic,strong) ApplyCategory *currentApplyCategory;

@end
