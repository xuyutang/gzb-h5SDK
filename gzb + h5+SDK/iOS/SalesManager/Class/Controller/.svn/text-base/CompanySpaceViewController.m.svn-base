//
//  CompanySpaceViewController.m
//  SalesManager
//
//  Created by 章力 on 14-4-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "CompanySpaceViewController.h"
#import "CompanySpaceDetailViewController.h"
#import "AppDelegate.h"
#import "Constant.h"

@interface CompanySpaceViewController ()<UITableViewDelegate>

@end

@implementation CompanySpaceViewController
@synthesize csCategory,parentCtrl;

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
    self.pullTableView.backgroundColor = WT_WHITE;
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor yellowColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.pullDelegate = self;
    self.pullTableView.sectionFooterHeight = TABLEVIEWHEADERHEIGHT;
    isLoad = NO;
    [lblFunctionName setText:NSLocalizedString(@"zone", @"")];
    itmeArray = [[NSMutableArray alloc] initWithCapacity:10];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setPullTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [pullTableView release];
    [super dealloc];
}

- (void) load{
    if (isLoad)
        return;
    
    if(!pullTableView.pullTableIsRefreshing) {
        self.pullTableView.pullLastRefreshDate = [NSDate date];
        self.pullTableView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
    isLoad = YES;
}


#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    
    if(csParams == nil){
        CompanySpaceParams_Builder* pb = [CompanySpaceParams builder];
        [pb setPage:1];
        [pb setCompanySpaceCategoryId:csCategory.id];
        csParams = [pb build];
    }
    currentPage = 1;
    if (csParams != nil){
        CompanySpaceParams_Builder* pb = [csParams toBuilder];
        [pb setPage:1];
        [pb setCompanySpaceCategoryId:csCategory.id];
        csParams = [[pb build] retain];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeCompanyspaceList param:csParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_space_list", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
        }
    }
    
}

- (void) loadMoreDataToTable
{
    self.pullTableView.pullTableIsLoadingMore = YES;
    if(currentPage*pageSize < totleSize){
        currentPage++;
        CompanySpaceParams_Builder* pb = [csParams toBuilder];
        [pb setPage:currentPage];
        [pb setCompanySpaceCategoryId:csCategory.id];
        
        AGENT.delegate = self;
        if (DONE != [AGENT sendRequestWithType:ActionTypeCompanyspaceList param:csParams]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_space_list", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
        }
    }else{
        self.pullTableView.pullTableIsLoadingMore = NO;
    }

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEWHEADERHEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itmeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnnounceCell";
    UITableViewCell *cell =(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    CompanySpace *a = [itmeArray objectAtIndex:indexPath.row];
    
    NSString *text = a.title;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - 30.0f, 2000.0f);
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text attributes:@{
                                                                                                     NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]
                                                                                                     }];
    CGRect rect = [attributedText boundingRectWithSize:constraint
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    cell.textLabel.text = a.title;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    cell.detailTextLabel.text = a.createDate;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2) - 30.0f, MAX(size.height, 21.0f))];
    [cell.detailTextLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, MAX(size.height, 31.0f), CELL_CONTENT_WIDTH, 21.0f)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([itmeArray count] > 0) {
        CompanySpaceDetailViewController *ctrl = [[CompanySpaceDetailViewController alloc] init];
        ctrl.cSpace = [itmeArray objectAtIndex:indexPath.row];
        UINavigationController *ancNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [APPDELEGATE.spaceController presentModalViewController :ancNavCtrl animated:YES];
        [ctrl release];
    }
}

-(void)clearTable{
    if (itmeArray.count > 0){
        [itmeArray removeAllObjects];
    }
}

- (void) didReceiveMessage:(id)message{
    
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        self.pullTableView.pullTableIsRefreshing = NO;
        self.pullTableView.pullTableIsLoadingMore = NO;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeCompanyspaceList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        PageCompanySpace* pageCompanySpace = [PageCompanySpace parseFromData:cr.data];
        int patrolCount = pageCompanySpace.companySpace.count;
        if (currentPage == 1)
            [self clearTable];
        
        for (int i = 0 ;i < patrolCount;i++){
            CompanySpace* p = (CompanySpace*)[[pageCompanySpace companySpace] objectAtIndex:i];
            [itmeArray addObject:p];
            
        }
        pageSize = pageCompanySpace.page.pageSize;
        totleSize = pageCompanySpace.page.totalSize;

        if (itmeArray.count == 0) {
            
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_space_list", @"")
                              description:NSLocalizedString(@"noresult", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
         
            [self.pullTableView reloadData];
            
            self.pullTableView.pullTableIsRefreshing = NO;
            self.pullTableView.pullTableIsLoadingMore = NO;
             
            return;
        }
    }
    self.pullTableView.pullTableIsRefreshing = NO;
    self.pullTableView.pullTableIsLoadingMore = NO;
    [super showMessage2:cr Title:NSLocalizedString(@"bar_space_list", @"") Description:@""];
    [self.pullTableView reloadData];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
