//
//  MainMenuSection.m
//  SalesManager
//
//  Created by liu xueyan on 7/30/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "MainMenuSection.h"

@implementation MainMenuSection
@synthesize title;

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
    [super dealloc];
}
@end
