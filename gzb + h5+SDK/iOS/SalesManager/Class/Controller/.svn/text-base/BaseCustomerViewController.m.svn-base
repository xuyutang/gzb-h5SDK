//
//  BaseCustomerViewController.m
//  SalesManager
//
//  Created by Administrator on 16/3/16.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "BaseCustomerViewController.h"
#import "CustomerListCell.h"
#import "LocationCell.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "City.h"
#import "CustomerFunctionCell.h"
#import "HeaderSearchView.h"
#import "DropMenu.h"
#import "CustomerInputView.h"
#import "NewCustomerViewController.h"
#import "Product.h"
#import "UIView+Util.h"
#import "HeaderSearchBar.h"
@interface BaseCustomerViewController ()<UITextFieldDelegate,PullTableViewDelegate,DropMenuDelegate,HeaderSearchViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,HeaderSearchBarDelegate,UISearchBarDelegate,UITextFieldDelegate>{
    UIView *rightView;
    
    NSMutableArray *customerCategories;
    NSMutableArray *categories;
    NSMutableArray *distances;
    
    UITextField *inputTextField;
    UIView *dropInputView;
    DropMenu *dropMenu1;
    DropMenu *dropMenu3;
    DropMenu *dropMenu4;
    int currentMenuIndex;
    UITextField *searchField;
    
    HeaderSearchView *searchView;
    
    NSArray *provinces, *cities, *areas;
    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;
    NSMutableArray *areaArray;
    CustomerParams *customerParams;
    int currentPage;
    int pageSize;
    int totleSize;
    
    //处理点击展开功能
    BOOL bHasExpand;
    int functionCellIndex;
    NSIndexPath *oldIndexPath;
    
    //展开后的功能
    NSMutableArray* functions;
    
    HeaderSearchBar *_headerSearchBar;
    NSMutableArray *_searchViews;
    BOOL    _bFilter;
}

@end

@implementation BaseCustomerViewController
@synthesize user;
@synthesize tableView;
@synthesize customerArray;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_headerSearchBar setColor:-1];
}

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [super viewDidLoad];
    _bFilter = YES;     //是否需要展示筛选功能
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload)
                                                 name:SYNC_NOTIFICATION_MENU object:nil];
}

-(void)reload{
    customerCategories = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getCustomerCategories]];
    functions = [LOCALMANAGER getFunctions];
    [categories removeAllObjects];
    [categories addObject:@"全部类型"];
    for (CustomerCategory *category in customerCategories) {
        [categories addObject:category.name];
    }
    [tableView reloadData];
}

-(void)initUI{
    self.view .backgroundColor = WT_WHITE;
    _searchViews = [[NSMutableArray alloc] init];
    [self.leftView setHidden:NO];
    leftImageView.hidden = YES;
    
    
   // self.navigationController.navigationBar.clipsToBounds = NO;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 1)];
    label.backgroundColor = WT_RED;
    [self.view addSubview:label];

    self.view.userInteractionEnabled = YES;
    [self initRightAddButton];
    [self loadCityData];
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadCityData) object:nil];
//    [thread start];
    
    
    customerArray = [[NSMutableArray alloc] init];
    categories = [[NSMutableArray alloc] init];
    
    distances = [[NSMutableArray alloc] initWithArray:[NSMutableArray arrayWithObjects:@"不限距离", @"1千米", @"3千米", @"5千米", @"10千米",nil]];
    
    dropInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, MAINWIDTH, 50)];
    
    //搜索部分
