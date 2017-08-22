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
    PDRCoreAppFrame* appFrame;
    
    
}

@end

static UIView* pContentVIew = nil;

@implementation MuiViewController


- (void)viewDidLoad {
    [lblFunctionName setText:@"MUI页面"];
    [PDRCore initEngineWihtOptions:nil withRunMode:PDRCoreRunModeWebviewClient];
    
    
    PDRCore*  pCoreHandle = [PDRCore Instance];
    if (pCoreHandle != nil)
    {
        
        NSString* pFilePath = [NSString stringWithFormat:@"file://%@/%@", [NSBundle mainBundle].bundlePath, @"Pandora/apps/HelloH5/www/plugin.html"];
        [pCoreHandle start];
        // 如果路径中包含中文，或Xcode工程的targets名为中文则需要对路径进行编码
        //NSString* pFilePath =  (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)pTempString, NULL, NULL,  kCFStringEncodingUTF8 );
        
        // 单页面集成时可以设置打开的页面是本地文件或者是网络路径
        // NSString* pFilePath = @"http://www.163.com";
        
        
        // 用户在集成5+SDK时，需要在5+内核初始化时设置当前的集成方式，
        // 请参考AppDelegate.m文件的- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法
        
        CGRect StRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        appFrame = [[PDRCoreAppFrame alloc] initWithName:@"WebViewID1" loadURL:pFilePath frame:StRect];
        if (appFrame) {
            [pCoreHandle.appManager.activeApp.appWindow registerFrame:appFrame];
            [self.view  addSubview:appFrame];
            [appFrame release];
        }
        
    }
}

- (void)dealloc
{
    [super dealloc];
    [[PDRCore Instance] setContainerView:nil];
}

@end
