//
//  TestCell.m
//  RefreshTest
//
//  Created by imac on 16/8/12.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}
#pragma mark ==Cell界面初始化布局==
- (void)initView{
    _testLb = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, __kWidth-60, 15)];
    [self addSubview:_testLb];
    _testLb.textAlignment = NSTextAlignmentLeft;
    _testLb.font = MFont(14);
    _testBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, 25, 25)];
    [self addSubview:_testBtn];
    _testBtn.layer.cornerRadius = 10;
    [_testBtn setImage:[UIImage imageNamed:@"noraml_check_off"] forState:UIControlStateNormal];
    [_testBtn addTarget:self action:@selector(choose:) forControlEvents:BtnTouchUpInside];

}

- (void)choose:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.delegate  SelectedCell:sender];
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"noraml_check_on"] forState:UIControlStateNormal];
    }else{
       [sender setImage:[UIImage imageNamed:@"noraml_check_off"] forState:UIControlStateNormal];
    }
}

@end
