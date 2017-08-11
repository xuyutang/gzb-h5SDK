//
//  MapTaggingViewController.m
//  SalesManager
//
//  Created by 章力 on 15/6/18.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "MapTaggingViewController.h"
#import "Product.h"
#import "Constant.h"
#import "CookieHelper.h"
#import "GZBWebView.h"
#import "WebViewJavascriptBridge.h"

@interface MapTaggingViewController ()<UIWebViewDelegate>{
    NSString* cAddress;
    double cLatitude;
    double cLongitude;
    NSString* cProvince;
    NSString* cCity;
    NSString* cArea;
    
    Location* cLocation;
    
    CLGeocoder *Geocoder;
    WebViewJavascriptBridge *_js;
}
@end

@implementation MapTaggingViewController
@synthesize webView,lLocation,delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    webView = [[GZBWebView alloc] initWithFrame:CGRectMake(0, 55, MAINWIDTH, MAINHEIGHT - 55)];
    [self initData];
    [self.view addSubview:webView];
    
    //JS 互动
    _js = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:nil];
    
    //初始化JS公开方法
    [self initJavaScriptMethod];
    Geocoder=[[CLGeocoder alloc]init];
    
    Location_Builder* lbv1 = [Location builder];
    if (APPDELEGATE.myLocation != nil) {
        [lbv1 setLatitude:APPDELEGATE.myLocation.latitude];
        [lbv1 setLongitude:APPDELEGATE.myLocation.longitude];
        [lbv1 setAddress:APPDELEGATE.myLocation.address];
    }else{
        [lbv1 setLatitude:0.00f];
        [lbv1 setLongitude:0.00f];
        [lbv1 setAddress:@""];

    }
    
    if (cLocation != nil) {
        [cLocation release];
        cLocation = nil;
    }
    cLocation = [[lbv1 build] retain];
    if (APPDELEGATE.myLocation != nil) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:APPDELEGATE.myLocation.latitude longitude:APPDELEGATE.myLocation.longitude];
        [self getCityCode:loc];
        [loc release];
        loc = nil;
    }
     [lblFunctionName setText:NSLocalizedString(@"title_location_info", @"")];
}

-(void) initJavaScriptMethod{
    [_js registerHandler:@"setLocation" handler:^(id data, WVJBResponseCallback responseCallback) {
            NSArray *array = [data componentsSeparatedByString:@"|"];
            if (array.count == 6) {
                [self setLocation2:array];
            }
    }];
}

-(void)initData{
    webView.delegate = self;
    if (APPDELEGATE.myLocation != nil) {
        lLocation.text = APPDELEGATE.myLocation.address;
    }
    
    [self loadMap];
    cLocation = nil;
    cLatitude = 0;
    cLongitude = 0;
    cAddress = @"";
    
    cProvince = @"";
    cCity = @"";
    cArea = @"";
}

-(void)clickLeftButton:(id)sender{
    if (delegate != nil && [delegate respondsToSelector:@selector(refresh:)]) {
        if (cLocation != nil) {
            [delegate refresh:cLocation];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadMap{
    dispatch_async(dispatch_get_main_queue(), ^{
        SHOWHUD;
    });
    NSString* latitude = @"";
    NSString* longitude = @"";
    if (APPDELEGATE.myLocation != nil) {
        latitude = [NSString stringWithFormat:@"%f",APPDELEGATE.myLocation.latitude];
        longitude = [NSString stringWithFormat:@"%f",APPDELEGATE.myLocation.longitude];
    }
    NSString *urlParam = [NSString stringWithFormat:CUSTOEMR_MAP_TAGGING_URL,latitude,longitude];
    NSString *url = [NSString stringWithFormat:@"https://%@/%@/%@",SERVER_URL,CONTEXT_PATH,urlParam];
    NSLog(@"map tagging url:%@",url);
    [webView loadUrl:url];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    HUDHIDE2;
    UIButton* bMark = [UIButton buttonWithType:UIButtonTypeCustom];
    [bMark setFrame:CGRectMake(50, 5.0f,50.0f, 50.0f)];
    bMark.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];
    [bMark setTitle:[NSString fontAwesomeIconStringForEnum:ICON_MAP_MARK] forState:UIControlStateNormal] ;
    [bMark setTitleColor:WT_RED forState:UIControlStateNormal];
    [bMark addTarget:self action:@selector(reLocation) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:bMark];
    self.rightButton = btRight;
    [btRight release];
}

//- (void)conduit:(JavascriptConduit *)conduit receivedMessage:(NSString *)message
//{
//    NSArray *array = [message componentsSeparatedByString:@"|"];
//    if (array.count == 6) {
//        [self setLocation2:array];
//    }
//}
-(void)reLocation{
    if (APPDELEGATE.myLocation != nil) {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"getLocation(%@,%@);",[NSString stringWithFormat:@"%f",APPDELEGATE.myLocation.latitude],[NSString stringWithFormat:@"%f",APPDELEGATE.myLocation.longitude]]];
        
        lLocation.text = APPDELEGATE.myLocation.address;
        
        Location_Builder* lbv1 = [cLocation toBuilder];
        if (APPDELEGATE.myLocation != nil) {
            [lbv1 setLatitude:APPDELEGATE.myLocation.latitude];
            [lbv1 setLongitude:APPDELEGATE.myLocation.longitude];
            [lbv1 setAddress:APPDELEGATE.myLocation.address];
        }else{
            [lbv1 setLatitude:0.00f];
            [lbv1 setLongitude:0.00f];
            [lbv1 setAddress:@""];
        }
        
        if (cLocation != nil) {
            [cLocation release];
            cLocation = nil;
        }
        cLocation = [[lbv1 build] retain];
        
        if (APPDELEGATE.myLocation != nil) {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:APPDELEGATE.myLocation.latitude longitude:APPDELEGATE.myLocation.longitude];
            [self getCityCode:loc];
            [loc release];
            loc = nil;
        }
    }
}

