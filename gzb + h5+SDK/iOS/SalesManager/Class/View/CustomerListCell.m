//
//  CustomerListCell.m
//  SalesManager
//
//  Created by liuxueyan on 15-4-24.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "CustomerListCell.h"

@implementation CustomerListCell{
    UIImageView *favImg;
    UILabel *lableLayer;
}

- (void)awakeFromNib {
    // Initialization code
    
}



-(void) setBHideFuncBtn:(BOOL)bHideFuncBtn
{
    _bHideFuncBtn = bHideFuncBtn;
    if (_bHideFuncBtn) {
        [_btFunction removeFromSuperview];
        [_btLocate removeFromSuperview];
        [_locate removeFromSuperview];
        [_cloud removeFromSuperview];
    }
}

-(void)setBShowFav:(BOOL)bShowFav{
    _bShowFav = bShowFav;
    if (_bShowFav && favImg == nil) {
        favImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 35, 30, 30)];
        favImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favTouchAction:)];
        gesture.numberOfTapsRequired = 1;
        [favImg addGestureRecognizer:gesture];
        [self addSubview:favImg];
        
        //扩大收藏按钮选择范围
        lableLayer = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 0, 70, 100)];
        [lableLayer setUserInteractionEnabled:YES];
        [lableLayer addGestureRecognizer:gesture];
        [lableLayer setBackgroundColor:[UIColor clearColor]];
        [gesture release];
    }
}

-(void) favTouchAction:(CustomerListCell *) sender{
    if (self.favTouchAction) {
        //收藏成功后再处理隐藏
        //[self setBFav:!_bFav];
        self.favTouchAction(self);
    }
}

-(void)setBFav:(BOOL)bFav{
    _bFav = bFav;
    if (favImg == nil) {
        return;
    }
    
    if (_bFav) {
        [favImg removeFromSuperview];
        [lableLayer removeFromSuperview];
    }else{
        [favImg setImage:[UIImage imageNamed:@"ic_fav_add"]];
        [self addSubview:lableLayer];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(CustomerListCell *) setFavStatus:(BOOL) bShow bfav:(BOOL) bfav{
    [self setBShowFav:bShow];
    [self setBFav:bfav];
    
    
    return self;
}

- (void)dealloc {
    [_name release];
    [_distance release];
    [_type release];
    [_locate release];
    [_tel release];
    [_address release];
    [_cloud release];
    [_btFunction release];
    [_icon release];
    [_btLocate release];
    [_btPhone release];
    [favImg release];
    [lableLayer release];
    [super dealloc];
}
@end
