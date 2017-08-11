//
//  OrderViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "OrderViewController.h"
#import "SelectCell.h"
#import "OrderProductCell.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "OrderListViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

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

    [lblFunctionName setText:TITLENAME_REPORT(FUNC_SELL_ORDER_DES)];
    (APPDELEGATE).agent.delegate = self;
}

-(void)syncTitle {
  [lblFunctionName setText:TITLENAME_REPORT(FUNC_SELL_ORDER_DES)];

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}



-(void)toList:(id)sender{
    [self dismissKeyBoard];
    OrderListViewController *ctrl = [[OrderListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)toSave:(id)sender{
    [self dismissKeyBoard];
    if (currentCustomer == nil) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_ORDER_DES)
                          description:NSLocalizedString(@"patrol_hont_customer_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    NSString* comment = tvRemarkCell.textView.text;
    //if (comment.trim.length == 0) {
    if (targetArray == nil || [targetArray count]<1) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_ORDER_DES)
                          description:NSLocalizedString(@"order_hint_product_empty", @"")
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
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_ORDER_DES)
                          description:NSLocalizedString(@"order_hint_product_num_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    // }else{
    if ([NSString stringContainsEmoji:comment]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_ORDER_DES)
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    //}
    
    OrderGoods_Builder* ob = [OrderGoods builder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    if ((APPDELEGATE).myLocation != nil){
        [ob setLocation:(APPDELEGATE).myLocation];
    }
    
    [ob setId:-1];
    [ob setCustomer:currentCustomer];
    [ob setProductsArray:targetArray];
    [ob setComment:comment];

    (APPDELEGATE).agent.delegate = self;
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeOrdergoodsSave param:[ob build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_ORDER_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    [super tableView:tableView titleForHeaderInSection:section];
    switch (section) {

        case 2:{
            if ([productArray count]<1) {
                return NSLocalizedString(@"title_order_no", nil);
            }
            
            return NSLocalizedString(@"title_order_info", nil);
        }
        default:
            break;
    }
    return @"";
}

-(void)setHeader3Title{
    header3.title.text = NSLocalizedString(@"title_order_info", nil);
}

-(void)findProduct:(NSString *)searchText{
    int i = 0;
    NSRange range;
    range.location = NSNotFound;
    for (; i<[productArray count]; i++) {
        Product *product = [productArray objectAtIndex:i];
        range = [product.name rangeOfString:searchText];
        if (range.location != NSNotFound) {
            [productArray insertObject:product atIndex:0];
            [productArray removeObjectAtIndex:i+1];
        }
    }
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeOrdergoodsSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [self clearTable];
                
            }
            [super showMessage2:cr Title:TITLENAME(FUNC_SELL_ORDER_DES) Description:NSLocalizedString(@"order_msg_saved", @"")];
        }
            break;
            
        default:
            break;
    }
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
