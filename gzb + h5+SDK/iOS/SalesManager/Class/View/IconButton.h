//
//  IconButton.h
//  SalesManager
//
//  Created by Administrator on 15/12/24.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconButton : UILabel

@property (nonatomic,assign) int icon;
@property (nonatomic,copy) void(^clicked) (NSInteger tag);
@end
