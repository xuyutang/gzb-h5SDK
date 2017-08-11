//
//  FavCustomerViewController.m
//  SalesManager
//
//  Created by Administrator on 16/3/29.
//  Copyright © 2016年 liu xueyan. All rights reserved.
//

#import "FavCustomerViewController.h"
#import "Constant.h"
#import "FavCustomerCell.h"
#import "SyncButton.h"
#import "DropMenu.h"
#import "PullTableView.h"

@interface FavCustomerViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DropMenuDelegate>
{
    UITableView *_tableView;
    UITableView *cataTabView;
    UISearchBar *_searchBar;
    
    NSMutableArray *_syncCustomer;
    NSMutableArray *categories;
    UITextField* searchField;
    //同步按钮
    SyncButton *_syncBtn;
    BOOL expandBool;
    DropMenu* dropMenu;
    
    UIButton *searchBtn;
    
    NSMutableArray *customerCategories;
    NSMutableArray * categoryMulArray;
    
    CustomerParams *customerParams;
    Customer *cus;
}

@end

@implementation FavCustomerViewController

@synthesize user;;

- (void)viewDidLoad {
    
    [super viewDidLoad];
       [self reload];
    [self initCustData];
    [self initView];
    expandBool = YES;
}

-(void)reload{
    categoryMulArray = [[NSMutableArray alloc] init];
    customerCategories = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getCustomerCategories]];
    categories = [[NSMutableArray alloc] init];
    [categories removeAllObjects];
    [categories addObject:@"全部"];
    for (CustomerCategory *category in customerCategories) {
        [categories addObject:category.name];
    }
    [_tableView reloadData];
}

-(void) initView{
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame =  CGRectMake(0, 0, MAINWIDTH/2, 44);
    [searchBtn setTitle:@"全部" forState:UIControlStateNormal];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    searchBtn.backgroundColor = WT_WHITE;
     [searchBtn setTitleColor:WT_BLACK forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINWIDTH /2 -30, 5, 30, 35)];
  //  iconImageView.backgroundColor = WT_BLUE;
    [iconImageView setImage:[UIImage imageNamed:@"abs__spinner_ab_default_holo_dark1.9"]];
    [searchBtn addSubview:iconImageView];
    [self.view addSubview:searchBtn];
    
   
//    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(MAINWIDTH /2, 0, MAINWIDTH/2, 44)];
//    _searchBar.backgroundColor = WT_WHITE;
//    _searchBar.text = @" ";
    
    //自定义搜索栏
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH /2, 0, MAINWIDTH/2 , 44)];
    view.backgroundColor = WT_WHITE;
  
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, MAINWIDTH/2 -40, 30)];
    searchField.placeholder = @"客户名称查询";
    searchField.font = [UIFont systemFontOfSize:14];
    [view addSubview:searchField];
    
    [view addSubview:[self setView]];
    
    UIButton *seachButton = [[UIButton alloc]initWithFrame:CGRectMake(MAINWIDTH/2 - 30, 15, 20, 20)];
    [seachButton setImage:[UIImage imageNamed:@"searchbar_textfield_search_icon.png"] forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [seachButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:seachButton];
    
    [self.view addSubview:view];
    
    
    if (IOS7) {
        _searchBar.barTintColor = WT_RED;
    }
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, MAINWIDTH, MAINHEIGHT - 44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //浮动同步按钮
    CGRect r = self.view.frame;
    _syncBtn = [[SyncButton alloc] initWithFrame:CGRectMake(r.size.width - 110, r.size.height - 100, 40, 40 )];
    _syncBtn.onClick = ^(SyncButton *sender){
        [self syncFavCustList];
    };
    [self.view addSubview:_syncBtn];
     user = [[LOCALMANAGER getLoginUser] retain];
    
    if (user != nil) {
        CustomerParams_Builder* cpbv1 = [CustomerParams builder];
        [cpbv1 setUser:user];
        if (APPDELEGATE.myLocation != nil) {
            [cpbv1 setLocation:APPDELEGATE.myLocation];
        }
       // [cpbv1 setPage:currentPage];
        customerParams = [[cpbv1 build] retain];
    }

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:CUSTOMER_NOTIFICATION object:nil];
}

