//
//  SinTreeCheckView.h
//  SinTreeCheckDemo
//
//  Created by RobinTang on 12-12-19.
//  Copyright (c) 2012年 com.sin All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinTreeCheckNode.h"

@class CustTagCheckView;
@interface CustTagTreeCheckCell : UITableViewCell
{
    CustTagCheckView *_parent;
    SinTreeCheckNode *_node;
}
@property(nonatomic, retain)SinTreeCheckNode *node;
@property(nonatomic, retain)UIButton *btnCheck;
@property(nonatomic, retain)CustTagCheckView *parent;

-(id)initWithStyleAndParent:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andParentView:(CustTagCheckView*)andParentView;
-(id)initWithStyleAndParent:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andParentView:(CustTagCheckView*)andParentView sinTreeNode:(SinTreeCheckNode *) sinTreeNode;
@end

@protocol CustTagCheckViewDelegate <NSObject>

@optional
-(void)clickNode:(SinTreeCheckNode *)node status:(BOOL)checked;
@end

@interface CustTagCheckView : UITableView<UITableViewDelegate, UITableViewDataSource,SinTreeCheckNodeDelegate>
{
    NSMutableArray *_cells;
    SinTreeCheckNode *_root;
    
    NSMutableArray *checkedArray;
}

@property (nonatomic,retain) NSMutableArray *tagsArray;
@property(nonatomic,retain) SinTreeCheckNode *root;
@property(nonatomic,retain) NSMutableArray *cells;
@property(nonatomic,assign) BOOL bLinkParent;
@property(nonatomic,retain) NSMutableArray *checkedArray;
@property(nonatomic,assign) id<CustTagCheckViewDelegate> treeDelegate;

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
