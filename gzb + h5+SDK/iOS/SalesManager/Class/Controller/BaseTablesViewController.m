//
//  BaseTablesViewController.m
//  SalesManager
//
//  Created by liu xueyan on 10/16/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseTablesViewController.h"
#import "CustomerSelectViewController.h"
#import "SelectCell.h"
#import "BaseTable1HeaderView.h"
#import "BaseTable2HeaderView.h"
#import "BaseTable3HeaderView.h"
#import "OrderProductCell.h"
#import "LocalManager.h"
#import "MessageBarManager.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+CNKit.h"


@implementation BaseTablesViewController

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
	rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 60)];
    
    [self initData];
    [self initView];
    UIImageView *listImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 17, 25, 25)];
    [listImageView setImage:[UIImage imageNamed:@"ab_icon_search"]];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toList:)];
    [tapGesture1 setNumberOfTapsRequired:1];
    listImageView.userInteractionEnabled = YES;

    [listImageView addGestureRecognizer:tapGesture1];
    [rightView addSubview:listImageView];
    [listImageView release];
    
    UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 17, 25, 25)];
    [saveImageView setImage:[UIImage imageNamed:@"ab_icon_save"]];
    saveImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSave:)];
    [tapGesture2 setNumberOfTapsRequired:1];
  
    [saveImageView addGestureRecognizer:tapGesture2];
    [rightView addSubview:saveImageView];
    [saveImageView release];
    
    if (bNeedBack) {
       leftImageView.image = [UIImage imageNamed:@"ab_icon_back"];
        [leftView addSubview:leftImageView];
    }
    
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
    [self.parentViewController.view addSubview:btNumber];
    
    [self initTablesView];
    
    if (self.customer != nil) {
        [self customerSearch:nil didSelectWithObject:self.customer];
    }
}

-(void)clickLeftButton:(id)sender{
    if (bNeedBack){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [super clickLeftButton:sender];
    }
}

