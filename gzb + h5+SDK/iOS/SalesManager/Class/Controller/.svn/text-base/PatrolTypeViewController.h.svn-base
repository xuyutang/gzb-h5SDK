//
//  PatrolTypeViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/3/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonCell.h"

@class PatrolTypeViewController;

@protocol PatrolTypeDelegate <NSObject>

- (void)patrolSearch:(PatrolTypeViewController *)controller didSelectWithObject:(id)aObject;
- (void)patrolSearchDidCanceled:(PatrolTypeViewController *)controller;
- (void)allCatgory;
@end

@interface PatrolTypeViewController : BaseViewController<UIActionSheetDelegate,CommonCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    UISearchBar *searchBar;
    NSMutableArray *patrolTypes;
    NSMutableArray *filterTypes;
    PatrolCategory *myFavorate;
    NSMutableArray *mulArray ;
    
    BOOL scrollTag;
    BOOL bFavorate;
    BOOL bNeedAll;
    BOOL hidenBool;
    BOOL allBool;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *patrolTypes;
@property(nonatomic,retain) NSMutableArray *filterTypes;
@property(nonatomic,assign)  BOOL allBool;

@property(nonatomic,assign)  BOOL hidenBool;
@property (nonatomic,assign) BOOL bNeedAll;
@property (nonatomic,assign) BOOL bFavorate;
@property (nonatomic,assign) id<PatrolTypeDelegate> delegate;
@property (nonatomic,retain) NSString *titleString;

-(void)setDataList:(NSArray *)patrolTypes;
-(void)reload;

@end
