//
//  CommonPrasesCellHeaderView.m
//  SalesManager
//
//  Created by Administrator on 15/12/24.
//  Copyright © 2015年 liu xueyan. All rights reserved.
//

#import "CommonPhrasesCellHeaderView.h"
#import "Constant.h"
#import "IconButton.h"
#import "CommonPhrasesListViewController.h"
#import "UIView+Util.h"

@implementation CommonPhrasesCellHeaderView


-(instancetype)init{
    if (self = [super init]) {
        
        [self initView];
    }
    return self;
}

-(void) initView{
    self.backgroundColor = WT_CLEARCOLOR;
    //headerTitle
    lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, MAINWIDTH * 0.8f, 50)];
    lbTitle.text = NSLocalizedString(@"title_live_info", nil);
    [lbTitle setTextColor:WT_GRAY];
    [lbTitle setFont:[UIFont systemFontOfSize:FONT_SIZE + 1]];
    [self addSubview:lbTitle];
    [lbTitle release];
    //按钮   
    IconButton *iconBtn = [[IconButton alloc] initWithFrame:CGRectMake(MAINWIDTH - 60, 0, 50, 50)];
    iconBtn.icon = ICON_PLUS;
    iconBtn.clicked = ^(NSInteger tag){
        [self showCommonPhrases];
    };
    [self addSubview:iconBtn];
    [iconBtn release];
}

-(void)setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = headerTitle;
    if (_headerTitle != nil && _headerTitle.length > 0) {
        lbTitle.text = headerTitle;
    }
}

-(void) showCommonPhrases{
    CommonPhrasesListViewController *cplVC = [[CommonPhrasesListViewController alloc] init];
    cplVC.bSelect = YES;
    cplVC.bNeedBack = YES;
    cplVC.selectedItem = ^(FavoriteLang *favoriteLang){
        if (self.selectedItem) {
            self.selectedItem(favoriteLang);
        }
    };
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:cplVC];
    [[UIView findViewController:self] presentViewController:navCtrl animated:YES completion:nil];
    [cplVC release];
    [navCtrl release];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
