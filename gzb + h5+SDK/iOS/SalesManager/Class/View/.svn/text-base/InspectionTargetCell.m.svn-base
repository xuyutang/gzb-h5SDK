//
//  InspectionTargetCell.m
//  SalesManager
//
//  Created by liuxueyan on 14-12-2.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InspectionTargetCell.h"
#import "NSString+Util.h"

#define C_W 297
@implementation InspectionTargetCell
@synthesize name,number,value;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}


-(void) resetFrame:(NSString *)name number:(NSString *) number{
    CGRect r = self.name.frame;
    CGSize s = [self.name.text rebuildSizeWtihContentWidth:C_W FontSize:self.name.font.pointSize];
    self.name.frame = CGRectMake(r.origin.x, r.origin.y, C_W, s.height);
    r = self.number.frame;
    s = [self.number.text rebuildSizeWtihContentWidth:C_W FontSize:self.number.font.pointSize];
    self.number.frame = CGRectMake(r.origin.x, self.name.frame.origin.y + self.name.frame.size.height + 3, C_W, s.height);
    
    r = self.value.frame;
    s = [self.value.text rebuildSizeWtihContentWidth:C_W FontSize:self.value.font.pointSize];
    self.value.frame = CGRectMake(self.value.frame.origin.x, self.number.frame.origin.y + self.number.frame.size.height + 3, C_W, MAX(self.value.frame.size.height, s.height));
}

-(float) getHeight:(NSString *) tname number:(NSString *) tnumber value:(NSString *) tvalue status:(NSString *) status{
    float height = 0;
    CGSize s = [tname rebuildSizeWtihContentWidth:C_W FontSize:14.f];
    height += 6 + s.height;
    s = [tnumber rebuildSizeWtihContentWidth:C_W FontSize:14.f];
    height += s.height;
    s = [tvalue rebuildSizeWtihContentWidth:C_W FontSize:14.f];
    height += s.height;
    s = [status rebuildSizeWtihContentWidth:C_W FontSize:14.f];
    height += s.height;
    return height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [name release];
    [number release];
    [value release];
    [super dealloc];
}
@end
