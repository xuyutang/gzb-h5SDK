//
//  OrderViewController.m
//  SalesManager
//
//  Created by liu xueyan on 8/7/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "StockViewController.h"
#import "SelectCell.h"
#import "StockProductCell.h"
#import "AppDelegate.h"
#import "LocalManager.h"
#import "StockListViewController.h"
#import "MBProgressHUD.h"
#import "MessageBarManager.h"
#import "Constant.h"
#import "SWTableViewCell.h"
#import "UIView+CNKit.h"


@implementation StockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initView{

    [lblFunctionName setText:TITLENAME_REPORT(FUNC_SELL_STOCK_DES)];
    (APPDELEGATE).agent.delegate = self;

}

-(void)syncTitle {
[lblFunctionName setText:TITLENAME_REPORT(FUNC_SELL_STOCK_DES)];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

-(void)toList:(id)sender{
    [self dismissKeyBoard];
    StockListViewController *ctrl = [[StockListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)toSave:(id)sender{
    [self dismissKeyBoard];
    if (currentCustomer == nil) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_STOCK_DES)
                          description:NSLocalizedString(@"patrol_hont_customer_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    NSString* comment = @"";
    if ((tvRemarkCell.textView.textColor != [UIColor lightGrayColor])) {
         comment = tvRemarkCell.textView.text;
    }else {
        comment = @"";
    }
   
    if (comment.trim.length > 1000){
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_STOCK_DES)
                          description:NSLocalizedString(@"input_limit_1000", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    
    //if (comment.trim.length == 0) {
    if (targetArray == nil || [targetArray count]<1) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_STOCK_DES)
                          description:NSLocalizedString(@"order_hint_product_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    BOOL hasProductNum = TRUE;
    for (Product* p in targetArray) {
        //NSString* num = [NSString stringWithFormat:@"%.4f",p.num];
        if (![p hasNum]){
            hasProductNum = FALSE;
            break;
        }
    }
    if (!hasProductNum) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_STOCK_DES)
                          description:NSLocalizedString(@"order_hint_product_num_empty", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    //}else{
    if ([NSString stringContainsEmoji:comment]) {
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_STOCK_DES)
                          description:NSLocalizedString(@"post_hint_text_error", @"")
                                 type:MessageBarMessageTypeInfo
                          forDuration:INFO_MSG_DURATION];
        return;
    }
    //}
    
    Stock_Builder* sb = [Stock builder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAINVIEW animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"loading", @"");
    
    if ((APPDELEGATE).myLocation != nil){
        [sb setLocation:(APPDELEGATE).myLocation];
    }
    
    [sb setId:-1];
    [sb setCustomer:currentCustomer];
    [sb setProductsArray:targetArray];
    [sb setComment:comment];
    
    
    (APPDELEGATE).agent.delegate = self;
    
    if (DONE != [(APPDELEGATE).agent sendRequestWithType:ActionTypeStockSave param:[sb build]]) {
        HUDHIDE2;
        [MESSAGE showMessageWithTitle:TITLENAME(FUNC_SELL_STOCK_DES)
                          description:NSLocalizedString(@"error_connect_server", @"")
                                 type:MessageBarMessageTypeError
                          forDuration:ERR_MSG_DURATION];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 44.0;
    if (indexPath.section == 2 && indexPath.row == [productArray count])
        return 44.0;
    return 70.f;
}

-(void)setHeader3Title{

    header2.title.text = @"产品列表";
    header3.title.text = @"库存详情";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = nil;
    
     
    switch (indexPath.section) {
        case 0:{
            
            SelectCell *selectCell =(SelectCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            //if(selectCell==nil){
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"SelectCell" owner:self options:nil];
                for(id oneObject in nib)
                {
                    if([oneObject isKindOfClass:[SelectCell class]])
                        selectCell=(SelectCell *)oneObject;
                }
            //}
            
            selectCell.title.text = NSLocalizedString(@"customer_label_name", nil);
            
            if (currentCustomer != nil) {
                selectCell.value.text = currentCustomer.name;
                selectCell.value.textColor = WT_BLACK;
            }else{
                selectCell.value.text = NSLocalizedString(@"patrol_hint_customer_select", nil);
                selectCell.value.textColor = WT_GRAY;
            }
            
            selectCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return selectCell;
            
        }
            break;
        case 1:{
            
            static NSString *qCellIdentifier = @"qCellIdentifier";
            //tvQuestionCell =(TextViewCell *)[tableView dequeueReusableCellWithIdentifier:qCellIdentifier];
      
            if(tvRemarkCell==nil){
                tvRemarkCell= [[TextViewCell alloc] init];
            }
            tvRemarkCell.textView.delegate=self;
            tvRemarkCell.textView.height = 60;
            
            NSLog(@"%@999999999",remark);
            if (remark == nil || [remark isEqualToString:@""]) {
                tvRemarkCell.textView.text  = @"选填（1000字以内）";
                tvRemarkCell.textView.textColor = [UIColor grayColor];
            }else {
                
                tvRemarkCell.textView.text  = remark;
            }
            
            
            
            
            // tvRemarkCell.textView.textColor = [UIColor lightGrayColor];
            [tvRemarkCell addSubview:[self setView]];

            
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
            //[tvRemarkCell.textView setInputAccessoryView:topView];
            tvRemarkCell.selectionStyle=UITableViewCellSelectionStyleNone;
            [topView release];
            return tvRemarkCell;
        }
            break;

        case 2:{
            StockProductCell *productCell = (StockProductCell *)[tableView dequeueReusableCellWithIdentifier:@"StockProductCell0"];
            if (productCell == nil) {
                productCell = [[StockProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StockProductCell0" containingTableView:tableView rowHeight:70 leftUtilityButtons:nil rightUtilityButtons:nil];
            }
            productCell.contentView.backgroundColor = [UIColor whiteColor];
            
            
            Product *product = [favorateArray objectAtIndex:indexPath.row];
            productCell.productName.text = product.name;
            productCell.productName.numberOfLines = 2;
            productCell.unit.text = product.unit;
            if (![product hasNum]) {
                productCell.count.text = @"";
            }else{
                productCell.count.text = [NSString stringWithFormat:@"%g",product.num];
            }
            
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
            productCell.count.delegate = self;
            productCell.count.tag = indexPath.row;
            productCell.tag = product.id;
            return productCell;
        }
            break;

        case 3:{
            int count = [productArray count];
            if (indexPath.row == count) {
                UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
                
                if (moreCell == nil) {
                    moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moreCell"];
                }
                moreCell.textLabel.text = NSLocalizedString(@"load_more", nil);
                moreCell.textAlignment = UITextAlignmentCenter;
                moreCell.textLabel.font = [UIFont systemFontOfSize:12];
                return moreCell;
            }
            
            StockProductCell *productCell = (StockProductCell *)[tableView dequeueReusableCellWithIdentifier:@"StockProductCell1"];
            
            
            if (productCell == nil) {
                productCell = [[StockProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StockProductCell1" containingTableView:tableView rowHeight:70 leftUtilityButtons:nil rightUtilityButtons:nil];
            }
            productCell.contentView.backgroundColor = [UIColor whiteColor];
    
            Product *product = [productArray objectAtIndex:indexPath.row];
            productCell.productName.text = product.name;
            productCell.productName.numberOfLines = 2;
            productCell.unit.text = product.unit;
            if (![product hasNum]) {
                productCell.count.text = @"";
            }else{
                productCell.count.text = [NSString stringWithFormat:@"%g",product.num];
            }

            
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
            productCell.count.delegate = self;
            productCell.count.tag = indexPath.row+20000;
            productCell.tag = product.id;
            return productCell;
        }
            break;
        case 4:{
            StockProductCell *productCell = (StockProductCell *)[tableView dequeueReusableCellWithIdentifier:@"StockProductCell2"];
            
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            [rightUtilityButtons addUtilityButtonWithColor:
             WT_RED
                                                      icon:[UIImage imageNamed:@"ic_delete_grey"]];
            if (productCell == nil) {
                productCell = [[StockProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StockProductCell2" containingTableView:tableView rowHeight:70 leftUtilityButtons:nil rightUtilityButtons:rightUtilityButtons];
            }
            Product *product = [targetArray objectAtIndex:indexPath.row];
            productCell.productName.text = product.name;
            productCell.productName.numberOfLines = 2;
            productCell.unit.text = product.unit;
            if (![product hasNum]) {
                productCell.count.text = @"";
            }else{
                productCell.count.text = [NSString stringWithFormat:@"%g",product.num];
            }

            
            productCell.selectionStyle=UITableViewCellSelectionStyleNone;
            
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
            productCell.count.delegate = self;
            productCell.count.tag = indexPath.row+40000;
            productCell.tag = product.id;
            productCell.delegate = self;
            return productCell;
        }
            break;
        
    }
    return cell;
}
-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 54, MAINWIDTH - 100, 20)];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 10, 0.5, 3)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(20, 13, MAINWIDTH  - 40, 0.3)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH - 20 - 0.5, 10, 0.5, 3)];
    view1.backgroundColor = [UIColor grayColor];
    view2.backgroundColor = [UIColor grayColor];
    view3.backgroundColor = [UIColor grayColor];
    
    [contView addSubview:view1];
    [contView addSubview:view2];
    [contView addSubview:view3];
    
    return contView;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    currentTextField = nil;
//    int index = textField.tag;
////    if (index<0) {
////        return;
////    }
//    Product_Builder* pb;
//    if (index <20000) {
//        pb = [((Product*)[favorateArray objectAtIndex:index]) toBuilder];
//        if ([textField.text length]>0) {
//            [pb setNum:[textField.text doubleValue]];
//        }
//        [favorateArray removeObjectAtIndex:index];
//        [favorateArray insertObject:[[pb build] retain] atIndex:index];
//    }else if (index <40000) {
//        pb = [((Product*)[productArray objectAtIndex:index-20000]) toBuilder];
//        if ([textField.text length]>0) {
//            [pb setNum:[textField.text doubleValue]];
//        }
//        [productArray removeObjectAtIndex:index-20000];
//        [productArray insertObject:[[pb build] retain] atIndex:index-20000];
//    }else{
//        pb = [((Product*)[targetArray objectAtIndex:index-30000]) toBuilder];
//        if ([textField.text length]>0) {
//            [pb setNum:[textField.text doubleValue]];
//        }
//        [targetArray removeObjectAtIndex:index-30000];
//        [targetArray insertObject:[[pb build] retain] atIndex:index-30000];
//    }
//}
//
- (void) didReceiveMessage:(id)message{
    SessionResponse* cr = [SessionResponse parseFromData:message];
    if ([super validateResponse:cr]) {
        return;
    }
    switch (INT_ACTIONTYPE(cr.type)) {
        case ActionTypeStockSave:{
            HUDHIDE2;
            if (([cr.code isEqual: NS_ACTIONCODE(ActionCodeDone)])){
                [self clearTable];
                remark = @"选填（1000字以内）";
                tvRemarkCell.textView.textColor = [UIColor grayColor];

            }
            
            [super showMessage2:cr Title:TITLENAME(FUNC_SELL_STOCK_DES) Description:NSLocalizedString(@"stock_msg_saved", @"")];
        }
            break;
            
            
        default:
            break;
    }
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
    [targetArray removeObjectAtIndex:indexPath.row];
    [btNumber setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)[targetArray count]] forState:UIControlStateNormal];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

@end
