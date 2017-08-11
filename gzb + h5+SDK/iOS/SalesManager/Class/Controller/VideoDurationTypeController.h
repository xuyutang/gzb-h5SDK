//
//  VideoDurationTypeController.h
//  SalesManager
//
//  Created by Administrator on 15/12/2.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"

@protocol VideoDurationTypeDelegate <NSObject>

-(VideoDurationCategory *) VideoDurationTypeSlectedItme:(UIViewController *)controller duration:(VideoDurationCategory *) duartion;

@end

@interface VideoDurationTypeController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataList;
}

@property (nonatomic,assign) id<VideoDurationTypeDelegate> delegate;
@end