-(void)initView{

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if ([productArray count]>0 || [favorateArray count] > 0) {
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
    bTargetExpand = YES;
    bProductExpand = YES;
    bFavorateExpand = YES;
    bEdit = NO;
    productArray = [[NSMutableArray alloc] initWithCapacity:0];
    targetArray = [[NSMutableArray alloc] initWithCapacity:0];
    favorateArray = [[NSMutableArray alloc] initWithCapacity:0];
}

-(void)initTablesView{
    tableView = [[SMTableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINHEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.allowsSelection = YES;
    tableView.backgroundView = nil;
    tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableView];
    [btNumber setHidden:YES];
}

-(void) clearTable{
    [targetArray removeAllObjects];
    [productArray removeAllObjects];
    [favorateArray removeAllObjects];
    bTargetExpand = YES;
    bProductExpand = YES;
    bFavorateExpand = YES;
    bEdit = NO;
    if (searchContent != nil) {
        [searchContent release];
    }
    searchContent = @"";
    remark = @"";
    [btNumber setTitle:@"0" forState:UIControlStateNormal];
    [btNumber setHidden:YES];
    //[header2.txtSearch setText:@""];
    currentCustomer = nil;
 
    [tableView reloadData];
    //[tableView setEditing:NO animated:YES];
}

-(void)showTarget{

    bTargetExpand = YES;
    bProductExpand = NO;
    bFavorateExpand = NO;
    [tableView reloadData];
}

-(void)setHeader3Title{

}

-(UIView*)setFootView {
    UIView *contentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT - 150)];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAINWIDTH, 50)];
    textLabel.text =@"暂无记录";
    textLabel.textAlignment = 1;
    textLabel.textColor = [UIColor grayColor];
    [contentView addSubview:textLabel];
    return contentView;
}
#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (currentCustomer == nil) {
        [tableView setTableFooterView:[self setFootView]];
        return 2;
    }else {
        tableView.tableFooterView = [[UIView alloc]init];
    
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return 1;
        
        }
        case 2:{
            if (bHasSupply) {
                return 0;
            }
            if (!bFavorateExpand) {
                return 0;
            }
            return [favorateArray count];
        }
            break;
        case 3:{
            if (!bProductExpand || [productArray count] == 0) {
                return 0;
            }
            return [productArray count];
        }
            break;
        case 4:{
            if (!bTargetExpand) {
                return 0;
            }
            return [targetArray count];
        }
            break;
            
        default:
            break;
    }
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section  == 0) {
        return 0;
    }
    if (bHasSupply && section == 1) {
        return 0;
    }
    if (section == 2) {
        return 44;
    }
    if (section == 4) {
        return 50;
    }
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 44.0;
    if (indexPath.section == 2 && indexPath.row == [productArray count])
        return 44.0;
       return 85.f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable1HeaderView" owner:self options:nil];
            BaseTable1HeaderView *header = [nibViews objectAtIndex:0];
        
            header.backgroundColor = [UIColor whiteColor];
            return header;
        }
            break;
        case 2:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable1HeaderView" owner:self options:nil];
            header1 = [nibViews objectAtIndex:0];
            UITapGestureRecognizer *tapSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIsTapEvent:)];
            [tapSectionGesture setNumberOfTapsRequired:1];
            header1.userInteractionEnabled = YES;
            header1.title.textColor = [UIColor blackColor];
            header1.title.text = @"收藏列表";
            [header1 addGestureRecognizer:tapSectionGesture];
            if (bFavorateExpand) {
                [header1.expandImage setImage:[UIImage imageNamed:@"expander_ic_minimized"]];
            } else {
             [header1.expandImage setImage:[UIImage imageNamed:@"expander_ic_maximized"]];
            
            }
            tapSectionGesture.view.tag = section;
            header1.backgroundColor = [UIColor whiteColor];
            return header1;
        }
        case 3:{
            
            if (header2 == nil) {
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable4HeaderView" owner:self options:nil];
                header2 = [[nibViews objectAtIndex:0] retain];
            }
            
            header2.backgroundColor = [UIColor whiteColor];
            UITapGestureRecognizer *tapSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIsTapEvent:)];
            [tapSectionGesture setNumberOfTapsRequired:1];
            [header2 addGestureRecognizer:tapSectionGesture];
            tapSectionGesture.view.tag = section;
            [tapSectionGesture release];
            if (bProductExpand) {
                 [header2.expandImage setImage:[UIImage imageNamed:@"expander_ic_minimized"]];
            } else {
            
               [header2.expandImage setImage:[UIImage imageNamed:@"expander_ic_maximized"]];
            }
            header2.userInteractionEnabled = YES;
            header2.txtSearch.delegate = self;
            header2.txtSearch.tag = -1;
            header2.txtSearch.text = searchContent;
            header2.title.textColor = [UIColor blackColor];
            header2.backgroundColor = [UIColor whiteColor];
            return header2;
        }
            break;
        case 4:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable1HeaderView" owner:self options:nil];
            header3 = [nibViews objectAtIndex:0];
            UITapGestureRecognizer *tapSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerIsTapEvent:)];
            [tapSectionGesture setNumberOfTapsRequired:1];
            header3.userInteractionEnabled = YES;

            [self setHeader3Title];
            [header3 addGestureRecognizer:tapSectionGesture];
            tapSectionGesture.view.tag = section;
            if (bTargetExpand) {
                [header3.expandImage setImage:[UIImage imageNamed:@"expander_ic_minimized"]];
            } else {
                [header3.expandImage setImage:[UIImage imageNamed:@"expander_ic_maximized"]];
                
            }

            header3.title.textColor = [UIColor blackColor];

            header3.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(37, 25, MAINWIDTH, 20)];
            label.text = @"向左滑动可以删除";
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor grayColor];
            [header3 addSubview:label];
            return header3;
        }
            break;
        case 1:{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BaseTable1HeaderView" owner:self options:nil];
            header4 = [nibViews objectAtIndex:0];
            header4.title.text = @"备注";
            header4.title.font = [UIFont systemFontOfSize:14];
            header4.title.frame = CGRectMake(15, 5, 50, 30);
            header4.backgroundColor = [UIColor whiteColor];
            header4.title.textColor = [UIColor blackColor];
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
            
            selectCell.title.text = NSLocalizedString(@"customer_label_name", nil);
            
            if (currentCustomer != nil) {
                selectCell.value.text = currentCustomer.name;
                selectCell.value.textColor = WT_BLACK;
            }else{
                selectCell.value.text = NSLocalizedString(@"patrol_hint_customer_select", nil);
                selectCell.value.textColor = WT_GRAY;
            }
            
            selectCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            //            tvRemarkCell.textView.layer.borderColor = RGBA(53, 153, 255, 1.0).CGColor;
            //            tvRemarkCell.textView.layer.borderWidth =1.0;
            //            tvRemarkCell.textView.layer.cornerRadius =5.0;
            
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
            OrderProductCell *productCell = (OrderProductCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderProductCell0"];
            if (productCell == nil) {
                productCell = [[OrderProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderProductCell0" containingTableView:tableView rowHeight:85 leftUtilityButtons:nil rightUtilityButtons:nil];
            }
            productCell.contentView.backgroundColor = [UIColor whiteColor];
            
            Product *product = [favorateArray objectAtIndex:indexPath.row];
            productCell.productName.text = product.name;
            productCell.productName.numberOfLines = 2;
            productCell.unit.text = product.unit;
            productCell.price.text = [NSString stringWithFormat:@"%.2f",product.price];
            if (![product hasNum]) {
                productCell.count.text = @"";
            }else{
                productCell.count.text = [NSString stringWithFormat:@"%g",product.num];
            }
            
            productCell.selectionStyle=UITableViewCellSelectionStyleNone;
            productCell.count.delegate = self;
            productCell.count.tag = indexPath.row;
            productCell.price.delegate = self;
            productCell.price.tag = indexPath.row+10000;
            productCell.tag = product.id;
            
            
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
            int count = [productArray count];
            if (indexPath.row == count) {
                UITableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                
                if (moreCell == nil) {
                    moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
                }
                moreCell.textLabel.text = NSLocalizedString(@"load_more", nil);
                moreCell.textAlignment=UITextAlignmentCenter;
                moreCell.textLabel.font = [UIFont systemFontOfSize:12];
                moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return moreCell;
            }
            
            OrderProductCell *productCell = (OrderProductCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderProductCell1"];
            if (productCell == nil) {
                productCell = [[OrderProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderProductCell1" containingTableView:tableView rowHeight:85 leftUtilityButtons:nil rightUtilityButtons:nil];
            }
            productCell.contentView.backgroundColor = [UIColor whiteColor];
            
            Product *product = [productArray objectAtIndex:indexPath.row];
            productCell.productName.text = product.name;
            productCell.productName.numberOfLines = 2;
            productCell.unit.text = product.unit;
            productCell.price.text = [NSString stringWithFormat:@"%.2f",product.price];
            if (![product hasNum]) {
                productCell.count.text = @"";
            }else{
                productCell.count.text = [NSString stringWithFormat:@"%g",product.num];
            }
            
            productCell.selectionStyle=UITableViewCellSelectionStyleNone;
            productCell.count.delegate = self;
            productCell.count.tag = indexPath.row+20000;
            productCell.price.delegate = self;
            productCell.price.tag = indexPath.row+30000;
            productCell.tag = product.id;
            
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
        case 4:{
            OrderProductCell *productCell = (OrderProductCell *)[tableView dequeueReusableCellWithIdentifier:@"OrderProductCell2"];
            NSMutableArray *rightUtilityButtons = [NSMutableArray new];
            
            [rightUtilityButtons addUtilityButtonWithColor:
             WT_RED
                                                     icon:[UIImage imageNamed:@"ic_delete_grey"]];
            if (productCell == nil) {
                productCell = [[OrderProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderProductCell2" containingTableView:tableView rowHeight:85 leftUtilityButtons:nil rightUtilityButtons:rightUtilityButtons];
            }
            
            if (indexPath.row % 2 == 0) {
                productCell.contentView.backgroundColor = [UIColor whiteColor];
            }else{
                productCell.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            Product *product = [targetArray objectAtIndex:indexPath.row];
            productCell.productName.text = product.name;
            productCell.productName.numberOfLines = 2;
            productCell.unit.text = product.unit;
            productCell.price.text = [NSString stringWithFormat:@"%.2f",product.price];
            if (![product hasNum]) {
                productCell.count.text = @"";
            }else{
                productCell.count.text = [NSString stringWithFormat:@"%g",product.num];
            }
            
            productCell.selectionStyle=UITableViewCellSelectionStyleNone;
            productCell.count.delegate = self;
            productCell.count.tag = indexPath.row+40000;
            productCell.price.delegate = self;
            productCell.price.tag = indexPath.row+50000;
            productCell.tag = product.id;
            
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
                default:
            break;
    }
    
    return cell;
}

-(UIView*)setView {
    
    UIView *contView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, MAINWIDTH - 100, 20)];
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

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[self searchDismissKeyBoard];
    switch (indexPath.section) {
        case 0:{
          //  [self clearTable];
            CustomerSelectViewController *ctrl = [[CustomerSelectViewController alloc] init];
            ctrl.bNeedAddCustomer = NO;
            ctrl.delegate = self;
            ctrl.bNeedAll = NO;
            UINavigationController *customerNavCtrl = [[UINavigationController alloc] initWithRootViewController:ctrl];
            [self presentViewController:customerNavCtrl animated:YES completion:nil];
            [ctrl release];
        }
            break;
        case 2:{
            if (indexPath.row == [productArray count]) {
                currentPage++;
                if(bHasSupply)
                   [productArray addObjectsFromArray:[[LOCALMANAGER getProducts:currentCustomer.id PruductName:searchContent Index:currentPage] retain]];
                else
                    [productArray addObjectsFromArray:[[LOCALMANAGER getProducts:searchContent Index:currentPage] retain]];
                
                //[productArray addObjectsFromArray:[[LOCALMANAGER getProducts:currentCustomer.id PruductName:header2.txtSearch.text Index:currentPage] retain]];
            }else{/*
                int index = [self findIndex:[productArray objectAtIndex:indexPath.row]];
                if (!(index == [targetArray count])) {
                    [targetArray removeObjectAtIndex:index];
                }
                [targetArray addObject:[productArray objectAtIndex:indexPath.row]];
                [btNumber setTitle:[NSString stringWithFormat:@"%d",[targetArray count]] forState:UIControlStateNormal];
            
                   */
            }
            //[tableView reloadData];
        }
            break;
        case 3:{
        
        }
            break;
            
        default:
            break;
    }
    
    //[self dismissModalViewControllerAnimated:YES];
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
    textView.textColor = WT_BLACK;
if ([textView.text isEqualToString:@"选填（1000字以内）"]) {
         tvRemarkCell.textView.text = @"";
    }
   
}

-(void)textViewDidEndEditing:(UITextView *)textView {
   
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@""]) {
        tvRemarkCell.textView.text = @"选填（1000字以内）";
        textView.textColor = [UIColor lightGrayColor];
        remark = nil;
    }else {
         remark = [textView.text copy];
        textView.textColor = WT_BLACK;
}

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    currentPage = 0;
    if(bHasSupply)
        productArray = [[LOCALMANAGER getProducts:currentCustomer.id PruductName:textField.text Index:currentPage] retain];
    else
        productArray = [[LOCALMANAGER getProducts:textField.text Index:currentPage] retain];
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    currentTextField = nil;
    int index = textField.tag;
    if (index<0) {
        searchContent = [textField.text retain];
        [tableView reloadData];
        return;
    }
    Product_Builder* pb;
    if (index <10000) {
        if(favorateArray.count == 0) return;
        pb = [((Product*)[favorateArray objectAtIndex:index]) toBuilder];
        if ([textField.text length]>0) {
            [pb setNum:[textField.text doubleValue]];
        }
        [favorateArray removeObjectAtIndex:index];
        [favorateArray insertObject:[[pb build] retain] atIndex:index];
    }else if (index <20000){
        if(favorateArray.count == 0) return;
        pb = [((Product*)[favorateArray objectAtIndex:index-10000]) toBuilder];
        [pb setPrice:[textField.text doubleValue]];
        [favorateArray removeObjectAtIndex:index-10000];
        [favorateArray insertObject:[[pb build] retain] atIndex:index-10000];
    }else if (index <30000) {
        if(productArray.count == 0) return;
        pb = [((Product*)[productArray objectAtIndex:index-20000]) toBuilder];
        if ([textField.text length]>0) {
            [pb setNum:[textField.text doubleValue]];
        }
        [productArray removeObjectAtIndex:index-20000];
        [productArray insertObject:[[pb build] retain] atIndex:index-20000];
    }else if (index <40000){
        if(productArray.count == 0) return;
        pb = [((Product*)[productArray objectAtIndex:index-30000]) toBuilder];
        [pb setPrice:[textField.text doubleValue]];
        [productArray removeObjectAtIndex:index-30000];
        [productArray insertObject:[[pb build] retain] atIndex:index-30000];
    }else if (index <50000){
        if(targetArray.count == 0) return;
        pb = [((Product*)[targetArray objectAtIndex:index-40000]) toBuilder];
        if ([textField.text length]>0) {
            [pb setNum:[textField.text doubleValue]];
        }
        [targetArray removeObjectAtIndex:index-40000];
        [targetArray insertObject:[[pb build] retain] atIndex:index-40000];
    }else{
        if(targetArray.count == 0) return;
        pb = [((Product*)[targetArray objectAtIndex:index-50000]) toBuilder];
        [pb setPrice:[textField.text doubleValue]];
        [targetArray removeObjectAtIndex:index-50000];
        [targetArray insertObject:[[pb build] retain] atIndex:index-50000];
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
        int index0 = [self findIndex:[favorateArray objectAtIndex:index]];
        if (!(index0 == [targetArray count])) {
            [targetArray removeObjectAtIndex:index0];
        }
        [targetArray addObject:[favorateArray objectAtIndex:index]];
        
    }else if(tag <20000){
        index = tag-10000;
        int index0 = [self findIndex:[favorateArray objectAtIndex:index]];
        if (!(index0 == [targetArray count])) {
            [targetArray removeObjectAtIndex:index0];
        }
        [targetArray addObject:[favorateArray objectAtIndex:index]];
    }else if(tag <30000){
        index = tag-20000;
        int index0 = [self findIndex:[productArray objectAtIndex:index]];
        if (!(index0 == [targetArray count])) {
            [targetArray removeObjectAtIndex:index0];
        }
        [targetArray addObject:[productArray objectAtIndex:index]];
    }else if(tag <40000){
        index = tag-30000;
        int index0 = [self findIndex:[productArray objectAtIndex:index]];
        if (!(index0 == [targetArray count])) {
            [targetArray removeObjectAtIndex:index0];
        }
        [targetArray addObject:[productArray objectAtIndex:index]];
    }else{
        return;
    }
    [btNumber setTitle:[NSString stringWithFormat:@"%d",[targetArray count]] forState:UIControlStateNormal];
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

-(int)findIndex:(Product *)product{
    int index = [targetArray count];
    Product *tmp;
    for (int i = 0; i<index; i++) {
        tmp = [targetArray objectAtIndex:i];
        if (tmp.id  == product.id) {
            return i;
        }
    }
    return index;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [targetArray removeObjectAtIndex:indexPath.row];
    [btNumber setTitle:[NSString stringWithFormat:@"%d",[targetArray count]] forState:UIControlStateNormal];
    [tableView reloadData];
}
*/
-(void)headerIsTapEvent:(id)sender{
    
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    int sectionIndex = tapGesture.view.tag;
    NSLog(@"%i", sectionIndex);
    if (sectionIndex == 2) bFavorateExpand = !bFavorateExpand;
    if (sectionIndex == 3) bProductExpand = !bProductExpand;
    if (sectionIndex == 4) bTargetExpand = !bTargetExpand;
    bEdit = NO;
    [tableView setEditing:NO animated:NO];
    [tableView reloadData];
}

- (void)customerSearch:(CustomerSelectViewController *)controller didSelectWithObject:(id)aObject{
    currentCustomer = [(Customer *)aObject retain];
    currentPage = 0;
    favorateArray = [[LOCALMANAGER getFavProducts] retain];
    productArray = [[LOCALMANAGER getProducts:currentCustomer.id PruductName:@"" Index:currentPage] retain];
    bHasSupply = YES;
    if ([productArray count]<1) {
        bHasSupply = NO;
        productArray = [[LOCALMANAGER getProducts:@"" Index:currentPage] retain];
    }
    bProductExpand = YES;
    bTargetExpand = YES;
    bFavorateExpand = YES;
    [btNumber setHidden:NO];
    [tableView reloadData];
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
    [targetArray removeObjectAtIndex:indexPath.row];
    [btNumber setTitle:[NSString stringWithFormat:@"%d",[targetArray count]] forState:UIControlStateNormal];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

@end