-(void)searchAction {

if (searchField.text.length > 0) {
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (Customer* item in _customers) {
        NSLog(@"ssss%@",item.name);
        
        NSRange rangeName = [item.name rangeOfString:searchField.text];
        if (rangeName.location != NSNotFound) {
            [temp addObject:item];
        }
    }
    _customers = temp;
    
    }else{
        _customers = [[LOCALMANAGER getCustomers] retain];
    } 
    [self initDefauleFavCustomer];
    [_tableView reloadData];


}
-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, MAINWIDTH - 200, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, MAINWIDTH/2 - 50, 0.3)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH/2 - 50 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
}

-(void) refreshUI{
    _customers = [[LOCALMANAGER getFavCustomers] retain];
    [self initDefauleFavCustomer];
    [_tableView reloadData];
}


-(void)touchAction{
    expandBool = !expandBool;
    if (expandBool) {
        dropMenu = [[DropMenu alloc] initWithFrame:CGRectMake(0, 44, MAINWIDTH, _tableView.frame.size.height)];
        dropMenu.delegate = self;
        dropMenu.menuCount = 1;
        dropMenu.array1 = [[NSMutableArray alloc] initWithArray:categories ];
        [dropMenu initMenu];
        [self.view addSubview:dropMenu];
    } else {
      [dropMenu removeFromSuperview];
    
    }
   
}

-(void)selectedDropMenuIndex:(int)index row:(int)row {
    [categoryMulArray removeAllObjects];
       NSString *title = [dropMenu.array1 objectAtIndex:row];
    [searchBtn setTitle:title forState:UIControlStateNormal];
    
    if (row > 0) {
        _customers = [[LOCALMANAGER getFavCustomers] retain];
        
      for ( Customer *c  in _customers ){
           
         if ([c.category.name isEqualToString:[categories objectAtIndex:row]]) {
                  [categoryMulArray addObject:c];
           }
             _customers = categoryMulArray;
   }
        
    }else{
        
        _customers = [[LOCALMANAGER getFavCustomers] retain];
        
    }
   [self initDefauleFavCustomer];
    [_tableView reloadData];
    
  
        [dropMenu removeFromSuperview];

    }
    

#pragma -mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _customers.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Customer *c = _customers[indexPath.row];
    [LOCALMANAGER favCustomer:c Fav:0];
    [_customers removeObject:c];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tableView endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(favCustomerDelegate:didSelectWithObject:)]) {
        [_delegate favCustomerDelegate:self didSelectWithObject:_customers[indexPath.row]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self createCellWith:tableView indexPath:indexPath];
}

#pragma -mark --
-(void)didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeCustomerFavList:
        {
            if ([NS_ACTIONCODE(ActionCodeDone) isEqual:cr.code]) {
               tmpArr = [[NSMutableArray alloc] init];
                for (id item in cr.datas) {
                    [tmpArr addObject:[Customer parseFromData:item]];
                }
     BOOL ret = [LOCALMANAGER saveCustomers:[[[PBArray alloc] initWithArray:tmpArr valueType:PBArrayValueTypeObject] autorelease]];
                if (ret) {
                    [self reloadTableCell];

                    }
                          }
        }
            break;
        case ActionTypeCustomerFavDelete:
        {
            if ([NS_ACTIONCODE(ActionCodeDone) isEqual:cr.code]) {
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                                  description:NSLocalizedString(@"favorate_commit_done", @"")
                                         type:MessageBarMessageTypeSuccess
                                  forDuration:SUCCESS_MSG_DURATION];
                
                //取消本地库收藏
                for (Customer *item in _syncCustomer) {
                    [LOCALMANAGER favCustomer:item Fav:0];
                }
                [self reloadTableCell];
            }
        }
            break;
            
        default:
            break;
    }
    [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
}


