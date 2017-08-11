//
//  InspectionTreeView.m
//  SalesManager
//
//  Created by liuxueyan on 14-12-1.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InspectionTreeView2.h"
#define CELL_H      50
#define CELL_IMG_W  30
#define CELL_IMG_H  30
#define CELL_EXP_W  20
#define CELL_EXP_H  20
#define CELL_LEV_W  20
#define RELEASE(_o) [_o release], _o = nil

static UIImage *_check_n;
static UIImage *_check_ed;
@interface TreeCell : UITableViewCell
{
    InspectionTreeView2 *_parent;
    InspectionTreeNode *_node;
    UIButton *_btnCheck;
}
@property(nonatomic, retain)InspectionTreeNode *node;
@property(nonatomic, retain)UIButton *btnCheck;
@property(nonatomic, retain)InspectionTreeView2 *parent;
@end

@implementation TreeCell

@synthesize node = _node;
@synthesize btnCheck = _btnCheck;
@synthesize parent = _parent;



-(id)initWithStyleAndParent:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andParentView:(InspectionTreeView2*)andParentView{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        if(_check_n==nil)
            _check_n = [[UIImage imageNamed:@"sintreecheck_no"] copy];
        if(_check_ed==nil)
            _check_ed = [[UIImage imageNamed:@"sintreecheck_yes"] copy];
        
        _parent = andParentView;
        _btnCheck = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        
        [self.contentView addSubview:_btnCheck];
    }
    return self;
}

-(void)dealloc{
    self.node = nil;
    RELEASE(_btnCheck);
    [super dealloc];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat sx = self.node.level*CELL_LEV_W;
    _btnCheck.frame = CGRectMake(sx, (h-CELL_IMG_H)/2, CELL_IMG_W, CELL_IMG_H);
    self.textLabel.frame = CGRectMake(sx+CELL_IMG_W+5, -5, w-sx-CELL_IMG_W-CELL_EXP_W, h);
    self.detailTextLabel.frame = CGRectMake(sx+CELL_IMG_W+5, 12, w-sx-CELL_IMG_W-CELL_EXP_W, h);
    if(self.node.isContainer){
        self.textLabel.text = [NSString stringWithFormat:@"%@(%d)", self.node.text, [self.node.children count]];
    }
    else{
        self.textLabel.text = self.node.text;
    }
    self.detailTextLabel.text = self.node.number;
    self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.font = [UIFont systemFontOfSize:17];
    self.imageView.frame = CGRectMake(w-CELL_EXP_W, (h-CELL_EXP_H)/2, CELL_EXP_W, CELL_EXP_H);
    
    [_btnCheck setImage:self.node.checked?_check_ed:_check_n forState:UIControlStateNormal];
    //[_btnCheck setTag:self.tag];
}

@end



@implementation InspectionTreeView2
@synthesize checkedArray;
@synthesize bLinkParent;
@synthesize cells = _cells;
@synthesize root = _root;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setDelegate:self];
        [self setDataSource:self];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        checkedArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}
-(void)dealloc{
    RELEASE(_cells);
    RELEASE(_root);
    [super dealloc];
}
- (void)setRootNode:(InspectionTreeNode *)rootNode{
    if (rootNode == nil) {
        return;
    }
    [rootNode retain];
    [_root release];
    _root = rootNode;
    [_cells removeAllObjects];
    if(_cells == nil)
        _cells = [[NSMutableArray alloc] initWithCapacity:0];
    [_cells addObject:_root];
    if(_root.expanded){
        [self expandNode:_root];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cells count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (bLinkParent && indexPath.row == 0) {
        return 0;
    }
    return CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SinTreeCellIdentifier1";
	TreeCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SinTreeCellIdentifier0"];
        if (cell == nil)
        {
            cell = [[[TreeCell alloc] initWithStyleAndParent:UITableViewCellStyleSubtitle
                                             reuseIdentifier:@"SinTreeCellIdentifier0" andParentView:self] autorelease];
            [cell.btnCheck setHidden:YES];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[TreeCell alloc] initWithStyleAndParent:UITableViewCellStyleSubtitle
                                             reuseIdentifier:CellIdentifier andParentView:self] autorelease];
        }
    }
    InspectionTreeNode *node = [_cells objectAtIndex:indexPath.row];
    node.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    cell.node = node;
    cell.btnCheck.tag = cell.tag = indexPath.row;
    if (bLinkParent && indexPath.row ==0) {
        //[cell.btnCheck setHidden:YES];
    }
    if (node.checked) {
        BOOL bAdded = NO;
        for (InspectionTreeNode *checkedNode in checkedArray) {
            if (node.department.v1.id == checkedNode.department.v1.id) {
                bAdded = YES;
                break;
            }
        }
        if (!bAdded) {
            [checkedArray addObject:node];
        }
    }
    
    //NSLog(@"indexPath.row = %d",indexPath.row);
    [cell.btnCheck addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell setNeedsUpdateConstraints];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InspectionTreeNode *node = [_cells objectAtIndex:indexPath.row];
    if (self.selected) {
        self.selected(self,node.target.v1.id);
    }
    node.delegate = self;
    if(node.children != nil && [node.children count]>0){
        if(!node.expanded){
            node.expanded = YES;
            [self expandNode:node];
        }
        else{
            if(node.hasChilren){
                node.expanded = NO;
                [self unexpandNode:node];
            }
        }
    }
}

