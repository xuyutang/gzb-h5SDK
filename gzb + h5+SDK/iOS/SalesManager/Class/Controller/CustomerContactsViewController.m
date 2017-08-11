//
//  CustomerContactsViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/8/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <MessageUI/MFMessageComposeViewController.h>
#import "CustomerContactsViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "CustomerCategoryView.h"
#import "SMContact.h"
#import "MBProgressHUD.h"
#import "RTLabel.h"
#import "HeaderSearchBar.h"
#import "UIView+Util.h"
#import "DropMenu.h"
#import "BBFlashCtntLabel.h"

@interface CustomerContactsViewController ()<MBProgressHUDDelegate, PullTableViewDelegate, HeaderSearchBarDelegate, DropMenuDelegate, UITextFieldDelegate>
{
    NSMutableArray *_checkDepartments;
    HeaderSearchBar *_searchBar;
    NSMutableArray *_searchViews;
    NSMutableArray *_custCategorys;
    NSMutableArray *_customeList;
    CustomerCategory *_custCategory;
    
    UITextField *_customerNameTextFiled;
    UIView *maskView;
}
@property(nonatomic, strong) NSString *cusName;
@end

@implementation CustomerContactsViewController

@synthesize selectTels,parentCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    index = 1;
    [super viewDidLoad];
    selectTels = [[NSMutableArray alloc] init];
    custMularray = [[NSMutableArray alloc]init];
    lblFunctionName.text = NSLocalizedString(@"customer_contacts_book", nil);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130,60)];
    
    UIImageView *smsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
    [smsImageView setImage:[UIImage imageNamed:@"ic_message"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSms:)];
    [tapGesture setNumberOfTapsRequired:1];
    smsImageView.userInteractionEnabled = YES;
    smsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [smsImageView addGestureRecognizer:tapGesture];
    [rightView addSubview:smsImageView];
    self.rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    self.tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 44, 320, (parentCtrl == nil)? MAINHEIGHT - 44:MAINHEIGHT - 90) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pullDelegate = self;
    self.tableView.allowsSelection = YES;
    self.tableView.pullBackgroundColor = [UIColor yellowColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    
    [self.view addSubview:self.tableView];
    
    //搜索条载入
    _searchBar = [[HeaderSearchBar alloc] initWithFrame:CGRectMake(0,0, MAINWIDTH, 45)];
    NSArray* titles = [NSArray arrayWithObjects:@"全部类型",@"筛选", nil];
    NSArray*  icons = [NSArray arrayWithObjects:@"",@"",nil];
    _searchBar.titles = [titles copy];
    _searchBar.icontitles = [icons copy];
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.layer.borderWidth = 0.5;
    _searchBar.layer.borderColor  = [UIColor grayColor].CGColor;
    [self.view addSubview:_searchBar];
    
    //啦啦啦啦
    _custCategorys = [[NSMutableArray alloc] initWithCapacity:0];
    [_custCategorys addObjectsFromArray:[LOCALMANAGER getCustomerCategories]];
    _customeList = [[NSMutableArray alloc] initWithCapacity:0];
    [_customeList removeAllObjects];
    [_customeList addObject:@"全部类型"];
    for (Customer* item in _custCategorys) {
        [_customeList addObject:item.name];
    }
    
    //计算frame
    CGRect tmpFrame = self.tableView.frame;
    //    tmpFrame.origin.y += 45;
    tmpFrame.size.height = MAINHEIGHT - 45 * 2;

    //初始化数据
    _searchViews = [[NSMutableArray alloc] initWithCapacity:2];
    
    // 客户类型
    DropMenu* custCategoryView = [[DropMenu alloc] initWithFrame:tmpFrame];
    custCategoryView.array1 = _customeList;
    custCategoryView.menuCount = 1;
    custCategoryView.delegate = self;
    [custCategoryView initMenu];
    [_searchViews addObject:custCategoryView];
    [custCategoryView release];
    // 筛选
    [self configureFilterView];

    currentPage = 1;
    currentCus = nil;
    currentRow = 0;
    self.customerParams = [[CustomerParams builder] build];
    filterContacts = [[NSMutableArray alloc] init];
    [lblFunctionName setText:TITLENAME_LIST(FUNC_CUSTOMER_CONTACT_DES)];
    
    AGENT.delegate = self;
    if (_customerParams == nil) {
        //[self openSearchView];
        [self refreshParamsAndTable];
    }else{
        //  [self refreshTable];
    }
    
    [self reload:index];

}

- (void)configureFilterView {
    //筛选视图
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT-45)];
    maskView.backgroundColor = [UIColor colorWithRed:63/255.0 green:65/255.0 blue:73/255.0 alpha:0.6];
    [_searchViews addObject:maskView];
    lblFunctionName.text = TITLENAME(FUNC_PATROL_TASK_DES);
    
    UIView *filterView = [[UIView alloc]init];
    filterView.backgroundColor = [UIColor whiteColor];
    filterView.frame = CGRectMake(0, 0, MAINWIDTH, 120);
    [maskView addSubview:filterView];
    
    UILabel *tintNameLabel = [[UILabel alloc]init];
    tintNameLabel.frame = CGRectMake(20, 20, 70, 30);
    tintNameLabel.text = @"客户名称:";
    tintNameLabel.font = [UIFont systemFontOfSize:14];
    [filterView addSubview:tintNameLabel];
    
    _customerNameTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(100, 12, MAINWIDTH-20-70-20-20, 30)];
    _customerNameTextFiled.font = [UIFont systemFontOfSize:14];
