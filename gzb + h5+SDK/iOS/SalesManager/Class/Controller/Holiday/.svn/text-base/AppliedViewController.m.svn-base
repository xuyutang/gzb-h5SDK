//
//  AppliedViewController.m
//  SalesManager
//  已申请
//  Created by iOS-Dev on 16/10/8.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "AppliedViewController.h"
#import "MJExtension.h"
#import "HeaderSearchBar.h"
#import "DepartmentViewController.h"
#import "DataReportTypeViewController.h"
#import "NameFilterViewController.h"
#import "UIView+Util.h"
#import "LeaveTypeViewController.h"
#import "HolidayListParams.h"
#import "UIView+CNKit.h"

@interface AppliedViewController ()<HeaderSearchBarDelegate,DepartmentViewControllerDelegate,NameFilterViewControllerDelegate> {
    UIView *rightView;
    HeaderSearchBar         *_headerBar;
    NSMutableArray          *_searchViews;
    NSMutableArray          *_departments;
    NSMutableArray          *_checkDepartments;
    LeaveTypeViewController *typeVC;
}

@end

@implementation AppliedViewController

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [lblFunctionName setText:[NSString stringWithFormat:@"%@-申请",TITLENAME(FUNC_HOLIDAY_DES)]];
    [leftImageView setImage:[UIImage imageNamed:@"ab_icon_back"]];
    
    _searchViews = [[NSMutableArray alloc] initWithCapacity:2];
    _departments = [[NSMutableArray alloc] initWithCapacity:0];
    [_departments removeAllObjects];
    [_departments addObjectsFromArray:[[LOCALMANAGER getDepartments] retain]];
    _checkDepartments = [[NSMutableArray alloc] initWithCapacity:0];
  
    _headerBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45)];
    _headerBar.titles = @[@"部门",@"假休类型",@"筛选"];
    _headerBar.icontitles = @[@"",@"",@""];
    _headerBar.backgroundColor = WT_WHITE;
    _headerBar.delegate = self;
    [self.view addSubview:_headerBar];
    [_headerBar release];
    
    CGFloat rectY = _headerBar.frame.origin.y + _headerBar.frame.size.height;
    CGRect rect = CGRectMake(0, rectY, MAINWIDTH, MAINHEIGHT - rectY);
    
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = _departments;
    departmentVC.view.frame = rect;
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    
     //类型
    typeVC = [[LeaveTypeViewController alloc] init];
    typeVC.view.frame = rect;
    [self addChildViewController:typeVC];
    typeVC = self.childViewControllers[1];
    [_searchViews addObject:typeVC.view];
    [typeVC release];
    
    //筛选
    NameFilterViewController *filterVC = [[[NSBundle mainBundle] loadNibNamed:@"NameFilterViewController" owner:self options:nil] lastObject];
    filterVC.delegate = self;
    filterVC.frame  = rect;
    [_searchViews addObject:filterVC];
    
    [typeVC getUserTrtByBlock:^(HolidayCategory *holidayCatory) {
        holiDyId = holidayCatory.id;
        UIButton *btn = _headerBar.buttons[1];
        [btn setTitle:holidayCatory.name forState:UIControlStateNormal];
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        [_headerBar setColor:1];
        HolidayListParams *parames = [[HolidayListParams alloc]init];
        parames.startTime = startTim;
        parames.endTime = endTim;
        parames.departmentIds = departmentsID;
        parames.holidayCatId =  holiDyId;
        parames.queryUserRealName = quenName;
        NSString * jsonString = [parames mj_JSONString];
        
        [self callJavascript:[NSString stringWithFormat:@"searchApply(%@)",jsonString]];
        
    }];

    NSString *urlString = @"/holidayApply/indexV2.jhtml";
    self.url = urlString;
    [self loadURL:self.url];
    self.webView.y = 45;
    self.webView.height = MAINHEIGHT - 45;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHoliday) name:@"refreshHolidayList" object:nil];
}

-(void)refreshHoliday {
  [self reload];
}

#pragma -mark NameFilterViewController delegate
-(void)NameFilterViewControllerSearch:(NSString *)name formTime:(NSString *)formTime endTime:(NSString *)endTime{
    NSLog(@"筛选名称：%@",name);
    startTim = formTime;
    endTim = endTime;
    quenName = name;
    
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerBar setColor:2];
    HolidayListParams *parames = [[HolidayListParams alloc]init];
    parames.startTime = formTime;
    parames.endTime = endTime;
    parames.departmentIds = departmentsID;
    parames.holidayCatId =  holiDyId;
    parames.queryUserRealName = name;
    NSString * jsonString = [parames mj_JSONString];
    
    [self callJavascript:[NSString stringWithFormat:@"searchApply(%@)",jsonString]];
}

#pragma -mark HeaderSearchBar delegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    NSLog(@"%d",index);
    if (current == index) {
        [UIView removeViewFormSubViews:-1 views:_searchViews];
    }
    else{
        [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
        [UIView removeViewFormSubViews:index views:_searchViews];
    }
}

#pragma -mark 部门选择 Delegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    NSLog(@"部门选择了%d个",departments.count);
    _checkDepartments = [departments retain];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerBar setColor:0];
    
    //设置标题
    NSMutableString* sb = [[[NSMutableString alloc] init] autorelease];
    if (departments && departments.count > 0) {
        int count = 0;
        for (Department* item in departments) {
            if (count > 5) {
                break;
            }
            [sb appendFormat:@"%@,",item.name];
            count ++;
        }
    }
    UIButton* btn = _headerBar.buttons[0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [btn setTitle:departments.count > 0 ? [sb substringToIndex:sb.length - 1] : _headerBar.titles[0] forState:UIControlStateNormal];
    });
    
   //获取部门Id集合
    NSMutableArray *idMuiArray = [[NSMutableArray alloc] init];
    [departments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [idMuiArray addObject: @(((Department*)obj).id)] ;
    }];
    NSString *idString = [idMuiArray componentsJoinedByString:@","];
    NSLog(@"idString == %@",idString);
    departmentsID = idString;
    HolidayListParams *parames = [[HolidayListParams alloc]init];
    parames.startTime = startTim;
    parames.endTime = endTim;
    parames.departmentIds = idString;
    parames.holidayCatId =  holiDyId;
    parames.queryUserRealName = quenName;
    NSString * jsonString = [parames mj_JSONString];
    
    [self callJavascript:[NSString stringWithFormat:@"searchApply(%@)",jsonString]];
}

#pragma mark 返回
-(void)clickLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark didReceiveMemoryWarning
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
