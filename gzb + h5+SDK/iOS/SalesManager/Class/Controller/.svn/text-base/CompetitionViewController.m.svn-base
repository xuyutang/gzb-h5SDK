//
//  CompetitionViewController.m
//  SalesManager
//
//  Created by liuxueyan on 11/6/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
//

#import "CompetitionViewController.h"
#import "SelectCell.h"
#import "OrderProductCell.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "CompetitionListViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "BaseTable1HeaderView.h"
#import "BaseTable2HeaderView.h"


@interface CompetitionViewController ()

@end

@implementation CompetitionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initView
{
    
    [lblFunctionName setText:TITLENAME_REPORT(FUNC_COMPETITION_DES)];
    (APPDELEGATE).agent.delegate = self;
}

-(void)syncTitle {
 [lblFunctionName setText:TITLENAME_REPORT(FUNC_COMPETITION_DES)];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

-(void)toList:(id)sender{
    [self dismissKeyBoard];
    CompetitionListViewController *ctrl = [[CompetitionListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];

}
-(void)toSave:(id)sender{
    [self dismissKeyBoard];
    if (currentCustomer == nil) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_COMPETITION_DES)
                          description:NSLocalizedString(@"patrol_hont_customer_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    NSString* comment = @"";
    if ((tvRemarkCell.textView.textColor != [UIColor lightGrayColor])) {
       comment = tvRemarkCell.textView.text;
    }
    
    if (comment.trim.length > 1000){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_COMPETITION_DES)
                          description:NSLocalizedString(@"input_limit_1000", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }

    //if (comment.trim.length == 0) {
    if (targetArray == nil || [targetArray count]<1) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_COMPETITION_DES)
                          description:NSLocalizedString(@"order_hint_product_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    
    BOOL hasProductNum = FALSE;
    for (CompetitionProduct* p in targetArray) {//CompetitionGoods
        //NSString* num = [NSString stringWithFormat:@"%.4f",p.num];
        if ([p hasNum]){
            hasProductNum = TRUE;
            break;
        }
    }
    
    if (!hasProductNum) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_COMPETITION_DES)
                          description:NSLocalizedString(@"order_hint_product_num_empty2", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    //}else{
    if ([NSString stringContainsEmoji:comment]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_COMPETITION_DES)
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    //}
    CompetitionGoods_Builder* cgb = [CompetitionGoods builder];
    
    NSMutableArray* competitionProducts = [[NSMutableArray alloc] initWithCapacity:0];
    for (CompetitionProduct* p in targetArray) {
        if ([p hasNum]){
            [competitionProducts addObject:p];
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    if ((APPDELEGATE).myLocation != nil){
        [cgb setLocation:(APPDELEGATE).myLocation];
    }
    
    [cgb setId:-1];
    [cgb setCustomer:currentCustomer];
    [cgb setProductsArray:competitionProducts];
    [cgb setComment:comment];
    
    
    (APPDELEGATE).agent.delegate = self;
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeCompetitiongoodsSave param:[cgb build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_COMPETITION_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}
#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self searchDismissKeyBoard];
    switch (indexPath.section) {
        case 0:{
//            [self clearTable];
            CustomerSelectViewController *ctrl = [[CustomerSelectViewController alloc] init];
            ctrl.bNeedAddCustomer = NO;
            ctrl.delegate = self;
            ctrl.bNeedAll = NO;
            
            UINavigationController *customerNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:customerNavCtrl animated:YES completion:nil];
            [ctrl release];
        }
            break;
        case 1:{
            if (indexPath.row == [productArray count]) {
                currentPage++;
                productTotal = [LOCALMANAGER getCompetitionProductTotal:searchContent];
                [productArray addObjectsFromArray:[[LOCALMANAGER getCompetitionProducts:searchContent Index:currentPage] retain]];

            }else{
                
            }
            [tableView reloadData];
        }
            break;
        case 2:{
            
            
        }
            break;
            
        default:
            break;
    }
    
    //[self dismissModalViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = [super tableView:tableView heightForHeaderInSection:section];
    if (section == 2) {
        height = 0;
    }
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    [super tableView:tableView titleForHeaderInSection:section];
    switch (section) {
            
        case 2:{
            if ([productArray count]<1) {
                return NSLocalizedString(@"title_order_no", nil);
            }
            
            return NSLocalizedString(@"title_order_info", nil);
        }
        default:
            break;
    }
    return @"";
}

-(void)setHeader3Title{
    header2.title.text = @"竞品列表";
    header3.title.text = @"竞品详情";
}

-(void)findProduct:(NSString *)searchText{
    
    int i = 0;
    NSRange range;
    range.location = NSNotFound;
    for (; i<[productArray count]; i++) {
        Product *product = [productArray objectAtIndex:i];
        range = [product.name rangeOfString:searchText];
        if (range.location != NSNotFound) {
            [productArray insertObject:product atIndex:0];
            [productArray removeObjectAtIndex:i+1];
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    currentPage = 0;

    productArray = [[LOCALMANAGER getCompetitionProducts:textField.text Index:currentPage] retain];
    productTotal = [LOCALMANAGER getCompetitionProductTotal:textField.text];

    searchContent = [[NSString alloc] initWithString:header2.txtSearch.text];
    bProductExpand = YES;
    [tableView reloadData];
    if ([productArray count]==0) {
        //[self showMessage:ResultCodeResponseDone Title:NSLocalizedString(@"search_title", nil) Description:NSLocalizedString(@"search_no_data", nil)];
        [MESSAGE showMessageWithTitle:NSLocalizedString(@"search_title", @"")
                          description:NSLocalizedString(@"search_no_data", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
    }
    return NO;
}


- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject{
    currentPage = 0;
    
    currentCustomer = [(Customer *)aObject retain];
    productArray = [[LOCALMANAGER getCompetitionProducts:@"" Index:0] retain];
    productTotal = [LOCALMANAGER getCompetitionProductTotal:@""];
    [tableView reloadData];
}

- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        HUDHIDE2;
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeCompetitiongoodsSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [self clearTable];
            }
            
            [super showMessage2:cr Title:TITLENAME(FUNC_COMPETITION_DES) Description:NSLocalizedString(@"competition_msg_saved", @"")];
        }
            break;
            
            
        default:
            break;
    }
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
