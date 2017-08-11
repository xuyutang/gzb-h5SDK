//
//  DropMenu.h
//  SalesManager
//
//  Created by liuxueyan on 15-5-19.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropMenuDelegate <NSObject>

@optional
-(void)selectedDropMenuIndex:(int)index row:(int)row;

@end


@interface DropMenu : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign) int menuCount;

@property(nonatomic,retain) NSMutableArray *array1;
@property(nonatomic,retain) NSMutableArray *array2;
@property(nonatomic,retain) NSMutableArray *array3;

@property(nonatomic,retain) UITableView *tableView1;
@property(nonatomic,retain) UITableView *tableView2;
@property(nonatomic,retain) UITableView *tableView3;

@property(nonatomic,assign) int selectedIndex1;
@property(nonatomic,assign) int selectedIndex2;
@property(nonatomic,assign) int selectedIndex3;

@property(nonatomic,assign) id<DropMenuDelegate> delegate;


-(void)initMenu;
@end

