//
//  PatrolPictureListViewController.m
//  SalesManager
//
//  Created by ZhangLi on 14-1-9.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "PatrolPictureListViewController.h"
#import "PatrolSearchViewController.h"
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"
#import "AppDelegate.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "Constant.h"
#import "SDImageView+SDWebCache.h"
#import "BigImageViewController.h"
#import "UIImage+RemoteSize.h"

@interface PatrolPictureListViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate,PatrolSearchDelegate,SRWebSocketDelegate>

@end

@implementation PatrolPictureListViewController
@synthesize images = _images,imageSizes = _imageSizes;

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
    [leftImageView setImage:[UIImage imageNamed:@"topbar_button_goback"]];
    waterFlowView = [[PullWaterflowView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT)];    
    waterFlowView.pullArrowImage = [UIImage imageNamed:@"ic_pull_refresh_blackArrow"];
    waterFlowView.pullBackgroundColor = [UIColor yellowColor];
    waterFlowView.pullTextColor = [UIColor blackColor];
    waterFlowView.delegate = self;
    waterFlowView.dataSource = self;
    waterFlowView.pullDelegate = self;
	
	[self.view addSubview:waterFlowView];

    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    UIImageView *seachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    [seachImageView setImage:[UIImage imageNamed:@"topbar_button_search"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSearchView)];
    [tapGesture1 setNumberOfTapsRequired:1];
    seachImageView.userInteractionEnabled = YES;
    [seachImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:seachImageView];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = btRight;
    [btRight release];
    [rightView release];
    
    currentPage = 1;
    patrolArray = [[NSMutableArray alloc] init];
    _images = [[NSMutableArray alloc] init];
    _imageSizes = [[NSMutableArray alloc] init];
    
    [lblFunctionName setText:NSLocalizedString(@"bar_patrol_picture_list", @"")];
    
    SOCKET.delegate = self;
    
    [self openSearchView];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)clickLeftButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)openSearchView{
    
    PatrolSearchViewController *ctrl = [[PatrolSearchViewController alloc] init];
    ctrl.delegate = self;
    UINavigationController *searchNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentModalViewController:searchNavCtrl animated:YES];
}

-(void)didFinishedSearchWithResult:(PatrolParams_Builder *)result{
    patrolParams = [[[(PatrolParams_Builder *)result setPage:currentPage] build] retain];
    if(!waterFlowView.pullTableIsRefreshing) {
        waterFlowView.pullTableIsRefreshing = YES;
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
    }
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    waterFlowView.pullLastRefreshDate = [NSDate date];
    waterFlowView.pullTableIsRefreshing = YES;
    
    currentPage = 1;
    if (patrolParams != nil){
        patrolParams = [[[[patrolParams toBuilder]setPage:1] build] retain];
        
        NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:USER,@"user", patrolParams,@"patrolparam",nil];
        SOCKET.delegate = self;
        if (DONE != [SOCKET sendRequestWithType:RequestTypePatrolList param:params]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_patrol_picture_list", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
        }
        [params release];
    }
    
}

- (void) loadMoreDataToTable
{
    waterFlowView.pullTableIsLoadingMore = YES;
    
    if(currentPage*pageSize < totleSize){
        currentPage++;
        patrolParams = [[[[patrolParams toBuilder]setPage:currentPage] build] retain];
        
        NSDictionary* params = [[NSDictionary alloc] initWithObjectsAndKeys:USER,@"user", patrolParams,@"patrolparam",nil];
        SOCKET.delegate = self;
        if (DONE != [SOCKET sendRequestWithType:RequestTypePatrolList param:params]){
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_patrol_picture_list", @"")
                              description:NSLocalizedString(@"error_connect_server", @"")
                                     type:MessageBarMessageTypeError
                              forDuration:ERR_MSG_DURATION];
            
            waterFlowView.pullTableIsRefreshing = NO;
            waterFlowView.pullTableIsLoadingMore = NO;
        }
        [params release];
    }else{
        waterFlowView.pullTableIsLoadingMore = NO;
    }
    
}