//    _customerNameTextFiled.layer.cornerRadius = 3;
    _customerNameTextFiled.delegate = self;
//    _customerNameTextFiled.layer.borderColor = [UIColor blackColor].CGColor;
    //_customerNameTextFiled.layer.borderWidth = 0.5;
    [filterView addSubview:_customerNameTextFiled];
    [filterView addSubview:[self setView]];
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.frame = CGRectMake(20, 70, 60, 30);
    resetButton.backgroundColor = [UIColor redColor];
    resetButton.tag = 1000;
    resetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [resetButton addTarget:self action:@selector(onOperationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [filterView addSubview:resetButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(MAINWIDTH-20-60, 70, 60, 30);
    searchButton.backgroundColor = [UIColor redColor];
    searchButton.tag = 1001;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton addTarget:self action:@selector(onOperationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [filterView addSubview:searchButton];
}

-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, MAINWIDTH - 100, 20)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(90, 10, 0.5, 3)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(90, 13, MAINWIDTH - 20 - 90, 0.5)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 20 - 0.5, 10, 0.5, 3)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
}

-(void)reload {
    [selectTels removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self reload:1];
    });
}

-(void) loadMore{
    index++;
    if (index * pageSize < totalSize) {
        [self reload:index];
    }else{
        self.tableView.pullTableIsLoadingMore = NO;
    }
}

-(void) reload:(int) page{
    index = page;
    self.tableView.pullLastRefreshDate = [NSDate date];
    self.tableView.pullTableIsRefreshing = YES;
    
    if (self.customerParams != nil){
        CustomerParams_Builder* cpb = [self.customerParams toBuilder];
        [cpb setPage:index];
        if (APPDELEGATE.myLocation != nil) {
            Location_Builder* lb = [self.customerParams.location toBuilder];
            
            [lb setLongitude:APPDELEGATE.myLocation.longitude];
            [lb setLatitude:APPDELEGATE.myLocation.latitude];
            [cpb setLocation:[lb build]];
        }
        if (_custCategory != nil) {
            [cpb setCategory:_custCategory];
        } else {
            if (self.cusName.length <= 0) {
                self.customerParams = [[CustomerParams builder] build];
                cpb = [self.customerParams toBuilder];
                [cpb clearCustomer];
            }
        }
        
        if (self.cusName.length > 0) {
            Customer_Builder *c = [Customer builder];
            [c setName:self.cusName.trim];
            [c setId:-1];
            [cpb setCustomer:[c build]];
        }else{
            [cpb clearCustomer];
        }
        self.customerParams = [[cpb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeCustomerList param:self.customerParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            self.tableView.pullTableIsRefreshing = NO;
            self.tableView.pullTableIsLoadingMore = NO;
        }
    }
}

-(void)didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeCustomerList:
        {
            if ([NS_ACTIONCODE(ActionCodeDone) isEqual:cr.code]) {
                PageCustomer *page = [PageCustomer parseFromData:cr.data];
                pageSize = page.page.pageSize;
                totalSize = page.page.totalSize;
                if (index == 1) {
                    [filterContacts removeAllObjects];
                }
                for (Customer *cust in page.customers) {
                    [filterContacts addObject:cust];
                }
                [self.tableView reloadData];
            }
        }
            break;
            
        default:
            break;
    }
    self.tableView.pullTableIsRefreshing = NO;
    self.tableView.pullTableIsLoadingMore = NO;
    [super showMessage2:cr Title:NSLocalizedString(@"customer_contacts_book", nil) Description:NSLocalizedString(@"", nil)];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {

    if (SCREENHEIGHT == 480) {
        [maskView setFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT-45)];
    }

}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (SCREENHEIGHT == 480) {
        [maskView setFrame:CGRectMake(0, 45, MAINWIDTH, MAINHEIGHT-45)];
    }


}
#pragma -mark pullTableViewDelegate
-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView{
    [self reload];
}

-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView{
    [self loadMore];
}

-(void) HeaderSearchBarClickBtn:(int) indexx current:(int) current {
    if (indexx == current) {
        [UIView removeViewFormSubViews:-1 views:_searchViews ];
        return;
    }
    [UIView addSubViewToSuperView:self.view subView:_searchViews[indexx]];
    [UIView removeViewFormSubViews:indexx views:_searchViews];
}

#pragma -mark
-(BOOL)isSelected:(NSString *)customer{

    for(NSString *cus in custMularray){
    
        if ([cus isEqualToString:customer]) {
            return YES;
        }
        
    }
    return NO;
}

