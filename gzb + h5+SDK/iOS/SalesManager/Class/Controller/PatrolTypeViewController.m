//
//  PatrolTypeViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/3/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "PatrolTypeViewController.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "CommonCell.h"
#import "MBProgressHUD.h"

@interface PatrolTypeViewController ()

@end

@implementation PatrolTypeViewController
@synthesize patrolTypes;
@synthesize filterTypes;
@synthesize tableView;
@synthesize delegate;
@synthesize bFavorate;
@synthesize bNeedAll;
@synthesize hidenBool;
@synthesize allBool;

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
//    [patrolTypes removeAllObjects];
//    
//    
//    self.patrolTypes = [NSMutableArray arrayWithArray:patrolTypes];
//    self.filterTypes = [NSMutableArray arrayWithArray:patrolTypes];
    [patrolTypes removeAllObjects];
    
    patrolTypes = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getPatrolCategories]];
    self.patrolTypes = [NSMutableArray arrayWithArray:patrolTypes];
    self.filterTypes = [NSMutableArray arrayWithArray:patrolTypes];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    if (bNeedAll) {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
        UILabel *checkAllImageView = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
        //[checkAllImageView setImage:[UIImage imageNamed:@"ic_check_all"]];
        [checkAllImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_CHECK_CIRCLE]];
        [checkAllImageView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
        [checkAllImageView setTextColor:WT_RED];
        [checkAllImageView setTextAlignment:UITextAlignmentCenter];
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
    
    if ([patrolTypes count]<1) {
        NSMutableArray *tmpArray = [LOCALMANAGER getFavPatrolCategories];
        if (tmpArray != nil && [tmpArray count]>0) {
            myFavorate = [[tmpArray objectAtIndex:0] retain];
        }
        patrolTypes = [[NSMutableArray alloc] init];
        [patrolTypes addObjectsFromArray:[LOCALMANAGER getPatrolCategories]];
        NSLog(@"%@",patrolTypes);
        if (myFavorate != nil) {
            [patrolTypes removeObject:myFavorate];
            [patrolTypes insertObject:myFavorate atIndex:0];
        }
    }
    filterTypes = [[NSMutableArray alloc] initWithArray:patrolTypes];
    
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    lblFunctionName.text = NSLocalizedString(@"patrol_label_category",@"");
//    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [searchBar setBackgroundImage:[UIImage createImageWithColor:WT_RED]];
//    //searchBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]];
//    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
//    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    if (bFavorate) {
        tableView.allowsSelection = NO;
    }else{
        tableView.allowsSelection = YES;
    }
    [tableView setBackgroundColor:[UIColor whiteColor]];
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
        [delegate patrolSearch:self didSelectWithObject:nil];
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
    
    [mulArray removeAllObjects];
    mulArray = [[NSMutableArray alloc]init];
    
    if (allBool) {
        [mulArray addObject:@"全部类型"];
    }
    
    for (PatrolCategory* item in patrolTypes) {
        [mulArray addObject:item.name];
    }
    
    if (allBool) {
        return mulArray.count;
    }
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
    
//    if (indexPath.row >= [filterTypes count]) {
//        [cell.title setHidden:YES];
//        [cell.ivFavorate setHidden:YES];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else{
//        [cell.title setHidden:NO];
//        [cell.ivFavorate setHidden:NO];
//    }
//    [ggg removeAllObjects];
//     ggg = [[NSMutableArray alloc]init];
//    
//    if (allBool) {
//         [ggg addObject:@"全部类型"];
//    }
//   
//    for (PatrolCategory* item in patrolTypes) {
//        [ggg addObject:item.name];
//    }
//
    PatrolCategory *itemm = [mulArray objectAtIndex:indexPath.row];
    cell.title.text = itemm;
    cell.bFavorate = (indexPath.row == 0) ? YES:NO;
    cell.delegate = self;
    cell.tag = indexPath.row;
   

    if (hidenBool) {
        cell.ivFavorate.hidden = YES;
    } else {
       cell.ivFavorate.hidden = NO;
    }
  
    [cell setCell];
    
    return cell;
}

-(void)clickFavorate:(int)index favorate:(BOOL)bFavorate{
    
    //(APPDELEGATE).bChangeFavorate = YES;
    (APPDELEGATE).bChangeFavorate = NO;
    if (index != 0) {
        [LOCALMANAGER favPatrolCategory:[filterTypes objectAtIndex:0] Fav:0];
    }
    [LOCALMANAGER favPatrolCategory:[filterTypes objectAtIndex:index] Fav:bFavorate];
    
    [filterTypes removeAllObjects];
    [patrolTypes removeAllObjects];
    if ([patrolTypes count]<1) {

        NSMutableArray *tmpArray = [LOCALMANAGER getFavPatrolCategories];
        if (tmpArray != nil && [tmpArray count]>0) {
            myFavorate = [[tmpArray objectAtIndex:0] retain];
        }
        patrolTypes = [[NSMutableArray alloc] init];
        [patrolTypes addObjectsFromArray:[LOCALMANAGER getPatrolCategories]];
        if (myFavorate != nil) {
            [patrolTypes removeObject:myFavorate];
            [patrolTypes insertObject:myFavorate atIndex:0];
        }
    }
    filterTypes = [[NSMutableArray alloc] initWithArray:patrolTypes];
    
    [tableView reloadData];
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self searchDismissKeyBoard];
    
    if (allBool) {
        if (indexPath.row == 0) {
            [self.view removeFromSuperview];
            [delegate allCatgory];
            return;
        }
        if ([delegate respondsToSelector:@selector(patrolSearch:didSelectWithObject:)]) {
            [delegate patrolSearch:self didSelectWithObject:[filterTypes objectAtIndex:indexPath.row - 1]];
        }
        [self dismissModalViewControllerAnimated:YES];
    }else {
        if ([delegate respondsToSelector:@selector(patrolSearch:didSelectWithObject:)]) {
            [delegate patrolSearch:self didSelectWithObject:[filterTypes objectAtIndex:indexPath.row]];
        }
        [self dismissModalViewControllerAnimated:YES];
    }
   
    
}


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
        self.filterTypes = [[NSMutableArray alloc] initWithArray:patrolTypes];
        [tableView reloadData];
        return;
    }
    [filterTypes removeAllObjects];
    
    for (int i = 0; i<[patrolTypes count]; i++) {
        PatrolCategory* item = [patrolTypes objectAtIndex:i];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
