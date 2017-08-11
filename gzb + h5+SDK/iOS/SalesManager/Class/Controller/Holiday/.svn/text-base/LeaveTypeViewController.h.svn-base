//
//  LeaveTypeViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/10/11.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^tryBlock)(HolidayCategory *holidayCatory);

@interface LeaveTypeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *radioMulArray;

@property (nonatomic,copy)tryBlock Myblock;

//选择后传值
-(void)getUserTrtByBlock:(tryBlock)block;

@end
