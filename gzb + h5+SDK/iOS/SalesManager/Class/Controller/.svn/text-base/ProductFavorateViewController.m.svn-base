//
//  ProductFavorateViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-11-25.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "ProductFavorateViewController.h"
#import "SMProduct.h"
#import "CustomerCategoryView.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Constant.h"
@interface ProductFavorateViewController ()<MBProgressHUDDelegate>

@end

@implementation ProductFavorateViewController

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
    self.view.backgroundColor = WT_WHITE;
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    lblFunctionName.text = NSLocalizedString(@"patrol_label_category",@"");
    
    
    //自定义搜索栏
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, MAINWIDTH - 20 , 30)];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    [self.view addSubview:view];
    _searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, MAINWIDTH -20, 30)];
    _searchField.placeholder = @"名称查询";
    _searchField.font = [UIFont systemFontOfSize:14];
    [view addSubview:_searchField];
    
    UIButton *seachButton = [[UIButton alloc]initWithFrame:CGRectMake(MAINWIDTH - 45, 5, 20, 20)];
    [seachButton setImage:[UIImage imageNamed:@"searchbar_textfield_search_icon.png"] forState:UIControlStateNormal];
    [seachButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:seachButton];

//    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, MAINWIDTH - 20, 35)];
//    [searchBar setBackgroundImage:[UIImage createImageWithColor:WT_WHITE]];
//    searchBar.layer.borderWidth = 0.5;
//    searchBar.layer.backgroundColor = WT_GRAY.CGColor;
//    searchBar.layer.masksToBounds = YES;
//    searchBar.layer.cornerRadius = 10;
//    searchBar.placeholder = @"名称查询";
//    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
    
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

-(void)clickAction {
    [_searchField resignFirstResponder];

    if ([_searchField.text isEqualToString:@""]) {
        [filterProducts removeAllObjects];
        filterProducts = [[NSMutableArray alloc] initWithArray:products];
        [tableView reloadData];
        return;
    }
    
    [filterProducts removeAllObjects];
    filterProducts = [[NSMutableArray alloc] init];
    for (int i = 0; i<[products count]; i++) {
        SMProduct* item = [products objectAtIndex:i];
        for (int j = 0; j<[item.productArray count]; j++) {
            
            Product *product = [item.productArray objectAtIndex:j];
            NSRange range = [product.name rangeOfString:_searchField.text];
            
            if ((range.location != NSNotFound) /*|| (pinyinRange.location != NSNotFound)*/){
                SMProduct *smProduct = nil;
                
                int index = [self isExistCategory:item.category];//分类是否存在
                if ( index == -1) {//如果不存在就新增一个
                    
                    SMProduct *smProduct = [[SMProduct alloc] init];
                    smProduct.category = item.category;
                    smProduct.productArray = [[NSMutableArray alloc] init];
                    [smProduct.productArray addObject:product];
                    smProduct.bExpand = YES;
                    [filterProducts addObject:smProduct];
                }else{
                    [((SMProduct *)[filterProducts objectAtIndex:index]).productArray addObject:product];
                }
                
            }
        }
        
    }
          [tableView reloadData];

}

-(void)viewWillAppear:(BOOL)animated{
    if (bCustomerSync) {
        [self initData];
    }
}

-(void)customerHasSync{
    bCustomerSync = YES;
}

-(void) reload{
    if (bCustomerSync) {
        [self initData];
    }
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

-(void)initData{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [self.view addSubview:HUD];
	HUD.labelText = NSLocalizedString(@"loading", @"");
	HUD.delegate = self;
	[HUD showWhileExecuting:@selector(_loadData) onTarget:self withObject:nil animated:YES];
    
}

-(void) _loadData{
    sleep(1);
    if (favoratProducts != nil) {
        if([favoratProducts count]>0)[favoratProducts removeAllObjects];
        favoratProducts = nil;
    }
    if (productCategories != nil) {
        if([productCategories count]>0)[productCategories removeAllObjects];
        productCategories = nil;
    }
    if (filterProducts != nil) {
        if([filterProducts count]>0)[filterProducts removeAllObjects];
        filterProducts = nil;
    }
    
    favoratProducts = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getFavProducts]];
    productCategories = [[NSMutableArray alloc] initWithCapacity:0];//initWithArray:[LOCALMANAGER getCustomerCategories]];
    
    if (products != nil) {
        if([products count]>0)[products removeAllObjects];
        //[customers release];
        products = nil;
    }
    
    products = [[NSMutableArray alloc] init];
    /* for (ProductCategory *category in productCategories) {
     SMProduct *smProduct = [[SMProduct alloc] init];
     smProduct.bExpand = YES;
     smProduct.category = category;
     smProduct.productArray = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getCustomers:category.id]];
     [products addObject:smCustomer];
     }*/
    
    
    SMProduct *favorateProduct = [[SMProduct alloc] init];
    ProductCategory_Builder *pc = [ProductCategory builder];
    
    [pc setId:-1];
    [pc setName:NSLocalizedString(@"my_favorate", nil)];
    
    favorateProduct.bExpand = YES;
    favorateProduct.category = [[pc build] retain];
    if (favoratProducts != nil && [favoratProducts count]>0) {
        favorateProduct.productArray = [[[NSMutableArray alloc] initWithArray:favoratProducts] retain];
    }else{
        favorateProduct.productArray = [[NSMutableArray alloc] init];
    }
    [products addObject:favorateProduct];
    
    SMProduct *allProduct = [[SMProduct alloc] init];
    ProductCategory_Builder *pBuilder = [ProductCategory builder];
    [pBuilder setId:-2];
    [pBuilder setName:NSLocalizedString(@"favorate_all_product", nil)];
    
    allProduct.bExpand = YES;
    allProduct.category = [[pBuilder build] retain];
    allProduct.productArray = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getProducts]];
    [products addObject:allProduct];
    
    filterProducts = [[NSMutableArray alloc] initWithArray:products];
    [tableView reloadData];
    bCustomerSync = NO;
}

