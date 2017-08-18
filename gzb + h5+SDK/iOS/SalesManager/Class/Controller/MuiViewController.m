//
//  MuiViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 2017/8/15.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "MuiViewController.h"
#import "PDRToolSystem.h"
#import "PDRToolSystemEx.h"
#import "PDRCoreAppManager.h"

#define kStatusBarHeight 20.f


@interface MuiViewController () {
    PDRCoreApp* pAppHandle;
    BOOL _isFullScreen;
    UIStatusBarStyle _statusBarStyle;
    
    
}

@end

static UIView* pContentVIew = nil;

@implementation MuiViewController


- (void)viewDidLoad {
    [lblFunctionName setText:@"MUI页面"];
    [PDRCore initEngineWihtOptions:nil withRunMode:PDRCoreRunModeAppClient];
    
    
    [super loadView];
    if(pContentVIew == nil)
        
        pContentVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT + 64)];
    
    [self.view addSubview: pContentVIew];
    
    PDRCore *h5Engine = [PDRCore Instance];
    [self setStatusBarStyle:h5Engine.settings.statusBarStyle];
    _isFullScreen = [UIApplication sharedApplication].statusBarHidden;
    if ( _isFullScreen != h5Engine.settings.fullScreen ) {
        _isFullScreen = h5Engine.settings.fullScreen;
        if ( [self  respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)] ) {
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen];
        }
    }
    h5Engine.coreDeleagete = self;
    h5Engine.persentViewController = self;
    
    // 设置WebApp所在的目录，该目录下必须有mainfest.json
    NSString* pWWWPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Pandora/apps/HelloH5/www"];
    
    // 如果路径中包含中文，或Xcode工程的targets名为中文则需要对路径进行编码
    //NSString* pWWWPath2 =  (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)pTempString, NULL, NULL,  kCFStringEncodingUTF8 );
    
    // 用户在集成5+SDK时，需要在5+内核初始化时设置当前的集成方式，
    // 请参考AppDelegate.m文件的- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法
    
    // 设置5+SDK运行的View
    [[PDRCore Instance] setContainerView:pContentVIew];
    
    // 传入参数可以在页面中通过plus.runtime.arguments参数获取
    NSString* pArgus = @"id=plus.runtime.arguments";
    // 启动该应用
    pAppHandle = [[[PDRCore Instance] appManager] openAppAtLocation:pWWWPath withIndexPath:@"index.html" withArgs:pArgus withDelegate:nil];
    
    
    // 如果应用可能会重复打开的话建议使用restart方法
    //[[[PDRCore Instance] appManager] restart:pAppHandle
}

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark -
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventInterfaceOrientation
                            withObject:[NSNumber numberWithInt:toInterfaceOrientation]];
    if ([PTDeviceOSInfo systemVersion] >= PTSystemVersion8Series) {
        [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen ];
    }
}

- (BOOL)shouldAutorotate
{
    return TRUE;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[PDRCore Instance].settings supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( [PDRCore Instance].settings ) {
        return [[PDRCore Instance].settings supportsOrientation:interfaceOrientation];
    }
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (BOOL)prefersStatusBarHidden
{
    return _isFullScreen;/*
                          NSString *model = [UIDevice currentDevice].model;
                          if (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM()
                          && (NSOrderedSame == [@"iPad" caseInsensitiveCompare:model]
                          || NSOrderedSame == [@"iPad Simulator" caseInsensitiveCompare:model])) {
                          return YES;
                          }
                          return NO;*/
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

-(BOOL)getStatusBarHidden {
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series ) {
        return _isFullScreen;
    }
    return [UIApplication sharedApplication].statusBarHidden;
}

#pragma mark - StatusBarStyle
-(UIStatusBarStyle)getStatusBarStyle {
    return [self preferredStatusBarStyle];
}
-(void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if ( _statusBarStyle != statusBarStyle ) {
        _statusBarStyle = statusBarStyle;
        if ( [self  respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)] ) {
            [self setNeedsStatusBarAppearanceUpdate];
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _statusBarStyle;
}

#pragma mark -
-(void)wantsFullScreen:(BOOL)fullScreen
{
    if ( _isFullScreen == fullScreen ) {
        return;
    }
    
    _isFullScreen = fullScreen;
    [[UIApplication sharedApplication] setStatusBarHidden:_isFullScreen withAnimation:_isFullScreen?NO:YES];
    if ( [PTDeviceOSInfo systemVersion] > PTSystemVersion6Series ) {
        [self setNeedsStatusBarAppearanceUpdate];
    }// else {
    //   return;
    //  }
    CGRect newRect = self.view.bounds;
    if ( [PTDeviceOSInfo systemVersion] <= PTSystemVersion6Series ) {
        newRect = [UIApplication sharedApplication].keyWindow.bounds;
        if ( _isFullScreen ) {
            [UIView beginAnimations:nil context:nil];
            self.view.frame = newRect;
            [UIView commitAnimations];
        } else {
            UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
            if ( UIDeviceOrientationLandscapeLeft == interfaceOrientation
                || interfaceOrientation == UIDeviceOrientationLandscapeRight ) {
                newRect.size.width -=kStatusBarHeight;
            } else {
                newRect.origin.y += kStatusBarHeight;
                newRect.size.height -=kStatusBarHeight;
            }
            [UIView beginAnimations:nil context:nil];
            self.view.frame = newRect;
            [UIView commitAnimations];
        }
        [[PDRCore Instance] handleSysEvent:PDRCoreSysEventInterfaceOrientation
                                withObject:[NSNumber numberWithInt:0]];
        
    }
}

- (void)didReceiveMemoryWarning{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventReceiveMemoryWarning withObject:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
