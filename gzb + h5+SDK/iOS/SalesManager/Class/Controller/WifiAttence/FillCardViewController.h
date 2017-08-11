//
//  FillCardViewController.h
//  SalesManager
//
//  Created by iOS-Dev on 16/12/19.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "CheckInShiftModel.h"
@class AppDelegate;
typedef void(^refreshCheck)(NSString*remarkStr);

@interface FillCardViewController : BaseViewController

@property(nonatomic,assign)CheckInShiftModel *model;
@property(nonatomic,copy)refreshCheck checkBlock;


-(void)refreshCheckWithBlock:(refreshCheck) block;

@end
