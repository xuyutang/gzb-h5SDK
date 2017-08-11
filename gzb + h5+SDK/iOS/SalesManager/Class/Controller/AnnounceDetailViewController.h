//
//  AnnounceDetailViewController.h
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-14.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "GZBWebView.h"

@interface AnnounceDetailViewController : BaseViewController<UIWebViewDelegate>
@property (retain, nonatomic) GZBWebView *webView;
@property(nonatomic,retain) Announce *announce;
@end
