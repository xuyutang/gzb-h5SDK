//
//  TitleLableCell.m
//  SalesManager
//
//  Created by Administrator on 15/12/31.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "TitleLableCell.h"

@implementation TitleLableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContent:(NSString *)content size:(CGSize)size{
    self.lbContent.text = content;
    CGRect r = self.lbContent.frame;
    self.lbContent.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width,size.height);
    r = self.frame;
    r.size = size;
    r.size.height += 19;
    self.frame = r;
}

- (void)dealloc {
    [_lbTitle release];
    [_lbContent release];
    [super dealloc];
}
@end
