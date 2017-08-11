//
//  ContactsPageViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-10-10.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "ContactsPageViewController.h"
#import "DAPagesContainer.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "LocalManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "CompanyContactsViewController.h"
#import "CustomerContactsViewController.h"


@interface ContactsPageViewController ()<DAPagesContainerDelegate>
@property (strong, nonatomic) DAPagesContainer *pagesContainer;
@end

@implementation ContactsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init navigationbar
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    lblFunctionName.text = NSLocalizedString(@"contacts", nil);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 15, 30, 30)];
    [listImageView setImage:[UIImage imageNamed:@"ic_message"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSms:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.contentMode = UIViewContentModeScaleAspectFit;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_refresh"]];
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_refresh)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    self.rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    self.pagesContainer.delegate = self;
    
    ctrlArray =[[NSMutableArray alloc] initWithCapacity:2];
    CompanyContactsViewController *spaceViewController1 = [[CompanyContactsViewController alloc] init];
    spaceViewController1.title = TITLENAME(FUNC_COMPANY_CONTACT_DES);
    spaceViewController1.parentCtrl = self;
  
    
    CustomerContactsViewController *spaceViewController2 = [[CustomerContactsViewController alloc] init];
    spaceViewController2.title = TITLENAME(FUNC_CUSTOMER_CONTACT_DES);
    spaceViewController2.parentCtrl = self;
    
    [ctrlArray addObject:spaceViewController2];
    [ctrlArray addObject:spaceViewController1];
    
    self.pagesContainer.viewControllers = ctrlArray;
    
    appDelegate = APPDELEGATE;
    
    if (bNeedBack) {
      leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
}

-(void)clickLeftButton:(id)sender{
    if (bNeedBack){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [super clickLeftButton:sender];
    }
}

-(void)_refresh{
    if (self.pagesContainer.selectedIndex == 0) {
        CompanyContactsViewController *ctrl = [ctrlArray objectAtIndex:0];
        [ctrl reload];
    }
    if (self.pagesContainer.selectedIndex == 1) {
        CustomerContactsViewController *ctrl = [ctrlArray objectAtIndex:1];
        [ctrl reload];
    }
}

-(void)toSms:(id)sender{
    if ([ctrlArray count] > 0) {
        [[ctrlArray objectAtIndex:self.pagesContainer.selectedIndex] toSms:sender];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self toRefresh];
    
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

-(void) didSelected:(int)index{
    if ([ctrlArray count] > 0 && index ==1) {
         [[ctrlArray objectAtIndex:index] reload];
    }
    if (index == 0) {
        [[ctrlArray objectAtIndex:1] searchDismissKeyBoard];
    }else{
        [[ctrlArray objectAtIndex:0] searchDismissKeyBoard];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
