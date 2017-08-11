//
//  MainMenuViewController.m
//  SalesManager
//
//  Created by liu xueyan on 7/30/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MenuItem.h"
#import "MainMenuCell.h"
#import "MainMenuSection.h"
#import "AppDelegate.h"
#import "MainFunctionViewController.h"
#import "LocalManager.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"

@interface MainMenuViewController (){
    int selectedItem;
}

@end

@implementation MainMenuViewController

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
    appDelegate = APPDELEGATE;
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main"]]];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_top"] forBarMetrics:UIBarMetricsDefault];
        UIView* statusView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, MAINWIDTH, 20)];
        [statusView setBackgroundColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar addSubview:statusView];
        [statusView release];
    }
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton* bDb = [UIButton buttonWithType:UIButtonTypeCustom];
    [bDb setFrame:CGRectMake(0, 10, 25, 25)];
    bDb.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
    [bDb setTitle:[NSString fontAwesomeIconStringForEnum:ICON_BACK] forState:UIControlStateNormal] ;
    //[bDb setBackgroundImage:[UIImage imageNamed:@"topbar_button_goback"] forState:UIControlStateNormal];
    [bDb setTitleColor:WT_RED forState:UIControlStateNormal];
    [leftView addSubview:bDb];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftView addGestureRecognizer:tapGesture];
    [tapGesture release];
    self.view.userInteractionEnabled = YES;
    
    UILabel *lblFunctionName = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 240, 44)];
    lblFunctionName.textColor = [UIColor brownColor];
    lblFunctionName.font = [UIFont boldSystemFontOfSize: 20.0];
    [lblFunctionName setBackgroundColor:[UIColor clearColor]];
    lblFunctionName.text = NSLocalizedString(@"menu_function_dashboard_1",@"");
    [leftView addSubview:lblFunctionName];
    [lblFunctionName release];
    
    
    /*
     lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
     lblTitle.textColor = [UIColor brownColor];
     lblTitle.font = [UIFont boldSystemFontOfSize: 20.0];
     [lblTitle setBackgroundColor:[UIColor clearColor]];
     lblTitle.text = NSLocalizedString(@"menu_function_dashboard",@"");
     lblTitle.textAlignment = NSTextAlignmentCenter;
     self.navigationItem.titleView = lblTitle;
     */
    
    [leftView addGestureRecognizer:tapGesture];
    UIBarButtonItem *btLogo = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.navigationItem.leftBarButtonItem = btLogo;
    [btLogo release];
    [leftView release];
    
    
    [self initData];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_menu"]]];
    
    CGSize logoSize = CGSizeMake(100, 100);
    UIImageView *logoBg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.tableView.bounds)-logoSize.width/2.0,
                                                                     -logoSize.height,
                                                                     logoSize.width,
                                                                     logoSize.height)];

    [logoBg setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.tableView addSubview:logoBg];
    
    //[self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_menu"]]];
    [self.tableView setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_menu"]] autorelease]];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData)
												 name:SYNC_NOTIFICATION_MENU object:nil];
    //[self.tableView reloadData]
    selectedItem = 0;
}

-(void)clickLeftButton:(id)sender{
    [APPDELEGATE.drawerController.navigationController popViewControllerAnimated:YES];
}