//    UISearchBar *filterBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 1, MAINWIDTH, 44)];
//    if (IOS7) {
//        filterBar.barTintColor = RGBA(240,240,240,1.0);
//    }
//    filterBar.placeholder = @"客户名称查询";
//    filterBar.backgroundColor = WT_RED;
//    filterBar.delegate = self;
   // [self.view addSubview:filterBar];
    
    //自定义搜索栏
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, MAINWIDTH - 20 , 30)];
      view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    [self.view addSubview:view];
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, MAINWIDTH -30, 30)];
    searchField.placeholder = @"客户名称查询";
    searchField.font = [UIFont systemFontOfSize:14];
    [view addSubview:searchField];
    
    UIButton *seachButton = [[UIButton alloc]initWithFrame:CGRectMake(MAINWIDTH - 50, 3, 25, 25)];
    [seachButton setImage:[UIImage imageNamed:@"searchbar_textfield_search_icon.png"] forState:UIControlStateNormal];
    [seachButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:seachButton];

    UILabel *grayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, MAINWIDTH, 1)];
    grayLabel.backgroundColor = WT_GRAY;
    [self.view addSubview:grayLabel];
    
    _headerSearchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0, 45, MAINWIDTH, 45)];
    [self refreshSearchBar];
    _headerSearchBar.delegate = self;
    [self.view addSubview:_headerSearchBar];
    
    //标签视图
    CustTagSelectViewController* tagSelectVC = [[CustTagSelectViewController alloc] init];
    tagSelectVC.view.frame = CGRectMake(0, 90, MAINWIDTH, MAINHEIGHT - 140);
    tagSelectVC.bNeedBack = YES;
    tagSelectVC.delegate = self;
    tagSelectVC.bView = YES;
    [self addChildViewController:tagSelectVC];
    [_searchViews addObject:self.childViewControllers.firstObject.view];
    [tagSelectVC release];
    
    
    tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 90, MAINWIDTH, MAINHEIGHT-140) style:UITableViewStylePlain];
    tableView.pullBackgroundColor = [UIColor yellowColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.pullDelegate = self;
    tableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    [self.view addSubview:tableView];
    
    currentPage = 1;
    
    NSLog(@"%@999999",user);
    if (user != nil) {
        CustomerParams_Builder* cpbv1 = [CustomerParams builder];
        [cpbv1 setUser:user];
        if (APPDELEGATE.myLocation != nil) {
            [cpbv1 setLocation:APPDELEGATE.myLocation];
        }
        [cpbv1 setPage:currentPage];
        customerParams = [[cpbv1 build] retain];
    }
    
    bHasExpand = NO;
    oldIndexPath = nil;
    functionCellIndex = -1;
    
    lblFunctionName.text = APPTITLE;
    lblFunctionName.textAlignment = NSTextAlignmentCenter;
    [self reload];
    [self refreshTable];
}

-(void) initRightAddButton{
    UIView *rightBtnView = [[UIView alloc] initWithFrame:CGRectMake(3, 15,70, 30)];
    UIImageView *freshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(36, 0, 25, 25)];
    [freshImageView setImage:[UIImage imageNamed:@"ab_icon_add"]];
    freshImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCustomer:forEvent:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    freshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [freshImageView addGestureRecognizer:tapGesture2];
    [rightBtnView addSubview:freshImageView];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightBtnView];
    [freshImageView release];
    [rightBtnView release];
    self.rightButton = btRight;
    [btRight release];
}


//及时更新搜索栏功能
-(void) refreshSearchBar{
    NSArray *titles = @[@"类型",@"距离",@"地区"];
    NSArray *icons = @[[NSString fontAwesomeIconStringForEnum:ICON_TAB_CATEGORY],
                       [NSString fontAwesomeIconStringForEnum:ICON_TAB_DISTANCE],
                       [NSString fontAwesomeIconStringForEnum:ICON_TAB_CITY]];
    if (_bFilter) {
        NSMutableArray *tmpIcon = [NSMutableArray arrayWithArray:icons];
        [tmpIcon insertObject:[NSString fontAwesomeIconStringForEnum:ICON_FILTER] atIndex:1];
        _headerSearchBar.icontitles = tmpIcon;
        NSMutableArray *tmpTitle = [NSMutableArray arrayWithArray:titles];
        [tmpTitle insertObject:@"标签" atIndex:1];
        
        titles = tmpTitle;
        icons = tmpIcon;
    }
    _headerSearchBar.titles = titles;
    _headerSearchBar.icontitles = icons;
    _headerSearchBar.backgroundColor = [UIColor whiteColor];
}

#pragma -mark -- HeaderSearchBarDelegate
-(void)HeaderSearchBarClickBtn:(int)index current:(int)current{
    currentMenuIndex = current;
    [self clickButtunIndex:index];
}

-(void)clickAction {
  [self searchCustom];

}
//#pragma -mark -- UISearchBarDelegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    CustomerParams_Builder *pb = [customerParams toBuilder];
//    Customer_Builder *cb = [Customer builder];
//    [cb setId:-1];
//    if (searchBar.text.trim.length > 0) {
//        [cb setName:searchBar.text.trim];
//        [pb setCustomer:[cb build]];
//    }else{
//        [pb clearCustomer];
//    }
//    customerParams = [[pb build] retain];
//    [searchBar resignFirstResponder];
//    [self refreshTable];
//}
//始终保留一个空格 让搜索按钮可用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        searchBar.text = @" ";
    }
}
#pragma -mark
-(void)addCustomer:(id)sender forEvent:(UIEvent *)event{
    NewCustomerViewController *vctrl = [[NewCustomerViewController alloc] initWithNibName:@"NewCustomerViewController" bundle:nil];
    vctrl.bNeedBack = YES;
    vctrl.delegate = self;
    if (self.parentController != nil) {
        [self.parentController.navigationController pushViewController:vctrl animated:YES];
    }else{
        [self.navigationController pushViewController:vctrl animated:YES];
    }
}

