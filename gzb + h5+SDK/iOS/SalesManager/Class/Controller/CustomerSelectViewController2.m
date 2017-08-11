//
//  CustomerSelectViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/3/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "CustomerSelectViewController2.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"
#import "CustomerCategoryView.h"
#import "CommonCell.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+Helpers.h"
#import "MapTaggingViewController.h"

@interface CustomerSelectViewController2 ()<MBProgressHUDDelegate,RefreshDelegate>{
    Location* customerLocation;
}

@end

@implementation CustomerSelectViewController2
@synthesize delegate,bNeedAddCustomer,tableView,bNeedAll;

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
    [super viewDidLoad];
    
    bNewCustomer = NO;
    
    /*
     addCustomerBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
     [addCustomerBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
     txtCustomer = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 230, 34)];
     txtCustomer.borderStyle = UITextBorderStyleRoundedRect;
     [addCustomerBar addSubview:txtCustomer];
     UIButton *btConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [btConfirm setFrame:CGRectMake(250, 5, 60, 34)];
     [btConfirm setTintColor:[UIColor clearColor]];
     [btConfirm setBackgroundColor:[UIColor clearColor]];
     [btConfirm setTitle:@"确定" forState:UIControlStateNormal];
     [btConfirm addTarget:self action:@selector(returnResult) forControlEvents:UIControlEventTouchUpInside];
     [addCustomerBar addSubview:btConfirm];
     [self.view addSubview:addCustomerBar];
     */
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"NewCustomerView" owner:self options:nil];
    newCustomerView = [nibViews objectAtIndex:0];
    [newCustomerView setFrame:CGRectMake(0, 0, 320, MAINHEIGHT + 44)];
    [newCustomerView initView];
    [newCustomerView.btConfirm addTarget:self action:@selector(returnResult) forControlEvents:UIControlEventTouchUpInside];
    [newCustomerView.btnLocation addTarget:self action:@selector(toMapTagging) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newCustomerView];
    
    if(bNeedAll){
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
        UILabel *checkAllImageView = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
        
        checkAllImageView.text = [NSString fontAwesomeIconStringForEnum:ICON_SAVE];
        checkAllImageView.textColor = WT_RED;
        checkAllImageView.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
        checkAllImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAll)];
        [tapGesture1 setNumberOfTapsRequired:1];
        checkAllImageView.contentMode = UIViewContentModeScaleAspectFit;
        [checkAllImageView addGestureRecognizer:tapGesture1];
        [rightView addSubview:checkAllImageView];
        [checkAllImageView release];
        
        UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.rightButton = btRight;
        [tapGesture1 release];
        [btRight release];
    }else if(bNeedAddCustomer){
        
        segmentCtrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"列表",@"新增", nil]];
        [segmentCtrl setTintColor:[UIColor redColor]];
        
        segmentCtrl.frame = CGRectMake(0.0f, 0.0f, 100.0f, 32.0f);

        [segmentCtrl addTarget:self action:@selector(switchPage:) forControlEvents:UIControlEventValueChanged];
        [segmentCtrl setSelectedSegmentIndex:0];
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 32.0f)];
        [tmpView addSubview:segmentCtrl];
        self.rightButton = [[[UIBarButtonItem alloc] initWithCustomView:tmpView] autorelease];
    }
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    lblFunctionName.text = NSLocalizedString(@"patrol_label_category",@"");
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [searchBar setBackgroundImage:[UIImage createImageWithColor:WT_RED]];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.allowsSelection = YES;
    //[tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
    [lblFunctionName setText:NSLocalizedString(@"select_customer", @"")];
    
    bCustomerSync = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customerHasSync)
												 name:SYNC_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customerHasSync)
												 name:CUSTOMER_NOTIFICATION object:nil];
}

-(void)refresh:(id)obj{
    if ([obj isKindOfClass:[Location class]]) {
        customerLocation = [(Location*)obj retain];
        if (!customerLocation.address.isEmpty) {
            newCustomerView.lLocation.text = customerLocation.address;
        }else{
            newCustomerView.lLocation.text = [NSString stringWithFormat:@"%f,%f",customerLocation.latitude,customerLocation.longitude];
        }
    }
}

