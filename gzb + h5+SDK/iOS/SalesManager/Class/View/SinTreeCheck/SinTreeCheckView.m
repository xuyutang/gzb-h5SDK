//
//  SinTreeCheckView.m
//  SinTreeCheckDemo
//
//  Created by RobinTang on 12-12-19.
//  Copyright (c) 2012年 com.sin All rights reserved.
//

#import "SinTreeCheckView.h"
#define CELL_H      40
#define CELL_IMG_W  20
#define CELL_IMG_H  20
#define CELL_EXP_W  20
#define CELL_EXP_H  20
#define CELL_LEV_W  20
#define RELEASE(_o) [_o release], _o = nil

static UIImage *_check_n;
static UIImage *_check_ed;

@implementation TreeCheckCell

@synthesize node = _node;
@synthesize btnCheck = _btnCheck;
@synthesize parent = _parent;



-(id)initWithStyleAndParent:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andParentView:(SinTreeCheckView*)andParentView onlyCheckChildren:(BOOL) onlyCheckChildren{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.bOnlyCheckChildren = onlyCheckChildren;
        if(_check_n==nil)
            _check_n = [[UIImage  imageNamed:@"sintreecheck_no"] copy];
        if(_check_ed==nil)
            _check_ed = [[UIImage imageNamed:@"sintreecheck_yes"] copy];
        _parent = andParentView;
        _btnCheck = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [self.contentView addSubview:_btnCheck];
    }
    return self;
}