-(void)clickButtunIndex:(int)index{
    if (currentMenuIndex == index) {
        
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        [dropMenu1 removeFromSuperview];
        [dropMenu1 release];
        dropMenu1 = nil;
        [dropMenu3 removeFromSuperview];
        [dropMenu4 removeFromSuperview];
        [dropInputView removeFromSuperview];
        currentMenuIndex = -1;
        //        [self changeDropMenuColorWithIndex:index];
        
        return;
    }
    currentMenuIndex = index;
    
    if (index == 0) {
        if (dropMenu1 == nil) {
            dropMenu1 = [[DropMenu alloc] initWithFrame:CGRectMake(0, 90, MAINWIDTH, tableView.frame.size.height)];
            dropMenu1.delegate = self;
            dropMenu1.menuCount = 1;
            dropMenu1.array1 = [[NSMutableArray alloc] initWithArray:categories];
            [dropMenu1 initMenu];
        }
        if (_searchViews[0] != nil) {
            [_searchViews[0] removeFromSuperview];
        }

        if (dropMenu3 != nil) {
            [dropMenu3 removeFromSuperview];
        }
        if (dropMenu4 != nil) {
            [dropMenu4 removeFromSuperview];
        }
        if (dropInputView != nil) {
            [dropInputView removeFromSuperview];
        }
        [self.view addSubview:dropMenu1];
        
    }else if (index == 2) {
        
        //[self.view addSubview:dropInputView];
        
        if (dropMenu3 == nil) {
            dropMenu3 = [[DropMenu alloc] initWithFrame:CGRectMake(0, 90, MAINWIDTH, tableView.frame.size.height)];
            dropMenu3.delegate = self;
            dropMenu3.menuCount = 1;
            dropMenu3.array1 = [[NSMutableArray alloc] initWithArray:distances];
            [dropMenu3 initMenu];
        }
        if (dropMenu1 != nil) {
            [dropMenu1 removeFromSuperview];
            [dropMenu1 release];
            dropMenu1 = nil;
        }
        if (dropMenu4 != nil) {
            [dropMenu4 removeFromSuperview];
        }
        if (_searchViews[0] != nil) {
            [_searchViews[0] removeFromSuperview];
        }

        if (dropInputView != nil) {
            [dropInputView removeFromSuperview];
        }
        [self.view addSubview:dropMenu3];
        
    }else if (index == 3) {
        if (dropMenu4 == nil) {
            dropMenu4 = [[DropMenu alloc] initWithFrame:CGRectMake(0, 90, MAINWIDTH, tableView.frame.size.height)];
            dropMenu4.delegate = self;
            dropMenu4.menuCount = 3;
            
            dropMenu4.array1 = [[NSMutableArray alloc] init];
            [dropMenu4.array1 addObject:@"全部"];
            for (NSDictionary *p in provinces) {
                [dropMenu4.array1 addObject:[p objectForKey:@"province"]];
            }
            
            dropMenu4.array2 = [[NSMutableArray alloc] init];
            dropMenu4.array3 = [[NSMutableArray alloc] init];
            [dropMenu4 initMenu];
        }
        if (_searchViews[0] != nil) {
            [_searchViews[0] removeFromSuperview];
        }

        if (dropMenu3 != nil) {
            [dropMenu3 removeFromSuperview];
        }
        if (dropMenu1 != nil) {
            [dropMenu1 removeFromSuperview];
            [dropMenu1 release];
            dropMenu1 = nil;
        }
        if (dropInputView != nil) {
            [dropInputView removeFromSuperview];
        }
        [self.view addSubview:dropMenu4];
    }else if (index == 1){
        if (dropMenu1 != nil) {
            [dropMenu1 removeFromSuperview];
        }
        if (dropMenu3 != nil) {
            [dropMenu3 removeFromSuperview];
        }

        if (dropMenu4 != nil) {
            [dropMenu4 removeFromSuperview];
        }

        [UIView addSubViewToSuperView:self.view subView:_searchViews[0]];
    }
}

