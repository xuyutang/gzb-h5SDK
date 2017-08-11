//
//  GiftDeliveryViewController.m
//  SalesManager
//
//  Created by liuxueyan on 14-9-22.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "GiftDeliveryViewController.h"
#import "CustomerSelectViewController.h"
#import "DepartmentViewController.h"
#import "ApplyDetailViewController.h"
#import "GiftDeliveryListViewController.h"
#import "ApplyListViewController.h"
#import "SelectCell.h"
#import "LocationCell.h"
#import "BaseTable1HeaderView.h"
#import "BaseTable2HeaderView.h"
#import "BaseTable3HeaderView.h"
#import "GiftProductCell.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface GiftDeliveryViewController ()

@end

@implementation GiftDeliveryViewController
@synthesize parentCtrl;

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autorefreshLocation)
                                                 name:@"update_location"
                                               object:nil];
	rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    [self initData];
    [self initView];
    UILabel *listImageView = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 30, 30)];
    //[listImageView setImage:[UIImage imageNamed:@"topbar_button_list"]];
    [listImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_LIST]];
    [listImageView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
    [listImageView setTextColor:WT_RED];
    [listImageView setTextAlignment:UITextAlignmentCenter];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;
    listImageView.contentMode = UIViewContentModeScaleAspectFit;
    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    
    UILabel *saveImageView = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 30, 30)];
    //[saveImageView setImage:[UIImage imageNamed:@"topbar_button_save"]];
    [saveImageView setText:[NSString fontAwesomeIconStringForEnum:ICON_SAVE]];
    [saveImageView setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:25]];
    [saveImageView setTextColor:WT_RED];
    [saveImageView setTextAlignment:UITextAlignmentCenter];
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture2 setNumberOfTapsRequired:1];
    saveImageView.contentMode = UIViewContentModeScaleAspectFit;
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    UIBarButtonItem *btRight = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    //[btLogo setAction:@selector(clickLeftButton:)];
    self.rightButton = btRight;
    [btRight release];
    
    btNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    [btNumber setFrame:CGRectMake(270, 410, 60, 51)];
    if (IS_IPHONE5) {
        [btNumber setFrame:CGRectMake(270, 500, 60, 51)];
    }
    [btNumber setBackgroundImage:[UIImage imageNamed:@"bg_selected_number"] forState:UIControlStateNormal];
    
    [btNumber setTitle:@"0" forState:UIControlStateNormal];
    [btNumber setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btNumber addTarget:self action:@selector(showTarget) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btNumber];
    
    
    [self initTablesView];
    //[self initView];
    [tableView reloadData];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasSync)
                                                 name:SYNC_NOTIFICATION_MENU object:nil];
}

-(void)hasSync{
    [self initData];
    [tableView reloadData];
    if (liveImageCell != nil) {
        [liveImageCell clearCell];
    }
}


-(void)initView{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if ([productModelArray count]>0) {
        [btNumber setHidden:NO];
    }else{
        [btNumber setHidden:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [btNumber setHidden:YES];
}

-(void)initData{
    searchContent = @"";
    bTargetExpand = YES;
    bProductExpand = YES;
    if (applyItemArray.count) {
        bExpand = YES;
    }
      bEdit = NO;
    currentPage = 1;
    productModelArray = [[NSMutableArray alloc] initWithArray:[[LOCALMANAGER getGiftProductsWithGiftName:@"" CategoryId:0 Index:currentPage] retain]];
    targetModelArray = [[NSMutableArray alloc] initWithCapacity:0];
    applyItemArray = [[NSMutableArray alloc] initWithCapacity:0];
    imageFiles = [[NSMutableArray alloc] initWithCapacity:0];
    departmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    checkedDepartmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [departmentArray removeAllObjects];
    [departmentArray addObjectsFromArray:[[LOCALMANAGER getDepartments] retain]];
    [btNumber setHidden:YES];
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeGiftDeliverySave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [self clearTable];
                
            }
            
            [super showMessage2:cr Title:NSLocalizedString(@"bar_gift_delivery_post", @"") Description:NSLocalizedString(@"gift_delivery_saved", @"")];
        }
            break;
            
            
        default:
            break;
    }
}