-(void)toMapTagging{
    MapTaggingViewController *ctrl = [[MapTaggingViewController alloc] init];
    ctrl.bNeedBack = YES;
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)viewWillAppear:(BOOL)animated{
    if (bCustomerSync) {
        [self initData];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

-(void)customerHasSync{
    bCustomerSync = YES;
}

-(void) reload{
    if (bCustomerSync) {
        [self initData];
    }
    
}

-(void)switchPage:(id)sender {
    int selectedIndex = [segmentCtrl selectedSegmentIndex];
    switch (selectedIndex) {
        case 0:
            [self.view addSubview:searchBar];
            [self.view addSubview:tableView];
            bNewCustomer = NO;
            break;
        case 1:
            [searchBar removeFromSuperview];
            [tableView removeFromSuperview];
            bNewCustomer = YES;
            break;
        default:
            break;
    }
}

-(void)openNewCustomer{
    
    if (bNewCustomer) {
        [btNewCustomer setTitle:@"新增"];
        [self.view addSubview:searchBar];
        [self.view addSubview:tableView];
        bNewCustomer = NO;
    }else{
        [btNewCustomer setTitle:@"选择"];
        [searchBar removeFromSuperview];
        [tableView removeFromSuperview];
        bNewCustomer = YES;
    }
    
}
-(void)initData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    [self _loadData];
    HUDHIDE2;
}

-(void) _loadData{
    //sleep(1);
    if (favoratCustomers != nil) {
        if([favoratCustomers count]>0)[favoratCustomers removeAllObjects];
        favoratCustomers = nil;
    }
    if (customerCategories != nil) {
        if([customerCategories count]>0)[customerCategories removeAllObjects];
        customerCategories = nil;
    }
    if (filterCustomers != nil) {
        if([filterCustomers count]>0)[filterCustomers removeAllObjects];
        filterCustomers = nil;
    }
    
    favoratCustomers = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getFavCustomers]];
    customerCategories = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getCustomerCategories]];
    
    if (customers != nil) {
        if([customers count]>0)[customers removeAllObjects];
        //[customers release];
        customers = nil;
    }
    
    customers = [[NSMutableArray alloc] init];
    for (CustomerCategory *category in customerCategories) {
        SMCustomer *smCustomer = [[SMCustomer alloc] init];
        smCustomer.bExpand = YES;
        smCustomer.category = category;
        smCustomer.customerArray = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getCustomers:category.id]];
        [customers addObject:smCustomer];
    }
    
    
    SMCustomer *favorateCustomer = [[SMCustomer alloc] init];
    CustomerCategory_Builder *ccBuilder = [CustomerCategory builder];
    
    [ccBuilder setId:-1];
    [ccBuilder setName:NSLocalizedString(@"my_favorate", nil)];
    
    favorateCustomer.bExpand = YES;
    favorateCustomer.category = [[ccBuilder build] retain];
    if (favoratCustomers != nil && [favoratCustomers count]>0) {
        favorateCustomer.customerArray = [[[NSMutableArray alloc] initWithArray:favoratCustomers] retain];
    }else{
        favorateCustomer.customerArray = [[NSMutableArray alloc] init];
    }
    [customers insertObject:favorateCustomer atIndex:0];
    
    
    filterCustomers = [[NSMutableArray alloc] initWithArray:customers];
    newCustomerView.customerCategories = [[NSMutableArray alloc] initWithArray:customerCategories];
    [tableView reloadData];
    bCustomerSync = NO;
}

-(BOOL)isFavorate:(Customer *)customer{
    for (Customer *item in favoratCustomers) {
        if(item.id == customer.id)return YES;
    }
    return NO;
}

-(void)showNewCustomerBar:(id)sender{
    
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    categoryIndex = tapGesture.view.tag;
    
    if (bNewCustomer) {
        [addCustomerBar removeFromSuperview];
        [self.view addSubview:searchBar];
        bNewCustomer = NO;
    }else{
        
        [self.view addSubview:addCustomerBar];
        [searchBar removeFromSuperview];
        bNewCustomer = YES;
    }
    
}

