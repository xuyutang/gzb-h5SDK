//
//  IconButton.m
//  SalesManager
//
//  Created by Administrator on 15/12/24.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "IconButton.h"
#import "Constant.h"

@implementation IconButton


-(instancetype)init{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

-(void) initView{
    
}

-(void)setIcon:(int) icon{
    _icon = icon;
    if (_icon > 0) {
        self.font = [UIFont fontWithName:kFontAwesomeFamilyName size:self.frame.size.height];
        self.text = [NSString fontAwesomeIconStringForEnum:_icon];
        self.textAlignment = UITextAlignmentCenter;
        self.textColor = WT_GRAY;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *clicked = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(btnAction:)];
        clicked.numberOfTapsRequired = 1;
        [self addGestureRecognizer:clicked];
        [clicked release];
    }
}


-(void) btnAction:(NSObject *) obj{
    if (self.clicked) {
        self.clicked(self.tag);
    }
}

@end
