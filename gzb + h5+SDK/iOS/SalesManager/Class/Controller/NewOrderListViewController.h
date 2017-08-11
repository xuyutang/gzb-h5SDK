//
//  NewOrderListViewController.h
//  SalesManager
//
//  Created by Administrator on 16/3/23.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseOrderWebViewController.h"
#import "MJExtension.h"
@interface OrderListParams : NSObject
@property (nonatomic,retain) NSString *typeIds;
@property (nonatomic,retain) NSString *realName;
@property (nonatomic,retain) NSString *customerName;
@property (nonatomic,retain) NSString *beginTime;
@property (nonatomic,retain) NSString *endTime;
@property (nonatomic,retain) NSString *departIds;
@property (nonatomic,retain) NSString *orderBy;
@end

@interface NewOrderListViewController : BaseOrderWebViewController

@property (nonatomic,retain) OrderGoodsParams *orderParams;
@end
