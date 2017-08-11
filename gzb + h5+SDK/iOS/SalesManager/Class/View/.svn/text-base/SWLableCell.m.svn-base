//
//  LableCell.m
//  SalesManager
//
//  Created by Administrator on 15/11/26.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "SWLableCell.h"
#import "Constant.h"

@implementation SWLableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView rowHeight:(CGFloat)height leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView rowHeight:height leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(void) initSubviews{
    self.backgroundColor = WT_WHITE;
    if (_lable == nil) {
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _lable.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _lable.backgroundColor = WT_CLEARCOLOR;
        _lable.numberOfLines = 0;
        [self addSubview:_lable];
        [_lable release];
    }
}
-(void)setText:(NSString *)text size:(CGSize) size
{
    _text = text;
    
    if (_lable.frame.origin.x > 0 || _lable.frame.origin.y > 0) {
        _lable.frame = CGRectMake(_lable.frame.origin.x, _lable.frame.origin.y, size.width, size.height);
    }else{
        _lable.frame = CGRectMake(10, 0, size.width, size.height);
    }
    _lable.text = _text.length == 0 ? @"--" : _text;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [_lable release];
    [super dealloc];
}

@end
