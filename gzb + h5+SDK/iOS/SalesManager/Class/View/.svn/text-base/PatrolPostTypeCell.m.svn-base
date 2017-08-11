//
//  PatrolPostTypeCell.m
//  SalesManager
//
//  Created by Administrator on 15/12/9.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "PatrolPostTypeCell.h"
#import "Constant.h"

@implementation PatrolPostTypeCell

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}


-(void) initMenu{
    NSMutableArray *medias = [LOCALMANAGER getPatrolMediaCategories];
    _checkbox.tintColor  = WT_RED;
    if (!IOS7) {
        _checkbox.frame = CGRectMake(_checkbox.frame.origin.x - 5, _checkbox.frame.origin.y, _checkbox.frame.size.width - 15, _checkbox.frame.size.height - 15);
    }
    for (int i = 0; i < medias.count; i++) {
        PatrolMediaCategory * item = medias[i];
        if (i > 1) {
            [_checkbox insertSegmentWithTitle:item.name
                                      atIndex:i
                                     animated:NO];
            [_checkbox setTag:item.id];
        }else{
            [_checkbox setTitle:item.name forSegmentAtIndex:i];
            [_checkbox setTag:item.id];
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_checkbox release];
    [super dealloc];
}
@end
