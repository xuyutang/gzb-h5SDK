//
//  VideoDurationTypeController.m
//  SalesManager
//
//  Created by Administrator on 15/12/2.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "PatrolVideoDurationTypeController.h"

@interface PatrolVideoDurationTypeController ()

@end

@implementation PatrolVideoDurationTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblFunctionName.text = NSLocalizedString(@"bar_video_duration_type", nil);
    _dataList = [[LOCALMANAGER getPatrolVideoDurationCategories] retain];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftButton:(id)sender{
    [super clickLeftButton:sender];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark -UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellid = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    PatrolVideoDurationCategory *duration = _dataList[indexPath.row ];
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"video_duration_to_seconds", nil),duration.durationValue];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PatrolVideoDurationCategory *duration = _dataList[indexPath.row ];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(PatrolVideoDurationTypeSlectedItme:duration:)]) {
        [_delegate PatrolVideoDurationTypeSlectedItme:self duration:duration];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
