//
//  InspectionTreeView.m
//  SalesManager
//
//  Created by liuxueyan on 14-12-1.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InspectionTreeView.h"
#import "NSString+Util.h"
#define CELL_H      44
#define CELL_IMG_W  16
#define CELL_IMG_H  16
#define CELL_EXP_W  16
#define CELL_EXP_H  16
#define CELL_LEV_W  16
#define RELEASE(_o) [_o release], _o = nil

static UIImage *_check_n;
static UIImage *_check_ed;

static UIImage *_groupcheck_n;
static UIImage *_groupcheck_ed;

@interface TreeCell : UITableViewCell {
    InspectionTreeView *_parent;
    InspectionTreeNode *_node;
    UIButton *_btnCheck;
    UIButton *_gropBtn;
    UIScrollView *scrollView;//跑马灯范围限制
}
@property(nonatomic, retain)InspectionTreeNode *node;
@property(nonatomic, retain)UIButton *btnCheck;
@property(nonatomic, retain)UIButton *gropBtn;
@property(nonatomic, retain)InspectionTreeView *parent;

+(NSMutableDictionary *) sheardTotalCountDic;

@end

static NSMutableDictionary *totalCountDic;
@implementation TreeCell
{
    NSString *totalCount;
}

@synthesize node = _node;
@synthesize btnCheck = _btnCheck;
@synthesize gropBtn = _gropBtn;
@synthesize parent = _parent;

-(id)initWithStyleAndParent:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andParentView:(InspectionTreeView*)andParentView{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        if(_check_n==nil)
            _check_n = [[UIImage imageNamed:@"noraml_check_off"] copy];
        if(_check_ed==nil)
            _check_ed = [[UIImage imageNamed:@"noraml_check_on"] copy];
        if (_groupcheck_n == nil)
            _groupcheck_n = [[UIImage imageNamed:@"expander_ic_maximized"] copy];
        if (_groupcheck_ed == nil)
            _groupcheck_ed = [[UIImage imageNamed:@"expander_ic_minimized"] copy];
        
        _parent = andParentView;
        _gropBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _btnCheck = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [self.contentView addSubview:_gropBtn];
        [self.contentView addSubview:_btnCheck];
    }
    return self;
}

+(NSMutableDictionary *)sheardTotalCountDic{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        totalCountDic = [[NSMutableDictionary alloc] init];
    });
    return totalCountDic;
}

