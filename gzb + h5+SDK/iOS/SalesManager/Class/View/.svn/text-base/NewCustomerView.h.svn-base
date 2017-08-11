//
//  NewCustomerView.h
//  SalesManager
//
//  Created by liu xueyan on 9/6/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSYPopoverListView.h"
#import "CategoryPickerView.h"
#import "BaseViewController.h"
@class CustomerCategory;
@interface NewCustomerView : UIView<CategoryPickerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,RefreshDelegate>{
    UITextField *currentTextField;
    SEL confirmAction;
    CustomerCategory *currentCategory;
    IBOutlet UIButton *btCategory;
}

@property (assign, nonatomic) int selectedIndex;
@property (retain, nonatomic) NSMutableArray *customerCategories;

@property (retain, nonatomic) IBOutlet UITextField *txtCustomerCategory;
@property (retain, nonatomic) IBOutlet UITextField *txtCustomerName;
@property (retain, nonatomic) IBOutlet UITextField *txtContact;
@property (retain, nonatomic) IBOutlet UITextField *txtTel;
@property (retain, nonatomic) IBOutlet CategoryPickerView *pickerView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btCancel;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btDone;
@property (retain, nonatomic) IBOutlet UILabel *lblCustomerCategory;
@property (retain, nonatomic) IBOutlet UIButton *btConfirm;
@property (retain, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (retain, nonatomic) IBOutlet UILabel *lLocation;
@property (retain, nonatomic) IBOutlet UILabel *lMark;
@property (retain, nonatomic) IBOutlet UIButton *btnLocation;
@property (retain, nonatomic) IBOutlet UILabel *lblLocation;

-(void)initView;
@end
