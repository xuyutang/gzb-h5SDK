//
//  NewOrderNormalViewController.h
//  SalesManager
//
//  Created by Administrator on 16/3/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseOrderWebViewController.h"

#define REFRESH_GOODS_CAR_UI @"kRefreshGoodsCar"

@interface NewOrderNormalViewController : BaseOrderWebViewController

@property (nonatomic,retain) NSString *lbtitle;

@property (nonatomic) BOOL bOrderInfoView;

@property (nonatomic,assign) int orderId;

@property (nonatomic,retain) NSString *price;

@property (nonatomic,assign) BOOL bMessageView;

@end
