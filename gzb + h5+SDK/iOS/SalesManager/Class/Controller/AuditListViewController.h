//
//  AuditListViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 2017/5/15.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"
#import "ApplySearchViewController.h"
#import "WorklogDetailViewController.h"
#import "QCheckBox.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger,auditlStatus) {
    APPLY_NOT_MANAGE = 0,
    APPLY_MANAGE = 1
};

@protocol AuditListViewControllerDelegate <NSObject>

@optional
-(void)didFinishedSelectApplyItem:(NSMutableArray *)applyItemArray;

@end

@interface AuditListViewController : BaseViewController<InputFinishDelegate,ApplySearchDelegate,UITableViewDataSource, PullTableViewDelegate,RefreshDelegate,QCheckBoxDelegate> {
    PullTableView *pullTableView;
    NSMutableArray *auditArray;
    AppDelegate *appDelegate;
    ApplyItemParams* applyParams;
    int currentPage;
    int pageSize;
    int totleSize;
    ApplyItem* currentApplyItem;
    int currentRow;
    BOOL bEnableSelect;
    NSMutableArray *selectedArray;
    id<AuditListViewControllerDelegate> delegate;
}

@property (nonatomic, assign) BOOL bEnableSelect;
@property (nonatomic, retain) NSMutableArray *auditArray;
@property (nonatomic,retain) IBOutlet PullTableView *pullTableView;
@property (nonatomic,retain) id<AuditListViewControllerDelegate> delegate;
@property (nonatomic,retain) ApplyItemParams* applyParams;

@end