-(void)dealloc{
    self.node = nil;
    RELEASE(_btnCheck);
    [super dealloc];
}
-(void)setNode:(InspectionTreeNode *)node{
    _node = node;
    if (_node != nil) {
        if (self.node.level == 1) {
            NSString *parentId = [NSString stringWithFormat:@"%d",self.node.target.id];
            totalCount = [[TreeCell sheardTotalCountDic] objectForKey:parentId];
            if (totalCount == nil || totalCount.length == 0) {
                totalCount = [NSString stringWithFormat:@"%d",[LOCALMANAGER getInspectionTargetsTotalCountWithParentId:self.node.target.id]];
                [totalCountDic setObject:totalCount forKey:parentId];
            }
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat sx = self.node.level*CELL_LEV_W;
    
    _gropBtn.frame = CGRectMake(sx - CELL_IMG_W , 0, CELL_IMG_W, CELL_IMG_H);
//    _gropBtn.backgroundColor = WT_RED;
    
    _btnCheck.frame = CGRectMake(sx+10, 0, 17, 17);
//    _btnCheck.backgroundColor = WT_GREEN;
    
    self.textLabel.frame = CGRectMake(sx+CELL_IMG_W+22, 0, w-sx-CELL_IMG_W-CELL_EXP_W, h);
    self.detailTextLabel.frame = CGRectMake(sx+CELL_IMG_W+22, 22, w-sx-CELL_IMG_W-CELL_EXP_W, h);
    
    //self.node.isContainer
    if(self.node.level == 1){
        if (self.textLabel.frame.size.height == 0) {
            [self.textLabel removeFromSuperview];
            return;
        }
        
        self.textLabel.text = [NSString stringWithFormat:@"%@(%@)", self.node.text, totalCount];
        if ([totalCount intValue] ) {
            self.gropBtn.hidden = NO;
        }else {
            self.gropBtn.hidden = YES;
            
        }
        
    }
    else{
        self.textLabel.text = self.node.text;
        self.gropBtn.hidden = YES;
        
    }
    self.detailTextLabel.text = self.node.number;
    self.detailTextLabel.textColor = WT_LIGHT_GRAY;
    self.detailTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
    self.imageView.frame = CGRectMake(w-CELL_EXP_W, (h-CELL_EXP_H)/2, CELL_EXP_W, CELL_EXP_H);
    
    [_gropBtn setImage:self.node.expanded?_groupcheck_ed:_groupcheck_n forState:UIControlStateNormal];
    _gropBtn.userInteractionEnabled = NO;
    
    [_btnCheck setImage:self.node.checked?_check_ed:_check_n forState:UIControlStateNormal];
    
    //[_btnCheck setTag:self.tag];
    
    //自动高度
    self.textLabel.numberOfLines = 0;
    self.detailTextLabel.numberOfLines = 0;
    CGSize size = [[self.textLabel.text trim] rebuildSizeWtihContentWidth:self.textLabel.frame.size.width FontSize:FONT_SIZE + 1];
    CGSize size2 = [[self.detailTextLabel.text trim] rebuildSizeWtihContentWidth:self.detailTextLabel.frame.size.width FontSize:FONT_SIZE];
    CGRect r = self.textLabel.frame;
    r.size.height = size.height;
    self.textLabel.frame = r;
    CGRect r2 = self.detailTextLabel.frame;
    r2.size.height = size2.height;
    r2.origin.y = r.origin.y + r.size.height ;
    self.detailTextLabel.frame = r2;
}

@end


@implementation InspectionTreeView{
    TreeCell *_cell;
}
@synthesize checkedArray;
@synthesize bLinkParent;
@synthesize cells = _cells;
@synthesize root = _root;
@synthesize rootIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setDelegate:self];
        [self setDataSource:self];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        checkedArray = [[NSMutableArray alloc] init];
        parentNodeDic = [[NSMutableDictionary alloc] init];
        cid = 0;
        _cell = [[[TreeCell alloc] init] retain];
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
        _cells = [[NSMutableArray alloc] init];
    [_cells addObject:_root];
    if(_root.expanded){
        [self expandNode:_root];
    }
    if (rootIndex == 0) {
        rootIndex = 1;
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
    InspectionTreeNode *node = _cells[indexPath.row];
    _cell.node = node;
    [_cell layoutSubviews];
    CGSize textLable = [[_cell.textLabel.text trim] rebuildSizeWtihContentWidth:_cell.textLabel.frame.size.width - 15 FontSize:FONT_SIZE + 1];
    CGSize detailLable = [[node.number trim] rebuildSizeWtihContentWidth:_cell.textLabel.frame.size.width - CELL_EXP_W FontSize:FONT_SIZE];
    float h = textLable.height + detailLable.height;
    return MAX(CELL_H, h + 10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InspectionTreeNode *node = [_cells objectAtIndex:indexPath.row];
    if ([node.text isEqualToString:LOAD_MORE] || [node.text isEqualToString:LOAD_MORE_SUBCATEGORY]) {
        UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
        if (moreCell == nil) {
            moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        if (node.level > 1) {
            moreCell.textLabel.text = LOAD_MORE_SUBCATEGORY;
        }else{
            moreCell.textLabel.text = LOAD_MORE;
        }
        moreCell.textAlignment=UITextAlignmentCenter;
        moreCell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
        moreCell.backgroundColor = WT_CLEARCOLOR;
        moreCell.backgroundView = nil;
        moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return moreCell;
    }
    
    
    static NSString *CellIdentifier = @"SinTreeCellIdentifier1";
    TreeCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SinTreeCellIdentifier0"];
        if (cell == nil)
        {
            cell = [[[TreeCell alloc] initWithStyleAndParent:UITableViewCellStyleSubtitle
                                             reuseIdentifier:@"SinTreeCellIdentifier0" andParentView:self] autorelease];
            [cell.btnCheck setHidden:YES];
            [cell.gropBtn setHidden:YES];
            
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[TreeCell alloc] initWithStyleAndParent:UITableViewCellStyleSubtitle
                                             reuseIdentifier:CellIdentifier andParentView:self] autorelease];
        }
    }
    
    node.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    cell.node = node;
    cell.btnCheck.tag = cell.tag = indexPath.row;
    if (node.checked) {
        BOOL bAdded = NO;
        for (InspectionTreeNode *checkedNode in checkedArray) {
            if (node.department.id == checkedNode.department.id) {
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


-(void) addAllChildTargets:(InspectionTreeNode *)node{
    if (node.level != 1 || node.target.parentId != 0) {
        return;
    }
    
    if (node.level == 1 && !node.checked) {
        [self removeAllChildNodesWithParentNode:node];
    }else{
        [self removeAllChildNodesWithParentNode:node];
        NSMutableArray *targets = [LOCALMANAGER getInspectionTargetsWithParentId:node.target.id];
        for (InspectionTarget *item in targets) {
            InspectionTreeNode *tmp = [InspectionTreeNode nodeWithProperties:cid++ andText:item.name andChecked:YES andTarget:item];
            tmp.level = 1;
            tmp.parentId = node;
            if (![checkedArray containsObject:tmp]) {
                [checkedArray addObject:tmp];
            }
        }
    }
}

//移除所有父节点中的子节点
-(void) removeAllChildNodesWithParentNode:(InspectionTreeNode *) node{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (InspectionTreeNode *item in checkedArray) {
        if ([node isEqual:item.parentId]) {
            [tmpArray addObject:item];
        }
    }
    for (InspectionTreeNode *item in tmpArray) {
        [checkedArray removeObject:item];
    }
    [tmpArray release];
}


-(int) isExistCheckArray:(InspectionTreeNode *) node{
    for (InspectionTreeNode *item in checkedArray) {
        if (item.target.id == node.target.id) {
            return [checkedArray indexOfObject:item];
        }
    }
    return -1;
}


-(void) addChildNodes:(InspectionTreeNode *) node bFirst:(BOOL) bFirst{
    int pid = 0;
    if (node.target.parentId == 0) {
        pid = node.target.id;
    }else{
        pid = node.target.parentId;
    }
    NSString *parentId = [NSString stringWithFormat:@"%d",pid];
    id curentIndex = [parentNodeDic objectForKey:parentId];
    if (curentIndex == nil) {
        curentIndex = @(0);
    }
    int index = [curentIndex intValue] + 1;
    
    NSMutableArray *array = [LOCALMANAGER getInspectionTargetsWithChildPage:index parentId:node.target.id];
    if (array.count > 0) {
        [parentNodeDic setObject:@(index) forKey:parentId];
    }
    //NSInteger cid = ((InspectionTreeNode *)_cells.lastObject).cid;
    InspectionTreeNode *parentNode = nil;
    
    for (InspectionTreeNode *item in _cells) {
        if (array.count == 0) {
            break;
        }
        if (item.target.id == parentId.intValue && item.level == 1) {
            parentNode = item;
            
            for (InspectionTarget *target in array) {
                InspectionTreeNode *node = [InspectionTreeNode nodeWithProperties:cid++ andText:target.name andChecked:item.checked andTarget:target];
                if ([self isExistCheckArray:node] > -1) {
                    node.checked = YES;
                }
                [item addChild:node];
                //                if (parentNode.checked) {
                //                    [self.checkedArray addObject:node];
                //                }
            }
            if ([node.text isEqualToString:LOAD_MORE] || [node.text isEqualToString:LOAD_MORE_SUBCATEGORY]) {
                while ([item.children containsObject:node]) {
                    [item.children removeObject:node];
                }
            }
            //加载更多
            if (array.count >= PAGESIZE) {
                NSString *cellTitle;
                if (node.level > 1) {
                    cellTitle = LOAD_MORE_SUBCATEGORY;
                }else{
                    cellTitle = LOAD_MORE;
                }
                [item addChild:[InspectionTreeNode nodeWithProperties:cid++ andText:cellTitle andChecked:NO andTarget:node.target]];
            }
            
            break;
        }
    }
    if (bFirst) {
        [self changeState:parentNode];
    }
}

-(void) addRootNodes:(InspectionTreeNode *)node{
    rootIndex++;
    NSLog(@"当前页数:%d",rootIndex);
    NSMutableArray *array = nil;
    if (_searchText != nil && _searchText.length > 0) {
        array = [LOCALMANAGER getInspectionTargetsWithName:_searchText Index:rootIndex];
    }else{
        array = [LOCALMANAGER getInspectionTargetsWithChildPage:rootIndex parentId:0];
    }
    cid = _cells.count + 1;
    for (InspectionTarget *target in array) {
        [_root addChild:[InspectionTreeNode nodeWithProperties:cid++ andText:target.name andChecked:NO andTarget:target]];
    }
    while ([_root.children containsObject:node]) {
        [_root.children removeObjectIdenticalTo:node];
        [_root.children removeObject:node];
    }
    //加载更多
    if (array.count >= PAGESIZE) {
        NSString *cellTitle;
        if (node.level > 1) {
            cellTitle = LOAD_MORE_SUBCATEGORY;
        }else{
            cellTitle = LOAD_MORE;
        }
        [_root addChild:[InspectionTreeNode nodeWithProperties:cid++ andText:cellTitle andChecked:NO andTarget:[array lastObject]]];
    }
    [self changeState:node];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InspectionTreeNode *node = [_cells objectAtIndex:indexPath.row];
    if ([node.text isEqualToString:LOAD_MORE] || [node.text isEqualToString:LOAD_MORE_SUBCATEGORY]) {
        if (node.level > 1) {
            [self addChildNodes:node bFirst:NO];
        }else{
            [self addRootNodes:node];
            return;
        }
    }
    if ((node.children == nil || node.children.count == 0) && node.level == 1) {
        node.expanded = NO;
        [self addChildNodes:node bFirst:YES];
    }
    else{
        [self changeState:node];
    }
}

-(void) changeState:(InspectionTreeNode *) node{
    if ([node.text isEqualToString:LOAD_MORE] || [node.text isEqualToString:LOAD_MORE_SUBCATEGORY]) {
        NSString *parentId = [NSString stringWithFormat:@"%d",node.target.id];
        NSInteger parentIndex = [_cells indexOfObject:node.parentId];
        
        [_cells removeObjectIdenticalTo:node];
        if (node.level == 1) {
            node = _root;
            [self setRootNode:_root];
            return;
        }else{
            node = _cells[parentIndex];
            
        }
        for (InspectionTreeNode *item in node.children) {
            [_cells removeObjectIdenticalTo:item];
        }
        node.expanded = NO;
        
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
        //[willExpand addObject:[NSIndexPath indexPathForRow:location inSection:0]];
        [_cells insertObject:ch atIndex:location++];
    }
    //[self insertRowsAtIndexPaths:willExpand withRowAnimation:UITableViewRowAnimationLeft];
    //    for (InspectionTreeNode* ch in node.children) {
    //        ch.delegate = self;
    //        if(ch.expanded && ch.hasChilren){
    //            [self expandNode:ch];
    //        }
    //    }
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
                    if ([cell isKindOfClass:[TreeCell class]]) {
                        cell.btnCheck.tag = cell.tag = i-1;
                    }
                    //NSLog(@"node reset tag : %@ tag = %d",node.text,i-1);
                }
            }
            //NSLog(@"remove node : %@",node.text);
            [_cells removeObjectIdenticalTo:node];
            //[self deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]]withRowAnimation:UITableViewRowAnimationRight];
            
        }
    }
    [self reloadData];
}

-(void)checkAction:(id)sender {
    UIButton *btn = sender;
    InspectionTreeNode *node = [_cells objectAtIndex:btn.tag];
    node.delegate = self;
    [node changeCheckStatus:!node.checked linkage:YES];
    if (!node.checked) {
        int index = [self isExistCheckArray:node];
        if (index > -1) {
            [checkedArray removeObjectAtIndex:index];
        }
    }
    //载入所有一级节点的所有子节点
    [self addAllChildTargets:node];
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


-(void) reloadTableCell{
    //移除
    [self beginUpdates];
    int count = _cells.count;
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:_cells];
    [_cells removeAllObjects];
    NSMutableArray *indexpaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexpaths addObject:indexPath];
    }
    [self deleteRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationMiddle];
    [self endUpdates];
    
    //载入
    [_cells release];
    _cells = [[NSMutableArray arrayWithArray:tmpArray] retain];
    [tmpArray release];
    [indexpaths removeAllObjects];
    count = _cells.count;
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexpaths addObject:indexPath];
    }
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationMiddle];
    [self endUpdates];
    [indexpaths release];
    
    [parentNodeDic removeAllObjects];
}

@end
