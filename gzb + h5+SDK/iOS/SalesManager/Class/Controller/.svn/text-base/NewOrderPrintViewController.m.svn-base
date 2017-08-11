//
//  NewOrderPrintViewController.m
//  SalesManager
//
//  Created by Administrator on 16/3/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "NewOrderPrintViewController.h"
#import "OrderFloatButton.h"
#import "Constant.h"
#import "WTPrintViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface NewOrderPrintViewController ()
{
    UITextView *_txtView;
    OrderFloatButton *_floatButton;
    WTPrintViewController *_print;
}

@end

@implementation NewOrderPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    //初始化打印机连接功能
    [self initPrintFunc];
}

-(void)clickLeftButton:(id)sender{
    [_print disconnect];
    [super clickLeftButton:sender];
}

-(void) initView{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.lblFunctionName setText:TITLENAME_PRINT(FUNC_SELL_ORDER_DES)];
    
    _txtView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, 280, MAINHEIGHT)];
    _txtView.backgroundColor = WT_WHITE;
    _txtView.font = [UIFont systemFontOfSize:FONT_SIZE + 1];
    _txtView.editable = NO;
    [self.view addSubview:_txtView];
    
    UILabel *listImageView = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
    //[listImageView setImage:[UIImage imageNamed:@"topbar_button_list"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBlueTooth)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.textAlignment = UITextAlignmentCenter;
    listImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_BLUETOOTH];
    listImageView.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
    listImageView.textColor = WT_RED;
    [listImageView addGestureRecognizer:tapGesture1];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:listImageView];
    self.rightButton = rightBtn;
    [rightBtn release];
    [listImageView release];
    
    _floatButton = [[OrderFloatButton alloc] initWithLableText:NSLocalizedString(@"lable_connect_device", nil) titles:@[NSLocalizedString(@"lable_print", nil)]];
    _floatButton.btnClick = ^(int index){
        SHOWHUD;
        [_print print];
    };
    [self.view addSubview:_floatButton];
    [_floatButton setButtonEnable:NO];
    
    [self sendPrintAction];
}

#pragma -mark -- AGNT_Delegate
-(void)didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypePrintOrder:
            if ([cr.code isEqualToString:NS_ACTIONCODE(ActionCodeDone)]) {
                NSString *result = ([Print parseFromData:cr.data]).content;
                result = [NSString stringWithFormat:@"%@\n\n",result];
                _txtView.text = result;
                _print.printContent = result;
                [_print scan];
            }
            break;
            
        default:
            break;
    }
    [super showMessage2:cr Title:TITLENAME_PRINT(FUNC_SELL_ORDER_DES) Description:@""];
}

#pragma -mark -- 私有方法

-(void) sendPrintAction{
    AGENT.delegate = self;
    SHOWHUD;
    PrintParams_Builder *pb = [PrintParams builder];
    [pb setOrderId:self.orderId];
    if (DONE != [AGENT sendRequestWithType:ActionTypePrintOrder param:[pb build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_ORDER_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void) openBlueTooth{
    if (IOS7) {
        _print.modalPresentationStyle = UIModalPresentationCustom;
        _print.transitioningDelegate  = _print;
        [self presentViewController:_print animated:YES completion:nil];
    }
}

-(void) initPrintFunc{
    _print = [WTPrintViewController mainPrintVC];
    __block OrderFloatButton *_tmpFloatButton = _floatButton;
    _print.scanNull = ^(enum PrintConnectionStatus printConnectionStatus){
        NSLog(@"扫描完毕");
        if (printConnectionStatus == PrintConnectionStatusOff) {
            [_tmpFloatButton setLabeText:NSLocalizedString(@"lable_goto_connect_device", nil)];
            
            [_floatButton setButtonEnable:NO];
        }else{
            
            [_floatButton setButtonEnable:YES];
            [_tmpFloatButton setLabeText:[NSString stringWithFormat:NSLocalizedString(@"connect_device", nil),[WTPrintViewController mainPrintVC].currentPeripheral.name]];
        }
    };
    _print.printEnd = ^(NSError *error){
        HUDHIDE2;
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                                  description:@"打印完成"
                                         type:MessageBarMessageTypeSuccess
                                  forDuration:SUCCESS_MSG_DURATION];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                                  description:[NSString stringWithFormat:@"打印调用失败：%@",error.description]
                                         type:MessageBarMessageTypeError
                                  forDuration:ERR_MSG_DURATION];
            });
        }
    };
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
