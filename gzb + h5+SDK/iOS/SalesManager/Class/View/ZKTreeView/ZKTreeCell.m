//
//  TreeCell.m
//  MyTreeView
//
//  Created by Administrator on 16/1/4.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "ZKTreeCell.h"


#define DEPTH_W 20
#define ICON_W 20
#define ICON_H 20

@implementation ZKTreeCell
{
    UIImageView *_btnCheck;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title depth:(int) depth bExpand:(BOOL) bExpand bCheckParent:(BOOL) bCheckParent parent:(ZKTreeCell *)parent target:(id) target rootId:(int) rootId{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZKTreeCell"]) {
        _name = title;
        _depth = depth;
        _bExpand = bExpand;
        _parent = parent;
        _target = target;
        _bChecked = NO;
        _bCheckParent = bCheckParent;
        _rootId = rootId;
        [self initView];
    }
    return self;
}

-(void)setBExpand:(BOOL)bExpand{
    _bExpand = bExpand;
    if (_bExpand) {
        _expandIcon.image = [UIImage imageNamed:@"expander_ic_minimized.png"];
    }else{
        _expandIcon.image = [UIImage imageNamed:@"expander_ic_maximized.png"];
    }
}

-(void) initView{
    _children = [[NSMutableArray alloc] init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _btnCheck = [[UIImageView alloc] init];
    _btnCheck.image = [UIImage imageNamed:@"noraml_check_off.png"];
    _btnCheck.contentMode = UIViewContentModeScaleToFill;
    _btnCheck.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [_btnCheck addGestureRecognizer:tapGesture];
    
    _expandIcon = [[UIImageView alloc] init];
    _expandIcon.image = [UIImage imageNamed:@"expander_ic_maximized.png"];
    _expandIcon.contentMode = UIViewContentModeScaleToFill;
    _expandIcon.userInteractionEnabled = YES;
    
    
    [self addSubview:_expandIcon];
    [self addSubview:_btnCheck];
}

-(void)changeChcecked:(BOOL)checked{
    _bChecked = checked;
    if (_bChecked) {
        _btnCheck.image = [UIImage imageNamed:@"noraml_check_on.png"];
    }else{
        _btnCheck.image = [UIImage imageNamed:@"noraml_check_off.png"];
    }
}

-(void) checkAction:(NSObject *) sender{
    //NSLog(@"checked....");
    if (self.clicked) {
        self.clicked(self);
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.text = _name;
    BOOL hasChildern = _children.count > 0 ? YES : NO;
    float x = _depth * DEPTH_W + self.textLabel.frame.origin.x - 10;
    float y = 0;
    float w = self.bounds.size.width - x;
    float h = self.bounds.size.height;
    if (!hasChildern) {
        [_expandIcon removeFromSuperview];
    }
    _expandIcon.frame = CGRectMake(x, 15, ICON_W -8,ICON_H - 8);
    _btnCheck.frame = CGRectMake(_expandIcon.frame.origin.x + ICON_W, 12, ICON_W, ICON_H);
    x = _btnCheck.frame.origin.x + ICON_W + 5;
    if (!_bCheckParent && hasChildern) {
        [_btnCheck removeFromSuperview];
        x = _expandIcon.frame.origin.x + ICON_W + 5;
    }
    self.textLabel.frame = CGRectMake(x + 8, y, w - ICON_W - 5, h);
    self.textLabel.font = [UIFont systemFontOfSize:14.f];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