-(void)setLocation2:(NSArray*) jsArgs{
    if (jsArgs.count == 6) {
        cLatitude = [((NSString*)jsArgs[0]) doubleValue];
        cLongitude = [((NSString*)jsArgs[1]) doubleValue];
        cAddress = ((NSString*)jsArgs[2]);
        cProvince = ((NSString*)jsArgs[3]);
        cCity = ((NSString*)jsArgs[4]);
        cArea = ((NSString*)jsArgs[5]);
        
        Location_Builder* lbv1 = [cLocation toBuilder];
        [lbv1 setLatitude:cLatitude];
        [lbv1 setLongitude:cLongitude];
        [lbv1 setAddress:cAddress];
        
        cLocation = [[lbv1 build] retain];
        
        lLocation.text = cLocation.address;
        [self getCityCode];
    }
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error{
    HUDHIDE2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCityCode{
    NSLog(@"Province:%@",cProvince);
    NSString* Province = [cProvince stringByReplacingOccurrencesOfString:@"省" withString:@""];
    NSString* ProvinceCode = [LOCALMANAGER getProvincePostIdWithName:Province];
    
    NSLog(@"City:%@",cCity);
    NSString* City = [cCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
    NSString* CityCode = [LOCALMANAGER getCityPostIdWithName:City];
    
    NSLog(@"Area:%@",cArea);
    NSString* Area = [cArea stringByReplacingOccurrencesOfString:@"县" withString:@""];
    Area = [Area stringByReplacingOccurrencesOfString:@"区" withString:@""];
    NSString* AreaCode = [LOCALMANAGER getAreaPostIdWithName:Area];
    if (AreaCode.isEmpty) {
        AreaCode = CityCode;
    }
    Location_Builder* lbv1 = [cLocation toBuilder];
    [lbv1 setProvince:Province];
    [lbv1 setCity:City];
    [lbv1 setDistrict:Area];
    if (!ProvinceCode.isEmpty) {
        [lbv1 setProvinceCode:ProvinceCode];
    }
    if (!CityCode.isEmpty) {
        [lbv1 setCityCode:CityCode];
    }
    if (!AreaCode.isEmpty) {
        [lbv1 setDistrictCode:AreaCode];
    }
    cLocation = [[lbv1 build] retain];
    NSLog(@"Province code:%@",ProvinceCode);
    NSLog(@"City code:%@",CityCode);
    NSLog(@"Area code:%@",AreaCode);
}
- (void)getCityCode:(CLLocation *)location {
    
    [Geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error == nil && [placemarks count] > 0){
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           NSLog(@"Province:%@",placemark.administrativeArea);
                           NSString* Province = [placemark.administrativeArea stringByReplacingOccurrencesOfString:@"省" withString:@""];
                           NSString* ProvinceCode = [LOCALMANAGER getProvincePostIdWithName:Province];
                           
                           NSLog(@"City:%@",placemark.locality);
                           NSString* City = [placemark.locality stringByReplacingOccurrencesOfString:@"市" withString:@""];
                           NSString* CityCode = [LOCALMANAGER getCityPostIdWithName:City];
                           
                           NSLog(@"Area:%@",placemark.subLocality);
                           NSString* Area = [placemark.subLocality stringByReplacingOccurrencesOfString:@"县" withString:@""];
                           Area = [Area stringByReplacingOccurrencesOfString:@"区" withString:@""];
                           NSString* AreaCode = [LOCALMANAGER getAreaPostIdWithName:Area];
                           if (AreaCode.isEmpty) {
                               AreaCode = CityCode;
                           }
                           Location_Builder* lbv1 = [cLocation toBuilder];
                           [lbv1 setProvince:Province];
                           [lbv1 setCity:City];
                           [lbv1 setDistrict:Area];
                           if (!ProvinceCode.isEmpty) {
                               [lbv1 setProvinceCode:ProvinceCode];
                           }
                           if (!CityCode.isEmpty) {
                               [lbv1 setCityCode:CityCode];
                           }
                           if (!AreaCode.isEmpty) {
                               [lbv1 setDistrictCode:AreaCode];
                           }
                           cLocation = [[lbv1 build] retain];
                           NSLog(@"Province code:%@",ProvinceCode);
                           NSLog(@"City code:%@",CityCode);
                           NSLog(@"Area code:%@",AreaCode);
                           
                       }else if (error == nil && [placemarks count] == 0){
                           NSLog(@"No results were returned.");
                       }
                       else if (error != nil){
                           NSLog(@"An error occurred = %@", error);
                           
                       }
                   }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [webView release];
    [lLocation release];
    [super dealloc];
}
@end