-(void) setSearchHeaderTitle:(int) index title:(NSString *) title{
    UIButton *btn = _headerSearchBar.buttons[index];
    [btn setTitle:title forState:UIControlStateNormal];
}

-(void)selectedDropMenuIndex:(int)index row:(int)row{
    
    if (dropMenu1 != nil) {
        [dropMenu1 removeFromSuperview];
    }
    if (dropMenu3 != nil) {
        [dropMenu3 removeFromSuperview];
    }
    
    if (currentMenuIndex == 0) {
        NSString *title = [dropMenu1.array1 objectAtIndex:row];
        [searchView.bt1 setTitle:title forState:UIControlStateNormal];
        
        if (row != 0) {
            CustomerParams_Builder* cpb = [customerParams toBuilder];
            [cpb setCategory:[customerCategories objectAtIndex:row-1]];
            customerParams = [[cpb build] retain];
        }else{
            CustomerParams_Builder* cpb = [customerParams toBuilder];
            [cpb clearCategory];
            customerParams = [[cpb build] retain];
        }
        [self refreshTable];
        currentMenuIndex = 0;
        [self setSearchHeaderTitle:0 title:title ];
    }
    
    if (currentMenuIndex == 2) {
        NSString *title = [dropMenu3.array1 objectAtIndex:row];
        [searchView.bt3 setTitle:title forState:UIControlStateNormal];
        
        if (row == 0) {
            CustomerParams_Builder* cpb = [customerParams toBuilder];
            
            [cpb clearLocation];
            customerParams = [[cpb build] retain];
        }else{
            CustomerParams_Builder* cpb = [customerParams toBuilder];
            
            Location_Builder *lb = [cpb.location builder];
            
            if (row == 1) {
                [lb setDistance:@"1000"];
            }else if (row == 2){
                [lb setDistance:@"3000"];
            }else if (row == 3){
                [lb setDistance:@"5000"];
            }else if (row == 4){
                [lb setDistance:@"10000"];
            }
            
            if (lb.latitude == 0) {
                [lb setLatitude:0.00f];
                [lb setLongitude:0.00f];
            }
            
            [cpb setLocation:[lb build]];
            customerParams = [[cpb build] retain];
        }
        [self refreshTable];
        currentMenuIndex = 0;
        [self setSearchHeaderTitle:2 title:title];
    }
    
    if (currentMenuIndex == 3) {
        NSString *lableTitle = nil;
        CustomerParams_Builder* cpb = [customerParams toBuilder];
        Location_Builder *lb = [cpb.location builder];
        
        if (row == 0) {
            [dropMenu4 removeFromSuperview];
            
            
            if (index == 1){
                NSString *title = _headerSearchBar.titles[3];
                [dropMenu4.array2 removeAllObjects];
                [dropMenu4.array3 removeAllObjects];
                [dropMenu4.tableView2 reloadData];
                [dropMenu4.tableView3 reloadData];
                [searchView.bt4 setTitle:@"全部" forState:UIControlStateNormal];
                lableTitle = title;
                [lb clearDistrict];
                [lb clearProvince];
                [lb clearCity];
                
                if (lb.latitude == 0) {
                    [lb setLatitude:0.00f];
                    [lb setLongitude:0.00f];
                }
                [cpb setLocation:[lb build]];
                customerParams = [[cpb build] retain];
                [self refreshTable];
                currentMenuIndex = 0;
                
            }else if (index == 2) {
                NSString *title = [dropMenu4.array1 objectAtIndex:dropMenu4.selectedIndex1];
                [dropMenu4.array3 removeAllObjects];
                [dropMenu4.tableView3 reloadData];
                [searchView.bt4 setTitle:title forState:UIControlStateNormal];
                lableTitle = title;
                [lb setProvinceCode:[[[provinces objectAtIndex:dropMenu4.selectedIndex1-1] objectForKey:@"provinceId"] substringToIndex:5]];
                if (lb.latitude == 0) {
                    [lb setLatitude:0.00f];
                    [lb setLongitude:0.00f];
                }
                [cpb setLocation:[lb build]];
                customerParams = [[cpb build] retain];
                [self refreshTable];
                currentMenuIndex = 0;
            }else if (index == 3){
                NSString  *title = [dropMenu4.array2 objectAtIndex:dropMenu4.selectedIndex2];
                [searchView.bt4 setTitle:title forState:UIControlStateNormal];
                lableTitle =  title;
                
                //                [lb setCityCode:[[areas objectAtIndex:dropMenu4.selectedIndex3-1] objectForKey:@"cityId"]];
                [lb setCityCode:[NSString stringWithFormat:@"%d",((Area *)[areas objectAtIndex:0]).id]];
                
                if (lb.latitude == 0) {
                    [lb setLatitude:0.00f];
                    [lb setLongitude:0.00f];
                }
                
                [cpb setLocation:[lb build]];
                customerParams = [[cpb build] retain];
                [self refreshTable];
                currentMenuIndex = 0;
            }
        }else if (index == 1) {
            cities = [[provinces objectAtIndex:row-1] objectForKey:@"cities"];
            [dropMenu4.array2 removeAllObjects];
            [dropMenu4.array2 addObject:@"全部"];
            for (NSDictionary *c in cities) {
                [dropMenu4.array2 addObject:[c objectForKey:@"city"]];
            }
            if (cities.count > 0)
                areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            [dropMenu4.array3 removeAllObjects];
            [dropMenu4.tableView2 reloadData];
            [dropMenu4.tableView3 reloadData];
            lableTitle = [[provinces objectAtIndex:dropMenu4.selectedIndex1-1] objectForKey:@"province"];
        }else if (index == 2){
            areas = [[cities objectAtIndex:row-1] objectForKey:@"areas"];
            [dropMenu4.array3 removeAllObjects];
            [dropMenu4.array3 addObject:@"全部"];
            for (Area *a in areas) {
                [dropMenu4.array3 addObject:a.name];
            }
            [dropMenu4.tableView3 reloadData];
            lableTitle =  [[cities objectAtIndex:dropMenu4.selectedIndex2-1] objectForKey:@"city"];
        }else if (index == 3) {
            [dropMenu4 removeFromSuperview];
            NSString *title = [dropMenu4.array3 objectAtIndex:dropMenu4.selectedIndex3];
            [searchView.bt4 setTitle:title forState:UIControlStateNormal];
            lableTitle = ((Area *)[areas objectAtIndex:dropMenu4.selectedIndex3-1]).name;
            [lb setDistrictCode:[NSString stringWithFormat:@"%d",((Area *)[areas objectAtIndex:dropMenu4.selectedIndex3-1]).id]];
            if (lb.latitude == 0) {
                [lb setLatitude:0.00f];
                [lb setLongitude:0.00f];
            }
            [cpb setLocation:[lb build]];
            customerParams = [[cpb build] retain];
            [self refreshTable];
            currentMenuIndex = 0;
        }
        [self setSearchHeaderTitle:3 title:lableTitle];
    }
    
}


