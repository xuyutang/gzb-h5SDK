//
//  InspectionTargetTypeViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-12-3.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonCell.h"

@class InspectionTargetTypeViewController;

@protocol TargetTypeDelegate <NSObject>

- (void)targetTypeSearch:(InspectionTargetTypeViewController *)controller didSelectWithObject:(id)aObject;
- (void)targetTypeSearchDidCanceled:(InspectionTargetTypeViewController *)controller;
-(void)allTarget;
@end

@interface InspectionTargetTypeViewController : BaseViewController<UIActionSheetDelegate,CommonCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    UISearchBar *searchBar;
    NSMutableArray *targetTypes;
    NSMutableArray *filterTypes;
    NSMutableArray *targetArray;
    
    BOOL scrollTag;
    BOOL bFavorate;
    BOOL bNeedAll;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *targetTypes;
@property(nonatomic,retain) NSMutableArray *filterTypes;

@property (nonatomic,assign) BOOL bNeedAll;
@property (nonatomic,assign) BOOL bFavorate;
@property (nonatomic,assign) id<TargetTypeDelegate> delegate;
@property (nonatomic,retain) NSString *titleString;

-(void)setDataList:(NSArray *)targetTypes;
-(void)reload;



@end
