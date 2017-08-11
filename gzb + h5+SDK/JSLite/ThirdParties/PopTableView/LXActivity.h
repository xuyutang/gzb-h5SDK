//
//  LXActivity.h
//  LXActivityDemo
//
//  Created by lixiang on 14-3-17.
//  Copyright (c) 2014年 lcolco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXActivityDelegate <NSObject>
- (void)didClickOnImageIndex:(NSInteger *)imageIndex;
@optional
- (void)didClickOnCancelButton;
@end

@interface LXActivity : UIView
@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) NSString *actionTitle;
@property (nonatomic,assign) BOOL isHadCancelButton;
@property (nonatomic,assign) CGFloat LXActivityHeight;
@property (nonatomic,assign) id<LXActivityDelegate>delegate;

- (id)initWithTitle:(NSString *)title delegate:(id<LXActivityDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)creatView;
@end
