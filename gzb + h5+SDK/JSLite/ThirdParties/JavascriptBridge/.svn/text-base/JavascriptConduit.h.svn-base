//
//  JavascriptConduit.h
//  JSLite
//
//  Created by 章力 on 15/7/7.
//  Copyright (c) 2015年 Juicyshare. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JavascriptBridge.h"

@class JavascriptConduit;

//

@protocol JavascriptConduitDelegate
- (void)conduit:(JavascriptConduit *)conduit receivedMessage:(NSString *)message;
- (void)conduitDidFinishLoad:(UIWebView *)webView;
@end

//

@interface JavascriptConduit : UIView <JavascriptBridgeDelegate>
{
@private JavascriptBridge *_conduitBridge;
}

@property id <JavascriptConduitDelegate> delegate;
@property UIWebView *webView;
@property (readonly) NSMutableDictionary *headers;

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)html baseURL:(NSURL *)baseURL;

- (void)addHeader:(NSString *)key withValue:(NSString *)value;
- (void)removeHeader:(NSString *)key;

- (void)sendMessage:(NSString *)message;
- (void)resetMessageQueue;

@end