- (void)PullWaterflowViewDidTriggerRefresh:(PullWaterflowView*)pullWaterflowView{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:RELOAD_DELAY];
}
- (void)PullWaterflowViewDidTriggerLoadMore:(PullWaterflowView*)pullWaterflowView{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:RELOAD_DELAY];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.images count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] autorelease];
    }
    if ([[self.imageSizes objectAtIndex:indexPath.row] CGSizeValue].height == 0) {
        cell.photoView.contentMode = UIViewContentModeScaleAspectFit;
        cell.photoView.image = [UIImage imageNamed:@"ic_default_rect_pic"];
    }else{
        [cell.photoView setImageWithURL:[NSURL URLWithString:[self.images objectAtIndex:indexPath.row]] refreshCache:YES placeholderImage:[UIImage imageNamed:@"ic_default_rect_pic"]];
    }
    cell.titleLabel.text = ((Patrol *)[patrolArray objectAtIndex:indexPath.row]).customer.name;
    return cell;
}

#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
	{
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.imageSizes objectAtIndex:indexPath.row] CGSizeValue].height == 0) {
        return 107.0f;
    }else{
        return ([[self.imageSizes objectAtIndex:indexPath.row] CGSizeValue].height / 2) / [self quiltViewNumberOfColumns:quiltView];
    }
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    Patrol* p = [patrolArray objectAtIndex:indexPath.row];
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [_images objectAtIndex:indexPath.row];
    ctrl.functionName = [NSString stringWithFormat:@"[%@]%@",p.category.name,p.customer.name];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

-(void)clearTable{
    if (_images.count > 0){
        [_images removeAllObjects];
    }
    [LOCALMANAGER clearImages];
    
    if (_imageSizes.count > 0) {
        [_imageSizes removeAllObjects];
    }
    
    if (patrolArray.count > 0) {
        [patrolArray removeAllObjects];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    ClientResponse* cr = [ClientResponse parseFromData:(NSData*)message];
    if ((cr.type == RequestTypePatrolList) && (cr.code == ResultCodeResponseDone)){
        int patrolCount = cr.pagePatrol.patrols.count;
        if (currentPage == 1)
            [self clearTable];
        
        for (int i = 0 ;i < patrolCount;i++){
            Patrol* p = (Patrol*)[[cr.pagePatrol patrols] objectAtIndex:i];
            
            for (int j = 0; j < [p.filePath count]; ++j) {
                [_images addObject:[p.filePath objectAtIndex:j]];
                [patrolArray addObject:p];
            }
        }

        for (int i = 0 ;i < patrolCount;i++){
            Patrol* p = (Patrol*)[[cr.pagePatrol patrols] objectAtIndex:i];
            
            for (int j = 0; j < [p.filePath count]; ++j) {
                [UIImage requestSizeFor:[NSURL URLWithString:[p.filePath objectAtIndex:j]] completion:^(NSURL *imgURL, CGSize size) {
                    //NSLog(@"image %d width:%f,height:%f",j,size.width,size.height);
                    [_imageSizes addObject:[NSValue valueWithCGSize:size]];
                    
                    if (_imageSizes.count == _images.count) {
                        [waterFlowView reloadData];
                        
                        waterFlowView.pullTableIsRefreshing = NO;
                        waterFlowView.pullTableIsLoadingMore = NO;
                    }
                 
                }];
            }
            
        }
        pageSize = cr.pagePatrol.pageSize;
        totleSize = cr.pagePatrol.totalSize;
        
        if (patrolCount == 0) {
            [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_patrol_picture_list", @"")
                              description:NSLocalizedString(@"noresult", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
            
            waterFlowView.pullTableIsRefreshing = NO;
            waterFlowView.pullTableIsLoadingMore = NO;
        }
    }
    [super showMessage2:cr Title:NSLocalizedString(@"bar_patrol_picture_list", @"") Description:@""];
    
    //[waterFlowView reloadData];
    
    //waterFlowView.pullTableIsRefreshing = NO;
    //waterFlowView.pullTableIsLoadingMore = NO;

}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    waterFlowView.pullTableIsRefreshing = NO;
    waterFlowView.pullTableIsLoadingMore = NO;
    
    [super webSocket:webSocket didFailWithError:error];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    waterFlowView.pullTableIsRefreshing = NO;
    waterFlowView.pullTableIsLoadingMore = NO;
    [super webSocket:webSocket didCloseWithCode:code reason:reason wasClean:wasClean];
}

@end
