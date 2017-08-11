//
//  ContentView.m
//  ProductMenu
//
//  Created by Administrator on 16/2/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ContentView.h"
#import "PDRightCollectionView.h"
#import "PDRightHeaderCell.h"
#import "PDMenuHeader.h"

@implementation ContentView
{
    NSMutableArray *headerCells;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    headerCells = [[NSMutableArray alloc] initWithCapacity:_dataSource.count];
    [headerCells removeAllObjects];
    int index = 0;
    for (NSDictionary *dic in _dataSource) {
        PDRightHeaderCell *item = [[PDRightHeaderCell alloc]initWithTitle:dic.allKeys.firstObject];
        item.section = index;
        item.clicked = ^(PDRightHeaderCell *header){
            if (PDMENU_IOS7) {
                [tvb reloadData];
            }else{
                [tvb reloadData];
            }
        };
        [headerCells addObject:item];
        index++;
    }
}



-(void) initView{
    CGRect r = self.frame;
    r.origin = CGPointMake(0, 0);
    tvb = [[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    tvb.dataSource = self;
    tvb.delegate = self;
    tvb.sectionFooterHeight = 0.f;
    tvb.backgroundColor = [UIColor whiteColor];
    tvb.showsVerticalScrollIndicator = NO;
    [self addSubview:tvb];
}

-(void)reloadTable{
    [tvb reloadData];
    
}


-(float) getCellHeight:(NSInteger) section{
    NSDictionary *dic = _dataSource[section];
    NSMutableArray *array = dic[dic.allKeys[0]];
    return array.count / 2 * CELL_HEIGHT;//CELL 固定高度
}

#pragma -mark -- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDRightHeaderCell *header = headerCells[indexPath.section];
    if (header.bChecked) {
        return 0.f;
    }
    return [self getCellHeight:indexPath.section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return headerCells[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDRightHeaderCell *header = headerCells[indexPath.section];
    if (header.bChecked) {
        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    PDRightCollectionView *subView = [tableView dequeueReusableCellWithIdentifier:@"PDRightCollectionView"];
    if (subView == nil) {
        subView = [[PDRightCollectionView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PDRightCollectionView"];
    }
    NSDictionary *dic = _dataSource[indexPath.section];
    subView.dataList = dic[dic.allKeys[0]];
    subView.clicked = ^(id demo){
        if (self.clicked) {
            self.clicked(demo);
        }
    };
    return subView;
}

@end
