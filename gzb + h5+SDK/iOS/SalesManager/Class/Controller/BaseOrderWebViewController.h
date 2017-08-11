//
//  BaseOrderWebViewController.h
//  SalesManager
//
//  Created by Administrator on 16/2/4.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OrderFloatButton.h"

@class WebViewJavascriptBridge;
@interface BaseOrderWebViewController : BaseViewController

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) OrderFloatButton *floatButton;
@property (nonatomic,retain) WebViewJavascriptBridge *js;
@property (nonatomic,retain) NSString *url;

@property (nonatomic,copy) void(^onRefreshUI) (void);



-(void) loadURL:(NSString *) url;
-(void) refreshUI;
-(void) reload;

-(NSString *) callJavascript:(NSString *) js;

- (void)webViewDidFinishLoad:(UIWebView *)webView;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