- (void)expandNode:(InspectionTreeNode*)node{
    node.delegate = self;
    NSInteger location = [_cells indexOfObject:node]+1;
    NSMutableArray *willExpand = [NSMutableArray array];
    for (InspectionTreeNode* ch in node.children) {
        ch.delegate = self;
        [willExpand addObject:[NSIndexPath indexPathForRow:location inSection:0]];
        [_cells insertObject:ch atIndex:location++];
    }
    //[self insertRowsAtIndexPaths:willExpand withRowAnimation:UITableViewRowAnimationLeft];
    for (InspectionTreeNode* ch in node.children) {
        ch.delegate = self;
        if(ch.expanded && ch.hasChilren){
            [self expandNode:ch];
        }
    }
    [self reloadData];
}

- (void)unexpandNode:(InspectionTreeNode *)node{
    node.delegate = self;
    if(node.hasChilren){
        [self unexpandNodes:node.children];
    }
}

-(void)unexpandNodes:(NSArray*)nodes{
	for(InspectionTreeNode *node in nodes ) {
        node.delegate = self;
		NSUInteger indexToRemove=[_cells indexOfObjectIdenticalTo:node];
		NSArray *willUnexpand=node.children;
		if(willUnexpand && [willUnexpand count]>0){
			[self unexpandNodes:willUnexpand];
		}
		
		if([_cells indexOfObjectIdenticalTo:node]!=NSNotFound) {
            if (indexToRemove <_cells.count) {
                for (int i = indexToRemove+1; i<_cells.count; i++) {
                    TreeCell *cell = (TreeCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    cell.btnCheck.tag = cell.tag = i-1;
                    //NSLog(@"node reset tag : %@ tag = %d",node.text,i-1);
                }
            }
            //NSLog(@"remove node : %@",node.text);
            [_cells removeObjectIdenticalTo:node];
			[self deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]]withRowAnimation:UITableViewRowAnimationRight];
		}
	}
}

-(void)checkAction:(id)sender {
    UIButton *btn = sender;
    InspectionTreeNode *node = [_cells objectAtIndex:btn.tag];
    node.delegate = self;
    [node changeCheckStatus:!node.checked linkage:YES];
    if(bLinkParent)[self checkParent:node.parentId];
    [self reloadData];
}

-(void)checkParent:(InspectionTreeNode *)node{
    
    BOOL bCheck = YES;
    for (InspectionTreeNode* ch in node.children) {
        if (!ch.checked) {
            bCheck = NO;
            break;
        }
    }
    
    NSLog(@"node %d is check: %@",node.cid,bCheck?@"YES":@"NO");
    [node changeCheckStatus:bCheck linkage:NO];
    
    if (node.parentId != nil) {
        [self checkParent:node.parentId];
    }
    return;
    
}

-(void)finishedCheckNode:(InspectionTreeNode *)node status:(BOOL)checked{
    if (checked) {
        [checkedArray addObject:node];
        NSLog(@"add node : %@",node.text);
    }else{
        [checkedArray removeObject:node];
        NSLog(@"remove node : %@",node.text);
    }
}


@end
