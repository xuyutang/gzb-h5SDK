//
//  DropMenu.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-19.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "DropMenu.h"
#import "Constant.h"

@implementation DropMenu


-(void)initMenu{
    
    _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH/_menuCount, self.frame.size.height) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.tag = 1;
    _tableView1.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:_tableView1];
    
    _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(MAINWIDTH/_menuCount, 0, MAINWIDTH/_menuCount, self.frame.size.height) style:UITableViewStylePlain];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    //[_tableView2 setBackgroundColor:[UIColor lightGrayColor]];
    _tableView2.tag = 2;
    _tableView2.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:_tableView2];
    
    _tableView3 = [[UITableView alloc] initWithFrame:CGRectMake((MAINWIDTH/_menuCount)*2.0, 0, MAINWIDTH/_menuCount, self.frame.size.height) style:UITableViewStylePlain];
    _tableView3.delegate = self;
    _tableView3.dataSource = self;
    _tableView3.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   // [_tableView3 setBackgroundColor:[UIColor lightGrayColor]];
    _tableView3.tag = 3;
    
    [self addSubview:_tableView3];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return _array1.count;
    }else if (tableView.tag == 2){
        return _array2.count;
    }else if (tableView.tag == 3){
        return _array3.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38.f;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    if (tableView.tag == 1) {
        NSString *title = [_array1 objectAtIndex:indexPath.row];
        cell.textLabel.text = title;
    }else if (tableView.tag == 2){
        NSString *title = [_array2 objectAtIndex:indexPath.row];
        cell.textLabel.text = title;
    }else if (tableView.tag == 3){
        NSString *title = [_array3 objectAtIndex:indexPath.row];
        cell.textLabel.text = title;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *oldIndex = [tableView indexPathForSelectedRow];
    
    [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    return indexPath;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        _selectedIndex1 = indexPath.row;
    }else if (tableView.tag == 2){
        _selectedIndex2 = indexPath.row;
    }else if (tableView.tag == 3){
        _selectedIndex3 = indexPath.row;
    }

    if (_delegate != nil && [_delegate respondsToSelector:@selector(selectedDropMenuIndex:row:)]) {
        [_delegate selectedDropMenuIndex:tableView.tag row:indexPath.row];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
