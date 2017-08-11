//
//  RadioViewController.h
//  SalesManager
//  此为单选视图
//  Created by iOS-Dev on 16/8/24.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^tryBlock)(NSDictionary *dic);

@interface RadioViewController : BaseViewController

@property (nonatomic,strong)NSMutableArray *radioMulArray;

@property (nonatomic,copy)tryBlock Myblock;

-(void)getUserTrtByBlock:(tryBlock)block;

@end
