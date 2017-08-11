//
//  InspectionTargetsViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-11-25.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "InspectionTreeView.h"
#import "InspectionTreeNode.h"

@protocol InspectionTargetsDelegate <NSObject>

@optional
-(void)InspectionTargetsdidFnishedCheck:(NSMutableArray *)targets;

@end

@interface InspectionTargetsViewController : BaseViewController<UISearchBarDelegate>{
    
    UISearchBar *searchBar;
    InspectionTreeView *treeView;
    NSMutableArray *targetArray;
    NSMutableArray *filterArray;
    NSMutableArray *selectedArray;
    id<InspectionTargetsDelegate> delegate;
    
}

@property(nonatomic,retain) NSMutableArray *selectedArray;
@property(nonatomic,retain) NSMutableArray *targetArray;
@property(nonatomic,assign) id<InspectionTargetsDelegate> delegate;

@end
