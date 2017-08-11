//
//  UserSelectViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/5/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "UserSelectViewController.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "Constant.h"

@interface UserSelectViewController (){
    NSString* searchContent;
}

@end

@implementation UserSelectViewController
@synthesize delegate,bAllUsers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDataList:(NSArray *)users delegate:(id<UserSearchDelegate>)delegate{
    
    if (self = [super init]) {
        self.users = [NSMutableArray arrayWithArray:users];
        self.filterUsers = [NSMutableArray arrayWithArray:users];
        self.delegate = delegate;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *checkAllImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
    [checkAllImageView setImage:[UIImage imageNamed:@"ic_check_all"]];
    checkAllImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAll)];
    [tapGesture1 setNumberOfTapsRequired:1];
    checkAllImageView.contentMode = UIViewContentModeScaleAspectFit;
    [checkAllImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:checkAllImageView];
    [checkAllImageView release];
    [tapGesture1 release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];

    if (bAllUsers) {
        users = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getAllUsers]];
    }else{
        users = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getUsers]];
    }
    
    filterUsers = [[NSMutableArray alloc] initWithArray:users];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    lblFunctionName.text = NSLocalizedString(@"user_select",@"");
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [searchBar setBackgroundImage:[UIImage createImageWithColor:WT_RED]];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, MAINWIDTH, MAINHEIGHT - 44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.allowsSelection = YES;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
    
}

-(void)selectAll{

    [self searchDismissKeyBoard];
    if ([delegate respondsToSelector:@selector(userSearch:didSelectWithObject:)]) {
        [delegate userSearch:self didSelectWithObject:nil];
    }
    [self dismissModalViewControllerAnimated:YES];

}

-(void)clickLeftButton:(id)sender{
    /*if (!searchContent.isEmpty) {
        User_Builder* ub = [User builder];
        UserV1_Builder* ubv1 = [UserV1 builder];
        [ubv1 setId:0];
        [ubv1 setRealName:searchContent];
        [ub setVersion:ubv1.version];
        [ub setV1:[ubv1 build]];
        
        if ([delegate respondsToSelector:@selector(userSearch:didSelectWithObject:)]) {
            [delegate userSearch:self didSelectWithObject:[ub build]];
        }
    }*/
    [self searchDismissKeyBoard];
    [self dismissModalViewControllerAnimated:YES];
    [self cancel];
    
}


- (void)cancel
{
    if ([delegate respondsToSelector:@selector(userSearchDidCanceled:)]) {
        [delegate userSearchDidCanceled:self];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filterUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    if (indexPath.row >= [filterUsers count]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    User *item = [filterUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = item.realName;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self searchDismissKeyBoard];
    
    if (indexPath.row >= [filterUsers count]) {
        return;
    }
    if ([delegate respondsToSelector:@selector(userSearch:didSelectWithObject:)]) {
        [delegate userSearch:self didSelectWithObject:[filterUsers objectAtIndex:indexPath.row]];
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
    searchContent = [searchText retain];
    if ([searchText isEqualToString:@""]) {
        [self.filterUsers removeAllObjects];
        self.filterUsers = [[NSMutableArray alloc] initWithArray:users];
        [tableView reloadData];
        return;
    }
    [filterUsers removeAllObjects];
    
    for (int i = 0; i<[users count]; i++) {
        User* item = [users objectAtIndex:i];
        NSRange range = [item.realName rangeOfString:searchText];
        
        if (range.location != NSNotFound){
            [filterUsers addObject:item];
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

@end
