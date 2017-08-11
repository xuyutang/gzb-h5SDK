//
//  CustomerFunctionCell.m
//  SalesManager
//
//  Created by liuxueyan on 15-5-5.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "CustomerFunctionCell.h"
#import "Constant.h"
#import "AppDelegate.h"

@implementation FunctionItem

@end


@implementation CustomerFunctionCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews{
    myFunctions =[[NSMutableArray alloc] init];
    _functions = [LOCALMANAGER getFunctions];
    for (Function* f in _functions) {
        if ([f.value isEqual: FUNC_PATROL_DES]){
            FunctionItem *item = [[FunctionItem alloc] init];
            item.name = TITLENAME(FUNC_PATROL_DES);
            item.fid = FUNC_PATROL;
            [myFunctions addObject:item];
        }
    }
    
    for (Function *f in _functions) {
        if ([f.value isEqual: FUNC_RESEARSH_DES]){
            FunctionItem *item = [[FunctionItem alloc] init];
            item.name = TITLENAME(FUNC_RESEARSH_DES);
            item.fid = FUNC_RESEARSH;
            [myFunctions addObject:item];
        }
    }

    for (Function *f in _functions) {
        if ([f.value isEqual: FUNC_BIZOPP_DES]){
            FunctionItem *item = [[FunctionItem alloc] init];
            item.name = TITLENAME(FUNC_BIZOPP_DES);
            item.fid = FUNC_BIZOPP;
            [myFunctions addObject:item];
        }
    }

    for (Function *f in _functions) {
        if ([f.value isEqual: FUNC_COMPETITION_DES]){
            FunctionItem *item = [[FunctionItem alloc] init];
            item.name = TITLENAME(FUNC_COMPETITION_DES);
            item.fid = FUNC_COMPETITION;
            [myFunctions addObject:item];
        }
    }

    for (Function *f in _functions) {
        if ([f.value isEqual: FUNC_SELL_TODAY_DES]){
            FunctionItem *item = [[FunctionItem alloc] init];
            item.name = TITLENAME(FUNC_SELL_TODAY_DES);
            item.fid = FUNC_SELL_TODAY;
            [myFunctions addObject:item];
        }
    }

    for (Function *f in _functions) {
        if ([f.value isEqual: FUNC_SELL_ORDER_DES]){
            FunctionItem *item = [[FunctionItem alloc] init];
            item.name = TITLENAME(FUNC_SELL_ORDER_DES);
            item.fid = FUNC_NEW_ORDER_REPORT;
            [myFunctions addObject:item];
        }
    }
    
    
    for (Function *f in _functions) {
        if ([f.value isEqual: FUNC_SELL_STOCK_DES]){
            FunctionItem *item = [[FunctionItem alloc] init];
            item.name =TITLENAME(FUNC_SELL_STOCK_DES);

            item.fid = FUNC_SELL_STOCK;
            [myFunctions addObject:item];
        }
    }
    
    for (Function *f in _functions) {
        if ([f.value isEqual: FUNC_GIFT_DES]){
            FunctionItem *item = [[FunctionItem alloc] init];
            item.name = @"赠品发放";
            item.fid = FUNC_GIFT;
            [myFunctions addObject:item];
        }
    }
           for (int i =0;i<myFunctions.count;i++) {
        FunctionItem *item = [myFunctions objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage createImageWithColor:WT_GREEN] forState:UIControlStateNormal];
        [button setTitle:item.name forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button.titleLabel setTextColor:WT_WHITE];
        if (i<4) {
            [button setFrame:CGRectMake(16*(i+1)+62*i, 8, 62, 30)];
        }else{
            int j = i-4;
            [button setFrame:CGRectMake(16*(j+1)+62*j, 46, 62, 30)];
        }
        button.tag = i;
        [button addTarget:self action:@selector(toFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
}

-(void)toFunction:(id)sender{
    
    FunctionItem *item = [myFunctions objectAtIndex:[(UIButton*)sender tag]];
    [VIEWCONTROLLER create:_vctrl.navigationController ViewId:item.fid Object:_customer Delegate:nil NeedBack:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [_bt1 release];
    [_bt2 release];
    [_bt3 release];
    [_bt4 release];
    [_bt5 release];
    [_bt6 release];
    [_bt7 release];
    [_bt8 release];
    [super dealloc];
}
@end