-(void)initData{
    
    NSMutableArray* userFunc = [LOCALMANAGER getFunctions];
    
    [menuItems removeAllObjects];
    menuItems =  [[NSMutableArray alloc] initWithCapacity:12];
    [othermenuItems removeAllObjects];
    othermenuItems =  [[NSMutableArray alloc] initWithCapacity:2];
    /*
    MenuItem *item = [[MenuItem alloc] init];
    item.image = [NSString fontAwesomeIconStringForEnum:ICON_HOME];
    item.name = NSLocalizedString(@"menu_function_dashboard_1", @"");
    item.functionId = FUNC_DASHBOARD;
    [menuItems addObject:item];
    */
    
    

    for (Function* f in userFunc){
        if ([FUNC_ATTENDANCE_DES isEqual: f.value]){
            MenuItem *item1 = [[MenuItem alloc] init];
            item1.image = [NSString fontAwesomeIconStringForEnum:ICON_ATTENDANCE];
            item1.name = f.name;
            item1.functionId = FUNC_ATTENDANCE;
            [menuItems addObject:item1];
        }
        if ([FUNC_PATROL_DES isEqual: f.value]){
            MenuItem *item2 = [[MenuItem alloc] init];
            item2.image = [NSString fontAwesomeIconStringForEnum:ICON_PATROL];
            item2.name = f.name;
            item2.functionId = FUNC_PATROL;
            [menuItems addObject:item2];
        }
        if ([FUNC_WORKLOG_DES isEqual: f.value]){
            MenuItem *item3 = [[MenuItem alloc] init];
            item3.image = [NSString fontAwesomeIconStringForEnum:ICON_WORKLOG];
            item3.name = f.name;
            item3.functionId = FUNC_WORKLOG;
            [menuItems addObject:item3];
        }
        if ([FUNC_PATROL_TASK_DES isEqual: f.value]){
            MenuItem *item2 = [[MenuItem alloc] init];
            item2.image = [NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL];
            item2.name = f.name;
            item2.functionId = FUNC_PATROL_TASK;
            [menuItems addObject:item2];
        }
        if ([FUNC_RESEARSH_DES isEqual: f.value]){
            MenuItem *item2 = [[MenuItem alloc] init];
            item2.image = [NSString fontAwesomeIconStringForEnum:ICON_MARKET_RESEARCH];
            item2.name = f.name;
            item2.functionId = FUNC_RESEARSH;
            [menuItems addObject:item2];
        }
        if ([FUNC_BIZOPP_DES isEqual: f.value]){
            MenuItem *item2 = [[MenuItem alloc] init];
            item2.image = [NSString fontAwesomeIconStringForEnum:ICON_BUSSINESS_OPPORTUNITY];
            item2.name = f.name;
            item2.functionId = FUNC_BIZOPP;
            [menuItems addObject:item2];
        }
        if ([FUNC_APPROVE_DES isEqual: f.value]){
            MenuItem *item2 = [[MenuItem alloc] init];
            item2.image = [NSString fontAwesomeIconStringForEnum:ICON_APPROVE];
            item2.name = f.name;
            item2.functionId = FUNC_APPROVE;
            [menuItems addObject:item2];
        }
        if ([FUNC_TASK_DES isEqual: f.value]){
            MenuItem *item2 = [[MenuItem alloc] init];
            item2.image = [NSString fontAwesomeIconStringForEnum:ICON_TASK_PATROL];
            item2.name = f.name;
            item2.functionId = FUNC_TASK;
            [menuItems addObject:item2];
        }
        
        if ([FUNC_COMPETITION_DES isEqual: f.value]){
            MenuItem *item16 = [[MenuItem alloc] init];
            item16.image = [NSString fontAwesomeIconStringForEnum:ICON_COMPETITION];
            item16.name = f.name;
            item16.functionId = FUNC_COMPETITION;
            [menuItems addObject:item16];
        }
        if ([FUNC_SELL_TODAY_DES isEqual: f.value]){
            MenuItem *item15 = [[MenuItem alloc] init];
            item15.image = [NSString fontAwesomeIconStringForEnum:ICON_SELL_TODAY];
            item15.name = f.name;
            item15.functionId = FUNC_SELL_TODAY;
            [menuItems addObject:item15];
        }
        if ([FUNC_SELL_ORDER_DES isEqual: f.value]){
            MenuItem *item4 = [[MenuItem alloc] init];
            item4.image = [NSString fontAwesomeIconStringForEnum:ICON_SELL_ORDER];
            item4.name = f.name;
            item4.functionId = FUNC_SELL_ORDER;
            [menuItems addObject:item4];
        }
        if ([FUNC_SELL_STOCK_DES isEqual: f.value]){
            MenuItem *item5 = [[MenuItem alloc] init];
            item5.image = [NSString fontAwesomeIconStringForEnum:ICON_SELL_STOCK];
            item5.name = f.name;
            item5.functionId = FUNC_SELL_STOCK;
            [menuItems addObject:item5];
        }
        
        if ([FUNC_SELL_REPORT_DES isEqual: f.value]){
            MenuItem *item6 = [[MenuItem alloc] init];
            item6.image = [NSString fontAwesomeIconStringForEnum:ICON_BUSSINESS_OPPORTUNITY];
            item6.name = f.name;
            item6.functionId = FUNC_SELL_REPORT;
            [menuItems addObject:item6];
        }
        if ([FUNC_GIFT_DES isEqual: f.value]){
            MenuItem *item4 = [[MenuItem alloc] init];
            item4.image = [NSString fontAwesomeIconStringForEnum:ICON_GIFT];
            item4.name = f.name;
            item4.functionId = FUNC_GIFT;
            [menuItems addObject:item4];
        }
        if ([FUNC_INSPECTION_DES isEqual: f.value]){
            MenuItem *item4 = [[MenuItem alloc] init];
            item4.image = [NSString fontAwesomeIconStringForEnum:ICON_INPECTION];
            item4.name = f.name;
            item4.functionId = FUNC_INSPECTION;
            [menuItems addObject:item4];
        }
        if ([FUNC_VIDEO_DES isEqual: f.value]){
            MenuItem *item4 = [[MenuItem alloc] init];
            item4.image = [NSString fontAwesomeIconStringForEnum:ICON_VIDEO];
            item4.name = f.name;
            item4.functionId = FUNC_VIDEO;
            [menuItems addObject:item4];
        }
        if ([FUNC_MESSAGE_DES isEqualToString:f.value]) {
            MenuItem *item7 = [[MenuItem alloc] init];
            item7.image = [NSString fontAwesomeIconStringForEnum:ICON_MESSAGE];
            item7.name = f.name;
            item7.functionId = FUNC_MESSAGE;
            [menuItems addObject:item7];
        }
        if ([FUNC_SPACE_DES isEqualToString:f.value]) {
            MenuItem *item8 = [[MenuItem alloc] init];
            item8.image = [NSString fontAwesomeIconStringForEnum:ICON_COMPANY_SPACE];
            item8.name = f.name;
            item8.functionId = FUNC_SPACE;
            [menuItems addObject:item8];
        }
        
        if ([FUNC_PAPER_POST_DES isEqualToString:f.value]) {
            MenuItem *item9 = [[MenuItem alloc] init];
            item9.image = [NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD];
            item9.name = f.name;
            item9.functionId = FUNC_PAPER_POST;
            [menuItems addObject:item9];
        }

        if ([FUNC_HOLIDAY_DES isEqualToString:f.value]) {
            MenuItem *item10 = [[MenuItem alloc] init];
            item10.image = [NSString fontAwesomeIconStringForEnum:FAPlane];
            item10.name = f.name;
            item10.functionId = FUNC_HOLIDAY;
            [menuItems addObject:item10];
        }

    }
    
    
    /*
    for (Function* f in userFunc){
        if ([@"END_CONTACT" isEqual: f.value]){
            MenuItem *item17 = [[MenuItem alloc] init];
            item17.image = @"ic_customer_contact_menu";
            item17.name = NSLocalizedString(@"customer_contacts_book", @"");
            item17.functionId = FUNC_CUSTOMER_CONTACT;
            [menuItems addObject:item17];
        }
    }
    
    for (Function* f in userFunc){
        if ([@"COMPANY_CONTACT" isEqual: f.value]){
            MenuItem *item14 = [[MenuItem alloc] init];
            item14.image = @"ic_company_contact_menu";
            item14.name = NSLocalizedString(@"contacts_book", nil);
            item14.functionId = FUNC_COMPANY_CONTACT;
            [menuItems addObject:item14];
        }
    }
    */
    BOOL bHasCustomer = NO;
    for (Function* f in userFunc){
        if ([FUNC_CUSTOMER_CONTACT_DES isEqual: f.value]){
            bHasCustomer = YES;
            break;
        }
    }
    BOOL bHasCompany = NO;
    for (Function* f in userFunc){
        if ([FUNC_COMPANY_CONTACT_DES isEqual: f.value]){
            bHasCompany = YES;
            break;
        }
    }
    if (bHasCustomer && bHasCompany) {
        MenuItem *item14 = [[MenuItem alloc] init];
        item14.image = [NSString fontAwesomeIconStringForEnum:ICON_CONTACT];
        item14.name = NSLocalizedString(@"contacts", nil);
        item14.functionId = FUNC_CONTACTS;
        [menuItems addObject:item14];
    }else if(bHasCustomer){
        MenuItem *item17 = [[MenuItem alloc] init];
        item17.image =[NSString fontAwesomeIconStringForEnum:ICON_CONTACT];
        item17.name = NSLocalizedString(@"contacts", @"");
        item17.functionId = FUNC_CUSTOMER_CONTACT;
        [menuItems addObject:item17];
    }else if(bHasCompany){
        MenuItem *item14 = [[MenuItem alloc] init];
        item14.image = [NSString fontAwesomeIconStringForEnum:ICON_CONTACT];
        item14.name = NSLocalizedString(@"contacts", nil);
        item14.functionId = FUNC_COMPANY_CONTACT;
        [menuItems addObject:item14];
    }
    
    MenuItem *item13 = [[MenuItem alloc] init];
    item13.image = [NSString fontAwesomeIconStringForEnum:ICON_FAV];
    item13.name = NSLocalizedString(@"my_favorate", nil);
    item13.functionId = FUNC_FAVORATE;
    [menuItems addObject:item13];
    
    MenuItem *item8 = [[MenuItem alloc] init];
    item8.image = [NSString fontAwesomeIconStringForEnum:ICON_CHANGE_PWD];
    item8.name = NSLocalizedString(@"menu_function_changepwd", @"");
    item8.functionId = FUNC_CHANGE_PASSWORD;
    [menuItems addObject:item8];
    
    MenuItem *item9 = [[MenuItem alloc] init];
    item9.image = [NSString fontAwesomeIconStringForEnum:ICON_DATA_SYNC];
    item9.name = NSLocalizedString(@"menu_function_datasync", @"");
    item9.functionId = FUNC_SYNC;
    [menuItems addObject:item9];
    /*
    MenuItem *item10 = [[MenuItem alloc] init];
    item10.image = [NSString fontAwesomeIconStringForEnum:ICON_LOGOUT];
    item10.name = NSLocalizedString(@"menu_function_logout", @"");
    item10.functionId = FUNC_LOGOUT;
    [menuItems addObject:item10];*/
    
    MenuItem *item12 = [[MenuItem alloc] init];
    item12.image = [NSString fontAwesomeIconStringForEnum:ICON_CLOUD_UPLOAD];
    item12.name = NSLocalizedString(@"menu_other_checkversion", @"");
    item12.functionId = FUNC_CHECK_VERSION;
    [othermenuItems addObject:item12];
    
    MenuItem *item11 = [[MenuItem alloc] init];
    item11.image = [NSString fontAwesomeIconStringForEnum:ICON_COPYRIGHT];
    item11.name = NSLocalizedString(@"menu_other_copyright", @"");
    item11.functionId = FUNC_ABOUT;
    [othermenuItems addObject:item11];
    
    
    
    [self.tableView reloadData];
    NSIndexPath *home = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:home animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    //self.navigationController.navigationBarHidden=YES;
    //NSLog(@"view appear");
}

