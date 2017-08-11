//
//  BoxViewController.h
//  SalesManager
//  此为多选视图
//  Created by iOS-Dev on 16/8/24.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^BoxBlock)(NSMutableArray *mulArray);
@interface BoxViewController : BaseViewController

@property(nonatomic,strong)NSArray *array;//数据源


@property(nonatomic, strong)NSString* boxString;


@property (nonatomic,copy)BoxBlock myBlock;

@property (nonatomic,strong)NSMutableArray *boxMulArray;


@property (nonatomic,strong)NSMutableArray *selectorPatnArray;//存放选中数据


-(void)getUserTrtByBlock:(BoxBlock)block;

@end
