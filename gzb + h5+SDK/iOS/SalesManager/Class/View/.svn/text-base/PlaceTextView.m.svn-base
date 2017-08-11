//
//  PlaceTextView.m
//  SalesManager
//
//  Created by Administrator on 15/12/4.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "PlaceTextView.h"
#import "Constant.h"

@implementation PlaceTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    if (_placeHolder) {
        if (_lable == nil) {
            _lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width, 25)];
            _lable.textColor = WT_GRAY;
            _lable.backgroundColor = WT_CLEARCOLOR;
            _lable.font = [UIFont systemFontOfSize:FONT_SIZE];
            [self addSubview:_lable];
            //[_lable release];
        }
        _lable.text = _placeHolder;
    }
}

-(void)setText:(NSString *)text{
    [super setText:text];
    if (text != nil && text.length > 0) {
        [self textViewDidChange:self];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    NSString *str = textView.text;
    if (str.length == 0) {
        [UIView animateWithDuration:.2f animations:^{
            _lable.text = _placeHolder;
        }];
    }else{
        [UIView animateWithDuration:.2f animations:^{
            _lable.text = @"";
        }];
    }
}
@end
