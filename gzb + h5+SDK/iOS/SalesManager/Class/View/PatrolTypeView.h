//
//  PatrolTypeView.h
//  SalesManager
//
//  Created by liuxueyan on 15-5-5.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PatrolTypeViewDelegate <NSObject>

@optional
-(void)selectedPatrolCategory:(PatrolCategory *)category status:(BOOL)checked;

@end

@interface PatrolTypeView : UIView<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *patrolTypes;
    PatrolCategory *myFavorate;
}
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,assign)id<PatrolTypeViewDelegate> delegate;

- (void)initView;
@end
