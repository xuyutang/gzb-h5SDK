//
//  JavascriptBridge.h
//  JSLite
//
//  Created by 章力 on 15/7/7.
//  Copyright (c) 2015年 Juicyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class JavascriptBridge;

//

@protocol JavascriptBridgeDelegate <UIWebViewDelegate>
- (void)javascriptBridge:(JavascriptBridge *)bridge receivedMessage:(NSString *)message fromWebView:(UIWebView *)webView;
- (void)javascriptBridgeDidFinishLoad:(UIWebView *)webView;
@end

//

@interface JavascriptBridge : NSObject <UIWebViewDelegate>

@property id <JavascriptBridgeDelegate> delegate;
@property NSMutableDictionary *requestHeaders;

- (void)sendMessage:(NSString *)message toWebView:(UIWebView *)webView;
- (void)resetQueue;
- (void)pushRequestHeaders:(NSMutableDictionary *)headers;

@end
