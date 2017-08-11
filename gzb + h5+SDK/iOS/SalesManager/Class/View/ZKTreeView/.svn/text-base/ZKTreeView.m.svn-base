//
//  TreeView.m
//  MyTreeView
//
//  Created by Administrator on 16/1/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZKTreeView.h"
#import "Constant.h"

@interface ZKTreeView ()

@end

@implementation ZKTreeView

-(NSMutableArray *) checkedArray{
    if (_checkedArray != nil && _checkedArray.count > 0) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (ZKTreeCell *item in _checkedArray) {
            [tmpArray addObject:item.target];
        }
        return tmpArray;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_cells == nil) {
        _cells = [[NSMutableArray alloc] init];
    }
    _checkedArray = [[NSMutableArray alloc] init];
    _countDic = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTreeCell *cell = _cells[indexPath.row];
    cell.tag = indexPath.row;
    cell.clicked = ^(ZKTreeCell *cell){
        [self changeCheckeStatus:cell];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZKTreeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //收起
    if (cell.bExpand && cell.children.count > 0) {
        if ([_cells containsObject:cell.children.firstObject]) {
            [self hide:cell];
        }
    //展开
    }else if(cell.children.count > 0){
        [self show:cell];
    }
}

-(void) show:(ZKTreeCell *) cell{
    int index = [_cells indexOfObject:cell];
    int startIndex = index + 1;
    int endIndex = startIndex + cell.children.count;
    NSMutableArray *indexSet = [[NSMutableArray alloc] init];
    for (int i = startIndex; i < endIndex; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        [indexSet addObject:index];
    }
    for (int i = cell.children.count - 1; i >= 0; i--) {
        [_cells insertObject:cell.children[i] atIndex:startIndex];
    }
    [self.tableView insertRowsAtIndexPaths:indexSet withRowAnimation:UITableViewRowAnimationBottom];
    cell.bExpand = !cell.bExpand;
}

-(void) hide:(ZKTreeCell *) cell{
    if (cell.children.count > 0) {
        for (ZKTreeCell *item in cell.children) {
            if (item.bExpand) {
                [self hide:item];
            }
        }
    }
    int index = [_cells indexOfObject:cell];
    int startIndex = index + 1;
    int endIndex = startIndex + cell.children.count;
    [_cells removeObjectsInArray:cell.children];
    NSMutableArray *indexSet = [[NSMutableArray alloc] init];
    for (int i = startIndex; i < endIndex; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        [indexSet addObject:index];
    }
    [self.tableView deleteRowsAtIndexPaths:indexSet withRowAnimation:UITableViewRowAnimationTop];
    cell.bExpand = !cell.bExpand;
}

//父节点 与 子节点选中个数检测
-(BOOL) cehckCount:(ZKTreeCell *) cell{
    if (_selectCount <= 0 || _maxSelectCount <= 0) return YES;
    NSString *key = [NSString stringWithFormat:@"%d",cell.rootId];
    //检测分组个数
    if (![_countDic.allKeys containsObject:key]) {
        if (_countDic.count >= _maxSelectCount) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                              description:[NSString stringWithFormat:NSLocalizedString(@"customer_tagvalue_max_count", nil),_countDic.count]
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            return NO;
        }
    }
    
    //检测分组子项限定个数
    int count = [_countDic[key] intValue];
    if (!cell.bChecked) {
        //如果是选中 则判断有没有超出限定范围
        if (count >= _selectCount) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                              description:[NSString stringWithFormat:NSLocalizedString(@"customer_tagvalue_count", nil),count]
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            return NO;
        }
        count++;
    }else{
        count--;
    }
    if (count <= 0) {
        [_countDic removeObjectForKey:key];
    }else{
        [_countDic setValue:@(count) forKey:key];
    }
    NSLog(@"%@",_countDic);
    return YES;
}

-(void) changeCheckeStatus:(ZKTreeCell *) cell{
    //不考虑父及
    if(![self cehckCount:cell]) return;
    if (cell.depth == 0) {
        [self changeAllChildrenStatus:cell];
    }else{
        if (_bSingle) {
            [self cancleAllCheckedCellWithRootId:cell.rootId];
        }
        [cell changeChcecked:!cell.bChecked];
        [self changeAllChildrenStatus:cell];
        //子类全选不勾选父类
//        if (_bCheckParent) {
//            [self changeParentStatus:cell];
//        }
    }
}


