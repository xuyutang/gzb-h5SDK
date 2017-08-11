//
//  PatrolTypeView.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-5.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "PatrolTypeView.h"
#import "Constant.h"
#import "LocalManager.h"
#import "CommonCell.h"

@implementation PatrolTypeView


-(void) reload{
    [self initData];
    [_tableView reloadData];
}

-(void)initData{
    [patrolTypes removeAllObjects];
    
    patrolTypes = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getPatrolCategories]];
    patrolTypes = [NSMutableArray arrayWithArray:patrolTypes];
    
}

- (void)initView
{
    if ([patrolTypes count]<1) {
        NSMutableArray *tmpArray = [LOCALMANAGER getFavPatrolCategories];
        if (tmpArray != nil && [tmpArray count]>0) {
            myFavorate = [[tmpArray objectAtIndex:0] retain];
        }
        patrolTypes = [[NSMutableArray alloc] init];
        [patrolTypes addObjectsFromArray:[LOCALMANAGER getPatrolCategories]];
        if (myFavorate != nil) {
            [patrolTypes removeObject:myFavorate];
            [patrolTypes insertObject:myFavorate atIndex:0];
        }
    }

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    /*
    if (bFavorate) {
        tableView.allowsSelection = NO;
    }else{
        tableView.allowsSelection = YES;
    }*/
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.backgroundView = nil;
    [self addSubview:_tableView];
    
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [patrolTypes count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PatrolCategory *item = [patrolTypes objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

#pragma mark - UITableView Delegate methods
/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *oldIndex = [tableView indexPathForSelectedRow];
    
    [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    return indexPath;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PatrolCategory *category = [patrolTypes objectAtIndex:indexPath.row];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(selectedPatrolCategory:)]) {
       // [_delegate selectedPatrolCategory:];
    }
    /*
    if ([delegate respondsToSelector:@selector(patrolSearch:didSelectWithObject:)]) {
        [delegate patrolSearch:self didSelectWithObject:[filterTypes objectAtIndex:indexPath.row]];
    }
    [self dismissModalViewControllerAnimated:YES];
 }
    */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PatrolCategory *category = [patrolTypes objectAtIndex:indexPath.row];
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        thisCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (_delegate != nil &&[_delegate respondsToSelector:@selector(selectedPatrolCategory:status:)]) {
        if (thisCell.accessoryType == UITableViewCellAccessoryNone)
            [_delegate selectedPatrolCategory:category status:NO];
        else
            [_delegate selectedPatrolCategory:category status:YES];
    }
    
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    //add your own code to set the cell accesory type.
    return UITableViewCellAccessoryNone;
}


@end
