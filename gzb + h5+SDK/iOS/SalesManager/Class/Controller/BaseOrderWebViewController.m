//
//  BaseOrderWebViewController.m
//  SalesManager
//
//  Created by Administrator on 16/2/4.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseOrderWebViewController.h"
#import "BottomButtonView.h"
#import "Constant.h"
#import "WebViewJavascriptBridge.h"
#import "NewOrderNormalViewController.h"
#import "CookieHelper.h"
#import "MJRefresh.h"



@interface BaseOrderWebViewController ()<UIWebViewDelegate,NSURLConnectionDataDelegate>

@end

@implementation BaseOrderWebViewController
{
    NSHTTPURLResponse *_response;
    NSMutableData *_data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _response = [[NSHTTPURLResponse alloc] init];
    _data = [[NSMutableData alloc] init];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _js = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:nil];
    [self.view addSubview:_webView];
    _floatButton = [[OrderFloatButton alloc] init];
    [self.view addSubview:_floatButton];
    
    //初始化JS公开方法
    [self initJavaScriptMethod];
}

#pragma -mark -- 默认公开JS调用方法

-(void) initJavaScriptMethod{
    
    //消息弹窗
    [_js registerHandler:@"alert" handler:^(id data, WVJBResponseCallback responseCallback) {
        MessageBarMessageType msgType = MessageBarMessageTypeInfo;
        int type = [[data valueForKey:@"status"] intValue];
        switch (type) {
            case 0:
                msgType =MessageBarMessageTypeError;
                break;
            case 1:
                msgType =MessageBarMessageTypeSuccess;
                break;
            default:
                break;
        }
        [MESSAGE showMessageWithTitle:[data valueForKey:@"title"]
                          description:[data valueForKey:@"content"]
                                 type:msgType
                          forDuration:SUCCESS_MSG_DURATION];
    }];
    
    //窗口跳转 //合并订单详情页面x
    [_js registerHandler:@"openView" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *_tmpData = data;
        if ([_tmpData isKindOfClass:[NSDictionary class]]) {
             [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_NEW_ORDER_NORMAL Object:data Delegate:self NeedBack:YES];
        }else{
            [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_NEW_ORDER_NORMAL Object:@{@"url":data,@"orderId":@(0)} Delegate:self NeedBack:YES];
        }
    }];
    
    //跳转订单确认页面
    [_js registerHandler:@"openConfirmView" handler:^(id data, WVJBResponseCallback responseCallback) {
        [VIEWCONTROLLER create:self.navigationController ViewId:FUNC_NEW_ORDER_COMFIRM Object:data Delegate:self NeedBack:YES];
    }];
    
    //返回产品列表
    [_js registerHandler:@"openProductView" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    //设置购物车价格
    [_js registerHandler:@"setPrice" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data == nil) {
            [MESSAGE showMessageWithTitle:TITLENAME_REPORT(FUNC_SELL_ORDER_DES)
                              description:NSLocalizedString(@"order_price_empty", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }
        if (_floatButton != nil) {
            [_floatButton setLabeText:data];
        }
    }];
}

#pragma -mark -- 公开方法

-(void)refreshUI{
    
}

-(void) loadURL:(NSString *) url{
    SHOWHUD;
    NSString *urlString = [NSString stringWithFormat:@"https://%@/%@%@",SERVER_URL,CONTEXT_PATH,url];
    
    [self resetData];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:REQUEST_TIME_OUT];
    [req setValue:DEVICE_TYPE forHTTPHeaderField:@"deviceType"];
    [COOKIEHEPLER setCookie];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connect start];
    [req retain];
    [connect release];
}


-(void) resetData{
    [_data release];
    _data = [[NSMutableData alloc] init];
}

-(void) reload{
    [_webView reload];
}

-(NSString *)callJavascript:(NSString *)js{
    NSString* src = @"";
    @try {
        src = [_webView stringByEvaluatingJavaScriptFromString:js];
    } @catch (NSException *exception) {
        return src;
    } @finally {
        return src;
    }
    //return [_webView stringByEvaluatingJavaScriptFromString:js];
}
#pragma mark web- 加载HTTPS 绕过证书的验证
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]forAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}


#pragma -mark -- UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    HUDHIDE2;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch (((NSHTTPURLResponse*)response).statusCode) {
        case 401:
        {
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:TITLENAME_REPORT(FUNC_SELL_ORDER_DES)
                              description:NSLocalizedString(@"error_account_expired", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            ExceptionMessage_Builder *em = [ExceptionMessage builder];
            [em setContent:NSLocalizedString(@"error_account_expired", nil)];
            [AGENT setUserExpire:[em build]];
            [connection cancel];
        }
            break;
        case 500:
        {
            HUDHIDE2;
        }
        case 502:
        {
            [MESSAGE showMessageWithTitle:TITLENAME_REPORT(FUNC_SELL_ORDER_DES)
                              description:NSLocalizedString(@"server_bad_error", nil)
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            ExceptionMessage_Builder *em = [ExceptionMessage builder];
            [em setContent:NSLocalizedString(@"server_bad_error", nil)];
        }
            break;
        default:
            break;
    }
    _response = [(NSHTTPURLResponse *)response retain];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    HUDHIDE2;
    [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                      description:error.localizedDescription
                             type:MessageBarMessageTypeError
                      forDuration:ERR_MSG_DURATION];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [_webView loadData:_data MIMEType:_response.MIMEType textEncodingName:_response.textEncodingName baseURL:connection.currentRequest.URL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [_response release];
    [_data release];
    [_js release];
    [_webView release];
    [super dealloc];
}

@end
