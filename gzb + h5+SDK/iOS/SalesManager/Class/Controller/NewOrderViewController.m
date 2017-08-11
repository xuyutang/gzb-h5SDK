//
//  NewOrderViewController.m
//  SalesManager
//
//  Created by Administrator on 16/3/22.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "NewOrderViewController.h"
#import "Constant.h"
#import "OrderFloatButton.h"
#import "WebViewJavascriptBridge.h"
#import "CustomerSelectViewController.h"
#import "NewOrderListViewController.h"
#import "UIView+Util.h"
#import "ProductFilterViewController.h"
#import "MJExtension.h"

@implementation ProductJavaScriptParams
@end

@interface NewOrderViewController ()<FavCustomerDelegate>
{
    BOOL _bFirstLoad;
    
    int _sort;// = 0;//asc
    NSString *_name;
    NSString *_code;
    NSString *_startPrice;
    NSString *_endPrice;
    NSString *_specIds;
    NSString *_tagName;
    ProductFilterViewController *pfvc;
    DepartmentViewController *departmentVC;
}
@end

@implementation NewOrderViewController


-(void) initData{
    _name = @"";
    _code = @"";
    _startPrice = @"";
    _endPrice = @"";
    _specIds = @"";
    
    [_checkCategory release];
    _checkCategory = [[NSMutableArray alloc] init];
    _sort = 0;
    [pfvc resetForm];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_headerSearchBar setColor:-1];
}

- (void)viewDidLoad {
    _sort = 0;
    _bFirstLoad = YES;
    self.url = ORDER_URL;
    [super viewDidLoad];
    [self initView];
    [self registerJavaScriptMethod];
}

-(void) initView{
    _category = [[LOCALMANAGER getProductCategories] retain];
    _checkCategory = [[NSMutableArray alloc] init];
    _searchViews = [[NSMutableArray alloc] init];
    
    [self.floatButton removeFromSuperview];
    //筛选视图
    CGRect r = CGRectMake(0,90 , MAINWIDTH, MAINHEIGHT - 90);
    //部门视图
    DepartmentViewController* categoryVC = [[DepartmentViewController alloc] init];
    categoryVC.delegate = self;
    categoryVC.departmentArray = _category;
    categoryVC.view.frame = r;
    [self addChildViewController:categoryVC];
    [categoryVC release];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    
    //查询筛选
    pfvc = [[ProductFilterViewController alloc] initWithFrame:r];
    pfvc.search = ^(NSDictionary *dic){
        NSString *title = nil;
        _name = dic[@"name"];
        _code = dic[@"code"];
        _startPrice = dic[@"start"];
        _endPrice = dic[@"end"];
        _specIds = dic[@"tags"];
        _tagName = dic[@"tagName"];
        if (_name.length > 0) {
            title = _name;
        }else if (_code.length > 0){
            title = _code;
        }else if (_startPrice.length > 0){
            title = [NSString stringWithFormat:@"%@-%@",_startPrice,_endPrice];
        }else if (_tagName.length > 0){
            title = _tagName;
        }else{
            title = _headerSearchBar.titles[2];
        }
        [self setSearchHeaderTitle:2 title:title];
        [self search];
        [_headerSearchBar setColor:2];
        [UIView removeViewFormSubViews:-1 views:_searchViews];
    };
    [self addChildViewController:pfvc];
    UIView *v = [self.childViewControllers objectAtIndex:1].view;
    [_searchViews addObject:v];
    [pfvc release];
    _headerTitles = @[@"类型",@"价格",@"筛选"];
    _headerIcons = @[[NSString fontAwesomeIconStringForEnum:ICON_TYPELIST],
                     [NSString fontAwesomeIconStringForEnum:ICON_ARROW],
                     [NSString fontAwesomeIconStringForEnum:ICON_FILTER]];
    
    _customerCell = (SelectCell *)[[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:nil options:nil].firstObject;
    _customerCell.backgroundColor = WT_WHITE;
    _customerCell.title.text = NSLocalizedString(@"customer_label_name0", nil);
    _customerCell.value.text = @"请选择客户";
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(selectCust)];
    gesture.numberOfTapsRequired = 1;
    [_customerCell addGestureRecognizer:gesture];
    [self.view addSubview:_customerCell];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, MAINWIDTH, 1)];
    line.backgroundColor = WT_LIGHT_GRAY;
    [self.view addSubview:line];
    [line release];
    
    _headerSearchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 45, MAINWIDTH, 45)];
    _headerSearchBar.backgroundColor = WT_WHITE;
    _headerSearchBar.delegate = self;
    _headerSearchBar.titles = _headerTitles;
    _headerSearchBar.icontitles = _headerIcons;
    [self.view addSubview:_headerSearchBar];
    
    UIView *rightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_search"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
   
    [listImageView addGestureRecognizer:tapGesture1];
    [rightV addSubview:listImageView];
    
    UIImageView *shopping = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [shopping setImage:[UIImage imageNamed:@"ab_icon_shopcart"]];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoCart)];
    [tapGesture2 setNumberOfTapsRequired:1];
    shopping.userInteractionEnabled = YES;
     [shopping addGestureRecognizer:tapGesture2];
    [rightV addSubview:shopping];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightV];
    self.rightButton = rightBtn;
    [rightBtn release];
    [shopping release];
    [listImageView release];
    [rightV release];
    
    
    [self.lblFunctionName setText:TITLENAME_REPORT(FUNC_SELL_ORDER_DES)];
    //重置webview 大小
    self.webView.frame = CGRectMake(0, 90, MAINWIDTH,MAINHEIGHT - 90);
    [self loadURL:self.url];
}

