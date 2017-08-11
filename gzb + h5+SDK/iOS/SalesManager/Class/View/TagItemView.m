//
//  TagItemView.m
//  SalesManager
//
//  Created by liuxueyan on 15-4-29.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "TagItemView.h"

@implementation TagItemView


-(id)initWithContent:(NSString *)content background:(UIImage *)image closeImage:(UIImage *)closeImage frame:(CGRect)frame{
    self = [super init];
    if (self) {
        [self setFrame:frame];
        [self setContent:content background:image closeImage:closeImage];
    }
    return self;
}

-(void)setContent:(NSString *)content background:(UIImage *)image closeImage:(UIImage *)closeImage{
    CGSize size =[self getContentSize:content];
    _lblContent = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, size.width, size.height)];
    [_lblContent setText:content];
    [_lblContent setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:_lblContent];
    _btClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btClose setFrame:CGRectMake(size.width+7, 2, 12, 12)];
    
    [_btClose setImage:closeImage forState:UIControlStateNormal];
    [self addSubview:_btClose];
    
    if (image == nil) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self setBgImage:image];
    }
}

-(CGSize)getContentSize:(NSString *)content{
    CGSize maximumSize =CGSizeMake(self.frame.size.width,9999);
    UIFont*dateFont = [UIFont systemFontOfSize:12];
    CGSize dateStringSize =[content sizeWithFont:dateFont
                                      constrainedToSize:maximumSize
                                          lineBreakMode:_lblContent.lineBreakMode];
    CGSize size = CGSizeMake(self.frame.size.width, dateStringSize.height);
    return size;
}

-(CGSize)getContentSize{
    return [self getContentSize:_lblContent.text];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
