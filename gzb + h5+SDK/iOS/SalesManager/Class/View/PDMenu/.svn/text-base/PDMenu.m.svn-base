//
//  PDMenu.m
//  ProductMenu
//
//  Created by Administrator on 16/2/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "PDMenu.h"
#import "PDTvbCell.h"
#import "PDMenuHeader.h"
@implementation PDMenu

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self initView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setDataList:(NSMutableArray *)dataList{
    _dataList = dataList;
    [self initView];
}

-(void) initView{
    tvb1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, self.frame.size.height) style:UITableViewStylePlain];
    tvb1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvb1.dataSource = self;
    tvb1.delegate = self;
    tvb1.showsVerticalScrollIndicator = NO;
    [self addSubview:tvb1];
    
    [self reloadTvb2];
}

-(void) reloadTvb2{
    if (tvb2 != nil) {
        tvb2 = nil;
    }
    float x = tvb1.frame.size.width;
    tvb2 = [[ContentView alloc] initWithFrame:CGRectMake(x, 0, 320 - x, tvb1.frame.size.height)];
    [tvb2 initView];
    tvb2.clicked = ^(id demo){
        if (self.clicked) {
            self.clicked(demo);
        }
    };
    [self addSubview:tvb2];
}


#pragma -mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDTvbCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PDTvbCell" owner:nil options:nil][0];
    NSString *title = ((NSDictionary *)_dataList[indexPath.row]).allKeys.firstObject;
    cell.backgroundColor = LINE_COLOR;
//    cell.lbicon.transform = CGAffineTransformMakeRotation(90.f * M_PI / 180);
    cell.lbtitle.text = title;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = (NSDictionary *)_dataList[indexPath.row];
    NSMutableArray *data = dic[dic.allKeys.firstObject];
    [self reloadTvb2];
    tvb2.dataSource = data;
    [tvb2 reloadTable];
}

@end
