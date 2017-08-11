//
//  TagItemView.h
//  SalesManager
//
//  Created by liuxueyan on 15-4-29.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagItemView : UIView
@property(nonatomic,retain) UIButton *btClose;
@property(nonatomic,retain) UILabel *lblContent;
@property(nonatomic,retain) UIImage *bgImage;


-(id)initWithContent:(NSString *)content background:(UIImage *)image closeImage:(UIImage *)closeImage frame:(CGRect)frame;
-(void)setContent:(NSString *)content background:(UIImage *)image closeImage:(UIImage *)closeImage;
-(CGSize)getContentSize:(NSString *)content;
-(CGSize)getContentSize;
@end
