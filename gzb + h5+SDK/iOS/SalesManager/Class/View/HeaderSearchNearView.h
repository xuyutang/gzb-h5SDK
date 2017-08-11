//
//  HeaderSearchNearView.h
//  SalesManager
//
//  Created by liuxueyan on 15/6/3.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderSearchNearViewDelegate <NSObject>

@optional
-(void)clickButtunIndex:(int)index;

@end

@interface HeaderSearchNearView : UIView

@property(nonatomic,retain) UILabel *icon1;
@property(nonatomic,retain) NSString *title1;
@property(nonatomic,retain) UIButton *bt1;

@property(nonatomic,retain) UILabel *icon2;
@property(nonatomic,retain) NSString *title2;
@property(nonatomic,retain) UIButton *bt2;

@property(nonatomic,retain) UILabel *icon3;
@property(nonatomic,retain) NSString *title3;
@property(nonatomic,retain) UIButton *bt3;

@property(nonatomic,assign) id<HeaderSearchNearViewDelegate> delegate;


@end
