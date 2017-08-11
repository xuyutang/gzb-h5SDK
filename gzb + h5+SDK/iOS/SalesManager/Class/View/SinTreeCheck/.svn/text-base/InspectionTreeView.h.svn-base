//
//  InspectionTreeView.h
//  SalesManager
//
//  Created by liuxueyan on 14-12-1.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InspectionTreeNode.h"
#define LOAD_MORE NSLocalizedString(@"load_more", nil)
#define LOAD_MORE_SUBCATEGORY NSLocalizedString(@"load_more_subcategory", nil)

@interface InspectionTreeView : UITableView<UITableViewDelegate, UITableViewDataSource,InspectionTreeNodeDelegate>
{
    NSMutableArray *_cells;
    InspectionTreeNode *_root;
    
    NSMutableArray *checkedArray;
    NSMutableDictionary *parentNodeDic;
    NSInteger cid;
}

@property(nonatomic,retain) InspectionTreeNode *root;
@property(nonatomic,retain) NSMutableArray *cells;
@property(nonatomic,assign) BOOL bLinkParent;
@property(nonatomic,retain) NSMutableArray *checkedArray;
@property (nonatomic,retain) NSString *searchText;
@property (nonatomic,assign) int rootIndex;

- (void)setRootNode:(InspectionTreeNode *)rootNode;
- (void)expandNode:(InspectionTreeNode*)node;
- (void)unexpandNode:(InspectionTreeNode *)node;



-(void) reloadTableCell;

@end
