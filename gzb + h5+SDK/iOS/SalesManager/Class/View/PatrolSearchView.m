//
//  PatrolSearchView.m
//  SalesManager
//
//  Created by liuxueyan on 15-4-30.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "PatrolSearchView.h"
#import "TagItemView.h"
#import "SelectedTagView.h"
#import "SelectedTagCell.h"
#import "Constant.h"
#import "UIImage+JSLite.h"

@implementation PatrolSearchView


-(void)initSegment{
    _selectedArray = [[NSMutableArray alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    _segmentCtrl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_title.frame) + 2.0, MAINWIDTH, 40.0)];
    UIImage *backgroundImage = [[UIImage imageNamed:@"bg_search_segment"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [_segmentCtrl setBackgroundImage:backgroundImage];

    [_segmentCtrl setDelegate:self];

    [_segmentCtrl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [_segmentCtrl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    [_segmentCtrl setSeparatorImage:[UIImage createImageWithColor:[UIColor lightGrayColor]]];
    
    UIImage *buttonBackgroundImagePressedLeft = [UIImage createImageWithColor:[UIColor lightGrayColor]];//[[UIImage imageNamed:@"bg_left_press"]
                                                 //resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedCenter = [UIImage createImageWithColor:[UIColor lightGrayColor]];//[[UIImage imageNamed:@"bg_center_press"]
                                                   //resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedRight = [UIImage createImageWithColor:[UIColor lightGrayColor]];//[[UIImage imageNamed:@"bg_right_press"]
                                                 // resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    
    // Button 1
    UIButton *button1 = [[UIButton alloc] init];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitle:@"部门" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
    [button1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [button1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [button1 setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *button2 = [[UIButton alloc] init];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitle:@"巡防类型" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    [button2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    [button2 setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    UIButton *button3 = [[UIButton alloc] init];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setTitle:@"客户类型" forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:14];
    [button3 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    [button3 setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    [button3 setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];

    
    // Button 3
    UIButton *button4 = [[UIButton alloc] init];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button4 setTitle:@"时间" forState:UIControlStateNormal];
    button4.titleLabel.font = [UIFont systemFontOfSize:14];
    [button4 setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [button4 setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [button4 setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [_segmentCtrl setButtonsArray:@[button1, button2, button3,button4]];
    [self addSubview:_segmentCtrl];
    
    [self createDepartmentTree];
    [self createPatrolTypeView];
    [self createCustomerTypeView];
    [self createDateSelectView];
}

-(void)createDateSelectView{
    _dateSelectView = [[DateSelectView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, CGRectGetHeight(_selectView.frame))];
    _dateSelectView.delegate = self;
    _dateSelectView.parentView = self;
    [_dateSelectView initView];
    [_selectView addSubview:_dateSelectView];
    _dateSelectView.hidden = YES;
}

-(void)createDepartmentTree{
    _treeView = [[SinTreeCheckView alloc] initWithFrame:CGRectMake(0, 5, MAINWIDTH, CGRectGetHeight(_selectView.frame))];
    _treeView.treeDelegate = self;
    //treeView.bLinkParent = YES;
    [_selectView addSubview:_treeView];
    [self initWithData:[[LOCALMANAGER getDepartments] retain]];
    //[self initWithData];
}

-(void)createPatrolTypeView{
    _patrolTypeView = [[PatrolTypeView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, CGRectGetHeight(_selectView.frame))];
    [_patrolTypeView initView];
    _patrolTypeView.delegate = self;
    [_selectView addSubview:_patrolTypeView];
    _patrolTypeView.hidden = YES;
}

-(void)createCustomerTypeView{
    _customerTypeView =[[CustomerTypeView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, CGRectGetHeight(_selectView.frame))];
    [_customerTypeView initView];
    _customerTypeView.delegate = self;
    [_selectView addSubview:_customerTypeView];
    _customerTypeView.hidden = YES;
}

-(void)initWithData:(NSMutableArray *)departments{
    
    SinTreeCheckNode *root;
    NSInteger cid = 0;
    NSMutableArray *nodes = [[NSMutableArray alloc] init];
    for (Department *department in departments) {
        BOOL bChecked = NO;/*
        for (Department *checkDepartment in selectedArray) {
            if (checkdepartment.id == department.id) {
                bChecked = YES;
                break;
            }
        }*/
        [nodes addObject:[SinTreeCheckNode nodeWithProperties:cid++ andText:department.name andChecked:bChecked andDepartment:department]];
    }
    
    for (SinTreeCheckNode *node in nodes) {
        
        Department *d = node.department;
        if (d.parentId == 0) {
            root = node;
        }
        for (SinTreeCheckNode *nodeChild in nodes) {
            if(d.parentId == d.id){
                [node addChild:nodeChild];
            }
        }
    }
    
    // 设置默认展开层数
    [root ergodicNode:^BOOL(SinTreeCheckNode *node) {
        if(node.level<3){
            // 展开1层
            node.expanded = YES;
            return YES;
        }
        else{
            return NO;
        }
    }];
    [_treeView setRootNode:root];
    
    
}

-(void)clickNode:(SinTreeCheckNode *)node status:(BOOL)checked{
    Department *d = node.department;
    if (checked) {
        SelectedTag *selectedTag = [[SelectedTag alloc] init];
        selectedTag.content = d.name;
        selectedTag.Id = 1;
        selectedTag.object = node;
        if (![self isExistTag:selectedTag]) {
            [_selectedArray addObject:selectedTag];
        }
    }else{
        Department *d2 = nil;
        for (SelectedTag *tag in _selectedArray) {
            SinTreeCheckNode *node0 = tag.object;
            d2 = node0.department;
            if (d2.id == d2.id) {
                [_selectedArray removeObject:tag];
                break;
            }
        }
    }
    [_tableView reloadData];
}

-(BOOL)isExistTag:(SelectedTag *)tag{
    for (SelectedTag *tag0 in _selectedArray) {
        if (tag0.object == tag.object) {
            return YES;
        }
    }
    return NO;
}

-(void)selectedPatrolCategory:(PatrolCategory *)category status:(BOOL)checked{
    if (checked) {
        SelectedTag *selectedTag = [[SelectedTag alloc] init];
        selectedTag.content = category.name;
        selectedTag.Id = 1;
        selectedTag.object = category;
        if (![self isExistTag:selectedTag]) {
            [_selectedArray addObject:selectedTag];
        }
    }else{
        for (SelectedTag *tag in _selectedArray) {
            PatrolCategory  *node0 = tag.object;
            if (node0.id == category.id) {
                [_selectedArray removeObject:tag];
                break;
            }
        }
    }
    [_tableView reloadData];

}

-(void)selectedCustomerCategory:(CustomerCategory *)category status:(BOOL)checked{
    if (checked) {
        SelectedTag *selectedTag = [[SelectedTag alloc] init];
        selectedTag.content = category.name;
        selectedTag.Id = 1;
        selectedTag.object = category;
        if (![self isExistTag:selectedTag]) {
            [_selectedArray addObject:selectedTag];
        }
    }else{
        for (SelectedTag *tag in _selectedArray) {
            CustomerCategory  *node0 = tag.object;
            if (node0.id == category.id) {
                [_selectedArray removeObject:tag];
                break;
            }
        }
    }
    [_tableView reloadData];

}

-(void)selectedDateFrom:(NSString *)fromDate to:(NSString *)toDate{
    for (SelectedTag *tag in _selectedArray) {
        if(tag.object == nil ){
            [_selectedArray removeObject:tag];
            break;
        }
    }
    
    SelectedTag *selectedTag = [[SelectedTag alloc] init];
    selectedTag.content = [NSString stringWithFormat:@"%@到%@",fromDate,toDate];
    selectedTag.Id = 1;
    selectedTag.object = nil;
    if (![self isExistTag:selectedTag]) {
        [_selectedArray addObject:selectedTag];
    }
    [_tableView reloadData];
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [_tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [_tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}


#pragma mark -
#pragma mark AKSegmentedControlDelegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (index == 0) {
        _customerTypeView.hidden = YES;
        _patrolTypeView.hidden = YES;
        _treeView.hidden = NO;
        _dateSelectView.hidden = YES;
    }else if (index == 1){
        _customerTypeView.hidden = YES;
        _patrolTypeView.hidden = NO;
        _treeView.hidden = YES;
        _dateSelectView.hidden = YES;
    }else if (index == 2){
        _customerTypeView.hidden = NO;
        _patrolTypeView.hidden = YES;
        _treeView.hidden = YES;
        _dateSelectView.hidden = YES;
    }
    else if (index == 3){
        _dateSelectView.hidden = NO;
        _customerTypeView.hidden = YES;
        _patrolTypeView.hidden = YES;
        _treeView.hidden = YES;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _selectedArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectedTag *tag = [_selectedArray objectAtIndex:indexPath.row];
    
    SelectedTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectedTagCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.title.text = tag.content;
    cell.btDelete.tag = indexPath.row;
    [cell.btDelete addTarget:self action:@selector(toDelete:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)toDelete:(id)sender{


}

- (void)dealloc {
    [_btClose release];
    [_segmentCtrl release];
    [_selectView release];
    [_name release];
    [_tableView release];
    [_title release];
    [super dealloc];
}
@end
