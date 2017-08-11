//
//  GiftTypeViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-9-19.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonCell.h"

@class GiftTypeViewController;
@protocol GiftTypeDelegate <NSObject>

- (void)giftTypeSearch:(GiftTypeViewController *)controller didSelectWithObject:(id)aObject;
- (void)giftTypeSearchDidCanceled:(GiftTypeViewController *)controller;
@end

@interface GiftTypeViewController : BaseViewController<UIActionSheetDelegate,CommonCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    UISearchBar *searchBar;
    NSMutableArray *giftTypes;
    NSMutableArray *filterTypes;
    PatrolCategory *myFavorate;
    
    BOOL scrollTag;
    BOOL bFavorate;
    BOOL bNeedAll;
    id<GiftTypeDelegate> delegate;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *giftTypes;
@property(nonatomic,retain) NSMutableArray *filterTypes;

@property (nonatomic,assign) BOOL bNeedAll;
@property (nonatomic,assign) BOOL bFavorate;
@property (nonatomic,assign) id<GiftTypeDelegate> delegate;
@property (nonatomic,retain) NSString *titleString;

-(void)setDataList:(NSArray *)giftTypes;
-(void)reload;


@end
