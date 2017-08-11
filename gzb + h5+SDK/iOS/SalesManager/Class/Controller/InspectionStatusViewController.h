//
//  InspectionStatusViewController.h
//  SalesManager
//
//  Created by Administrator on 16/4/6.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"

@interface InspectionStatusViewController : BaseViewController


@property (nonatomic,retain) NSMutableArray *status;
@property (nonatomic,retain) NSMutableArray *currentStatusList;

@property (nonatomic,copy) void(^checkDone) (NSMutableArray *statusList);
@end