-(void)selectGroupAll:(id)sender{
    
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    categoryIndex = tapGesture.view.tag;
    
    CustomerCategory *cc = ((SMCustomer *)[filterCustomers objectAtIndex:categoryIndex]).category;
    Customer_Builder* cb = [Customer builder];
    [cb setId:-1];
    [cb setName:cc.name];
    [cb setCategory:cc];
    
    Customer *c = [[cb build] retain];
    
    if ([delegate respondsToSelector:@selector(customerSearch:didSelectWithObject:)]) {
        [delegate customerSearch:self didSelectWithObject:c];
    }
    [self searchDismissKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)selectAll{
    
    if ([delegate respondsToSelector:@selector(customerSearch:didSelectWithObject:)]) {
        [delegate customerSearch:self didSelectWithObject:nil];
    }
    [self searchDismissKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)returnResult{
    
    [self addCustomerDismissKeyboard];
    
    if (newCustomerView.txtCustomerCategory.text.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_type", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
        
    }
    if (newCustomerView.txtCustomerName.text.length == 0){
        
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_name", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
        
    }
    
    if (![newCustomerView.txtCustomerName.text isValid:IdentifierTypeName]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_right_name", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    if (![newCustomerView.txtContact.text isValid:IdentifierTypeName]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"new_customer_title", @"")
                          description:NSLocalizedString(@"new_customer_right_contact", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    
    Customer_Builder *cb = [Customer builder];
    [cb setId:-1];
    [cb setName:txtCustomer.text];
    if ((APPDELEGATE).myLocation != nil){
        [cb setLocation:(APPDELEGATE).myLocation];
    }
    
    [cb setCategory:[customerCategories objectAtIndex:newCustomerView.selectedIndex]];
    [cb setName:newCustomerView.txtCustomerName.text];
    
    Contact_Builder* c = [Contact builder];
    [c setName:newCustomerView.txtContact.text];
    [c setPhoneArray:[[NSArray alloc] initWithObjects:newCustomerView.txtTel.text, nil]];
    [cb setContactsArray:[[NSArray alloc] initWithObjects:[c build], nil]];
    if (customerLocation != nil) {
        [cb setLocation:customerLocation];
    }
    
    if (delegate != nil && [delegate respondsToSelector:@selector(newCustomerDidFinished:newCustomer:)]) {
        [delegate newCustomerDidFinished:self newCustomer:cb];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(int)isExistCategory:(CustomerCategory *)category{
    
    for (int i = 0; i < [filterCustomers count]; i++) {
        CustomerCategory *tmp = ((SMCustomer *)[filterCustomers objectAtIndex:i]).category;
        if (category.id == tmp.id) {
            return i;
        }
    }
    return -1;
}


-(void)clickLeftButton:(id)sender{
    
    [self addCustomerDismissKeyboard];
    [self searchDismissKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
    [self cancel];
}

- (void)cancel
{
    if ([delegate respondsToSelector:@selector(customerSearchDidCanceled:)]) {
        [delegate customerSearchDidCanceled:self];
    }
}

-(void)headerIsTapEvent:(id)sender{
    
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    int sectionIndex = tapGesture.view.tag;
    
    SMCustomer *smCustomer = [filterCustomers objectAtIndex:sectionIndex];
    if (smCustomer.bExpand)smCustomer.bExpand=NO;
    else smCustomer.bExpand = YES;
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [filterCustomers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int n = [((SMCustomer *)[filterCustomers objectAtIndex:section]).customerArray count];
    SMCustomer *smCustomer = [filterCustomers objectAtIndex:section];
    if (!smCustomer.bExpand)return 0;
    
    if (section == [filterCustomers count]-1) {
        return n+5;
    }
    return n;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CustomerCategoryView" owner:self options:nil];
    CustomerCategoryView *header = [nibViews objectAtIndex:0];
    [header setBackgroundColor:WT_LIGHT_GRAY];
    
    UITapGestureRecognizer *tapSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIsTapEvent:)];
    [tapSectionGesture setNumberOfTapsRequired:1];
    header.userInteractionEnabled = YES;
    [header addGestureRecognizer:tapSectionGesture];
    tapSectionGesture.view.tag = section;
    [tapSectionGesture release];
    
    SMCustomer *smCustomer = [filterCustomers objectAtIndex:section];
    
    if (!bNeedAddCustomer) {
        [header.btAdd setImage:[UIImage imageNamed:@"ic_check_all_red"]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGroupAll:)];
        [tapGesture setNumberOfTapsRequired:1];
        header.title.text = ((SMCustomer *)[filterCustomers objectAtIndex:section]).category.name;
        header.btAdd.userInteractionEnabled = YES;
        [header.btAdd addGestureRecognizer:tapGesture];
        tapGesture.view.tag = section;
        [tapGesture release];
        
        if(bNeedAll && (smCustomer.category.id != -1)){
            [header.btAdd setHidden:NO];
        }else{
            [header.btAdd setHidden:YES];
        }
    }else {
        //if(smCustomer.category.id != -1)[header.btAdd setHidden:NO];
        //else
        [header.btAdd setHidden:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNewCustomerBar:)];
        [tapGesture setNumberOfTapsRequired:1];
        header.title.text = ((SMCustomer *)[filterCustomers objectAtIndex:section]).category.name;
        header.btAdd.userInteractionEnabled = YES;
        [ header.btAdd addGestureRecognizer:tapGesture];
        tapGesture.view.tag = section;
        [tapGesture release];
    }
    
    return header;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    
    CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SMCustomer *temp = (SMCustomer *)[filterCustomers objectAtIndex:[filterCustomers count]-1];
    
    
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CommonCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[CommonCell class]])
                cell=(CommonCell *)oneObject;
        }
    }
    
    if ((indexPath.section == [filterCustomers count]-1) && indexPath.row>=[temp.customerArray count]) {
        [cell.title setHidden:YES];
        [cell.ivFavorate setHidden:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        [cell.title setHidden:NO];
        [cell.ivFavorate setHidden:NO];
    }
    
    SMCustomer * item = (SMCustomer *)[filterCustomers objectAtIndex:indexPath.section];
    Customer *customer = (Customer *)[item.customerArray objectAtIndex:indexPath.row];
    
    cell.title.text = customer.name;
    cell.bFavorate = [self isFavorate:customer] ? YES:NO;
    cell.delegate = self;
    cell.section = indexPath.section;
    cell.row = indexPath.row;
    cell.tag = indexPath.row;
    [cell setCell];
    
    return cell;
}

-(void)clickFavorate:(int)section row:(int)row favorate:(BOOL)bFavorate{
    (APPDELEGATE).bChangeFavorate = NO;
    
    SMCustomer * item = (SMCustomer *)[filterCustomers objectAtIndex:section];
    Customer *customer = (Customer *)[item.customerArray objectAtIndex:row];
    
    [LOCALMANAGER favCustomer:customer Fav:bFavorate];
    [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_NOTIFICATION object:nil];
    [self initData];
    
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self searchDismissKeyBoard];
    SMCustomer *temp = (SMCustomer *)[filterCustomers objectAtIndex:[filterCustomers count]-1];
    if ((indexPath.section == [filterCustomers count]-1) && indexPath.row>=[temp.customerArray count]) {
        return;
    }
    
    if ([delegate respondsToSelector:@selector(customerSearch:didSelectWithObject:)]) {
        SMCustomer * item = (SMCustomer *)[filterCustomers objectAtIndex:indexPath.section];
        Customer *customer = (Customer *)[item.customerArray objectAtIndex:indexPath.row];
        [delegate customerSearch:self didSelectWithObject:customer];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    if ([searchText isEqualToString:@""]) {
        [filterCustomers removeAllObjects];
        filterCustomers = [[NSMutableArray alloc] initWithArray:customers];
        [tableView reloadData];
        return;
    }
    
    [filterCustomers removeAllObjects];
    filterCustomers = [[NSMutableArray alloc] init];
    for (int i = 0; i<[customers count]; i++) {
        SMCustomer* item = [customers objectAtIndex:i];
        for (int j = 0; j<[item.customerArray count]; j++) {
            
            Customer *customer = [item.customerArray objectAtIndex:j];
            NSRange range = [customer.name rangeOfString:searchText];
            NSRange pinyinRange = [customer.spell rangeOfString:searchText];
            
            //NSLog(@"customer.name = %@ location = %d",customer.name,range.location);
            if ((range.location != NSNotFound) || (pinyinRange.location != NSNotFound)){
                SMCustomer *smCustomer = nil;
                
                int index = [self isExistCategory:item.category];//分类是否存在
                if ( index == -1) {//如果不存在就新增一个
                    
                    SMCustomer *smCustomer = [[SMCustomer alloc] init];
                    smCustomer.category = item.category;
                    smCustomer.customerArray = [[NSMutableArray alloc] init];
                    [smCustomer.customerArray addObject:customer];
                    smCustomer.bExpand = YES;
                    [filterCustomers addObject:smCustomer];
                }else{
                    [((SMCustomer *)[filterCustomers objectAtIndex:index]).customerArray addObject:customer];
                }
                
            }
        }
        
    }
    
    [tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

-(IBAction)addCustomerDismissKeyboard{
    
    [txtCustomer resignFirstResponder];
}

-(IBAction)searchDismissKeyBoard
{
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if ((APPDELEGATE).bChangeFavorate) {
        
        if ((APPDELEGATE).bPopAction) {
            return;
        }
        (APPDELEGATE).bPopAction = YES;
        UIActionSheet *actionSheet =[[UIActionSheet alloc]
                                     initWithTitle:NSLocalizedString(@"msg_favorate_change", @"")
                                     delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"no", @"")
                                     destructiveButtonTitle:NSLocalizedString(@"msg_favorate_confirm", @"")
                                     otherButtonTitles:nil,nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self saveFavorate];
            (APPDELEGATE).bPopAction = NO;
        }
            break;
        case 1:{
            (APPDELEGATE).bPopAction = NO;
        }
            break;
        default:
            break;
    }
    
}

-(void)saveFavorate{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:(APPDELEGATE).currentUser,@"user",[LOCALMANAGER getFavCustomers],@"favCustomers", [LOCALMANAGER getFavPatrolCategories],@"favPatrolCategories",nil];
    (APPDELEGATE).agent.delegate = self;
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeFavSave param:params]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"my_favorate", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
    [params release];
    
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeFavSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                (APPDELEGATE).bChangeFavorate = NO;
            }
            [super showMessage2:cr Title:NSLocalizedString(@"my_favorate", @"") Description:NSLocalizedString(@"favorate_commit_done", @"")];
        }
            break;
    }
}


@end
