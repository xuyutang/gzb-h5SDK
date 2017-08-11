//
//  VideoDurationTypeController.h
//  SalesManager
//
//  Created by Administrator on 15/12/2.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"

@protocol PatrolVideoDurationTypeDelegate <NSObject>

-(void) PatrolVideoDurationTypeSlectedItme:(UIViewController *)controller duration:(PatrolVideoDurationCategory *) duartion;

@end

@interface PatrolVideoDurationTypeController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataList;
}

@property (nonatomic,retain) id<PatrolVideoDurationTypeDelegate> delegate;
@end