-(void)toList:(id)sender{
    NSLog(@"Gift Purchase ViewController to List");
    [self dismissKeyBoard];
    GiftDeliveryListViewController *ctrl = [[GiftDeliveryListViewController alloc] init];
    [self.parentCtrl.navigationController pushViewController:ctrl animated:YES];
    
}

-(void)toSave:(id)sender{
    [self dismissKeyBoard];
    if (imageFiles == nil || [imageFiles count]<1) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_gift_delivery_post", @"")
                          description:NSLocalizedString(@"patrol_hint_files", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    if (checkedDepartmentArray == nil || [checkedDepartmentArray count]<1) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_gift_delivery_post", @"")
                          description:NSLocalizedString(@"gift_delivery_hint_departments", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    
    NSString* comment = tvRemarkCell.textView.text;
    //if (comment.trim.length == 0) {
    if (targetModelArray == nil || [targetModelArray count]<1) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_gift_delivery_post", @"")
                          description:NSLocalizedString(@"order_hint_product_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    BOOL hasProductNum = TRUE;
    for (GiftProductModel* p in targetModelArray) {
        //NSString* num = [NSString stringWithFormat:@"%.4f",p.num];
        if (![p hasNum]){
            hasProductNum = FALSE;
            break;
        }
    }
    if (!hasProductNum) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_gift_delivery_post", @"")
                          description:NSLocalizedString(@"order_hint_product_num_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    //}else{
    if ([NSString stringContainsEmoji:comment]) {
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_gift_delivery_post", @"")
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    //}
    
    GiftDelivery_Builder* sb = [GiftDelivery builder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    if ((APPDELEGATE).myLocation != nil){
        [sb setLocation:APPDELEGATE.myLocation];
    }
    
    [sb setId:-1];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *file in liveImageCell.imageFiles) {
        UIImage *tmpImg = [UIImage imageWithContentsOfFile:file];
        NSData *dataImg = UIImageJPEGRepresentation(tmpImg,0.5);
        [images addObject:dataImg];
    }
    [sb setFilesArray:images];
    [sb setDepartmentArray:checkedDepartmentArray];
    [sb setProductsArray:targetModelArray];
    [sb setContent:comment];
    if (applyItemArray != nil && applyItemArray.count>0) {
        [sb setApplyItemsArray:applyItemArray];
    }
    [sb setUser:USER];
    
    (APPDELEGATE).agent.delegate = self;
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeGiftDeliverySave param:[sb build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"bar_gift_delivery_post", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }

}

-(void)initTablesView{
    tableView = [[SMTableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT-44) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.allowsSelection = YES;
    //[tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
}

-(void) clearTable{
    [targetModelArray removeAllObjects];
    [productModelArray removeAllObjects];
    productModelArray = [[NSMutableArray alloc] initWithArray:[[LOCALMANAGER getGiftProductsWithGiftName:@"" CategoryId:0 Index:currentPage] retain]];
    [applyItemArray removeAllObjects];
    //[departmentArray removeAllObjects];
    checkedDepartmentArray = [[NSMutableArray alloc] initWithCapacity:0];
    //[checkedDepartmentArray removeAllObjects];
    
    [imageFiles removeAllObjects];
    [liveImageCell clearCell];
    
    bTargetExpand = YES;
    bProductExpand = YES;
    bEdit = NO;
    tvRemarkCell.textView.text = @"";
    [tableView reloadData];
    [tableView setEditing:NO animated:YES];
    
    [btNumber setTitle:@"0" forState:UIControlStateNormal];
    [btNumber setHidden:YES];
}

-(void)showTarget{
    
    bTargetExpand = YES;
    bProductExpand = NO;
    [tableView reloadData];
}

-(void)setHeader3Title{
    
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 4:{
            return [applyItemArray count];
        }
            break;
        case 1:{
            return 2;
        }
            break;
        case 2:{
            if (!bProductExpand || [productModelArray count] == 0) {
                return 0;
            }
            return [productModelArray count]+1;
        }
            break;
        case 3:{
            if (!bTargetExpand) {
                return 0;
            }
            return [targetModelArray count];
        }
            break;
            
        default:
            break;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 0;
    }
//    if(section == 0 && ![LOCALMANAGER hasFunction:FUNC_APPROVE_DES])return 0;
    return 37.0;
//
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 4 )
        return 44.0;
    
    if (indexPath.section == 0) {
        return 44;
    }
    if (indexPath.section == 1){
        if(indexPath.row == 0)return 120.0;
        else return 50;
    }
    if (indexPath.section == 2){
        if(indexPath.row == [productModelArray count])
            return 44.0;
        else
            return 85.0;
    }
    if (indexPath.section == 3)
        return 85.0;
    if (indexPath.section == 5) {
        if(indexPath.row == 0) return 120.0;
        else return 44.0;
    }
    
    return 85.f;

}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 4:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable3HeaderView" owner:self options:nil];
            BaseTable3HeaderView *header = [nibViews objectAtIndex:0];
            //[header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
            [header.title setText:NSLocalizedString(@"apply_form", nil)];
            if (bExpand) {
                header.epanfImage.image = [UIImage imageNamed:@"expander_ic_maximized"];
            }else {
            
                header.epanfImage.image = [UIImage imageNamed:@"expander_ic_minimized"];
                
            }
            
            UITapGestureRecognizer *tapSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIsTapEvent:)];
            [tapSectionGesture setNumberOfTapsRequired:1];
            header.userInteractionEnabled = YES;
           
            [header addGestureRecognizer:tapSectionGesture];
            tapSectionGesture.view.tag = section;
            [tapSectionGesture release];
            
            header.btEdit.frame = CGRectMake(MAINWIDTH-30, 5, 20, 20);
            [header.btEdit setImage:[UIImage imageNamed:@"ic_plus"] forState:UIControlStateNormal];
            [header.btEdit addTarget:self action:@selector(addApplyItems) forControlEvents:UIControlEventTouchUpInside];
            return header;
        }
            break;
        case 0:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable3HeaderView" owner:self options:nil];
            BaseTable3HeaderView *header = [nibViews objectAtIndex:0];
            header.backgroundColor = WT_LIGHT_GRAY;
            header.title.textColor = [UIColor whiteColor];
            //[header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
            [header.title setText:NSLocalizedString(@"gift_delivery_department", nil)];
            [header.btEdit setHidden:YES];
            return header;
        }
            break;
        case 1:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable1HeaderView" owner:self options:nil];
            BaseTable1HeaderView *header = [nibViews objectAtIndex:0];
            //[header setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
            [header.title setText:NSLocalizedString(@"patrol_hint_uploadfile", nil)];
            header.backgroundColor = WT_LIGHT_GRAY;
            return header;
        }
            break;
        case 2:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable2HeaderView" owner:self options:nil];
            header2 = [nibViews objectAtIndex:0];
            header2.backgroundColor = WT_WHITE;
            header2.title.textColor = WT_BLACK;
           // bProductExpand
            if (bProductExpand) {
                header2.expandIcon.image = [UIImage imageNamed:@"expander_ic_minimized"];
            }else {
            
                header2.expandIcon.image = [UIImage imageNamed:@"expander_ic_maximized"];

            }
            //[header2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
            UITapGestureRecognizer *tapSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIsTapEvent:)];
            [tapSectionGesture setNumberOfTapsRequired:1];
            header2.userInteractionEnabled = YES;
            header2.txtSearch.delegate = self;
            header2.txtSearch.tag = -1;
            header2.txtSearch.text = searchContent;
            header2.title.text = NSLocalizedString(@"gift_product", nil);
            [header2 addGestureRecognizer:tapSectionGesture];
            tapSectionGesture.view.tag = section;
            [tapSectionGesture release];
            return header2;
        }
            break;
        case 3:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable1HeaderView" owner:self options:nil];
            header3 = [nibViews objectAtIndex:0];
            header3.backgroundColor = WT_WHITE;
           
            header3.title.textColor = WT_BLACK;
            if (bTargetExpand) {
                header3.expandImage.image = [UIImage imageNamed:@"expander_ic_maximized"];
            }else {
                header3.expandImage.image = [UIImage imageNamed:@"expander_ic_minimized"];
            
            }
            //[header3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
            UITapGestureRecognizer *tapSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIsTapEvent:)];
            [tapSectionGesture setNumberOfTapsRequired:1];
            header3.userInteractionEnabled = YES;
            header3.title.text = NSLocalizedString(@"gift_target", nil);
            [header3 addGestureRecognizer:tapSectionGesture];
            tapSectionGesture.view.tag = section;
            return header3;
        }
            break;
        case 5:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable1HeaderView" owner:self options:nil];
            header4 = [nibViews objectAtIndex:0];
            header4.backgroundColor = WT_WHITE;
            header4.title.textColor = WT_BLACK;
            //[header4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_topbar"]]];
            header4.title.text = NSLocalizedString(@"memo", nil);
            return header4;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 4:{
            
            SWTableViewCell *applyItemCell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ApplyItemCell"];
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            [rightUtilityButtons addUtilityButtonWithColor:
             WT_RED
                                                      icon:[UIImage imageNamed:@"ic_delete_grey"]];
            if (applyItemCell == nil) {
                applyItemCell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyItemCell" containingTableView:tableView rowHeight:44 leftUtilityButtons:nil rightUtilityButtons:rightUtilityButtons];
            }
            /*
             if (indexPath.row % 2 == 0) {
             applyItemCell.contentView.backgroundColor = WT_LIGHT_YELLOW;
             }else{
             applyItemCell.contentView.backgroundColor = [UIColor whiteColor];
             }*/
            
            ApplyItem *applyItem = [applyItemArray objectAtIndex:indexPath.row];
            applyItemCell.textLabel.text = applyItem.title;
            [applyItemCell.textLabel setBackgroundColor:[UIColor clearColor]];
            applyItemCell.textLabel.font = [UIFont systemFontOfSize:15];
            applyItemCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            applyItemCell.delegate = self;
            return applyItemCell;
        }
            break;
        case 0:{
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:@"SelectCell"];
            //if(selectCell==nil){
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
            for(id oneObject in nib)
            {
                if([oneObject isKindOfClass:[SelectCell class]])
                    selectCell=(SelectCell *)oneObject;
            }
            //}
            
            selectCell.title.text = NSLocalizedString(@"gift_delivery_select_department", nil);
            
            if (checkedDepartmentArray != nil && checkedDepartmentArray.count>0) {
                Department *tmpDepart = (Department *)[checkedDepartmentArray objectAtIndex:0];
                NSString *strDepartments = tmpDepart.name;
                for (int i = 1; i < 3 && i<checkedDepartmentArray.count; i++) {
                    tmpDepart = (Department *)[checkedDepartmentArray objectAtIndex:i];
                    strDepartments = [NSString stringWithFormat:@"%@,%@",strDepartments,tmpDepart.name];
                }
                selectCell.value.text = strDepartments;
            }else{
                selectCell.value.text = NSLocalizedString(@"gift_hint_select_department", nil);
            }
            
            selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return selectCell;
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                if(liveImageCell==nil){
                    liveImageCell = [[LiveImageCell alloc] init];
                    liveImageCell.delegate = self;
                }
                liveImageCell.selectionStyle=UITableViewCellSelectionStyleNone;
                return liveImageCell;
            }else{
                LocationCell *locationCell=(LocationCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
                if(locationCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[LocationCell class]])
                            locationCell=(LocationCell *)oneObject;
                    }
                }
                
                locationCell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                if (APPDELEGATE.myLocation != nil) {
                    if (!APPDELEGATE.myLocation.address.isEmpty) {
                        [locationCell.lblAddress setText:APPDELEGATE.myLocation.address];
                    }else{
                        [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",APPDELEGATE.myLocation.latitude,APPDELEGATE.myLocation.longitude]];
                    }
                }
                [locationCell.btnRefresh addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
                
                return locationCell;
                
            }
        }
            break;
        case 2:{
            int count = [productModelArray count];
            if (indexPath.row == count) {
                UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                if (moreCell == nil) {
                    moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
                }
                moreCell.textLabel.text = NSLocalizedString(@"load_more", nil);
                moreCell.textAlignment=UITextAlignmentCenter;
                moreCell.textLabel.font = [UIFont systemFontOfSize:12];
                moreCell.selectionStyle = UITableViewCellSelectionStyleDefault;
                return moreCell;
            }
            
            GiftProductCell *productCell = (GiftProductCell *)[tableView dequeueReusableCellWithIdentifier:@"GiftProductCell1"];
            if (productCell == nil) {
                productCell = [[GiftProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GiftProductCell1" containingTableView:tableView rowHeight:85 leftUtilityButtons:nil rightUtilityButtons:nil];
            }
            productCell.contentView.backgroundColor = [UIColor whiteColor];
            
            
            GiftProductModel *productModel = [productModelArray objectAtIndex:indexPath.row];
            productCell.productName.text = productModel.giftProduct.name;
            productCell.productModel.text = productModel.name;
            productCell.unit.text = productModel.giftProduct.category.unit;
            productCell.price.text = [NSString stringWithFormat:@"%.2f",productModel.price];
            if (![productModel hasNum]) {
                productCell.count.text = @"";
            }else{
                productCell.count.text = [NSString stringWithFormat:@"%g",productModel.num];
            }
            
            productCell.selectionStyle=UITableViewCellSelectionStyleNone;
            productCell.count.delegate = self;
            productCell.count.tag = indexPath.row;
            productCell.price.delegate = self;
            productCell.price.tag = indexPath.row+10000;
            productCell.tag = productModel.id;
            
            UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
            [topView setBarStyle:UIBarStyleDefault];
            [topView setBackgroundColor:WT_TOOLBAR_GRAY];
            UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
            UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(finishedInput)];
            
            NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
            [doneButton release];
            [btnSpace release];
            [helloButton release];
            
            [topView setItems:buttonsArray];
            [productCell.count setInputAccessoryView:topView];
            [productCell.price setInputAccessoryView:topView];
            //productCell.revealDirection = RMSwipeTableViewCellRevealDirectionNone;
            return productCell;
            
        }
            break;
        case 3:{
            GiftProductCell *productCell = (GiftProductCell *)[tableView dequeueReusableCellWithIdentifier:@"GiftProductCell2"];
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            [rightUtilityButtons addUtilityButtonWithColor:
             WT_RED
                                                      icon:[UIImage imageNamed:@"ic_delete_grey"]];
            if (productCell == nil) {
                productCell = [[GiftProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GiftProductCell2" containingTableView:tableView rowHeight:85 leftUtilityButtons:nil rightUtilityButtons:rightUtilityButtons];
            }
            
            if (indexPath.row % 2 == 0) {
                productCell.contentView.backgroundColor = WT_LIGHT_YELLOW;
            }else{
                productCell.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            GiftProductModel *productModel = [targetModelArray objectAtIndex:indexPath.row];
            productCell.productName.text = productModel.giftProduct.name;
            productCell.productModel.text = productModel.name;
            productCell.unit.text = productModel.giftProduct.category.unit;
            productCell.price.text = [NSString stringWithFormat:@"%.2f",productModel.price];
            if (![productModel hasNum]) {
                productCell.count.text = @"";
            }else{
                productCell.count.text = [NSString stringWithFormat:@"%g",productModel.num];
            }
            
            productCell.selectionStyle=UITableViewCellSelectionStyleNone;
            productCell.count.delegate = self;
            productCell.count.tag = indexPath.row+20000;
            productCell.price.delegate = self;
            productCell.price.tag = indexPath.row+30000;
            productCell.tag = productModel.id;
            
            UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
            [topView setBarStyle:UIBarStyleDefault];
            [topView setBackgroundColor:WT_TOOLBAR_GRAY];
            UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
            UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
            
            NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
            [doneButton release];
            [btnSpace release];
            [helloButton release];
            
            [topView setItems:buttonsArray];
            [productCell.count setInputAccessoryView:topView];
            [productCell.price setInputAccessoryView:topView];
            //productCell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
            productCell.delegate = self;
            return productCell;
        }
            break;
        case 5:{
            
            static NSString *qCellIdentifier = @"qCellIdentifier";
            //tvQuestionCell =(TextViewCell *)[tableView dequeueReusableCellWithIdentifier:qCellIdentifier];
            if(tvRemarkCell==nil){
                tvRemarkCell= [[TextViewCell alloc] init];
            }
            tvRemarkCell.textView.delegate=self;
//            tvRemarkCell.textView.layer.borderColor = RGBA(53, 153, 255, 1.0).CGColor;
//            tvRemarkCell.textView.layer.borderWidth =1.0;
//            tvRemarkCell.textView.layer.cornerRadius =5.0;
            [tvRemarkCell addSubview:[self setView]];
            UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
            [topView setBarStyle:UIBarStyleBlack];
            UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clearInput)];
            UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
            
            NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
            [doneButton release];
            [btnSpace release];
            [helloButton release];
            
            [topView setItems:buttonsArray];
            //[tvRemarkCell.textView setInputAccessoryView:topView];
            tvRemarkCell.selectionStyle=UITableViewCellSelectionStyleNone;
            [topView release];
            return tvRemarkCell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, MAINWIDTH - 200, 40)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 0.5, 5)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(10, 15, MAINWIDTH - 20, 0.5)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 10 - 0.5, 10, 0.5, 5)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self searchDismissKeyBoard];
    switch (indexPath.section) {
        case 4:{
            ApplyDetailViewController *vctl= [[ApplyDetailViewController alloc] init];
            vctl.applyItem = [applyItemArray objectAtIndex:indexPath.row];
            [self.parentCtrl.navigationController pushViewController:vctl animated:YES];
            [vctl release];
        }
            break;
        case 0:{
            DepartmentViewController *vctl = [[DepartmentViewController alloc] init];
            vctl.delegate = self;
            vctl.departmentArray = departmentArray;
            vctl.selectedArray = checkedDepartmentArray;
            [self.parentCtrl.navigationController pushViewController:vctl animated:YES];
            [vctl release];
        }
            break;
        case 3:{
            if (indexPath.row == [productModelArray count]) {
                currentPage++;
                [productModelArray addObjectsFromArray:[[LOCALMANAGER getGiftProductsWithGiftName:searchContent CategoryId:0 Index:currentPage] retain]];
            }
            [tableView reloadData];
        }
            break;
     
            
        default:
            break;
    }
    
    //[self dismissModalViewControllerAnimated:YES];
}

