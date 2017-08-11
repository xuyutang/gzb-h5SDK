//
//  OrderViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "SaleViewController.h"
#import "SelectCell.h"
#import "OrderProductCell.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "SaleListViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"

@interface SaleViewController ()

@end

@implementation SaleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initView
{
    
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_SELL_TODAY_DES)];
    (APPDELEGATE).agent.delegate = self;
}

-(void)syncTitle {
 [lblFunctionName setText:TITLENAME_REPORT(FUNC_SELL_TODAY_DES)];
}

-(void)setHeader3Title{
    header2.title.text = @"产品列表";
    header3.title.text = @"订单详情";
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}

-(void)toList:(id)sender{
    [self dismissKeyBoard];
    SaleListViewController *ctrl = [[SaleListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}
-(void)toSave:(id)sender{
    [self dismissKeyBoard];
    if (currentCustomer == nil) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_TODAY_DES)
                          description:NSLocalizedString(@"patrol_hont_customer_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    NSString* comment = @"";
    if ((tvRemarkCell.textView.textColor != [UIColor lightGrayColor])) {
          comment = tvRemarkCell.textView.text;
    }else {
    comment = @"";
    }
 
    if (comment.trim.length > 1000){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_TODAY_DES)
                          description:NSLocalizedString(@"input_limit_1000", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    //if (comment.trim.length == 0) {
    if (targetArray == nil || [targetArray count]<1) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_TODAY_DES)                          description:NSLocalizedString(@"order_hint_product_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    BOOL hasProductNum = TRUE;
    for (Product* p in targetArray) {
        //NSString* num = [NSString stringWithFormat:@"%.4f",p.num];
        if (![p hasNum]){
            hasProductNum = FALSE;
            break;
        }
        
    }
    if (!hasProductNum) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_TODAY_DES)
                          description:NSLocalizedString(@"order_hint_product_num_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    //}else{
    if ([NSString stringContainsEmoji:comment]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_TODAY_DES)
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
        
    }
    // }
    
    
    SaleGoods_Builder* sb = [SaleGoods builder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    if ((APPDELEGATE).myLocation != nil){
        [sb setLocation:(APPDELEGATE).myLocation];
    }
    
    [sb setId:-1];
    [sb setCustomer:currentCustomer];
    [sb setProductsArray:targetArray];
    [sb setComment:comment];

    (APPDELEGATE).agent.delegate = self;
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeSalegoodsSave param:[sb build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_TODAY_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}


- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeSalegoodsSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [self clearTable];
                
            }
            [super showMessage2:cr Title:TITLENAME(FUNC_SELL_TODAY_DES)Description:NSLocalizedString(@"sale_msg_saved", @"")];
        }
            break;
            
        default:
            break;
    }
}

- (void) didFailWithError:(NSError *)error{
    HUDHIDE2;
    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_TODAY_DES)
                      description:NSLocalizedString(@"error_server", @"")
                             type:MessageBarMessageTypeError
                      forDuration:ERR_MSG_DURATION];
}
- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    HUDHIDE2;
    [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_TODAY_DES)
                      description:NSLocalizedString(@"error_connect_server", @"")
                             type:MessageBarMessageTypeError
                      forDuration:ERR_MSG_DURATION];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
