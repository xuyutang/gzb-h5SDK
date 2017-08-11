//
//  TaskCommentViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15/6/5.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"

@protocol TaskCommentViewControllerDelegate <NSObject>

@optional
-(void)finishedComment:(TaskPatrolReply *) reply;

@end

@interface TaskCommentViewController : BaseViewController
@property(nonatomic,retain) UIViewController *parentController;
@property(nonatomic,assign) NSString *taskId;
@property(nonatomic,retain) TaskPatrol *taskPatrol;

@property(nonatomic,assign) id<TaskCommentViewControllerDelegate> delegate;
@end
