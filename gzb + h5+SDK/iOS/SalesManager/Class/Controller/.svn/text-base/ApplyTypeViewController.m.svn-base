//
//  ApplyTypeViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-9-19.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "ApplyTypeViewController.h"

@interface ApplyTypeViewController ()

@end

@implementation ApplyTypeViewController
@synthesize applyTypes;
@synthesize filterTypes;
@synthesize tableView;
@synthesize delegate;
@synthesize bFavorate;
@synthesize bNeedAll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) reload{
    [self initData];
    [tableView reloadData];
}

-(void)initData{
    [applyTypes removeAllObjects];
    
    applyTypes = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getApplyCategories]];
    ApplyCategory_Builder *ab = [ApplyCategory builder];
    [ab setName:@"请选择"];
    [ab setId:-1];
    [ab setUsersArray:nil];
    [applyTypes insertObject:[ab build] atIndex:0];
    
    self.applyTypes = [NSMutableArray arrayWithArray:applyTypes];
  
    self.filterTypes = [NSMutableArray arrayWithArray:applyTypes];
    [self.filterTypes insertObject:@"请选择" atIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    if (bNeedAll) {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
        UIImageView *checkAllImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 50, 30)];
        [checkAllImageView setImage:[UIImage imageNamed:@"ic_check_all"]];
        checkAllImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAll)];
        [tapGesture1 setNumberOfTapsRequired:1];
        checkAllImageView.contentMode = UIViewContentModeScaleAspectFit;
        [checkAllImageView addGestureRecognizer:tapGesture1];
        [rightView addSubview:checkAllImageView];
        [checkAllImageView release];
        
        UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.rightButton = btRight;
        [btRight release];
    }
    
    filterTypes = [[NSMutableArray alloc] initWithArray:applyTypes];
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    lblFunctionName.text = NSLocalizedString(@"apply_label_category",@"");
//    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [searchBar setBackgroundImage:[UIImage createImageWithColor:WT_RED]];
//    //searchBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]];
//    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    if (bFavorate) {
        tableView.allowsSelection = NO;
    }else{
        tableView.allowsSelection = YES;
    }
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
}

-(void)clickLeftButton:(id)sender{
    [self searchDismissKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
    [self cancel];
}

-(void)selectAll{
    
    [self searchDismissKeyBoard];
    if ([delegate respondsToSelector:@selector(patrolSearch:didSelectWithObject:)]) {
        [delegate applyTypeSearch:self didSelectWithObject:nil];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)cancel
{
    if ([delegate respondsToSelector:@selector(dataSearchDidCanceled:)]) {
        [delegate dataSearchDidCanceled:self];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filterTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    CommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CommonCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[CommonCell class]])
                cell=(CommonCell *)oneObject;
        }
    }
    
    [cell.ivFavorate setHidden:YES];
    if (indexPath.row >= [filterTypes count]) {
        [cell.title setHidden:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        [cell.title setHidden:NO];
    }
    
    
    ApplyCategory *item = [filterTypes objectAtIndex:indexPath.row];
    cell.title.text = item.name;
    cell.tag = indexPath.row;
    [cell setCell];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self searchDismissKeyBoard];
    
    if (indexPath.row >= [filterTypes count]) {
        return;
    }
    
    if ([delegate respondsToSelector:@selector(applyTypeSearch:didSelectWithObject:)]) {
        [delegate applyTypeSearch:self didSelectWithObject:[filterTypes objectAtIndex:indexPath.row]];
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
        [self.filterTypes removeAllObjects];
        self.filterTypes = [[NSMutableArray alloc] initWithArray:applyTypes];
        [tableView reloadData];
        return;
    }
    [filterTypes removeAllObjects];
    
    for (int i = 0; i<[applyTypes count]; i++) {
        GiftProductCategory* item = [applyTypes objectAtIndex:i];
        NSRange range = [item.name rangeOfString:searchText];
        
        if (range.location != NSNotFound){
            [filterTypes addObject:item];
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

-(void)viewWillDisappear:(BOOL)animated{
    /*
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
     [actionSheet showInView:(APPDELEGATE).drawerController.view];
     }*/
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    /*
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
     */
}

-(void)saveFavorate{
    /*
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
     hud.mode = MBProgressHUDModeCustomView;
     hud.labelText = NSLocalizedString(@"loading", @"");
     
     NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:(APPDELEGATE).currentUser,@"user",[LOCALMANAGER getFavCustomers],@"favCustomers", [LOCALMANAGER getFavPatrolCategories],@"favPatrolCategories",nil];
     (APPDELEGATE).agent.delegate = self;
     
     if (DONE != [(APPDELEGATE).agent sendRequestWithType:RequestTypeFavSave param:params]) {
     HUDHIDE2;
     [MESSAGE showMessageWithTitle:NSLocalizedString(@"my_favorate", @"")
     description:NSLocalizedString(@"error_connect_server", @"")
     type:MessageBarMessageTypeError
     forDuration:ERR_MSG_DURATION];
     }
     [params release];
     */
}

- (void) didReceiveMessage:(id)message{
    /*ClientResponse* cr = [ClientResponse parseFromData:message];
     
     switch (cr.type) {
     case RequestTypeFavSave:{
     HUDHIDE2;
     if (([cr.code isEqual: NS_RESULTCODE(ResultCodeResponseDone)])){
     (APPDELEGATE).bChangeFavorate = NO;
     }
     [super showMessage2:cr Title:NSLocalizedString(@"my_favorate", @"") Description:NSLocalizedString(@"favorate_commit_done", @"")];
     }
     break;
     }*/
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
