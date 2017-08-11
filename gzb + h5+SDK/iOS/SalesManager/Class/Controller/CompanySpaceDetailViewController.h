//
//  CompanySpaceDetailViewController.h
//  SalesManager
//
//  Created by 章力 on 14-4-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "GZBWebView.h"

@interface CompanySpaceDetailViewController : BaseViewController<UIWebViewDelegate>
@property (nonatomic, retain) CompanySpace *cSpace;
@property (retain, nonatomic) IBOutlet GZBWebView *webView;
@end