-(void)autorefreshLocation {
    [super refreshLocation];
    [tableView reloadData];
}

- (void)refreshLocation{
    [super refreshLocation];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"location_loading", @"");
    [tableView reloadData];
    
    [hud hide:YES afterDelay:1.0];
}


-(void)didFnishedCheck:(NSMutableArray *)departments{

    checkedDepartmentArray = [departments retain];
    [tableView reloadData];
}

-(void)addApplyItems{
    ApplyListViewController *vctrl = [[ApplyListViewController alloc] init];
    vctrl.bEnableSelect = YES;
    vctrl.delegate = self;
    [self.parentCtrl.navigationController pushViewController:vctrl animated:YES];
}

-(void)didFinishedSelectApplyItem:(NSMutableArray *)applyItemArray0{
    applyItemArray = [[NSMutableArray alloc] initWithArray:applyItemArray0];
    [tableView reloadData];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if(currentTextField != nil){
        [currentTextField resignFirstResponder];
    }else if(currentTextView != nil){
        [currentTextView resignFirstResponder];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    currentTextView = nil;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    currentTextView = textView;
    currentTextField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    currentPage = 1;
    
    productModelArray = [[LOCALMANAGER getGiftProductsWithGiftName:textField.text CategoryId:0 Index:currentPage] retain];
    searchContent = [[NSString alloc] initWithString:header2.txtSearch.text];
    bProductExpand = YES;
//    [tableView reloadData];
    [textField resignFirstResponder];
    if ([productModelArray count]==0) {
        //[self showMessage:ResultCodeResponseDone Title:NSLocalizedString(@"search_title", nil) Description:NSLocalizedString(@"search_no_data", nil)];
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"search_title", @"")
                          description:NSLocalizedString(@"search_no_data", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
    }
    return NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    currentTextField = nil;
    int index = textField.tag;
    
    if (index<0) {
        searchContent = [textField.text retain];
        [tableView reloadData];
        return;
    }
    GiftProductModel_Builder* pb;
    if (index <10000) {
        pb = [((GiftProductModel*)[productModelArray objectAtIndex:index]) toBuilder];
        if ([textField.text length]>0) {
            [pb setNum:[textField.text doubleValue]];
        }

        [productModelArray removeObjectAtIndex:index];
        [productModelArray insertObject:[[pb build] retain] atIndex:index];
    }else if (index <20000){
        pb = [((GiftProductModel*)[productModelArray objectAtIndex:index-10000]) toBuilder];
        [pb setPrice:[textField.text doubleValue]];

        [productModelArray removeObjectAtIndex:index-10000];
        [productModelArray insertObject:[[pb build] retain] atIndex:index-10000];
    }else if (index <30000){
        pb = [((GiftProductModel*)[targetModelArray objectAtIndex:index-20000]) toBuilder];
        if ([textField.text length]>0) {
            [pb setNum:[textField.text doubleValue]];
        }

        [targetModelArray removeObjectAtIndex:index-20000];
        [targetModelArray insertObject:[[pb build] retain] atIndex:index-20000];
    }else{
        pb = [((GiftProductModel*)[targetModelArray objectAtIndex:index-30000]) toBuilder];
        [pb setPrice:[textField.text doubleValue]];

        [targetModelArray removeObjectAtIndex:index-30000];
        [targetModelArray insertObject:[[pb build] retain] atIndex:index-30000];
    }
}

-(IBAction)dismissKeyBoard{
    if (currentTextField != nil) {
        [currentTextField resignFirstResponder];
    }else if(currentTextView != nil){
        [currentTextView resignFirstResponder];
    }
}

-(IBAction)finishedInput
{
    
    int tag=-1;
    if (currentTextField != nil) {
        tag = currentTextField.tag;
        [currentTextField resignFirstResponder];
    }
    int index = tag;
    if (tag<0) {
        return;
    }
    if (tag <10000) {
        index = tag;
    }else if(tag <20000){
        index = tag-10000;
    }else{
        return;
    }
    int index0 = [self findIndex:[productModelArray objectAtIndex:index]];
    if (!(index0 == [targetModelArray count])) {
        [targetModelArray removeObjectAtIndex:index0];
    }
    [targetModelArray addObject:[productModelArray objectAtIndex:index]];
    [btNumber setTitle:[NSString stringWithFormat:@"%d",[targetModelArray count]] forState:UIControlStateNormal];
    [tableView reloadData];
}

-(IBAction)searchDismissKeyBoard
{
    [header2.txtSearch resignFirstResponder];
}

-(IBAction)clearInput{
    
    currentTextField.text = @"";
    if (currentTextField != nil) {
        [currentTextField resignFirstResponder];
    }else if(currentTextView != nil){
        currentTextView.text = @"";
        [currentTextView resignFirstResponder];
    }
    
}

-(int)findIndex:(GiftProductModel *)productModel{
    int index = [targetModelArray count];
    GiftProductModel *tmp;
    for (int i = 0; i<index; i++) {
        tmp = [targetModelArray objectAtIndex:i];
        if (tmp.id  == productModel.id) {
            return i;
        }
    }
    return index;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [targetModelArray removeObjectAtIndex:indexPath.row];
    [btNumber setTitle:[NSString stringWithFormat:@"%d",[targetModelArray count]] forState:UIControlStateNormal];
    [tableView reloadData];
}
*/
-(void)headerIsTapEvent:(id)sender{
    
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    int sectionIndex = tapGesture.view.tag;
    NSLog(@"%i", sectionIndex);
    
    if (sectionIndex == 2) bProductExpand = !bProductExpand;
    if (sectionIndex == 3) bTargetExpand = !bTargetExpand;
     if (sectionIndex == 4) bExpand = !bExpand;
    bEdit = NO;
    [tableView setEditing:NO animated:NO];
    [tableView reloadData];
}


-(void)addPhoto{
    
    NSLog(@"delegate addphoto");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
        [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
        [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
        [cameraVC setDelegate:self];
        [cameraVC setAllowsEditing:NO];
        [self.parentCtrl presentModalViewController:cameraVC animated:YES];
        [cameraVC release];
        
    }else {
        NSLog(@"Camera is not available.");
    }
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage *)fitSmallImage:(UIImage *)image
{
    if (nil == image)
    {
        return nil;
    }
    if (image.size.width<720 && image.size.height<960)
    {
        return image;
    }
    CGSize size = [self fitsize:image.size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newing;
}
- (CGSize)fitsize:(CGSize)thisSize
{
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/720;
    CGFloat hscale = thisSize.height/960;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    return newSize;
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    //NSLog(@"image.size.width=%f  image.size.height=%f",image.size.width,image.size.height);
    if (image.size.width > image.size.height) {
        newSize.width = (newSize.height/image.size.height) *image.size.width;
    }else{
        newSize.height = (newSize.width/image.size.width) *image.size.height;
    }
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Obtain the path to save to
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFile = [[NSString alloc] initWithString:[NSString UUID]];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageFile]];
    
    // Extract image from the picker and save it
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [self fitSmallImage:[info objectForKey:UIImagePickerControllerOriginalImage]] ;
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);//UIImagePNGRepresentation(image);
        [data writeToFile:imagePath atomically:YES];
    }
    [imageFiles addObject:imagePath];
    [liveImageCell insertPhoto:imagePath];
    
    //[imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
    [picker dismissModalViewControllerAnimated:YES];
    [imageFile release];
    
}


-(void)showMessage:(ActionCode)resultCode Title:(NSString*)title Description:(NSString*)desc{
    
    [super showMessage:resultCode Title:title Description:desc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SW Table View Cell Delegate

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index{
    
}
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    if (indexPath.section ==4) {
        [applyItemArray removeObjectAtIndex:indexPath.row];
    }else if(indexPath.section ==3){
        [targetModelArray removeObjectAtIndex:indexPath.row];
        [btNumber setTitle:[NSString stringWithFormat:@"%d",[targetModelArray count]] forState:UIControlStateNormal];
    }
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
    [tableView reloadData];
}

@end
