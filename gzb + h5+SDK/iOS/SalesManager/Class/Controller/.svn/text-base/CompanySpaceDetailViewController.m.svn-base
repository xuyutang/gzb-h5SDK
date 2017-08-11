//
//  CompanySpaceDetailViewController.m
//  SalesManager
//
//  Created by 章力 on 14-4-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "CompanySpaceDetailViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "Product.h"

@interface CompanySpaceDetailViewController ()

@end

@implementation CompanySpaceDetailViewController
@synthesize cSpace;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[GZBWebView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit =YES;
    [lblFunctionName setText:TITLENAME_DETAIL(FUNC_SPACE_DES)];
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [self.view addSubview:self.webView];
    [self openSpace];
}

-(void)clickLeftButton:(id)sender{
    [self.webView stopLoading];
    HUDHIDE;
    [self dismissModalViewControllerAnimated :YES];
    
}

-(void) openSpace{
    NSString* url = [SPACE_URL stringByAppendingString:[NSString stringWithFormat:@"?userId=%d&spaceId=%d",USER.id,self.cSpace.id]];
    
    NSLog(@"%@",url);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    NSString *encodedurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webView loadUrl:encodedurl];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    HUDHIDE;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error.description);
    HUDHIDE;
    /*[MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_announce_detail", @"")
     description:NSLocalizedString(@"error_connect_server", @"")
     type:MessageBarMessageTypeError
     forDuration:ERR_MSG_DURATION];*/
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL =[ [ request URL ] retain ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ];
    }
    [ requestURL release ];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
