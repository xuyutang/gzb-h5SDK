//
//  NewOrderConfirmViewController.m
//  SalesManager
//
//  Created by Administrator on 16/3/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "NewOrderConfirmViewController.h"
#import "NewOrderPrintViewController.h"
#import "OrderFloatButton.h"
#import "Constant.h"
#import "WebViewJavascriptBridge.h"
#import "NewOrderNormalViewController.h"

@interface NewOrderConfirmViewController ()
{
    int orderId;
    BOOL bSucess;   //用于判断返回是刷新购物车
}
@end

@implementation NewOrderConfirmViewController

- (void)viewDidLoad {
    orderId = 0;
    [super viewDidLoad];
    [self.lblFunctionName setText:TITLENAME_CONFIRM(FUNC_SELL_ORDER_DES)];
    [self loadURL:self.url];
    [self.floatButton setLableText:@"" titles:@[NSLocalizedString(@"commit_order_form", nil)]];
    self.floatButton.btnClick = ^(int index) {
        [self callJavascript:[NSString stringWithFormat:@"saveOrder('%@')",DEVICE_TYPE]];
    };
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initJavascriptMethod];
}

-(void)clickLeftButton:(id)sender{
    if (bSucess) {
        if (_carVC.onRefreshUI) {
            _carVC.onRefreshUI();
        }
    }
    [super clickLeftButton:sender];
}

//注册JS调用方法
-(void) initJavascriptMethod{
    [self.js registerHandler:@"orderSuccess" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *_tmpid = data;
        if (_tmpid != nil && _tmpid.length > 0) {
            orderId = _tmpid.intValue;
        }else{
            orderId = 0;
        }
        [self setSucessStatus];
    }];
}

//设置订单成功后的按钮状态
-(void) setSucessStatus{
    bSucess = YES;
    [self.lblFunctionName setText:TITLENAME_SUCESS(FUNC_SELL_ORDER_DES)];
    [self.floatButton setLableText:@"" titles:@[NSLocalizedString(@"print_order", nil),NSLocalizedString(@"continue_order", nil)]];
    self.floatButton.btnClick = ^(int index) {
        if (index == 0) {
            if (IOS7) {
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_NEW_ORDER_PRINT Object:@(orderId) Delegate:nil NeedBack:YES];
            }else{
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                                  description:NSLocalizedString(@"bluetooth_need_ios_version", nil)
                                         type:MessageBarMessageTypeError
                                  forDuration:ERR_MSG_DURATION];
            }
        }else{
            
            NSArray * ctrlArray = self.navigationController.viewControllers;
        
            [self.navigationController popToViewController:[ctrlArray objectAtIndex:ctrlArray.count -3] animated:YES];
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
