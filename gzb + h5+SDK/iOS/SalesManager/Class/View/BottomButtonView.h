//
//  BottomButtonView.h
//  SalesManager
//
//  Created by Administrator on 15/11/19.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomButtonView : UIView


@property (nonatomic,retain) NSArray *titles;

@property (nonatomic,copy)   void (^buttonSelected) (NSInteger index);

@end
