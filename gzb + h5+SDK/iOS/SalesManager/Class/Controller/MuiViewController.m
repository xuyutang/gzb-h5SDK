//
//  WorklogListMuiViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 2017/8/28.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "MuiViewController.h"
#import "AppDelegate.h"
#import "WorklogSearchViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "NSDate+Util.h"
#import "WorkLogCell.h"
#import "InputViewController.h"
#import "HeaderSearchBar.h"
#import "NameFilterViewController.h"
#import "UIView+Util.h"
#import "DepartmentViewController.h"
#import "SDImageView+SDWebCache.h"

#import "PDRToolSystem.h"
#import "PDRToolSystemEx.h"
#import "PDRCoreAppManager.h"

#define kStatusBarHeight 20.f

@interface MuiViewController ()<UITableViewDelegate,InputFinishDelegate,HeaderSearchBarDelegate,NameFilterViewControllerDelegate,DepartmentViewControllerDelegate>{
    
    PDRCoreApp* pAppHandle;
    BOOL _isFullScreen;
    UIStatusBarStyle _statusBarStyle;
}

@end
static UIView* pContentVIew = nil;

@implementation MuiViewController {
    HeaderSearchBar*        _searchBar;
    NSMutableArray*         _searchViews;
    NSMutableArray*         _departments;
    NSMutableArray*         _checkDepartments;
    NSString*               _name;
    NSString*               _formTime;
    NSString*               _endTime;
    
    NSString* pWWWPath;
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [lblFunctionName setText:TITLENAME_LIST(FUNC_WORKLOG_DES)];
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    //搜索条载入
    
    
    [PDRCore initEngineWihtOptions:nil withRunMode:PDRCoreRunModeAppClient];
    if(pContentVIew == nil)
        pContentVIew = [[UIView alloc] initWithFrame:CGRectMake(0, -20, MAINWIDTH, MAINHEIGHT  + 20)];
    
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
    pWWWPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Pandora/apps/HelloH5/www"];
    
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
    [[[PDRCore Instance] appManager] restart:pAppHandle];
}


#pragma -mark HeaderSearchBar delegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    NSLog(@"日志搜索条选择了:%d",index);
    if (current == index) {
        [UIView removeViewFormSubViews:-1 views:_searchViews ];
    }else{
        [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
        [UIView removeViewFormSubViews:index views:_searchViews];
    }
    
}
#pragma -mark NameFilterViewController delegate
-(void)NameFilterViewControllerSearch:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"筛选名称：%@",name);
    _name = name;
    _formTime = formTime;
    _endTime = endTime;
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:1];
    
    //4[self refreshParamsAndTable];
}

#pragma -mark DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"选择了 %lu 个部门",(unsigned long)departments.count);
    _checkDepartments = [departments retain];
    
    //设置状态
    [_searchBar setColor:0];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    NSMutableString* sb = [[NSMutableString alloc] init];
    int i = 0;
    for (Department* item in departments) {
        if (i > 5) {
            break;
        }
        [sb appendFormat:@"%@,",item.name];
        i++;
    }
    UIButton* btn = _searchBar.buttons[0];
    [btn setTitle:departments.count > 0 ?[sb substringToIndex:sb.length - 1] : _searchBar.titles[0] forState:UIControlStateNormal];
    
    [self fireEvent:@"eventName" args:sb];
    //[self refreshParamsAndTable];
}

-(void)evaluatingJavaScriptFromString:(NSString*)string{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *views = [[[window rootViewController] view] subviews];
    //调用上述方法
    NSArray *frames = [self searchViews:views];
    for (PDRCoreAppFrame *appFrame in frames) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appFrame stringByEvaluatingJavaScriptFromString:string];
        });
    }
}

-(NSMutableArray*)searchViews:(NSArray*)views{
    NSMutableArray *frames = [NSMutableArray array];
    for (UIView *temp in views) {
        if ([temp isMemberOfClass:[PDRCoreAppFrame class]]) {
            [frames addObject:temp];
        }
        if ([temp subviews]) {
            NSMutableArray *tempArray = [self searchViews:[temp subviews]];
            for (UIView *tempView in tempArray) {
                if ([tempView isMemberOfClass:[PDRCoreAppFrame class]]) {
                    [frames addObject:tempView];
                }
            }
        }
    }
    return frames;
}


#pragma mark 封装的事件 + 参数的方法
-(void)fireEvent:(NSString*)event args:(id)args{
    NSString *evalString = nil;
    NSError  *error      = nil;
    NSString *argsString = nil;
    
    if (args) {
        if ([args isKindOfClass:[NSString class]]) {
            argsString = args;
        }else{
            NSData   *jsonData   = [NSJSONSerialization dataWithJSONObject:args options:0 error:&error];
            argsString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (error) {
                NSLog(@"%@",error);
            }
        }
        evalString = [NSString stringWithFormat:@"\
                      var jpushEvent = document.createEvent('HTMLEvents');\
                      jpushEvent.initEvent('%@', true, true);\
                      jpushEvent.eventType = 'message';\
                      jpushEvent.arguments = '%@';\
                      document.dispatchEvent(jpushEvent);",event,argsString];
    }else{
        evalString = [NSString stringWithFormat:@"\
                      var jpushEvent = document.createEvent('HTMLEvents');\
                      jpushEvent.initEvent('%@', true, true);\
                      jpushEvent.eventType = 'message';\
                      document.dispatchEvent(jpushEvent);",event];
    }
    //调用上述方法
    [self evaluatingJavaScriptFromString:evalString];
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


-(void)clickLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