-(void)syncTitle {
 [self.lblFunctionName setText:TITLENAME_REPORT(FUNC_SELL_ORDER_DES)];
}

#pragma -mark -- 私有方法
-(void) search{
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [self callJavascript:[NSString stringWithFormat:@"searchProduct(%@)",[self getParams]]];
}

-(NSString *) getParams{
    ProductJavaScriptParams *param = [[[ProductJavaScriptParams alloc] init] autorelease];
    param.name = _name;
    param.categoryIds = @"";
    param.code = _code;
    param.priceSort = NS_SORT(_sort);
    param.minPrice = _startPrice;
    param.maxPrice = _endPrice;
    param.specificationIds = _specIds;//[{"1","1,2,3"},{"2","1,2,3"}]
    if (_checkCategory.count > 0) {
        NSMutableString *ids = [[NSMutableString alloc] init];
        for (ProductCategory *item in _checkCategory) {
            [ids appendFormat:@"%d,",item.id];
        }
        param.categoryIds = [ids substringToIndex:ids.length - 1];
    }
    return [param mj_JSONString];
}

-(void) toList{
    NewOrderListViewController *listVC = [[NewOrderListViewController alloc] init];
    listVC.bNeedBack = YES;
    listVC.url = ORDER_LIST_URL;
    [self.navigationController pushViewController:listVC animated:YES];
    [listVC release];
}


-(void) selectCust{
    CustomerSelectViewController *custVC = [[CustomerSelectViewController alloc] init];
    custVC.bNeedBack = YES;
    custVC.delegate = self;
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:custVC];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

#pragma -mark -- HeaderSearchBarDelegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    if (self.customer == nil) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", nil)
                          description:NSLocalizedString(@"patrol_hint_customer_select", nil)
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        [_headerSearchBar setColor:index];
        return;
    }
    if (current == index && index != 1) {
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        return;
    }
    switch (index) {
        case 1:
        {
            _sort = _sort == 0 ? 1 : 0;
            if (_sort == 0) {
                [self setSearchHeaderTitle:1 title:NSLocalizedString(@"sort_asc", nil)];
            }else{
                [self setSearchHeaderTitle:1 title:NSLocalizedString(@"sort_dsc", nil)];
            }
            [self search];
        }
            break;
        case 0:
        {
            [UIView addSubViewToSuperView:self.view subView:_searchViews[index]];
            [UIView removeViewFormSubViews:index views:_searchViews];
        }
            break;
        case 2:
        {
            [UIView addSubViewToSuperView:self.view subView:_searchViews[1]];
            [UIView removeViewFormSubViews:1 views:_searchViews];
        }
            break;
        default:
            break;
    }
}

#pragma -mark -- UIWebviewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    if (_bFirstLoad) {
        _bFirstLoad = NO;
        if (self.customer != nil) {
            [self selectCustomer:self.customer];
        }
    }
}


#pragma -mark -- DepartmentViewControllerDelegate

-(void)didFnishedCheck:(NSMutableArray *)departments{
    _checkCategory = [departments retain];
    [self search];
    if (_checkCategory.count == 0) {
        [self setSearchHeaderTitle:0 title:_headerSearchBar.titles[0]];
    }else{
        NSMutableString *title = [[[NSMutableString alloc] init] autorelease];
        for (ProductCategory *item in _checkCategory) {
            [title appendFormat:@"%@,",item.name];
        }
        [self setSearchHeaderTitle:0 title:[title substringToIndex:title.length - 1]];
    }
    [_headerSearchBar setColor:0];
}


-(void) setSearchHeaderTitle:(int) index title:(NSString *) title{
    UIButton *btn = _headerSearchBar.buttons[index];
    [btn setTitle:title forState:UIControlStateNormal];
}
#pragma -mark -- 公开JS调用方法
-(void) registerJavaScriptMethod{
    
    //选择客户
    [self.js registerHandler:@"getCustomer" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self selectCust];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark -- CALL JavaScript

//购物车
-(void) gotoCart{
    [self callJavascript:@"gotoCart()"];
}


#pragma -mark -
//选择客户回CALL
-(void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject{
    [self initData];
    self.customer = [(Customer *)aObject retain];
    [self selectCustomer:self.customer];
}
-(void)favCustomerDelegate:(UIViewController *)controller didSelectWithObject:(id)aObject{
    [self initData];
    self.customer = [(Customer *)aObject retain];
    _customerCell.value.text = self.customer.name;
    [self selectCustomer:self.customer];
}
-(void) selectCustomer:(Customer *) c{
    
    _customerCell.value.text = c.name;
    [self callJavascript:[NSString stringWithFormat:@"setCustomer('%@',%d)",c.name,c.id]];
}

-(void)dealloc{
    [departmentVC release];
    [super dealloc];
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
