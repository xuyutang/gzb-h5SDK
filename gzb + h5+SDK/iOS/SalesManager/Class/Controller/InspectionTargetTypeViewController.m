//
//  InspectionTargetTypeViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-12-3.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "InspectionTargetTypeViewController.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "CommonCell.h"
#import "MBProgressHUD.h"

@interface InspectionTargetTypeViewController ()

@end

@implementation InspectionTargetTypeViewController
@synthesize targetTypes;
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
    [targetTypes removeAllObjects];
    
    targetTypes = [[NSMutableArray alloc] initWithArray:[LOCALMANAGER getInspectionTypes]];
    self.targetTypes = [NSMutableArray arrayWithArray:targetTypes];
    self.filterTypes = [NSMutableArray arrayWithArray:targetTypes];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    if (bNeedAll) {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
        UILabel *checkAllImageView = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
        //[checkAllImageView setImage:[UIImage imageNamed:@"ic_check_all"]];
        [checkAllImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_SAVE]];
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
    
    if ([targetTypes count]<1) {
        targetTypes = [[NSMutableArray alloc] init];
        [targetTypes addObjectsFromArray:[LOCALMANAGER getInspectionTypes]];
    }
    filterTypes = [[NSMutableArray alloc] initWithArray:targetTypes];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    lblFunctionName.text = NSLocalizedString(@"inspection_label_category",@"");
    targetArray = [[NSMutableArray alloc]init];
    
    [targetArray removeAllObjects];
    [targetArray addObject:@"全部类型"];
    for (InspectionReportCategory* item in targetTypes) {
        [targetArray addObject:item.name];
    }

    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.tableFooterView = [[UIView alloc]init];
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
    if ([delegate respondsToSelector:@selector(targetTypeSearch:didSelectWithObject:)]) {
        [delegate targetTypeSearch:self didSelectWithObject:nil];
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
    return [targetArray count];
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
//    
//    if (indexPath.row >= [filterTypes count]) {
//        [cell.title setHidden:YES];
//        [cell.ivFavorate setHidden:YES];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else{
//        [cell.title setHidden:NO];
//    }
//    [cell.ivFavorate setHidden:YES];
    
    InspectionReportCategory *item = [targetArray objectAtIndex:indexPath.row];
    cell.title.text = item;
    //cell.bFavorate = (indexPath.row == 0) ? YES:NO;
    cell.ivFavorate.hidden = YES;
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell setCell];
    
    return cell;
}


#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self searchDismissKeyBoard];
    
    if (indexPath.row == 0) {
        
        [delegate allTarget];
        [self.view removeFromSuperview];
        return;
    }
    if ([delegate respondsToSelector:@selector(targetTypeSearch:didSelectWithObject:)]) {
        [delegate targetTypeSearch:self didSelectWithObject:[filterTypes objectAtIndex:indexPath.row - 1]];
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
        self.filterTypes = [[NSMutableArray alloc] initWithArray:targetTypes];
        [tableView reloadData];
        return;
    }
    [filterTypes removeAllObjects];
    
    for (int i = 0; i<[targetTypes count]; i++) {
        InspectionReportCategory* item = [targetTypes objectAtIndex:i];
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
        [actionSheet showInView:(APPDELEGATE).drawerController.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //[self saveFavorate];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