-(void) reloadTableCell{
    //移除
    [_tableView beginUpdates];
    int count = _customers.count;
    [_customers removeAllObjects];
    NSMutableArray *indexpaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexpaths addObject:indexPath];
    }
    [_tableView deleteRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationMiddle];
    [_tableView endUpdates];
    
    
    //if (searchField.text.length == 0) {
        _customers = [[LOCALMANAGER getCustomers] retain];
//    }else{
//        _customers = [[LOCALMANAGER getFavCustomersWithName:searchField.text] retain];
//    }
    [self initDefauleFavCustomer];
    count = _customers.count;
    
    //载入
    [indexpaths removeAllObjects];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexpaths addObject:indexPath];
    }
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationMiddle];
    [_tableView endUpdates];
    [indexpaths release];
}


#pragma -mark -- 公开方法
-(void)deleteCustomerFav{
    _syncCustomer = [[NSMutableArray alloc] init];
    NSMutableArray *tmpData = [[[NSMutableArray alloc] init] autorelease];
    for (Customer *item in _customers) {
        if (!item.isFav) {
            [tmpData addObject:item.dataStream];
            [_syncCustomer addObject:item];
        }
    }
    if (tmpData.count > 0) {
        
        SHOWHUD;
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeCustomerFavDelete param:tmpData]) {
            HUDHIDE2;
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
        }
        
        [self syncFavCustList];
        HUDHIDE2
    }else{
        //提示，避免访问服务器
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"请选择需要删除的客户", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
    }
}

#pragma -mark -- 私有方法
-(UITableViewCell *) createCellWith:(UITableView *) tableView indexPath:(NSIndexPath *) indexPath{
    static NSString *cellid = @"cellid";
    FavCustomerCell *customerCell  = [tableView dequeueReusableCellWithIdentifier:cellid];
    Customer *c = _customers[indexPath.row];
    if (customerCell == nil) {
        customerCell = [[FavCustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    customerCell.cust = c;
    customerCell.textLabel.font = [UIFont systemFontOfSize:14];
    customerCell.textLabel.text = c.name;
    Contact *u = [LOCALMANAGER getContactWithCustomer:c];
    customerCell.type.text = c.category.name;
    customerCell.detailTextLabel.textColor = WT_GRAY;
    customerCell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@",u.name,[u.phone objectAtIndex:0]];
    [customerCell setFav:c.isFav];
    customerCell.tag = indexPath.row;
    customerCell.click = ^(FavCustomerCell *cell){
        Customer_Builder *pb = [cell.cust toBuilder];
        [pb setIsFav:cell.bCheck];
        Customer *tmpc = [pb build];
        [_customers replaceObjectAtIndex:[self findCustIndex:cell.cust] withObject:tmpc];
    };
    return customerCell;
}

-(int) findCustIndex:(Customer *) cust{
    for (int i = 0; i < _customers.count; i++) {
        if (((Customer*)_customers[i]).id == cust.id) {
            return i;
        }
    }
    return -1;
}

-(void) initCustData{
   // _customers = [[LOCALMANAGER getFavCustomers] retain];
    if (_customers.count == 0) {
        [self syncFavCustList];
    }else{
        [self initDefauleFavCustomer];
    }
}

//初始化默认收藏
-(void) initDefauleFavCustomer{
    for (int i = 0; i < _customers.count; i++) {
        Customer_Builder *pb = [_customers[i] toBuilder];
        [pb setIsFav:YES];
        [_customers replaceObjectAtIndex:i withObject:[pb build]];
    }
}

-(void) syncFavCustList{
    SHOWHUD;
    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeCustomerFavList param:nil]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_customers release];
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
