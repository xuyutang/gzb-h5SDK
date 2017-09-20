//
//  WorklogListMuiViewController.m
//  SalesManager
//
//  Created by iOS-Dev on 2017/8/28.
//  Copyright © 2017年 liu xueyan. All rights reserved.
//

#import "WorklogListMuiViewController.h"
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
#import "WorklogdetailMuiViewController.h"


@interface WorklogListMuiViewController ()<UITableViewDelegate,InputFinishDelegate,HeaderSearchBarDelegate,NameFilterViewControllerDelegate,DepartmentViewControllerDelegate>

@end

@implementation WorklogListMuiViewController {
    HeaderSearchBar*        _searchBar;
    NSMutableArray*         _searchViews;
    NSMutableArray*         _departments;
    NSMutableArray*         _checkDepartments;
    NSString*               _name;
    NSString*               _formTime;
    NSString*               _endTime;
    
    PDRCoreAppFrame* appFrame;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toDetail) name:@"pushAction" object:nil];
    
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    //搜索条载入
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0,0, MAINWIDTH, 45)];
    NSArray* titles = [NSArray arrayWithObjects:@"部门",@"筛选", nil];
    NSArray*  icons = [NSArray arrayWithObjects:@"",@"",nil];
    _searchBar.titles = [titles copy];
    _searchBar.icontitles = [icons copy];
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchBar];
    
    //计算frame
    CGRect tmpFrame = CGRectMake(04, 45,320 , 459);
    tmpFrame.size.height = MAINHEIGHT - 45;
    
    //初始化数据
    _searchViews = [[NSMutableArray alloc] initWithCapacity:1];
    _departments = [[LOCALMANAGER getDepartments] retain];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.departmentArray = _departments;
    departmentVC.delegate = self;
    departmentVC.view.frame = tmpFrame;
    [self addChildViewController:departmentVC];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    [departmentVC release];
    
    //筛选视图
    NameFilterViewController* nameFilterVC = [[NSBundle mainBundle] loadNibNamed:@"NameFilterViewController" owner:self options:nil][0];
    nameFilterVC.frame = tmpFrame;
    nameFilterVC.delegate = self;
    [_searchViews addObject:nameFilterVC];
    [lblFunctionName setText:TITLENAME_LIST(FUNC_WORKLOG_DES)];
    
    //MUI部分
    
    [PDRCore initEngineWihtOptions:nil withRunMode:PDRCoreRunModeWebviewClient];
    
    
    PDRCore*  pCoreHandle = [PDRCore Instance];
    if (pCoreHandle != nil)
    {
        
        NSString* pFilePath = [NSString stringWithFormat:@"file://%@/%@", [NSBundle mainBundle].bundlePath, @"Pandora/apps/HelloH5/www/myWorklog.html"];
        [pCoreHandle start];
        // 如果路径中包含中文，或Xcode工程的targets名为中文则需要对路径进行编码
        //NSString* pFilePath =  (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)pTempString, NULL, NULL,  kCFStringEncodingUTF8 );
        
        // 单页面集成时可以设置打开的页面是本地文件或者是网络路径
        // NSString* pFilePath = @"http://www.163.com";
        
        
        // 用户在集成5+SDK时，需要在5+内核初始化时设置当前的集成方式，
        // 请参考AppDelegate.m文件的- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法
        
        CGRect StRect = CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT - 45);
        
        appFrame = [[PDRCoreAppFrame alloc] initWithName:@"WebViewID1" loadURL:pFilePath frame:StRect];
        if (appFrame) {
            [pCoreHandle.appManager.activeApp.appWindow registerFrame:appFrame];
            [self.view  addSubview:appFrame];
            [appFrame release];
        }
        
    }
    
    // Do any additional setup after loading the view.
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
-(void)toDetail {
    WorklogdetailMuiViewController *muidetailVC  = [[WorklogdetailMuiViewController alloc] init];
    [self.navigationController pushViewController:muidetailVC animated:YES];

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
    
    //NSString *evalString = [NSString stringWithFormat:@"alert('%@')",sb];
    
    // [appFrame dispatchDocumentEvent:@"tttt"];
    // [appFrame stringByEvaluatingJavaScriptFromString:evalString];
    [self fireEvent:@"eventName" args:sb];
    //[self refreshParamsAndTable];
}

#pragma mark 传递事件 参数
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
    [appFrame stringByEvaluatingJavaScriptFromString:evalString];
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