#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    [_headerSearchBar setColor:-1];
    //[tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    tableView.pullLastRefreshDate = [NSDate date];
    tableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    if (customerParams != nil){
        CustomerParams_Builder* cpb = [customerParams toBuilder];
        [cpb setPage:1];
        if (APPDELEGATE.myLocation != nil) {
            Location_Builder* lb = [customerParams.location toBuilder];
            
            [lb setLongitude:APPDELEGATE.myLocation.longitude];
            [lb setLatitude:APPDELEGATE.myLocation.latitude];
            [cpb setLocation:[lb build]];
        }
        if (_selectTags.count > 0) {
            [cpb setTagValuesArray:_selectTags];
        }else{
            [cpb clearTagValues];
        }
        customerParams = [[cpb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeCustomerList param:customerParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            tableView.pullTableIsRefreshing = NO;
            tableView.pullTableIsLoadingMore = NO;
        }
        
    }
}


#pragma mark - Refresh and load more methods

- (void) searchCustom
{
    
    [_headerSearchBar setColor:-1];
    //[tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    tableView.pullLastRefreshDate = [NSDate date];
    tableView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    if (customerParams != nil){
        CustomerParams_Builder* cpb = [customerParams toBuilder];
        [cpb setPage:1];
        if (APPDELEGATE.myLocation != nil) {
            Location_Builder* lb = [customerParams.location toBuilder];
            
            [lb setLongitude:APPDELEGATE.myLocation.longitude];
            [lb setLatitude:APPDELEGATE.myLocation.latitude];
            [cpb setLocation:[lb build]];
        }
        if (_selectTags.count > 0) {
            [cpb setTagValuesArray:_selectTags];
        }else{
            [cpb clearTagValues];
        }
       // customerParams = [[cpb build] retain];
        
        CustomerParams_Builder *pb = [customerParams toBuilder];
        Customer_Builder *cb = [Customer builder];
        [cb setId:-1];
        if (searchField.text.trim.length > 0) {
            [cb setName:searchField.text.trim];
            [pb setCustomer:[cb build]];
        }else{
            [pb clearCustomer];
        }
        customerParams = [[pb build] retain];
        [searchField resignFirstResponder];

        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeCustomerList param:customerParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            tableView.pullTableIsRefreshing = NO;
            tableView.pullTableIsLoadingMore = NO;
        }
        
    }
}

