//
//  SMTableView.m
//  SalesManager
//
//  Created by liu xueyan on 10/10/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "SMTableView.h"

@implementation SMTableView
@synthesize searchBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [searchBar resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
