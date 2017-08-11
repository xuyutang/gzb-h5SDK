//
//  GZBWebView.m
//  SalesManager
//
//  Created by Administrator on 16/3/29.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "GZBWebView.h"
#import "Constant.h"
#import "CookieHelper.h"

@implementation GZBWebView
{
    NSMutableData *_data;
    NSHTTPURLResponse *_response;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _data = [[NSMutableData alloc] init];
    }
    return self;
}


-(void) loadUrl:(NSString *) url{
    
    _data = [[NSMutableData alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:REQUEST_TIME_OUT];
    [request setValue:DEVICE_TYPE forHTTPHeaderField:@"deviceType"];
    [COOKIEHEPLER setCookie];
    NSURLConnection* tmpConnect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [tmpConnect start];
    [request release];
    [tmpConnect release];
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

#pragma -mark -- NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                      description:error.localizedDescription
                             type:MessageBarMessageTypeError
                      forDuration:ERR_MSG_DURATION];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_data appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch (((NSHTTPURLResponse*)response).statusCode) {
        case 401:
        {
            [MESSAGE showMessageWithTitle:nil
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
        }
        case 502:
        {
            [MESSAGE showMessageWithTitle:nil
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

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    NSString *html = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",html);
    [self loadData:_data MIMEType:_response.MIMEType textEncodingName:_response.textEncodingName baseURL:connection.currentRequest.URL];
    [_response release];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