-(BOOL)isFavorate:(Product *)product{
    for (Product *item in favoratProducts) {
        if(item.id == product.id)return YES;
    }
    return NO;
}

-(int)isExistCategory:(ProductCategory *)category{
    
    for (int i = 0; i < [filterProducts count]; i++) {
        ProductCategory *tmp = ((SMProduct *)[filterProducts objectAtIndex:i]).category;
        if (category.id == tmp.id) {
            return i;
        }
    }
    return -1;
}


-(void)clickLeftButton:(id)sender{
    
    //[self addCustomerDismissKeyboard];
    [self searchDismissKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
    //[self cancel];
}

-(void)headerIsTapEvent:(id)sender{
    
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    int sectionIndex = tapGesture.view.tag;
    
    SMProduct *smProduct = [filterProducts objectAtIndex:sectionIndex];
    if (smProduct.bExpand)smProduct.bExpand=NO;
    else smProduct.bExpand = YES;
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [filterProducts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int n = [((SMProduct *)[filterProducts objectAtIndex:section]).productArray count];
    SMProduct *smProduct = [filterProducts objectAtIndex:section];
    if (!smProduct.bExpand)return 0;
    
    if (section == [filterProducts count]-1) {
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
    header.backgroundColor = WT_LIGHT_GRAY;
    UITapGestureRecognizer *tapSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIsTapEvent:)];
    [tapSectionGesture setNumberOfTapsRequired:1];
    header.userInteractionEnabled = YES;
    [header addGestureRecognizer:tapSectionGesture];
    tapSectionGesture.view.tag = section;
    [tapSectionGesture release];
    
    SMProduct *smProduct = [filterProducts objectAtIndex:section];
    
    [header.btAdd setImage:[UIImage imageNamed:@"ic_check_all_red"]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectGroupAll:)];
    [tapGesture setNumberOfTapsRequired:1];
    header.title.text = ((SMProduct *)[filterProducts objectAtIndex:section]).category.name;
    header.btAdd.userInteractionEnabled = YES;
    [header.btAdd addGestureRecognizer:tapGesture];
    tapGesture.view.tag = section;
    [tapGesture release];
    [header.btAdd setHidden:YES];
    
    
    return header;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    
    CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SMProduct *temp = (SMProduct *)[filterProducts objectAtIndex:[filterProducts count]-1];
    
    
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CommonCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[CommonCell class]])
                cell=(CommonCell *)oneObject;
        }
    }
    
    if ((indexPath.section == [filterProducts count]-1) && indexPath.row>=[temp.productArray count]) {
        [cell.title setHidden:YES];
        [cell.ivFavorate setHidden:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        [cell.title setHidden:NO];
        [cell.ivFavorate setHidden:NO];
    }
    
    SMProduct * item = (SMProduct *)[filterProducts objectAtIndex:indexPath.section];
    Product *customer = (Product *)[item.productArray objectAtIndex:indexPath.row];
    
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
    
    SMProduct * item = (SMProduct *)[filterProducts objectAtIndex:section];
    Product *customer = (Product *)[item.productArray objectAtIndex:row];
    
    [LOCALMANAGER favProduct:customer Fav:bFavorate];
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOMER_NOTIFICATION object:nil];
    [self initData];
    
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self searchDismissKeyBoard];
    SMProduct *temp = (SMProduct *)[filterProducts objectAtIndex:[filterProducts count]-1];
    if ((indexPath.section == [filterProducts count]-1) && indexPath.row>=[temp.productArray count]) {
        return;
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
        [filterProducts removeAllObjects];
        filterProducts = [[NSMutableArray alloc] initWithArray:products];
        [tableView reloadData];
        return;
    }
    
    [filterProducts removeAllObjects];
    filterProducts = [[NSMutableArray alloc] init];
    for (int i = 0; i<[products count]; i++) {
        SMProduct* item = [products objectAtIndex:i];
        for (int j = 0; j<[item.productArray count]; j++) {
            
            Product *product = [item.productArray objectAtIndex:j];
            NSRange range = [product.name rangeOfString:searchText];

            if ((range.location != NSNotFound) /*|| (pinyinRange.location != NSNotFound)*/){
                SMProduct *smProduct = nil;
                
                int index = [self isExistCategory:item.category];//分类是否存在
                if ( index == -1) {//如果不存在就新增一个
                    
                    SMProduct *smProduct = [[SMProduct alloc] init];
                    smProduct.category = item.category;
                    smProduct.productArray = [[NSMutableArray alloc] init];
                    [smProduct.productArray addObject:product];
                    smProduct.bExpand = YES;
                    [filterProducts addObject:smProduct];
                }else{
                    [((SMProduct *)[filterProducts objectAtIndex:index]).productArray addObject:product];
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
@end
