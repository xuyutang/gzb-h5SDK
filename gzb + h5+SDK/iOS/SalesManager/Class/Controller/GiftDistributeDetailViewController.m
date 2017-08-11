//
//  GiftDistributeDetailViewController.m
//  SalesManager
//
//  Created by 章力 on 14-9-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "GiftDistributeDetailViewController.h"
#import "ApplyDetailViewController.h"
#import "SelectCell.h"
#import "LiveImageCell.h"
#import "GiftProductCell.h"
#import "GiftProductItemCell.h"
#import "AppDelegate.h"
#import "BigImageViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"

@interface GiftDistributeDetailViewController ()

@end

@implementation GiftDistributeDetailViewController

@synthesize giftDistribute,giftDistributeId,msgType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData{
    
    imageFiles = [[NSMutableArray alloc] init];
    for (int i = 0; i<[giftDistribute.filePath count]; i++) {
        [imageFiles addObject:[giftDistribute.filePath objectAtIndex:i]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
    [leftView addSubview:leftImageView];
    
    AGENT.delegate = self;
    if (giftDistribute != nil) {
        [self _show];
    }else{
        [self _getGiftDistribute];
    }
    
    [lblFunctionName setText:NSLocalizedString(@"gift_detail", @"")];
}

- (void) _show{
    [self initData];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeftButton:)];
    [tapGesture setNumberOfTapsRequired:1];
    [leftImageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    //tableView.allowsSelection = NO;
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
}

- (void) _getGiftDistribute{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    GiftDistributeParams_Builder* pb = [GiftDistributeParams builder];
    
    [pb setId:giftDistributeId];
    if (DONE != [AGENT sendRequestWithType:ActionTypeGiftDistributeGet param:[pb build]]){
        HUDHIDE;
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"note", @"")
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)clickLeftButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (giftDistribute.applyItems.count > 0) {
        if (giftDistribute.content != nil && giftDistribute.content.length>0) {
            return 5;
        }
        return 4;
    }else if(giftDistribute.content.length>0){
        return 4;
    }
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (giftDistribute.applyItems.count > 0){
        switch (indexPath.section) {
            case 0:return 40;
            case 1:return 40;
            case 2:{
                if (indexPath.row == 0)return 88;
                else return 50;
            }
            case 3:return 68;
            case 4:return 120;
            default:
                return 120;
        }

    }else{
        switch (indexPath.section) {
            case 0:return 40;
            case 1:{
                if (indexPath.row == 0)return 88;
                else return 50;
            }
            case 2:return 68;
            case 3:return 120;
            default:
                return 120;
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:{
            if (giftDistribute.applyItems.count > 0)return NSLocalizedString(@"apply_form", nil);
            else return NSLocalizedString(@"gift_distribute_customer", nil);
        }
            break;
        case 1:{
            if (giftDistribute.applyItems.count > 0)return NSLocalizedString(@"gift_distribute_customer", nil);
            else return NSLocalizedString(@"title_live_image_detail", nil);
        }
            break;
        case 2:{
            if (giftDistribute.applyItems.count > 0)return NSLocalizedString(@"title_live_image_detail", nil);
            else return NSLocalizedString(@"gift_info", nil);
        }
            break;
        case 3:{
            if (giftDistribute.applyItems.count > 0)return NSLocalizedString(@"gift_info", nil);
            else{
                if(giftDistribute.content != nil && giftDistribute.content.length>0)return NSLocalizedString(@"memo", nil);
                else return @"";
            }
        }
            break;
        case 4:{
            return NSLocalizedString(@"memo", nil);
        }
            break;
            
        default:
            break;
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (giftDistribute.applyItems.count > 0){
        if (section == 0) return giftDistribute.applyItems.count;
        if (section == 2) return 2;
        if (section == 3) return giftDistribute.products.count;
        return 1;
    }else{
        if (section == 1) return 2;
        if (section == 2) return giftDistribute.products.count;
        return 1;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath section:(int)section{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    switch (section) {
        case 0:{
            UITableViewCell *selectCell =(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(selectCell==nil){
                selectCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            selectCell.textLabel.text = ((ApplyItem *)[giftDistribute.applyItems objectAtIndex:indexPath.row]).title;
            selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            selectCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return selectCell;
        }
            break;
        case 1:{
            
            UITableViewCell *selectCell =(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomerCell"];
            if(selectCell==nil){
                selectCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            selectCell.textLabel.text = giftDistribute.customer.name;
            selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            selectCell.accessoryType = UITableViewCellAccessoryNone;
            return selectCell;
        }
            break;
        case 2:{
            
            if (indexPath.row == 0) {
                liveImageCell = [[LiveImageCell alloc] initWithImages:imageFiles];
                liveImageCell.delegate = self;
                if(liveImageCell==nil){
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"LiveImageCell" owner:self options:nil];
                    for(id oneObject in nib)
                    {
                        if([oneObject isKindOfClass:[LiveImageCell class]])
                            liveImageCell=(LiveImageCell *)oneObject;
                    }
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
                
                locationCell.btnRefresh.hidden = YES;
                if (!giftDistribute.location.address.isEmpty) {
                    [locationCell.lblAddress setText:giftDistribute.location.address];
                }else{
                    [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",giftDistribute.location.latitude,giftDistribute.location.longitude]];
                }
                return locationCell;
            }

        }
            break;
        case 3:{
            
            NSString *cellIdentifier = @"GiftProductItemCell";
            
            GiftProductItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(cell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"GiftProductItemCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[GiftProductItemCell class]])
                        cell=(GiftProductItemCell *)oneObject;
                }
            }
            GiftProductModel *p = [giftDistribute.products objectAtIndex:indexPath.row];
            cell.count.text = [NSString stringWithFormat:@"%g",p.num];
            cell.price.text = [NSString stringWithFormat:@"%.2f",p.price];
            cell.product.text = p.giftProduct.name;
            cell.modelName.text = p.name;
            cell.unit.text = p.giftProduct.category.unit;
            
            return cell;
            
        }
            break;
        case 4:{
            textViewCell = [[TextViewCell alloc] init];
            //textViewCell.title.text = NSLocalizedString(@"patrol_label_content", nil);
            textViewCell.textView.delegate=self;
            textViewCell.textView.text = giftDistribute.content;
            [textViewCell.textView setEditable:NO];
            textViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return textViewCell;
            
        }
            break;
            
            
        default:
            break;
    }
    
    return cell;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (giftDistribute.applyItems.count > 0) {
                return [self tableView:tableView cellForRowAtIndexPath:indexPath section:0];
            }else{
                return [self tableView:tableView cellForRowAtIndexPath:indexPath section:1];
            }
        }
            break;
        case 1:{
            if (giftDistribute.applyItems.count > 0) {
                return [self tableView:tableView cellForRowAtIndexPath:indexPath section:1];
            }else{
                return [self tableView:tableView cellForRowAtIndexPath:indexPath section:2];
            }
        }
            break;
        case 2:{
            if (giftDistribute.applyItems.count > 0) {
                return [self tableView:tableView cellForRowAtIndexPath:indexPath section:2];
            }else{
                return [self tableView:tableView cellForRowAtIndexPath:indexPath section:3];
            }
        }
            break;
        case 3:{
            if (giftDistribute.applyItems.count > 0) {
                return [self tableView:tableView cellForRowAtIndexPath:indexPath section:3];
            }else{
                return [self tableView:tableView cellForRowAtIndexPath:indexPath section:4];
            }
        }
            break;
        case 4:{
            return [self tableView:tableView cellForRowAtIndexPath:indexPath section:4];
        }
            break;
        default:
            break;
    }
    return [self tableView:tableView cellForRowAtIndexPath:indexPath section:4];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && giftDistribute.applyItems.count>0) {
        ApplyDetailViewController *vctl= [[ApplyDetailViewController alloc] init];
        vctl.applyItem = nil;
        vctl.applyItemId = ((ApplyItem*)[giftDistribute.applyItems objectAtIndex:indexPath.row]).id;
        [self.navigationController pushViewController:vctl animated:YES];
        [vctl release];
    }
}

-(void)openPhoto:(int)index{
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [imageFiles objectAtIndex:index];
    ctrl.functionName = [NSString stringWithFormat:@"%@",giftDistribute.user.userName];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didReceiveMessage:(id)message{
    SessionResponse * cr = [SessionResponse parseFromData:message];
    HUDHIDE;
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeGiftDistributeGet:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                GiftDistribute* g = [GiftDistribute parseFromData:cr.data];
                if ([super validateData:g]) {
                    giftDistribute = [g retain];
                    [self _show];
                }
            }
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",giftDistributeId]];
            }
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
            
        }
            break;
            
        default:
            break;
    }
}
@end
