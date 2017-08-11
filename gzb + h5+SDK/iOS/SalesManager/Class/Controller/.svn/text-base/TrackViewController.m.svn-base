//
//  TrackViewController.m
//  SalesManager
//
//  Created by 章力 on 15/5/27.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "TrackViewController.h"
#import "Constant.h"
#import "RDVTabBar.h"
#import "EGORefreshTableHeaderView.h"
#import "NSDate+Util.h"
#import "Product.h"
#import "HeaderSearchDateView.h"
#import "DatePicker2.h"


@interface TrackViewController ()<DatePicker2Delegate,HeaderSearchDateViewDelegate,UIWebViewDelegate,UIScrollViewDelegate, EGORefreshTableHeaderDelegate>{
    int selectIndex;
    GZBWebView* webView;
    HeaderSearchDateView *searchView;
    
    //下拉视图
    EGORefreshTableHeaderView * _refreshHeaderView;
    //刷新标识，是否正在刷新过程中
    BOOL _reloading;
    
    NSString *currentDate;
    DatePicker2 *datePicker;
}

@end

@implementation TrackViewController
@synthesize webView,user;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [lblFunctionName setText:NSLocalizedString(@"menu_fuction_tack",@"")];
    currentDate = [[NSDate getCurrentDate] retain];
    
    self.title = @"";
    webView.delegate = self;
    webView.scrollView.delegate = self;
    
    if (_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-webView.scrollView.bounds.size.height, webView.scrollView.frame.size.width, webView.scrollView.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [webView.scrollView addSubview:_refreshHeaderView];
    }
    [_refreshHeaderView setBackgroundColor:RGBA(255,228,181,1.0) textColor:[UIColor blackColor] arrowImage:[UIImage imageNamed:@"ic_pull_refresh_arrow"]];
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
    searchView = [[HeaderSearchDateView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    searchView.delegate = self;
    [self.view addSubview:searchView];
    dispatch_async(dispatch_get_main_queue(), ^{

        [searchView.bt1 setTitle:NSLocalizedString(@"search_yesterday", @"") forState:UIControlStateNormal];
        [searchView.bt2 setTitle:NSLocalizedString(@"search_today", @"") forState:UIControlStateNormal];
        [searchView.bt3 setTitle:NSLocalizedString(@"search_customize_day", @"") forState:UIControlStateNormal];
        [searchView.bt2 setSelected:YES];

    });
    
    [self refresh];
    
    
}

-(void)clickButtunIndex:(int)index{

    switch (index) {
        case 1:{

            [self datePickerDidCancel];
            [searchView.bt1 setSelected:YES];
            [searchView.bt2 setSelected:NO];
            [searchView.bt3 setSelected:NO];
            currentDate = [[NSDate getYesterdayDate] retain];

            [self refresh];
        }
            break;
        case 2:{

            [self datePickerDidCancel];
            [searchView.bt1 setSelected:NO];
            [searchView.bt2 setSelected:YES];
            [searchView.bt3 setSelected:NO];
            currentDate = [[NSDate getCurrentDate] retain];

            [self refresh];
        }
            break;
        case 3:{
            [searchView.bt1 setSelected:NO];
            [searchView.bt2 setSelected:NO];
            [searchView.bt3 setSelected:YES];
            datePicker = [[DatePicker2 alloc] init];

            [self.view addSubview:datePicker];
            [datePicker setDelegate:self];
            [datePicker setCenter:CGPointMake(self.view.frame.size.width*.5, self.view.frame.size.height-datePicker.frame.size.height*.5)];
            [datePicker release];

        }
            break;
            
        default:
            break;
    }
}

-(void)clickLeftButton:(id)sender{
    if (bNeedBack) {
        [self.parentController.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadText{

    NSString *urlParam = [NSString stringWithFormat:TRACK_TIMELINE_URL,currentDate,user.id,USER.userName,USER.password];
    NSString *url = [NSString stringWithFormat:@"https://%@/%@/%@",SERVER_URL,CONTEXT_PATH,urlParam];
//    NSLog(@"timeline url:%@",url);
//    NSURLRequest *request =[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    webView.delegate = self;
    [webView loadUrl:url];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    _reloading = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:webView.scrollView];
}

- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:webView.scrollView];
}

-(NSString *)intToDoubleString:(int)d{
    
    if (d<10) {
        return [NSString stringWithFormat:@"0%d",d];
    }
    return [NSString stringWithFormat:@"%d",d];
    
}
-(void)datePickerDidDone:(DatePicker2*)picker{
    
    currentDate = [[NSString stringWithFormat:@"%d-%@-%@",datePicker.yearValue,[self intToDoubleString:datePicker.monthValue],[self intToDoubleString:datePicker.dayValue]] retain];
    [searchView.bt3 setTitle:currentDate forState:UIControlStateNormal];
    [self datePickerDidCancel];
    [self refresh];
    
}
-(void)datePickerDidCancel{
    
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[DatePicker2 class]]){
            [view removeFromSuperview];
        }
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self refresh];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
}

- (void) refresh{
    [self _loadText];

}

- (void)dealloc {
    [webView release];
    [super dealloc];
}
@end
