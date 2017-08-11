//
//  CityViewController.h
//  SalesManager
//
//  Created by Administrator on 16/4/14.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"

@interface CityViewController : BaseViewController


@property (nonatomic,copy) void(^selected) (id p,id c,id a);
@end
