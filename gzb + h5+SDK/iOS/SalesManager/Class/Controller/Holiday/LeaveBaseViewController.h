//
//  LeaveBaseViewController.h
//  SalesManager
//  此类为webView的基类
//  Created by iOS-Dev on 16/10/9.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MBProgressHUD.h"

@class WebViewJavascriptBridge;
@interface LeaveBaseViewController : BaseViewController

@property (nonatomic,retain) UIWebView *webView;

@property (nonatomic,retain) WebViewJavascriptBridge *js;

@property (nonatomic,retain) NSString *url;

@property (nonatomic,strong)MBProgressHUD *hud;

-(void) loadURL:(NSString *) url;

-(void) refreshUI;

-(void) reload;

-(NSString *) callJavascript:(NSString *) js;

-(void)webViewDidFinishLoad:(UIWebView *)webView;

-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
