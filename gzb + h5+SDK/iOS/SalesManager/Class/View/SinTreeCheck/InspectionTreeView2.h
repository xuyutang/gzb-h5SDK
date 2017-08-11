//
//  InspectionTreeView.h
//  SalesManager
//
//  Created by liuxueyan on 14-12-1.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InspectionTreeNode.h"

@interface InspectionTreeView2 : UITableView<UITableViewDelegate, UITableViewDataSource,InspectionTreeNodeDelegate>
{
    NSMutableArray *_cells;
    InspectionTreeNode *_root;
    
    NSMutableArray *checkedArray;
}

@property(nonatomic,retain) InspectionTreeNode *root;
@property(nonatomic,retain) NSMutableArray *cells;
@property(nonatomic,assign) BOOL bLinkParent;
@property(nonatomic,retain) NSMutableArray *checkedArray;

@property(nonatomic,copy) void(^selected) (InspectionTreeView2 *treeView,int objId);

- (void)setRootNode:(InspectionTreeNode *)rootNode;
- (void)expandNode:(InspectionTreeNode*)node;
- (void)unexpandNode:(InspectionTreeNode *)node;




@end
