//
//  PDRightHeaderCell.m
//  ProductMenu
//
//  Created by Administrator on 16/2/2.
//  Copyright © 2016年 Administrator. All rights reserved.
//

#import "PDRightHeaderCell.h"
#import "PDMenuHeader.h"

@implementation PDRightHeaderCell

-(instancetype)initWithTitle:(NSString *)title{
    if (self = [super initWithFrame:CGRectMake(0, 0, 212, 44.f)]) {
        _lbtitle = [[UILabel alloc] initWithFrame:self.frame];
        _lbtitle.text = title;
        _lbicon = [[UIImageView alloc] initWithFrame:CGRectMake(175.f, 9.f, 25.f, 25.f)];
        _lbicon.image = [UIImage imageNamed:@"arrow_carrot-right.png"];
        _lbicon.transform = CGAffineTransformMakeRotation((90.f * M_PI) / 180.f);
        
        
        [self addSubview:_lbtitle];
        [self addSubview:_lbicon];
        
        self.backgroundColor = [UIColor whiteColor];
        _lbtitle.textAlignment = UITextAlignmentCenter;
        
        //头部线条
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        line.backgroundColor = RIGHT_BACK_COLOR;
        [self addSubview:line];
        //底部线条
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 1)];
        line2.backgroundColor = RIGHT_BACK_COLOR;
        [self addSubview:line2];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleAction)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}


-(void) expan{
    
}


-(void)unexpan{
    _lbicon.transform = CGAffineTransformMakeRotation((90.f * M_PI) / 180.f);
}


-(void) toggleAction{
    _bChecked = !_bChecked;
    if (_bChecked) {
        if (PDMENU_IOS7) {
            [UIView animateKeyframesWithDuration:0.2f delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                _lbicon.transform = CGAffineTransformMakeRotation((-90.f * M_PI) / 180.f);
                self.backgroundColor = LINE_COLOR;
            } completion:nil];
        }else{
            _lbicon.transform = CGAffineTransformMakeRotation((-90.f * M_PI) / 180.f);
            self.backgroundColor = LINE_COLOR;
        }
        
    }else{
        if (PDMENU_IOS7) {
            [UIView animateKeyframesWithDuration:0.2f delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                _lbicon.transform = CGAffineTransformMakeRotation((90.f * M_PI) / 180.f);
                self.backgroundColor = [UIColor whiteColor];
            } completion:nil];
        }else{
            _lbicon.transform = CGAffineTransformMakeRotation((90.f * M_PI) / 180.f);
            self.backgroundColor = [UIColor whiteColor];
        }
    }
    if (self.clicked) {
        self.clicked(self);
    }
}


@end
