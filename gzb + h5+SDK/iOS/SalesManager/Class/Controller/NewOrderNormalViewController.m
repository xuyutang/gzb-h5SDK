//
//  NewOrderNormalViewController.m
//  SalesManager
//
//  Created by Administrator on 16/3/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "NewOrderNormalViewController.h"
#import "WebViewJavascriptBridge.h"
#import "Constant.h"

@interface NewOrderNormalViewController ()<UIActionSheetDelegate>
@end

@implementation NewOrderNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadURL:self.url];
    if (!self.bOrderInfoView) {
        //普通界面不需工具条
        [self.floatButton removeFromSuperview];
    }else{
        [self.lblFunctionName setText:TITLENAME_DETAIL(FUNC_SELL_ORDER_DES)];
        //订单详情
        [self.floatButton setLableText:self.price titles:@[NSLocalizedString(@"print_order", nil)]];
        
        //暂时取消继续下单功能
        //,NSLocalizedString(@"continue_order", nil)
        self.floatButton.btnClick = ^(int index){
            if (index == 0) {
                if (!IOS7) {
                    [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                                      description:NSLocalizedString(@"bluetooth_need_ios_version", nil)
                                             type:MessageBarMessageTypeError
                                      forDuration:ERR_MSG_DURATION];
                    return;
                }
                [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_NEW_ORDER_PRINT Object:@(_orderId) Delegate:nil NeedBack:YES];
            }else{
                if (!_bMessageView) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [APPDELEGATE.drawerController setCenterViewController:APPDELEGATE.orderNavCtrl withCloseAnimation:YES completion:nil];
                    [APPDELEGATE.mainTabbar.navigationController popToViewController:APPDELEGATE.mainTabbar animated:NO];
                    [APPDELEGATE.mainTabbar.navigationController pushViewController:APPDELEGATE.drawerController animated:YES];
                }
            }
        };
    }
    
    
    if (self.lbtitle == nil || self.lbtitle.length == 0) {
        [self.lblFunctionName setText:NSLocalizedString(@"loading", nil)];
    }else{
        [self.lblFunctionName setText:self.lbtitle];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self initJSMethod];
}

-(void)clickLeftButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)refreshUI{
    [self loadURL:self.url];
}

-(void) initJSMethod{
    //删除购物车
    [self.js registerHandler:@"confirmDeleteCart" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"delete_hint", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"no", nil)
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"yes", nil), nil];
        [alert showInView:self.view];
        [alert release];
    }];
}


#pragma -mark --UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self callJavascript:@"deleteCart();"];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    HUDHIDE2;
    NSString *title = [self callJavascript:@"document.title"];
    [self.lblFunctionName setText:title];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