-(void)toSms:(id)sender{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        //self.navigationController.navigationBarHidden = YES;
        controller.body = @"";
        controller.recipients = selectTels;
        
        controller.messageComposeDelegate = self;
        if (parentCtrl != nil) {
            [self.parentCtrl.navigationController presentModalViewController:controller animated:YES];
        }else{
            [(APPDELEGATE).endContactNavCtrl presentModalViewController:controller animated:YES];
        }
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return filterContacts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CustomerContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomerContactCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[CustomerContactCell class]])
                cell=(CustomerContactCell *)oneObject;
        }
    }
    
    Customer *c = (Customer *)[filterContacts objectAtIndex:indexPath.row];
    cell.customerName.text = c.name;
    cell.personName.text = NSLocalizedString(@"nocontact", "");
    Contact *contact = nil;
    NSString *phone = nil;
    if (c.contacts.count >0) {
        contact = [c.contacts objectAtIndex:0];
        if (contact.phone.count >0) {
            NSString* constactName = contact.name;
            phone = [contact.phone objectAtIndex:0];
            if (![constactName isEqualToString:@""] || ![phone isEqualToString:@""]) {
                cell.personName.text = constactName;
                cell.tel.text = [NSString stringWithFormat:@"%@",phone];
                cell.phone = phone;
            }
        }
    }
    NSString* cusName = c.name;
    float x = IOS7 ? 8 : 13;
    //BBFlashCtntLabel 在7.0以上 为了兼容6.0版本
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x,0,300,40)];
        [label setText:cusName];
        [label setBackgroundColor:[UIColor clearColor]];
        //    label.lineSpacing = 20.0;
        //    [label setParagraphReplacement:@""];
        [cell addSubview:label];
        [label release];
        label = nil;

    }else {
        BBFlashCtntLabel *label = [[BBFlashCtntLabel alloc] initWithFrame:CGRectMake(x,0,300,40)];
        [label setText:cusName];
        [label setBackgroundColor:[UIColor clearColor]];
        //    label.lineSpacing = 20.0;
        //    [label setParagraphReplacement:@""];
        [cell addSubview:label];
        [label release];
        label = nil;

    }
     cell.delegate = self;
    if (contact != nil) {
        if ([self isSelected:c.name]) {
            cell.isChecked = YES;
        }else{
            cell.isChecked =NO;
        }
    }
    [cell setCell];
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self searchDismissKeyBoard];
    
    CustomerContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isChecked = ! cell.isChecked;
    if (cell.isChecked) {
        if (cell.phone != nil) {
            [custMularray addObject: cell.customerName.text];
            
            [selectTels addObject:cell.phone];
        }
    }else{
        [selectTels removeObject:cell.phone];
          [custMularray removeObject: cell.customerName.text];
    }
    [tableView reloadData];
}

-(void)clickSmsButton:(NSString *)tel{


    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        //self.navigationController.navigationBarHidden = YES;
        
        controller.body = @"";
        controller.recipients = [NSArray arrayWithObjects:tel, nil];
        controller.messageComposeDelegate = self;
        if (parentCtrl != nil) {
            [self.parentCtrl.navigationController presentModalViewController:controller animated:YES];
        }else{
            [(APPDELEGATE).endContactNavCtrl presentModalViewController:controller animated:YES];
        }
    }

}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:YES];
    //self.navigationController.navigationBarHidden = NO;
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
        }
            break;
        case MessageComposeResultFailed:// send failed
            
            break;
            
        case MessageComposeResultSent:
        {
            //do something
        }
            break;
        default:
            break;
    } 
    
}

- (void)onOperationButtonClick:(UIButton *)sender {
    if (sender.tag == 1000) {
        self.cusName = nil;
        _customerNameTextFiled.text = @"";
    } else {
        self.cusName = _customerNameTextFiled.text;
        [UIView removeViewFormSubViews:-1 views:_searchViews];
        [_searchBar setColor:1];
        [self refreshParamsAndTable];
    }
}


- (void)refreshParamsAndTable {
    [self reload];
}

- (void)clickTelButton:(int)section row:(int)row {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

-(IBAction)searchDismissKeyBoard
{
    [_searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark DropMenu delegate
-(void)selectedDropMenuIndex:(int)index row:(int)row{
    NSLog(@"选择了类型:%@",_customeList[row]);
    UIButton* btn = _searchBar.buttons[0];
    [btn setTitle:_customeList[row] forState:UIControlStateNormal];
    if (row == 0) {
        _custCategory = nil;
    }else{
        _custCategory = _custCategorys[row - 1];
    }
    
    [UIView removeViewFormSubViews:-1 views:_searchViews];
    [_searchBar setColor:1];
    [self refreshParamsAndTable];
}
#pragma mark -
#pragma mark  UITextFieldDelegate
// 设置输入框，是否可以被修改
// NO-将无法修改，不出现键盘
// YES-可以修改，默认值
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    NSLog(@"222");
//}
//// 当输入框获得焦点时，执行该方法。
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    NSLog(@"textFieldDidBeginEditing");
//    
//}
//// 文本框的文本，是否能被修改
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    return YES;
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self.tableView release];
    [selectTels release];
    [parentCtrl release];
    [_customerParams release];
    [super dealloc];
}

@end
