//
//  GiftStockDetailViewController.m
//  SalesManager
//
//  Created by 章力 on 14-9-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "GiftStockDetailViewController.h"
#import "SelectCell.h"
#import "GiftProductItemCell.h"
#import "GiftProductCell.h"
#import "LiveImageCell.h"
#import "AppDelegate.h"
#import "BigImageViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"

@interface GiftStockDetailViewController ()

@end

@implementation GiftStockDetailViewController
@synthesize giftStock,giftStockId,msgType;


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
    for (int i = 0; i<[giftStock.filePath count]; i++) {
        [imageFiles addObject:[giftStock.filePath objectAtIndex:i]];
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
    if (giftStock != nil) {
        [self _show];
    }else{
        [self _getGiftStock];
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

- (void) _getGiftStock{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    GiftStockParams_Builder* pb = [GiftStockParams builder];
    
    [pb setId:giftStockId];

    if (DONE != [AGENT sendRequestWithType:ActionTypeGiftStockGet param:[pb build]]){
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
    if (giftStock.content != nil && giftStock.content.length>0) {
        return 3;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0)return 88;
            else return 50;
        }
            break;
        case 1:{
            return 68;
        }
            break;
        case 2:{
            return 80;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:{
            return NSLocalizedString(@"title_live_image_detail", nil);
        }
            break;
        case 1:{
            return NSLocalizedString(@"gift_info", nil);
        }
            break;
        case 2:{
            return NSLocalizedString(@"memo", nil);
        }
            break;
            
        default:
            break;
    }
    return @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return giftStock.products.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
    
    switch (indexPath.section) {
        
        case 0:{
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
                if (!giftStock.location.address.isEmpty) {
                    [locationCell.lblAddress setText:giftStock.location.address];
                }else{
                    [locationCell.lblAddress setText:[NSString stringWithFormat:@"%f   %f",giftStock.location.latitude,giftStock.location.longitude]];
                }
                return locationCell;
            }

        }
            break;
        case 1:{
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
            GiftProductModel *p = [giftStock.products objectAtIndex:indexPath.row];
            cell.count.text = [NSString stringWithFormat:@"%g",p.num];
            cell.price.text = [NSString stringWithFormat:@"%.2f",p.price];
            cell.product.text = p.giftProduct.name;
            cell.modelName.text = p.name;
            cell.unit.text = p.giftProduct.category.unit;
            
            return cell;
        }
            break;
        case 2:{
            textViewCell = [[TextViewCell alloc] init];
            //textViewCell.title.text = NSLocalizedString(@"patrol_label_content", nil);
            textViewCell.textView.delegate=self;
            textViewCell.textView.text = giftStock.content;
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

-(void)openPhoto:(int)index{
    BigImageViewController *ctrl = [[BigImageViewController alloc] init];
    ctrl.filePath = [imageFiles objectAtIndex:index];
    ctrl.functionName = [NSString stringWithFormat:@"%@",giftStock.user.userName];
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
    SessionResponse* cr = [SessionResponse parseFromData:message];
    HUDHIDE;
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type) ) {
        case ActionTypeGiftStockGet:{
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                GiftStock* g = [GiftStock parseFromData:cr.data];
                if ([super validateData:g]) {
                    giftStock = [g retain];
                    [self _show];
                }
            }
            
            if (msgType != MESSAGE_UNKNOW) {
                [super readMessage:msgType SourceId:[NSString stringWithFormat:@"%d",giftStockId]];
            }
            
            [super showMessage2:cr Title:NSLocalizedString(@"note", @"") Description:@""];
            
        }
            break;
            
        default:
            break;
    }
}

@end