-(void)viewDidAppear:(BOOL)animated{
    //NSLog(@"did appear");

}

-(int)findFunction:(int)functionId{

    for (MenuItem *item in menuItems) {
        if (functionId == item.functionId) {
            return item.row;
        }
    }
    return 0;
}

-(void)selectCell:(int)functionId{
    [self resetTableCell];
    if ((functionId == FUNC_COMPANY_CONTACT) || (functionId == FUNC_CUSTOMER_CONTACT)) {
        functionId = FUNC_CONTACTS;
    }
    [self setTableCell:functionId];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self findFunction:functionId] inSection:0];
    //[self.tableView selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionBottom];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [menuItems count];
    }else{
        
        return [othermenuItems count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    MainMenuCell *cell=(MainMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"MainMenuCell" owner:self options:nil];
        for(id oneObject in nib)
        {
            if([oneObject isKindOfClass:[MainMenuCell class]])
                cell=(MainMenuCell *)oneObject;
        }
    }
    //[cell setBackgroundView:nil];
    [cell setBackgroundColor:[UIColor clearColor]];
    MenuItem *item = nil;
    if (indexPath.section == 0) {
        item = [menuItems objectAtIndex:indexPath.row];
        ((MenuItem *)[menuItems objectAtIndex:indexPath.row]).row = indexPath.row;
        [cell.title setText:item.name];
        //[cell.icon setImage:[UIImage imageNamed:item.image]];
        //图片来自自定义字体库
		//itemView.imageView.image = menuItem.icon;
        [cell.faIcon setText:item.image];
        cell.faIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
        [cell.faIcon setTextColor:[UIColor whiteColor]];
        
        cell.tag = item.functionId;
    
    }else if (indexPath.section == 1) {
        item = [othermenuItems objectAtIndex:indexPath.row];
       
        [cell.title setText:item.name];
        [cell.faIcon setText:item.image];
        cell.faIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
        [cell.faIcon setTextColor:[UIColor whiteColor]];
        cell.tag = item.functionId;
        
    }
    if (selectedItem == cell.tag) {
        [cell setBackgroundView:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_menu_item_selected"]]autorelease]];
        [cell.title setHighlightedTextColor:WT_RED];
    }else{
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [sectionV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_menu"]]];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    title.textColor = [UIColor whiteColor];
    [title setBackgroundColor:[UIColor clearColor]];
    if (section == 0) {
        title.text = NSLocalizedString(@"menu_category_function",@"");
    }else if(section == 1){
        title.text = NSLocalizedString(@"menu_category_other",@"");
    }
    UIImageView *seporater = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
    [seporater setImage:[UIImage imageNamed:@"ic_line_list"]];
    [sectionV addSubview:title];
    [sectionV addSubview:seporater];

    return sectionV;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuItem* item = nil;
    [self resetTableCell];
    if (indexPath.section == 0) {
        /*
        if (indexPath.row == 0) {
            [APPDELEGATE.drawerController.navigationController popViewControllerAnimated:YES];
            return;
        }
         */
        item = [menuItems objectAtIndex:indexPath.row];
    }
    else{
        item = [othermenuItems objectAtIndex:indexPath.row];
    }
    
    if (item != nil){
        [self showCtrl:item.functionId];
        selectedItem = item.functionId;
        MainMenuCell* cell = (MainMenuCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.selectedBackgroundView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_menu_item_selected"]]autorelease];
        cell.title.highlightedTextColor=WT_RED;
    }
}

-(void) resetTableCell{
    NSInteger sections = self.tableView.numberOfSections;
    for (int section = 0; section < sections; section++) {
        NSInteger rows =  [self.tableView numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            MainMenuCell* cell = (MainMenuCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            [cell setBackgroundView:nil];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
    }
    [self.tableView reloadData];
}

-(void) setTableCell:(int) funId{
    selectedItem = funId;
    [self.tableView reloadData];
}

- (void) showCtrl:(int) funcid{
    switch (funcid){
        case FUNC_DASHBOARD:
            [appDelegate.drawerController setCenterViewController:appDelegate.mainFunctionNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_ATTENDANCE:
            [appDelegate.drawerController setCenterViewController:appDelegate.attendanceNavCtrl withCloseAnimation:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshChenkInshit" object:nil];
            break;
        case FUNC_PATROL:
            [appDelegate.drawerController setCenterViewController:appDelegate.patrolNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_PATROL_TASK:
            [appDelegate.drawerController setCenterViewController:appDelegate.patrolTaskNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_WORKLOG:
            [appDelegate.drawerController setCenterViewController:appDelegate.worklogNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_SELL_ORDER:
            [appDelegate.drawerController setCenterViewController:appDelegate.orderNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_SELL_STOCK:
            [appDelegate.drawerController setCenterViewController:appDelegate.stockNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_SELL_REPORT:
            [appDelegate.drawerController setCenterViewController:appDelegate.salestatisticsNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_MESSAGE:
            [appDelegate.drawerController setCenterViewController:appDelegate.myMessageNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_CHANGE_PASSWORD:
            [appDelegate.drawerController setCenterViewController:appDelegate.changePwdNavController withCloseAnimation:YES completion:nil];
            break;
        case FUNC_SYNC:
            [appDelegate.drawerController setCenterViewController:appDelegate.datasyncNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_LOGOUT:{
            UIActionSheet *actionSheet =[[UIActionSheet alloc]
                                         initWithTitle:NSLocalizedString(@"msg_system_exit_desc", @"")
                                         delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"no", @"")
                                         destructiveButtonTitle:NSLocalizedString(@"msg_system_exit", @"")
                                         otherButtonTitles:nil,nil];

            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:appDelegate.drawerController.view];
        }
            break;
        case FUNC_ABOUT:
            [appDelegate.drawerController setCenterViewController:appDelegate.settingNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_CHECK_VERSION:{
            if ([appDelegate.agent isExistenceNetwork]){
                [self checkVersion];
            }else{
                [MESSAGE showMessageWithTitle:NSLocalizedString(@"menu_other_checkversion", @"")
                                  description:NSLocalizedString(@"error_network_unfind", @"")
                                         type:MessageBarMessageTypeError
                                  forDuration:ERR_MSG_DURATION];
            }
        }
            
            break;
        case FUNC_FAVORATE:
            [appDelegate.drawerController setCenterViewController:appDelegate.myfavorateNavCtrl withCloseAnimation:YES completion:nil];
            break;

        case FUNC_COMPANY_CONTACT:
            [appDelegate.drawerController setCenterViewController:appDelegate.companyContactNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_CONTACTS:
            [appDelegate.drawerController setCenterViewController:appDelegate.contactsPageNavCtrl withCloseAnimation:YES completion:nil];
            break;
            
        case FUNC_CUSTOMER_CONTACT:
            [appDelegate.drawerController setCenterViewController:appDelegate.endContactNavCtrl withCloseAnimation:YES completion:nil];
            break;


        case FUNC_SELL_TODAY:
            [appDelegate.drawerController setCenterViewController:appDelegate.saleNavCtrl withCloseAnimation:YES completion:nil];
            break;
            
        case FUNC_COMPETITION:
            [appDelegate.drawerController setCenterViewController:appDelegate.competitionNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_RESEARSH:
            [appDelegate.drawerController setCenterViewController:appDelegate.researchNavCtrl withCloseAnimation:YES completion:nil];
            break;
            
        case FUNC_TASK:
            //[appDelegate.drawerController setCenterViewController:appDelegate.taskManageNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_SPACE:
            [appDelegate.drawerController setCenterViewController:appDelegate.spaceNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_INSPECTION:
            [appDelegate.drawerController setCenterViewController:appDelegate.inspectionNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_GIFT:
            [appDelegate.drawerController setCenterViewController:appDelegate.giftNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_APPROVE:
            [appDelegate.drawerController setCenterViewController:appDelegate.applyNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_BIZOPP:
            [appDelegate.drawerController setCenterViewController:appDelegate.bizOppNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_VIDEO:
            [appDelegate.drawerController setCenterViewController:appDelegate.videoNavCtrl withCloseAnimation:YES completion:nil];
            break;
        case FUNC_PAPER_POST:
            if ([LOCALMANAGER getFavPaperTempate] == nil) {
            [appDelegate.drawerController setCenterViewController:appDelegate.paperNavCtrl withCloseAnimation:YES completion:nil];
            }else {
              [appDelegate.drawerController setCenterViewController:appDelegate.dataReportNavCtrl withCloseAnimation:YES completion:nil];
            }
          
            break;
        case FUNC_HOLIDAY :
            [appDelegate.drawerController setCenterViewController:appDelegate.LeaveNavCtrl withCloseAnimation:YES completion:nil];
            break;
            
        default:
            break;
    }
}

-(void)checkVersion{
    [MESSAGE showMessageWithTitle:NSLocalizedString(@"menu_other_checkversion", @"")
                      description:NSLocalizedString(@"msg_update_info", @"")
                             type:MessageBarMessageTypeInfo
                      forDuration:ERR_MSG_DURATION];
    
    [[UpdateVersion sharedInstance] setAppID:@"688032620"];
    
    /* (Optional) Set the Alert Type for your app
     By default, the Singleton is initialized to HarpyAlertTypeOption */
    [[UpdateVersion sharedInstance] setAlertType:AlertTypeOption];
    
    /* (Optional) If your application is not availabe in the U.S. Store, you must specify the two-letter
     country code for the region in which your applicaiton is available in. */
    //[[UpdateVersion sharedInstance] setCountryCode:@"<countryCode>"];
    
    // Perform check for new version of your app
    [[UpdateVersion sharedInstance] checkVersion:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self logout];
        }
            break;
        case 1:{
           
        }
            break;
        default:
            break;
    }
    
}
- (void) logout{
    if(![LOCALMANAGER cleanLoginUser]){
        NSLog(@"clean login user error.");
        return;
    }
    
    [AGENT close];
    //[appDelegate.currentUser release];
    appDelegate.currentUser = nil;
    USER = nil;
    appDelegate.bFirstLogin = TRUE;
    
    NSIndexPath *home = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:home animated:YES scrollPosition:UITableViewScrollPositionBottom];
    //[appDelegate.drawerController setCenterViewController:appDelegate.mainFunctionNavCtrl withCloseAnimation:NO completion:nil];
    
    [VIEWCONTROLLER create:nil ViewId:FUNC_LOGOUT Object:nil Delegate:nil NeedBack:NO];
    [self dismissModalViewControllerAnimated:YES];
    [(APPDELEGATE) releaseAllPage];
}

// User presented with update dialog
- (void)DidShowUpdateDialog{
}

// User did click on button that launched App Store.app
- (void)UserDidLaunchAppStore{
    
}

// User did click on button that skips version update
- (void)UserDidSkipVersion{
    
}

// User did click on button that cancels update dialog
- (void)UserDidCancel{
    
}


@end
