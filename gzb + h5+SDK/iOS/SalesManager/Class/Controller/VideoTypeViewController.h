//
//  VideoTypeViewController.h
//  SalesManager
//
//  Created by Administrator on 15/11/5.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CommonCell.h"

@class VideoTypeViewController;
@protocol VideoTypeDelegate <NSObject>

- (void)videoTypeSearch:(VideoTypeViewController *)controller didSelectWithObject:(id)aObject;
- (void)videoTypeSearchDidCanceled:(VideoTypeViewController *)controller;
@end

@interface VideoTypeViewController : BaseViewController<UIActionSheetDelegate,CommonCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    UISearchBar *searchBar;
    NSMutableArray *videoTypes;
    NSMutableArray *filterTypes;
    PatrolCategory *myFavorate;
    
    BOOL scrollTag;
    BOOL bFavorate;
    BOOL bNeedAll;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *videoTypes;
@property(nonatomic,retain) NSMutableArray *filterTypes;

@property (assign ,nonatomic) BOOL bSearch;
@property (nonatomic,assign) BOOL bNeedAll;
@property (nonatomic,assign) BOOL bFavorate;
@property (nonatomic,assign) id<VideoTypeDelegate> delegate;
@property (nonatomic,retain) NSString *titleString;


-(void)setDataList:(NSArray *)videoTypes;
-(void)reload;


@end

