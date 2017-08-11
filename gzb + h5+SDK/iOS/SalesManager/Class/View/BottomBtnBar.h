//
//  BottomBtnBar.h
//  SalesManager
//
//  Created by Administrator on 15/11/3.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BottomBtnBarDelegate <NSObject>

-(void) BottomBtnBarTouch:(int) buttonIndex;
@end

@interface BottomBtnBar : UIView


@property (nonatomic,retain) UIButton* leftButton;
@property (nonatomic,retain) UIButton* rightButton;
@property (nonatomic,retain) id<BottomBtnBarDelegate> delegate;


-(instancetype)initWithPoint:(CGPoint)point;
@end