- (void) loadMoreDataToTable
{
    tableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        CustomerParams_Builder* cpb = [customerParams toBuilder];
        [cpb setPage:currentPage];
        if (APPDELEGATE.myLocation != nil) {
            Location_Builder* lb = [customerParams.location toBuilder];
            
            [lb setLongitude:APPDELEGATE.myLocation.longitude];
            [lb setLatitude:APPDELEGATE.myLocation.latitude];
            [cpb setLocation:[lb build]];
        }
        customerParams = [[cpb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeCustomerList param:customerParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            tableView.pullTableIsRefreshing = NO;
            tableView.pullTableIsLoadingMore = NO;
        }
        
    }else{
        tableView.pullTableIsLoadingMore = NO;
    }
}

#pragma -mark selectTagDelegate
-(void)custTagSelecDidFnishedCheck:(NSMutableArray *)array{
    _selectTags = [array retain];
    [_headerSearchBar setColor:-1];
    CustomerTagValue *tag = array.count > 0 ? array[0] : nil;
    NSString *title = tag == nil ? @"标签" : tag.name;
    [self setSearchHeaderTitle:1 title:title];
    [self refreshTable];
    [UIView removeViewFormSubViews:-1 views:_searchViews];
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}

- (void) didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        tableView.pullTableIsRefreshing = NO;
        tableView.pullTableIsLoadingMore = NO;
        return;
    }
    switch ((INT_ACTIONTYPE(cr.type))) {
        case ActionTypeCustomerList:
        {
            if ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)]) {
                PageCustomer* pageCustomer = [PageCustomer parseFromData:cr.data];
                if ([super validateData:pageCustomer]) {
                    int customerCount = pageCustomer.customers.count;
                    if (currentPage == 1)
                        [customerArray removeAllObjects];
                    
                    for (int i = 0 ;i < customerCount;i++){
                        Customer* c = (Customer*)[[pageCustomer customers] objectAtIndex:i];
                        [customerArray addObject:c];
                        
                    }
                    pageSize = pageCustomer.page.pageSize;
                    totleSize = pageCustomer.page.totalSize;
                    
                    if (customerArray.count == 0) {
                        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                                          description:NSLocalizedString(@"noresult", @"")
                                                 type:MessageBarMessageTypeInfo
                                          forDuration:INFO_MSG_DURATION];
                        
                    }
                    [tableView reloadData];
                    bHasExpand = NO;
                    oldIndexPath = nil;
                    functionCellIndex = -1;
                }
            }
        }
            break;
        default:
            break;
    }
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
}


- (void) didFailWithError:(NSError *)error{
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    
    [super didFailWithError:error];
}

- (void) didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
    [super didCloseWithCode:code reason:reason wasClean:wasClean];
}


-(void)loadCityData{
    
    
    NSMutableArray* p = [LOCALMANAGER getProvinces];
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    provinceArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < p.count; i++) {
        Province *province = (Province*)[p objectAtIndex:i];
        NSMutableArray* c = [LOCALMANAGER getCities:province.name];
        NSMutableArray* cArray = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < c.count; j++) {
            City *city = (City *)[c objectAtIndex:j];
            NSMutableArray* a = [LOCALMANAGER getAreas:city.name];
            NSMutableDictionary *aDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:a,@"areas",city.name,@"city",[NSString stringWithFormat:@"%d",city.id],@"cityId", nil];
            [cArray addObject:aDict];
            
        }
        
        NSMutableDictionary *cDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:cArray,@"cities",province.name,@"province",[NSString stringWithFormat:@"%d",province.id],@"provinceId", nil];
        [pArray addObject:cDict];
        
        [provinceArray addObject:province.name];
    }
    NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:pArray,@"provinces", nil];
    
    
    provinces = [addressDict objectForKey:@"provinces"];
    cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
    areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
    
}


