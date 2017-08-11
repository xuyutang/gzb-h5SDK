//
//  UserSelectViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/5/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"


@class UserSelectViewController;

@protocol UserSearchDelegate <NSObject>

- (void)userSearch:(UserSelectViewController *)controller didSelectWithObject:(id)aObject;
- (void)userSearchDidCanceled:(UserSelectViewController *)controller;
@end

@interface UserSelectViewController : BaseViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    
    UITableView *tableView;
    UISearchBar *searchBar;
    NSMutableArray *users;
    NSMutableArray *filterUsers;
    
    BOOL scrollTag;
    BOOL bAllUsers;
}

@property(nonatomic,assign) BOOL bAllUsers;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *users;
@property(nonatomic,retain) NSMutableArray *filterUsers;

@property (nonatomic,assign) id<UserSearchDelegate> delegate;
@property (nonatomic,retain) NSString *titleString;

- (id)initWithDataList:(NSArray *)users delegate:(id<UserSearchDelegate>)delegate;

@end
