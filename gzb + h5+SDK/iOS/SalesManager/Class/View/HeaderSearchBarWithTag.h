//
//  HeaderSearchBarWithTag.h
//  SalesManager
//
//  Created by iOS-Dev on 2017/5/15.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeaderSearchBarDelegate <NSObject>

-(void) HeaderSearchBarClickBtn:(int) index current:(int) current andWithTag:(int)tag;
//设置进入页面的默认选择
-(void)setFirstStatus;

@end

//搜索导航控件
@interface HeaderSearchBarWithTag : UIView

@property (nonatomic,assign) int currentIndex;

@property (nonatomic,retain) NSArray* icontitles;
@property (nonatomic,retain) NSArray* titles;

@property (nonatomic,retain) NSMutableArray* buttons;
@property (nonatomic,retain) NSMutableArray* icons;

@property (nonatomic,assign) id<HeaderSearchBarDelegate> delegate;

-(void)setColor:(int) index;

@end

