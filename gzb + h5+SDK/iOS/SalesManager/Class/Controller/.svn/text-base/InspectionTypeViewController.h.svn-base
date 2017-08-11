//
//  InspectionTypeViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-11-27.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonCell.h"

@class InspectionTypeViewController;

@protocol InspectionTypeDelegate <NSObject>

- (void)inspectionSearch:(InspectionTypeViewController *)controller didSelectWithObject:(id)aObject;
- (void)inspectionSearchDidCanceled:(InspectionTypeViewController *)controller;
-(void)allInspect;
@end

@interface InspectionTypeViewController : BaseViewController<UIActionSheetDelegate,CommonCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    UISearchBar *searchBar;
    NSMutableArray *inspectionTypes;
    NSMutableArray *filterTypes;
    NSMutableArray *inspectMularry;
    
    BOOL scrollTag;
    BOOL bFavorate;
    BOOL bNeedAll;
   
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *inspectionTypes;
@property(nonatomic,retain) NSMutableArray *filterTypes;

@property (nonatomic,assign) BOOL bNeedAll;
@property (nonatomic,assign) BOOL bFavorate;
@property (nonatomic,assign) id<InspectionTypeDelegate> delegate;
@property (nonatomic,retain) NSString *titleString;

@property (nonatomic,assign) BOOL allBool;
-(void)setDataList:(NSArray *)inspectionTypes;
-(void)reload;


@end
