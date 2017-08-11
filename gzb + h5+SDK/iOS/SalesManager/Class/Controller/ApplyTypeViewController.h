//
//  ApplyTypeViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-19.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonCell.h"

@class ApplyTypeViewController;
@protocol ApplyTypeDelegate <NSObject>

- (void)applyTypeSearch:(ApplyTypeViewController *)controller didSelectWithObject:(id)aObject;
- (void)applyTypeSearchDidCanceled:(ApplyTypeViewController *)controller;
@end

@interface ApplyTypeViewController : BaseViewController<UIActionSheetDelegate,CommonCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    UISearchBar *searchBar;
    NSMutableArray *applyTypes;
    NSMutableArray *filterTypes;
    PatrolCategory *myFavorate;
    
    BOOL scrollTag;
    BOOL bFavorate;
    BOOL bNeedAll;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *applyTypes;
@property(nonatomic,retain) NSMutableArray *filterTypes;

@property (nonatomic,assign) BOOL bNeedAll;
@property (nonatomic,assign) BOOL bFavorate;
@property (nonatomic,assign) id<ApplyTypeDelegate> delegate;
@property (nonatomic,retain) NSString *titleString;

-(void)setDataList:(NSArray *)applyTypes;
-(void)reload;


@end
