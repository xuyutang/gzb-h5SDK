//
//  LeaveBaseViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 16/10/9.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "LeaveBaseViewController.h"
#import "Constant.h"
#import "WebViewJavascriptBridge.h"
#import "MessageBarManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "NSString+Helpers.h"
#import "AppliedDetailViewController.h"
#import "CookieHelper.h"

@interface LeaveBaseViewController ()<UIWebViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>


@end

@implementation LeaveBaseViewController {
    NSHTTPURLResponse *_response;
    NSMutableData *_data;
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    _response = [[NSHTTPURLResponse alloc] init];
    _data = [[NSMutableData alloc] init];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [WebViewJavascriptBridge enableLogging];
    _js = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:nil];
    [self.view addSubview:_webView];
 
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
    
    [_js registerHandler:@"openViewV2" handler:^(id data, WVJBResponseCallback responseCallback) {
        
      AppliedDetailViewController* detailVC = [[AppliedDetailViewController alloc]init];
        detailVC.applyIdString = [data objectForKey:@"applyId"];
        detailVC.hasNavBool = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    
        [detailVC release];
              
    }];
    
    [_js registerHandler:@"getDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"approve_notifi" object:nil userInfo:data];

    }];
    //审批后回来刷新界面
    [_js registerHandler:@"setReturn" handler:^(id data, WVJBResponseCallback responseCallback) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHoliday" object:nil];
    }];

}

#pragma -mark -- 公开方法
-(void)refreshUI{
    
}

#pragma mark loadURL 加载webView
-(void) loadURL:(NSString *) url{
    NSString *URLString = [NSString stringWithFormat:@"https://%@/%@/%@",SERVER_URL,CONTEXT_PATH,url];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    [self resetData];
    [COOKIEHEPLER setCookie];
  
    //url 加密 MD5
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *tokenString = [NSString stringWithFormat:@"%d%@%@%@",USER.id,USER.userName,USER.password,uuid];
    
    NSString *accessToken = [tokenString md5];
    NSString *urlString;
    
    //url追加时间戳，避免web的缓存
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    
    if ([URLString rangeOfString:@"?"].location != NSNotFound) {
        urlString = [NSString stringWithFormat:@"%@&userId=%d&deviceType=IOS&ticket=%@&accessToken=%@&u=%@",URLString,USER.id,uuid,accessToken,timeString];
    }else {
        urlString = [NSString stringWithFormat:@"%@?userId=%d&deviceType=IOS&ticket=%@&accessToken=%@&u=%@",URLString,USER.id,uuid,accessToken,timeString];
    }
    
    NSLog(@"USER.id++++++++++ == %@",urlString);
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:30.0];
  
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [connect start];
    [req retain];
    [connect release];
}

#pragma mark 重置数据
-(void) resetData{
    [_data release];
     _data = [[NSMutableData alloc] init];
}

#pragma mark 重新加载
-(void) reload{
    [_webView reload];
}

#pragma mark CallJS
-(NSString *)callJavascript:(NSString *)js{
    NSString* src = @"";
    @try {
        src = [_webView stringByEvaluatingJavaScriptFromString:js];
    } @catch (NSException *exception) {
        return src;
    } @finally {
        return src;
    }
}

#pragma -mark -- UIWebViewDelegate
#pragma -mark webViewDidFinishLoad
- (void)webViewDidFinishLoad:(UIWebView *)webView {
     HUDHIDE2;
    [self.hud hide:YES];
}

#pragma mark didReceiveData
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

#pragma mark didReceiveResponse
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch (((NSHTTPURLResponse*)response).statusCode) {
        case 401:
        {
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_HOLIDAY_DES)
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
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_HOLIDAY_DES)
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

#pragma mark didFailWithError
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    HUDHIDE2;
     [self.hud hide:YES];
    [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                      description:error.localizedDescription
                             type:MessageBarMessageTypeError
                      forDuration:ERR_MSG_DURATION];
   
}

#pragma mark connectionDidFinishLoading
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    HUDHIDE2;
    [self.hud hide:YES];
    [_webView loadData:_data MIMEType:_response.MIMEType textEncodingName:_response.textEncodingName baseURL:connection.currentRequest.URL];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        //if ([trustedHosts containsObject:challenge.protectionSpace.host])
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
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
