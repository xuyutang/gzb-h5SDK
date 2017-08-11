//
//  CustomerCategoryView.m
//  SalesManager
//
//  Created by liu xueyan on 8/6/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "CustomerCategoryView.h"

@implementation CustomerCategoryView
@synthesize title,btAdd;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [title release];
    [btAdd release];
    [super dealloc];
}
@end
