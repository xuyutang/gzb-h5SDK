//
//  SinTreeCheckView.h
//  SinTreeCheckDemo
//
//  Created by RobinTang on 12-12-19.
//  Copyright (c) 2012年 com.sin All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinTreeCheckNode.h"

@class SinTreeCheckView;
@interface TreeCheckCell : UITableViewCell
{
    SinTreeCheckView *_parent;
    SinTreeCheckNode *_node;
}
@property(nonatomic, retain)SinTreeCheckNode *node;
@property(nonatomic, retain)UIButton *btnCheck;
@property(nonatomic, retain)SinTreeCheckView *parent;
@property (nonatomic,assign) BOOL bOnlyCheckChildren;

-(id)initWithStyleAndParent:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andParentView:(SinTreeCheckView*)andParentView onlyCheckChildren:(BOOL) onlyCheckChildren;
-(id)initWithStyleAndParent:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andParentView:(SinTreeCheckView*)andParentView onlyCheckChildren:(BOOL) onlyCheckChildren sinTreeNode:(SinTreeCheckNode *) sinTreeNode;
@end

@protocol SinTreeCheckViewDelegate <NSObject>

@optional
-(void)clickNode:(SinTreeCheckNode *)node status:(BOOL)checked;

@end

@interface SinTreeCheckView : UITableView<UITableViewDelegate, UITableViewDataSource,SinTreeCheckNodeDelegate>
{
    NSMutableArray *_cells;
    SinTreeCheckNode *_root;
    
    NSMutableArray *checkedArray;
}

@property(nonatomic,retain) SinTreeCheckNode *root;
@property(nonatomic,retain) NSMutableArray *cells;
@property(nonatomic,assign) BOOL bLinkParent;
@property(nonatomic,retain) NSMutableArray *checkedArray;
@property(nonatomic,assign) id<SinTreeCheckViewDelegate> treeDelegate;

@property (nonatomic,assign) BOOL bSingle;
@property (nonatomic,assign) BOOL bNonCheckRoot;//根节点是否可选
@property (nonatomic,assign) int selectedCount;//每个根的子节点限定选择个数，0 默认不限制
@property (nonatomic,assign) int maxCount;
@property (nonatomic,retain) NSMutableArray *countArray;

- (void)setRootNode:(SinTreeCheckNode *)rootNode;
- (void)expandNode:(SinTreeCheckNode*)node;
- (void)unexpandNode:(SinTreeCheckNode *)node;
- (void)appendRootNode:(SinTreeCheckNode *)rootNode;
@end