-(void) cancleAllCheckedCellWithRootId:(int) rootId{
    for (ZKTreeCell *cell in _cells) {
        if (cell.rootId == rootId) {
            if ([_checkedArray containsObject:cell]) {
                [_checkedArray removeObject:cell];
            }
            [cell changeChcecked:NO];
        }
    }
}


-(void) cancelAllCheckedCell{
    for (ZKTreeCell *cell in _cells) {
        if (cell.depth == 0) {
            cell.bChecked = YES;
            [self changeAllChildrenStatus:cell];
        }
    }
    [_countDic removeAllObjects];
    _countDic = nil;
    _countDic = [[NSMutableDictionary alloc] init];
    self.checkedArray = nil;
    self.checkedArray = [[NSMutableArray alloc] init];
}

-(void) changeParentStatus:(ZKTreeCell *) cell{
    ZKTreeCell *parent = [self findParentCell:cell];
    if (parent == nil) {
        return;
    }
    if (![self isChildrenChecked:parent]) {
        [parent changeChcecked:NO];
    }else{
        [parent changeChcecked:YES];
        
    }
    [self addOrDelCheckedCell:parent];
    [self changeParentStatus:parent];
    
}

-(void) changeAllChildrenStatus:(ZKTreeCell *) cell{
    if (cell.depth == 0) {
        [cell changeChcecked:!cell.bChecked];
    }
    [self addOrDelCheckedCell:cell];
    if (cell.children.count > 0) {
        for (ZKTreeCell *item in cell.children) {
            [item changeChcecked:cell.bChecked];
            [self addOrDelCheckedCell:item];
            [self changeAllChildrenStatus:item];
        }
    }
    
}

-(NSInteger) getSelectCountWithDepth:(int) depth{
    NSInteger count = 0;
    
    return count;
}


-(NSInteger) getMaxCountWithDepth:(int) depth{
    return _checkedArray.count;
}

//寻找父节点CELL
-(ZKTreeCell *) findParentCell:(ZKTreeCell *) cell{
    if (cell.parent == nil) {
        return nil;
    }
    int location = [_cells indexOfObject:cell.parent];
    return [_cells objectAtIndex:location];
}

//检查所有子节点是否被全部选中
-(BOOL) isChildrenChecked:(ZKTreeCell *) cell{
    if (cell.children.count == 0) {
        return YES;
    }
    for (ZKTreeCell *item in cell.children) {
        if (!item.bChecked) {
            return NO;
        }
    }
    return YES;
}

//新增或删除选择的cell
-(void) addOrDelCheckedCell:(ZKTreeCell *) cell{
    if (!cell.bChecked){
        if ([_checkedArray containsObject:cell]) {
            [_checkedArray removeObject:cell];
        }
    }else{
        if (![_checkedArray containsObject:cell]) {
            [_checkedArray addObject:cell];
        }
    }
}


-(void) expanChildren:(ZKTreeCell *) cell depth:(int) depth{
    if (cell.depth < depth) {
        if (cell.children.count > 0) {
            int index = [_cells indexOfObject:cell];
            int startIndex = index + 1;
            int endIndex = startIndex + cell.children.count;
            for (int i = cell.children.count - 1; i >= 0; i--) {
                ZKTreeCell *tmpCell = cell.children[i];
                [_cells insertObject:tmpCell atIndex:startIndex];
            }
            cell.bExpand = !cell.bExpand;
        }
    }
}

#pragma -mark - 公开方法
//在设置数据源之后执行 此方法
-(void) expandNodeWithDepth:(int) depth{
    if (depth <= 0 ) {
        return;
    }
    NSMutableArray *tmpCells = [[NSMutableArray alloc] initWithArray:_cells];
    for (int i = 0; i < depth; i++) {
        for (ZKTreeCell *cell in tmpCells) {
            if (cell.depth == i) {
                if (cell.children.count > 0) {
                    [self expanChildren:cell depth:depth];
                }
            }
        }
        tmpCells = [[NSMutableArray alloc] initWithArray:_cells];
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
