//
//  SaleStatisticsViewController.m
//  SalesManager
//
//  Created by lzhang@juicyshare.cc on 13-8-8.
//  Copyright (c) 2013年 liu xueyan. All rights reserved.
//

#import "SaleStatisticsViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "Product.h"

@interface SaleStatisticsViewController ()

@end

@implementation SaleStatisticsViewController
@synthesize webView;
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
    
    self.webView.delegate = self;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UILabel *seachImageView = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
    //[seachImageView setImage:[UIImage imageNamed:@"topbar_button_search"]];
    [seachImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_SEARCH]];
    [seachImageView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
    [seachImageView setTextColor:WT_RED];
    [seachImageView setTextAlignment:UITextAlignmentCenter];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSearchView)];
    [tapGesture1 setNumberOfTapsRequired:1];
    seachImageView.userInteractionEnabled = YES;
    [seachImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:seachImageView];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];
    [rightView release];
    [tapGesture1 release];
    
    [lblFunctionName setText:NSLocalizedString(@"bar_statisics", @"")];
    
    webView.scalesPageToFit =YES;
    webView.delegate =self;
    
    [self openSearchView];
}

-(void)openSearchView{
    
    SaleStatisticsSearchViewController *ctrl = [[SaleStatisticsSearchViewController alloc] init];
    ctrl.delegate = self;
    UINavigationController *searchNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentModalViewController:searchNavCtrl animated:YES];
    //[ctrl release];
    //[searchNavCtrl release];
    
}

-(void)didFinishedSearchWithResult:(SaleGoodsParams_Builder *)result{
    
    sParamsBuilder = [(SaleGoodsParams_Builder*)result retain];
    sParams = [[sParamsBuilder build] retain];
    NSString* url = [SALE_URL stringByAppendingString:[NSString stringWithFormat:@"?lid=%d",(APPDELEGATE).currentUser.id]];
    /*
    if (sParams.hasUser){
        NSString* Param = [NSString stringWithFormat:@"&uid=%d",sParams.user.id];
        url = [url stringByAppendingString:Param];
    }
    
    if (sParams.hasCustomer){
        NSString* Param = [NSString stringWithFormat:@"&cid=%d",sParams.customer.id];
        url = [url stringByAppendingString:Param];
    }
    if (sParams.hasCustomerCategory){
        NSString* Param = [NSString stringWithFormat:@"&ccid=%d",sParams.customerCategory.id];
        url = [url stringByAppendingString:Param];
    }else{
        NSString* Param = [NSString stringWithFormat:@"&ccid=0"];
        url = [url stringByAppendingString:Param];
    }
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&startDate=%@",sParams.startDate]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&endDate=%@",sParams.endDate]];
    NSLog(@"%@",url);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    NSString *encodedurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *requesturl =[NSURL URLWithString:encodedurl];
    NSURLRequest *request =[NSURLRequest requestWithURL:requesturl];
    [webView loadRequest:request];*/
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    HUDHIDE2;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error.description);
    HUDHIDE2;
    [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_statisics", @"")
                      description:NSLocalizedString(@"error_connect_server", @"")
                             type:MessageBarMessageTypeError
                      forDuration:ERR_MSG_DURATION];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