#pragma mark -tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return customerArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 50;
    }
    return 100.0f;
    
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            
        }
    }else if (indexPath.section == 1){
        Customer *c = [customerArray objectAtIndex:indexPath.row];
        [VIEWCONTROLLER create:self.parentController.navigationController ViewId:FUNC_CUSTOMER_DETAIL Object:c Delegate:nil NeedBack:YES];
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    // CustomerListCell.h
    if (indexPath.section == 0) {
        const NSString *CellIdentifier = @"LocationCell";
        LocationCell *locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(locationCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[LocationCell class]])
                    locationCell=(LocationCell *)oneObject;
            }
        }
        if (APPDELEGATE.myLocation != nil) {
            if (!APPDELEGATE.myLocation.address.isEmpty) {
                [locationCell.lblAddress setText:APPDELEGATE.myLocation.address];
            }else{
                [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude]];
            }
        }
        [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
        
        cell = locationCell;
    }else if(indexPath.section == 1){
        
        Customer *c = [customerArray objectAtIndex:indexPath.row];
        
        if (c.id == -1) {
            const NSString *CellIdentifier = @"CustomerFunctionCell";
            CustomerFunctionCell *functionCell=(CustomerFunctionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(functionCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomerFunctionCell" owner:self options:nil];
                functionCell = [nib objectAtIndex:0];
            }
            functionCell.vctrl = self.parentController;
            functionCell.customer = [customerArray objectAtIndex:indexPath.row - 1];
            cell = functionCell;
        }else{
            
            const NSString *CellIdentifier = @"CustomerListCell";
            CustomerListCell *customerCell=(CustomerListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if(customerCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomerListCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[CustomerListCell class]])
                        customerCell=(CustomerListCell *)oneObject;
                }
            }
            customerCell.distance.text = [NSString stringWithFormat:@"%@",c.location.distance];
            customerCell.type.text = [NSString stringWithFormat:@"%@",c.category.name];
            
            customerCell.locate.text = [NSString fontAwesomeIconStringForEnum:ICON_LOCATION_ARROW];
            customerCell.locate.font = [UIFont fontWithName:kFontAwesomeFamilyName size:17];
            customerCell.locate.textColor = WT_KHAKI;
            
            customerCell.btLocate.backgroundColor = WT_CLEARCOLOR;
            customerCell.btLocate.tag = indexPath.row;
            [customerCell.btLocate addTarget:self action:@selector(loadBaidu:) forControlEvents:UIControlEventTouchUpInside];
            if (c.location.latitude > 0) {
                customerCell.locate.hidden = YES;
                customerCell.btLocate.hidden = NO;
                
                if (!_bHideFuncBtn) {
                    CGRect rectl = customerCell.locate.frame;
                    UILabel *lLocate = [[UILabel alloc] initWithFrame:CGRectMake(rectl.origin.x - 5, rectl.origin.y + 5, rectl.size.width, rectl.size.height)];
                    lLocate.text = [NSString fontAwesomeIconStringForEnum:ICON_LOCATION_ARROW];
                    lLocate.font = [UIFont fontWithName:kFontAwesomeFamilyName size:17];
                    lLocate.textColor = WT_KHAKI;
                    lLocate.backgroundColor = WT_CLEARCOLOR;
                    [customerCell addSubview:lLocate];
                    [lLocate release];
                    lLocate = nil;
                }
                
            }else{
                customerCell.locate.hidden = YES;
                customerCell.btLocate.hidden = YES;
            }
            NSString* cusName = (c.highLightName != nil && c.highLightName.length > 0) ? c.highLightName : c.name;
            float x = IOS7 ? 8 : 13;
            RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(x,8,160,40)];
            [label setText:cusName];
            [label setBackgroundColor:[UIColor clearColor]];
            label.lineSpacing = 20.0;
            [label setParagraphReplacement:@""];
            [customerCell addSubview:label];
            [label release];
            label = nil;
            
            customerCell.tel.text = NSLocalizedString(@"nocontact", "");
            if (c.contacts.count >0) {
                Contact *contact = [c.contacts objectAtIndex:0];
                if (contact.phone.count >0) {
                    NSString* constactName = contact.name;
                    NSString *phone = [contact.phone objectAtIndex:0];
                    if (![constactName isEqualToString:@""] || ![phone isEqualToString:@""]) {
                        customerCell.tel.text = [NSString stringWithFormat:@"%@ %@",constactName,phone];
                    }
                }
            }
            customerCell.btPhone.hidden = YES;
            customerCell.icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:13];
            customerCell.icon.text = [NSString fontAwesomeIconStringForEnum:ICON_PHONE];
            
            customerCell.address.text = [NSString stringWithFormat:@"%@",c.location.address];
            
            if (!_bHideFuncBtn) {
                CGRect rect = customerCell.cloud.frame;
                UILabel *lClound = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x - 5, rect.origin.y + 5, rect.size.width, rect.size.height)];
                lClound.text = [NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD];
                lClound.font = [UIFont fontWithName:kFontAwesomeFamilyName size:17];
                lClound.textColor = WT_GREEN;
                lClound.backgroundColor = WT_CLEARCOLOR;
                [customerCell addSubview:lClound];
                [lClound release];
                lClound = nil;
            }
            
            customerCell.cloud.text = [NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD];
            customerCell.cloud.font = [UIFont fontWithName:kFontAwesomeFamilyName size:17];
            customerCell.cloud.hidden = YES;
            [customerCell.cloud removeFromSuperview];
            
            customerCell.btFunction.backgroundColor = WT_CLEARCOLOR;
            customerCell.btFunction.tag = indexPath.row;
            [customerCell.btFunction addTarget:self action:@selector(expandFunctionCell:) forControlEvents:UIControlEventTouchUpInside];
            
            customerCell.bHideFuncBtn = _bHideFuncBtn;
            cell = customerCell;
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)autorefreshLocation {
    [super refreshLocation];
    [tableView reloadData];
}