-(id)initWithStyleAndParent:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andParentView:(SinTreeCheckView*)andParentView onlyCheckChildren:(BOOL) onlyCheckChildren sinTreeNode:(SinTreeCheckNode *) sinTreeNode{
    self = [self initWithStyleAndParent:style reuseIdentifier:reuseIdentifier andParentView:andParentView onlyCheckChildren:onlyCheckChildren];
    if(self){
        self.node = sinTreeNode;
        [self resetView:self.node bOnlyCheckChildren:self.bOnlyCheckChildren];
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
    
    [self resetView:self.node bOnlyCheckChildren:self.bOnlyCheckChildren];
    //[_btnCheck setTag:self.tag];
}


-(void) resetView:(SinTreeCheckNode *) stcn bOnlyCheckChildren:(BOOL) bOnlyCheckChildren{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat sx = stcn.level*CELL_LEV_W;
    _btnCheck.frame = CGRectMake(sx, (h-CELL_IMG_H)/2, CELL_IMG_W, CELL_IMG_H);
    self.textLabel.frame = CGRectMake(sx+CELL_IMG_W + 5, 0, w-sx-CELL_IMG_W-CELL_EXP_W, h);
    if(stcn.isContainer){
        self.textLabel.text = [NSString stringWithFormat:@"%@(%d)", stcn.text, [stcn.children count]];
        if (bOnlyCheckChildren) {
            if (!stcn.expanded) {
                [self.btnCheck setImage:[UIImage imageNamed:@"expander_ic_maximized.png"] forState:UIControlStateNormal];
            }else{
                [self.btnCheck setImage:[UIImage imageNamed:@"expander_ic_minimized.png"] forState:UIControlStateNormal];
            }
        }else{
            [_btnCheck setImage:stcn.checked?_check_ed:_check_n forState:UIControlStateNormal];
        }
    }
    else{
        [_btnCheck setImage:stcn.checked?_check_ed:_check_n forState:UIControlStateNormal];
        self.textLabel.text = stcn.text;
    }
    self.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
    self.imageView.frame = CGRectMake(w-CELL_EXP_W, (h-CELL_EXP_H)/2, CELL_EXP_W, CELL_EXP_H);
    
    
}

@end



@implementation SinTreeCheckView
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
    RELEASE(checkedArray);
    [super dealloc];
}
- (void)setRootNode:(SinTreeCheckNode *)rootNode{
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

- (void)appendRootNode:(SinTreeCheckNode *)rootNode{
    if (rootNode == nil) {
        return;
    }
    [rootNode retain];
    [_root release];
    _root = rootNode;
//    [_cells removeAllObjects];
    if(_cells == nil)
        _cells = [[NSMutableArray alloc] initWithCapacity:0];
    [_cells addObject:_root];
    if(_root.expanded){
        [self expandNode:_root];
    }
    
    //初始化计数
    _countArray = [[NSMutableArray alloc] initWithCapacity:_cells.count];
    for (int i = 0; i < _cells.count; i++) {
        SinTreeCheckNode *node = _cells[i];
        if (node.parentId == 0) {
            int count = [self getCheckCount:node index:0];
            [_countArray addObject:@(count)];
        }
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
    static NSString *CellIdentifier = @"SinTreeCheckCellIdentifier";
	TreeCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[TreeCheckCell alloc] initWithStyleAndParent:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CellIdentifier andParentView:self onlyCheckChildren:NO];
	}
    [cell setBackgroundView:nil];
    [cell setBackgroundColor:[UIColor clearColor]];
    SinTreeCheckNode *node = [_cells objectAtIndex:indexPath.row];
    node.delegate = self;
    cell.node = node;
    cell.btnCheck.tag = cell.tag = indexPath.row;
    if (bLinkParent && indexPath.row ==0) {
        [cell.btnCheck setHidden:YES];
    }
    if (node.checked) {
        BOOL bAdded = NO;
        for (SinTreeCheckNode *checkedNode in checkedArray) {
            if ([[node.department valueForKey:@"id"] isEqual:[checkedNode.department valueForKey:@"id"]]) {
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
    SinTreeCheckNode *node = [_cells objectAtIndex:indexPath.row];
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

- (void)expandNode:(SinTreeCheckNode*)node{
    node.delegate = self;
    NSInteger location = [_cells indexOfObject:node]+1;
    NSMutableArray *willExpand = [NSMutableArray array];
    for (SinTreeCheckNode* ch in node.children) {
        ch.delegate = self;
        [willExpand addObject:[NSIndexPath indexPathForRow:location inSection:0]];
        [_cells insertObject:ch atIndex:location++];
    }
    //[self insertRowsAtIndexPaths:willExpand withRowAnimation:UITableViewRowAnimationLeft];
    for (SinTreeCheckNode* ch in node.children) {
        ch.delegate = self;
        if(ch.expanded && ch.hasChilren){
            [self expandNode:ch];
        }
    }
    [self reloadData];
}

- (void)unexpandNode:(SinTreeCheckNode *)node{
    node.delegate = self;
    if(node.hasChilren){
        [self unexpandNodes:node.children];
    }
}

-(void)unexpandNodes:(NSArray*)nodes{
	for(SinTreeCheckNode *node in nodes ) {
        node.delegate = self;
		NSUInteger indexToRemove=[_cells indexOfObjectIdenticalTo:node];
		NSArray *willUnexpand=node.children;
		if(willUnexpand && [willUnexpand count]>0){
			[self unexpandNodes:willUnexpand];
		}
		
		if([_cells indexOfObjectIdenticalTo:node]!=NSNotFound) {
            if (indexToRemove <_cells.count) {
                for (int i = indexToRemove+1; i<_cells.count; i++) {
                    TreeCheckCell *cell = (TreeCheckCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
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
    SinTreeCheckNode *node = [_cells objectAtIndex:btn.tag];
    if (_bSingle || _bNonCheckRoot) {
        if ([node hasChilren])return;
    }
    if (_bSingle) {
        [self setCancelCheckStatusWithRootId:node.rootId node:node];
    }else{
        //默认不检测限定选择个数
        if (_selectedCount > 0) {
            //多选个数限定
            int selectedCount = [_countArray[node.rootId] intValue];
            if (node.checked) {
                //移除选中个数
                [_countArray replaceObjectAtIndex:node.rootId withObject:@(selectedCount - 1)];
            }else{
                if ([self getSlectedSum] >= _maxCount) {
                    [self showInfoMsg:[NSString stringWithFormat:NSLocalizedString(@"customer_tagvalue_max_count", nil),_maxCount]];
                    return;
                }
                //新增选择个数
                if ((selectedCount + 1) > _selectedCount) {
                    [self showInfoMsg:[NSString stringWithFormat:NSLocalizedString(@"customer_tagvalue_count", nil),_selectedCount]];
                    return;
                }
                [_countArray replaceObjectAtIndex:node.rootId withObject:@(selectedCount + 1)];
            }
        }
    }
    node.delegate = self;
    [node changeCheckStatus:!node.checked linkage:!_bNonCheckRoot];
    if(bLinkParent)[self checkParent:node.parentId];
    [self reloadData];
}


-(int) getSlectedSum{
    int count = 0;
    for (int i = 0; i < _countArray.count; i++) {
        count += [_countArray[i] intValue];
    }
    return count;
}

-(int) getCheckCount:(SinTreeCheckNode *) node index:(int) index{
    for (SinTreeCheckNode *item in node.children) {
        index = [self getCheckCount:item index:item.checked ? ++index : index];
    }
    return index;
}


//取消当前根组总中选择项
-(void) setCancelCheckStatusWithRootId:(int) rootId node:(SinTreeCheckNode*) node{
    for (SinTreeCheckNode *item in _cells) {
        if (item.rootId == rootId && item.checked) {
            item.delegate = self;
            if (item.cid == node.cid) {
                [item changeCheckStatus:node.checked linkage:YES];
            }else{
                [item changeCheckStatus:NO linkage:YES];
            }
        }
    }
}

-(SinTreeCheckNode*) findCheckNode{
    for (SinTreeCheckNode *node in _cells) {
        if (node.checked) {
            return node;
        }
    }
    return nil;
}

-(void)checkParent:(SinTreeCheckNode *)node{
    
    BOOL bCheck = YES;
    for (SinTreeCheckNode* ch in node.children) {
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

-(void)finishedCheckNode:(SinTreeCheckNode *)node status:(BOOL)checked{
    if (_bSingle) {
        if (node.parentId == 0) {
            return;
        }
    }
    if (checked) {
        BOOL bAdded = NO;
        for (SinTreeCheckNode *checkedNode in checkedArray) {
            if ([node.department valueForKey:@"id"] == [checkedNode.department valueForKey:@"id"]) {
                bAdded = YES;
                break;
            }
        }
        if (!bAdded) {
            [checkedArray addObject:node];
        }
        NSLog(@"add node : %@",node.text);
    }else{
        [checkedArray removeObject:node];
        NSLog(@"remove node : %@",node.text);
    }
    if (_treeDelegate != nil && [_treeDelegate respondsToSelector:@selector(clickNode:status:)]) {
        [_treeDelegate clickNode:node status:checked];
    }
}


-(void) showInfoMsg:(NSString *) msg{
    [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                      description:msg
                             type:MessageBarMessageTypeInfo
                      forDuration:INFO_MSG_DURATION];
}

@end
