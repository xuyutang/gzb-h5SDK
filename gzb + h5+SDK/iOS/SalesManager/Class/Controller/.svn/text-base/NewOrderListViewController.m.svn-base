//
//  NewOrderListViewController.m
//  SalesManager
//
//  Created by Administrator on 16/3/23.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "NewOrderListViewController.h"
#import "Constant.h"
#import "UIView+Util.h"
#import "DepartmentViewController.h"
#import "HeaderSearchBar.h"
#import "DropMenu.h"
#import "OrderFilterViewController.h"


@interface NewOrderListViewController ()<HeaderSearchBarDelegate,DropMenuDelegate,DepartmentViewControllerDelegate,OrderFilterViewControllerDelegate>
{
    NSMutableArray *_departments;
    NSMutableArray *_checkDepartments;
    NSMutableArray *_customerCategorys;
    NSMutableArray *_customerCategoryData;
    CustomerCategory *_custCategory;
    NSString *_name;
    NSString *_code;
    NSString *_custName;
    NSString *_formTime;
    NSString *_endTime;
    
    HeaderSearchBar *_searchBar;
    NSMutableArray *_views;
    int     _sort;
}

@end

//订单JSON对象
@implementation OrderListParams
@end

@implementation NewOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _name = @"";
    _code = @"";
    _custName = @"";
    _formTime = @"";
    _endTime = @"";
    
    _sort = 0;
    _departments = [[LOCALMANAGER getDepartments] retain];
    _checkDepartments = [[NSMutableArray alloc] init];
    _views = [[NSMutableArray alloc] init];
    _customerCategorys = [[NSMutableArray alloc] init];
    //******初始化视图
    //部门视图
    DepartmentViewController* departmentVC = [[DepartmentViewController alloc] init];
    departmentVC.delegate = self;
    departmentVC.departmentArray = _departments;
    departmentVC.view.frame = CGRectMake(0, 45.f, MAINWIDTH, MAINHEIGHT - 45.f);
    [self addChildViewController:departmentVC];
    [departmentVC release];
    [_views addObject:self.childViewControllers.firstObject.view];
    //客户类型
    DropMenu* dropMenu1 = [[DropMenu alloc] initWithFrame:CGRectMake(0, 45.f, MAINWIDTH, MAINHEIGHT - 45.f)];
    dropMenu1.delegate = self;
    dropMenu1.menuCount = 1;
    _customerCategoryData = [[LOCALMANAGER getCustomerCategories] retain];
    [_customerCategorys removeAllObjects];
    [_customerCategorys addObject:@"全部类型"];
    for (CustomerCategory* item in _customerCategoryData) {
        [_customerCategorys addObject:item.name];
    }
    dropMenu1.array1 = [[NSMutableArray alloc] initWithArray:_customerCategorys];
    [dropMenu1 initMenu];
    [_views addObject:dropMenu1];
    [dropMenu1 release];
    
    //筛选视图
    OrderFilterViewController *orderFilterVC = [[NSBundle mainBundle] loadNibNamed:@"OrderFilterViewController" owner:nil options:nil].firstObject;
    orderFilterVC.delegate = self;
    orderFilterVC.frame = CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT - 45);
    [self initFilterViewParams:orderFilterVC];
    [_views addObject:orderFilterVC];

    
    //搜索栏
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, 45.f)];
    _searchBar.backgroundColor = WT_WHITE;
    _searchBar.icontitles = @[[NSString fontAwesomeIconStringForEnum:ICON_TYPELIST],
                              [NSString fontAwesomeIconStringForEnum:ICON_TYPELIST],
                              [NSString fontAwesomeIconStringForEnum:ICON_ARROW],
                              [NSString fontAwesomeIconStringForEnum:ICON_FILTER]];
    _searchBar.delegate = self;
    _searchBar.titles = @[@"部门",@"类型",@"金额",@"筛选"];
    [self.view addSubview:_searchBar];
    
    //加载网页
    [self.lblFunctionName setText:TITLENAME_LIST(FUNC_SELL_ORDER_DES)];
    
    self.webView.frame = CGRectMake(0, 45.f, MAINWIDTH, MAINHEIGHT - 45.f);
    NSLog(@"order_list_url:%@",self.url);
    [self loadURL:self.url];
}

