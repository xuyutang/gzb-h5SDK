//
//  PatrolDetail2ViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-5-11.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "playVideoCell.h"

@interface PatrolDetail2ViewController : BaseViewController
@property(nonatomic,retain) Patrol *patrol;
@property(nonatomic,assign) int patrolId;
@property(nonatomic,assign) int msgType;
@property(nonatomic,strong) id<RefreshDelegate> delegate;
@property (nonatomic,retain) PlayVideoCell *playVideoCell;
@end
