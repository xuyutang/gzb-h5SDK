//
//  AnnounceDetailViewController.m
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-14.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "AnnounceDetailViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "Product.h"

@interface AnnounceDetailViewController ()

@end

@implementation AnnounceDetailViewController
@synthesize announce;

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
    [lblFunctionName setText:TITLENAME_DETAIL(FUNC_MESSAGE_DES)];
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [self.view addSubview:self.webView];
    
    [self openAnnounce];
}

-(void)clickLeftButton:(id)sender{
    [self.webView stopLoading];
    HUDHIDE;
    [self dismissModalViewControllerAnimated :YES];
    [super clickLeftButton:sender];
}

-(void) openAnnounce{
    NSString* url = [ANNOUNCE_URL stringByAppendingString:[NSString stringWithFormat:@"?announcementId=%d&userId=%d",self.announce.id,USER.id]];
    SHOWHUD;
    
    NSString *encodedurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *requesturl =[NSURL URLWithString:encodedurl];
//    NSURLRequest *request =[NSURLRequest requestWithURL:requesturl];
//    self.webView.scalesPageToFit = YES;
//    //self.webView.autoresizesSubviews = NO;
//    //self.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
//    [self.webView loadRequest:request];
    [self.webView loadUrl:encodedurl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //加载完成后，标注通知已读
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    NSString *jsExpress =@"window.announcement.UpdateMessage(";
    NSString *HTMLSource = [self.webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    NSLog(@"%@",HTMLSource);
    
    NSRange range0 = [HTMLSource rangeOfString:jsExpress];
    if (range0.location != NSNotFound) {
        NSString *tail = [HTMLSource substringFromIndex:range0.location+jsExpress.length];
        NSRange range1 = [tail rangeOfString:@");"];
        if (range1.location != NSNotFound) {
            NSString *strId = [tail substringToIndex:range1.location];
            if ([strId isEqualToString:@"-1"]) {
                [LOCALMANAGER deleteAnnounce:announce];
            }else{
                [LOCALMANAGER setReadedAnnounceStatus:announce];
                [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_NOTIFICATION_MENU object:nil];
            }
        }
    }
    
    HUDHIDE;
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


- (void)updateAnnounce:(NSString *)announceId{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error.description);
    HUDHIDE;
    /*[MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_announce_detail", @"")
                      description:NSLocalizedString(@"error_connect_server", @"")
                             type:MessageBarMessageTypeError
                      forDuration:ERR_MSG_DURATION];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
