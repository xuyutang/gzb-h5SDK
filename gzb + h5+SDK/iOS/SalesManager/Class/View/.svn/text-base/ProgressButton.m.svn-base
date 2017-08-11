//
//  ProgressButton.m
//  SalesManager
//
//  Created by liu xueyan on 1/6/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "ProgressButton.h"

@implementation ProgressButton
@synthesize button,icon,title,description;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)addTag:(id)tag withAction:(SEL)action{

    if (tag != nil && action != nil) {
        _selTag = tag;
        _action = action;
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (_selTag != nil && _action != nil) {
        [_selTag performSelector:_action];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

}


- (void)dealloc {
    [icon release];
    [title release];
    [description release];
    [button release];
    [super dealloc];
}
@end