-(void) initFilterViewParams:(OrderFilterViewController *) vc{
    if (_orderParams != nil && _orderParams.customers.count > 0) {
        _custName = ((Customer *)[_orderParams.customers objectAtIndex:0]).name;
        vc.custName.text = _custName;
    }else if (_orderParams != nil && _orderParams.users.count > 0){
        _name = ((User *) [_orderParams.users objectAtIndex:0]).realName;
        vc.txtName.text = _name;
    }
}

#pragma -mark -- OrderFilterViewControllerDelegate
-(void)OrderFilterViewControllerSearch:(NSString *)name custName:(NSString *)custName formTime:(NSString *)formTime endTime:(NSString *)endTime{
    int index = 3;
    _name = name;
    _custName = custName;
    _formTime = formTime;
    _endTime = endTime;
    NSString *title;
    if (_name.length > 0) {
        title = _name;
    }else if (_custName.length > 0){
        title = _custName;
    }else if (_formTime.length > 0){
        title = _formTime;
    }else if (_endTime.length > 0){
        title = _endTime;
    }else{
        title = _searchBar.titles[index];
    }
    [self setSearchHeaderTitle:index title:title];
    [self search];
    [_searchBar setColor:index];
}

#pragma -mark -- HeaderSearchBarDelegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    if (current == index && index != 2) {
        [UIView removeViewFormSubViews:-1 views:_views];
        return;
    }
    switch (index) {
        case 2:
            _sort = _sort == 0 ? 1 : 0;
            if (_sort == 0) {
                [self setSearchHeaderTitle:2 title:NSLocalizedString(@"sort_asc_3", nil)];
            }else{
                [self setSearchHeaderTitle:2 title:NSLocalizedString(@"sort_dsc_3", nil)];
            }
            [self search];
            break;
        case 0:
        case 1:
        case 3:
            if (index == 3) {
                index--;
            }
            [UIView addSubViewToSuperView:self.view subView:_views[index]];
            [UIView removeViewFormSubViews:index views:_views];
            break;
        default:
            break;
    }
}


#pragma -mark -- DropMenuDelegate
-(void)selectedDropMenuIndex:(int)index row:(int)row{
    if (row == 0) {
        [_custCategory release];
        _custCategory = nil;
    }else{
        _custCategory = [_customerCategoryData[row - 1] retain];
    }
    [UIView removeViewFormSubViews:-1 views:_views];
    [_searchBar setColor:1];
    NSString *title = _custCategory != nil ? _custCategory.name : _searchBar.titles[1];
    [self setSearchHeaderTitle:1 title:title];
    [self search];
}

#pragma -mark -- DepartmentViewControllerDelegate
-(void)didFnishedCheck:(NSMutableArray *)departments{
    _checkDepartments = [departments retain];
    [self search];
    [_searchBar setColor:-1];
    NSString *title = _checkDepartments.count > 0 ? [(Department *)_checkDepartments.firstObject name] : _searchBar.titles[0];
    [self setSearchHeaderTitle:0 title:title];
}

-(void) setSearchHeaderTitle:(int) index title:(NSString *) title{
    UIButton *btn = _searchBar.buttons[index];
    [btn setTitle:title forState:UIControlStateNormal];
}

-(void) search{
    [self callJavascript:[NSString stringWithFormat:@"searchOrderList(%@)",[self getParams]]];
    
    [UIView removeViewFormSubViews:-1 views:_views];
}

-(NSString *) getParams{
    OrderListParams *param = [[[OrderListParams alloc] init] autorelease];
    param.orderBy = NS_SORT(_sort);
    param.customerName = _custName;
    param.realName = _name;
    param.beginTime = _formTime;
    param.endTime = _endTime;
    param.departIds = @"";
    param.typeIds = @"";
    NSMutableString *departIdStr = [[NSMutableString alloc] init];
    
    for (Department *item in _checkDepartments) {
        [departIdStr appendFormat:@"%d,",item.id];
    }
    if (departIdStr.length > 0) {
        param.departIds = departIdStr;
    }
    if (_custCategory != nil) {
        param.typeIds = [NSString stringWithFormat:@"%d",_custCategory.id];
    }
    return [param mj_JSONString];
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