- (void)refreshLocation{
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [tableView reloadData];
    
    [hud hide:YES afterDelay:1.0];
}

-(void)loadBaidu:(id)sender{
    int index = [sender tag];
    Customer *c = [customerArray objectAtIndex:index];
    if (APPDELEGATE.myLocation == nil) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"gps_unavilable", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (c.location.latitude <= 0) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"gps_customer_unavilable", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
        NSString *urlString = [[NSString stringWithFormat:BAIDU_NAV,APPDELEGATE.myLocation.latitude, APPDELEGATE.myLocation.longitude,c.location.latitude,c.location.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        
    }else{
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"msg_cannot_find_baidu", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    [tableView reloadData];
}

-(void)expandFunctionCell:(id)sender{
    int index = [sender tag];
    int section = 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
    //NSLog(@"functionCellIndex ＝ %d indexPath.row = %d",functionCellIndex , indexPath.row);
    Customer *c = [customerArray objectAtIndex:indexPath.row];
    if (functionCellIndex == indexPath.row) {
        return;
    }
    c = [[[c toBuilder]setId:-1] build];
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
    
    if (!bHasExpand) {//如果没有展开的情况，则展开当前cell
        [customerArray insertObject:c atIndex:(indexPath.row+1)];
        functionCellIndex = indexPath.row+1;
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView endUpdates];
        oldIndexPath = [indexPath retain];
        bHasExpand=YES;
    }else if (oldIndexPath.row == indexPath.row){
        [customerArray removeObjectAtIndex:functionCellIndex];
        functionCellIndex = -1;
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView endUpdates];
        [oldIndexPath release];
        oldIndexPath = nil;
        
        bHasExpand = NO;
    }else if(oldIndexPath.row != indexPath.row){
        //收缩上一次展开cell
        //NSLog(@"old indexpath : %d",oldIndexPath.row);
        NSIndexPath *pathOld = [NSIndexPath indexPathForItem:(functionCellIndex) inSection:indexPath.section];
        [customerArray removeObjectAtIndex:functionCellIndex];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[pathOld]  withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView endUpdates];
        
        //展开本次的cell
        //NSLog(@"indexpath : %d",indexPath.row);
        if (oldIndexPath.row < indexPath.row) {
            [customerArray insertObject:c atIndex:(indexPath.row)];
            path = [NSIndexPath indexPathForItem:(indexPath.row) inSection:indexPath.section];
            functionCellIndex = indexPath.row;
        }else{
            [customerArray insertObject:c atIndex:(indexPath.row+1)];
            functionCellIndex = indexPath.row+1;
        }
        //NSIndexPath *path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
        
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [tableView endUpdates];
        oldIndexPath = [indexPath retain];
        
        bHasExpand=YES;
    }
    [tableView reloadData];
    if (bHasExpand && functionCellIndex == customerArray.count-1) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:functionCellIndex inSection:section];
        [tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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
