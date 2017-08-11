//
//  videoTypeViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-9-19.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "VideoTypeViewController.h"

@interface VideoTypeViewController ()

@end

@implementation VideoTypeViewController
@synthesize videoTypes;
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
    videoTypes = [[NSMutableArray alloc] initWithCapacity:0];
    filterTypes = [[NSMutableArray alloc] initWithCapacity:0];
    [videoTypes removeAllObjects];
    
    videoTypes = [NSMutableArray arrayWithArray:[LOCALMANAGER getVideoCategories]];
    
    self.videoTypes = [NSMutableArray arrayWithArray:videoTypes];
    self.filterTypes = [NSMutableArray arrayWithArray:videoTypes];
    
}
-(void)setBSearch:(BOOL)bSearch{
    _bSearch = bSearch;
    if (_bSearch) {
        if (_bSearch) {
            VideoCategory_Builder *v = [VideoCategory builder];
            [v setId:-1];
            [v setName:@"全部类型"];
            VideoCategory *vc = [v build];
            [self.videoTypes insertObject:vc atIndex:0];
            [self.filterTypes insertObject:vc atIndex:0 ];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    if (bNeedAll) {
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
        
        UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        self.rightButton = btRight;
        [btRight release];
    }
    
    filterTypes = [[NSMutableArray alloc] initWithArray:videoTypes];
   leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    lblFunctionName.text = NSLocalizedString(@"video_label_category",@"");
//    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
//    [searchBar setBackgroundImage:[UIImage createImageWithColor:WT_WHITE]];
//    //searchBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]];
//    searchBar.delegate = self;
//    [self.view addSubview:searchBar];
//    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, MAINWIDTH, 1)];
//    lineLabel.backgroundColor = WT_GRAY;
//    [self.view addSubview:lineLabel];
//    [lineLabel release];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundView = nil;
    tableView.bounces = NO;
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
        [delegate videoTypeSearch:self didSelectWithObject:nil];
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
    return [filterTypes count]+5;
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
    
    
    VideoCategory *item = [filterTypes objectAtIndex:indexPath.row];
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
    if ([delegate respondsToSelector:@selector(videoTypeSearch:didSelectWithObject:)]) {
        [delegate videoTypeSearch:self didSelectWithObject:[filterTypes objectAtIndex:indexPath.row]];
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
        self.filterTypes = [[NSMutableArray alloc] initWithArray:videoTypes];
        [tableView reloadData];
        return;
    }
    [filterTypes removeAllObjects];
    
    for (int i = 0; i<[videoTypes count]; i++) {
        GiftProductCategory* item = [videoTypes objectAtIndex:i];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
