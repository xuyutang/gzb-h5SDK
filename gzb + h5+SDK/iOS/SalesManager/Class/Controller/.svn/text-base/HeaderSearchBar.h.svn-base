//
//  HeaderSearchBar.h
//  自定义搜索导航
//
//  Created by 朱康 on 15/10/9.
//  Copyright © 2015年 Anonymous. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol HeaderSearchBarDelegate <NSObject>

-(void) HeaderSearchBarClickBtn:(int) index current:(int) current;

@end

//搜索导航控件
@interface HeaderSearchBar : UIView

@property (nonatomic,assign) int currentIndex;

@property (nonatomic,retain) NSArray* icontitles;
@property (nonatomic,retain) NSArray* titles;

@property (nonatomic,retain) NSMutableArray* buttons;
@property (nonatomic,retain) NSMutableArray* icons;

@property (nonatomic,assign) id<HeaderSearchBarDelegate> delegate;

-(void)setColor:(int) index;

@end
