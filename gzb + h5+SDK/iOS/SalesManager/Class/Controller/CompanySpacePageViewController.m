//
//  CompanySpacePageViewController.m
//  SalesManager
//
//  Created by liuxueyan on 24/4/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "CompanySpacePageViewController.h"
#import "DAPagesContainer.h"
#import "CompanySpaceViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"

@interface CompanySpacePageViewController ()<DAPagesContainerDelegate>
@property (strong, nonatomic) DAPagesContainer *pagesContainer;
@end

@implementation CompanySpacePageViewController

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
    
    //init navigationbar
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [lblFunctionName setText:TITLENAME(FUNC_SPACE_DES)];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    UIImageView *freshImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 25, 25)];
    [freshImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    freshImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toRefresh)];
    [tapGesture2 setNumberOfTapsRequired:1];
    freshImageView.contentMode = UIViewContentModeScaleAspectFit;
    [freshImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:freshImageView];
    [freshImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.rightButton = btRight;
    [btRight release];

    
    
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;
    
    spaceCategories = [[PBAppendableArray alloc] init];
    
    appDelegate = APPDELEGATE;
    [self toRefresh];
}

-(void)syncTitle {
 [lblFunctionName setText:TITLENAME(FUNC_SPACE_DES)];
}

-(void)toRefresh{

    if(self.pagesContainer != nil){
        
        [self.pagesContainer.view removeFromSuperview];
        [self.pagesContainer release];
    }
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;
    [self _load];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self toRefresh];
    
}

- (void) _load{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");

    AGENT.delegate = self;
    if (DONE != [AGENT sendRequestWithType:ActionTypeCompanyspaceCategoryList param:self]){
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SPACE_DES)
                          description:NSLocalizedString(@"error_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }

}

-(void)EScrollerViewEnableScroll:(BOOL)bEnable{
    
    self.pagesContainer.scrollView.userInteractionEnabled = bEnable;
    
}

-(IBAction)leftButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) _clear{
    if (spaceCategories.count > 0){
        [spaceCategories release];
    }
    if (ctrlArray.count >0) {
        for (UIViewController *ctrl in ctrlArray) {
            [ctrl.view removeFromSuperview];
            [ctrl release];
        }
        [ctrlArray removeAllObjects];
        //self.pagesContainer.viewControllers = ctrlArray;
    }
    spaceCategories = [[PBAppendableArray alloc] init];
}

-(void) didSelected:(int)index{
    if ([ctrlArray count] > 0) {
        [((CompanySpaceViewController*)[ctrlArray objectAtIndex:index]) load];
    }
}

#pragma receive message

- (void) didReceiveMessage:(id)message{
    HUDHIDE2;
    SessionResponse* cr = [SessionResponse parseFromData:(NSData*)message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    if ((INT_ACTIONTYPE(cr.type) == ActionTypeCompanyspaceCategoryList) && ([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
        [self _clear];
        
        if (cr.datas.count == 0) {
            [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SPACE_DES)
                              description:NSLocalizedString(@"noresult", @"")
                                     type:MessageBarMessageTypeInfo
                              forDuration:INFO_MSG_DURATION];
        }else{
            [spaceCategories appendArray:[cr.datas retain]];
            ctrlArray =[[NSMutableArray alloc] initWithCapacity:[spaceCategories count]];
            for (int i= 0; i < [spaceCategories count]; i++) {
                CompanySpaceCategory* t = [CompanySpaceCategory parseFromData:[spaceCategories objectAtIndex:i]];
                if ([super validateData:t]) {
                    CompanySpaceViewController *spaceViewController = [[CompanySpaceViewController alloc] init];
                    spaceViewController.title = t.name;
                    spaceViewController.parentCtrl = self;
                    //zoneViewController.imgScrollView.delegate = self;
                    spaceViewController.csCategory = t;
                    [ctrlArray addObject:spaceViewController];
                }
                
            }
            
            self.pagesContainer.viewControllers = ctrlArray;
        }
    //[super showMessage2:cr Title:NSLocalizedString(@"msg_info", @"") Description:@""];
    }
}



@end
