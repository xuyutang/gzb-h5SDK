//
//  TTTableButtonCell.m
//  KK UI
//
//  Created by KK UI on 12-12-7.
//
//

#import "TTTableButtonCell.h"

@implementation TTTableButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.control.frame = CGRectMake(0.f, 0.f, 260.f, 35.f);
}

@end
