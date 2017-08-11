//
//  PatrolSearchView.h
//  SalesManager
//
//  Created by liuxueyan on 15-4-30.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKSegmentedControl.h"
#import "SinTreeCheckView.h"
#import "PatrolTypeView.h"
#import "CustomerTypeView.h"
#import "DateSelectView.h"

@interface PatrolSearchView : UIView<UITableViewDataSource,UITableViewDelegate,AKSegmentedControlDelegate,SinTreeCheckViewDelegate,PatrolTypeViewDelegate,CustomerTypeViewDelegate,DateSelectViewDelegate>
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UIButton *btClose;
@property (retain, nonatomic) IBOutlet AKSegmentedControl *segmentCtrl;
@property (retain, nonatomic) IBOutlet UIView *selectView;
@property (retain, nonatomic) IBOutlet UITextField *name;
@property (retain, nonatomic) NSMutableArray *selectedArray;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) SinTreeCheckView *treeView;
@property (retain, nonatomic) PatrolTypeView *patrolTypeView;
@property (retain, nonatomic) CustomerTypeView *customerTypeView;
@property (retain, nonatomic) DateSelectView *dateSelectView;

-(void)initSegment;
@end
