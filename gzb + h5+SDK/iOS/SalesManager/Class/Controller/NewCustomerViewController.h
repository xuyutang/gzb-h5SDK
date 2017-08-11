//
//  NewCustomerViewController.h
//  SalesManager
//
//  Created by liuxueyan on 15-5-28.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "ZSYPopoverListView.h"
#import "CategoryPickerView.h"
#import "CustTagSelectViewController.h"

@protocol NewCustomerViewControllerDelegate <NSObject>

@optional
-(void)didFinishedInput:(Customer_Builder *) custBuilder;

@end

@interface NewCustomerViewController : BaseViewController<CategoryPickerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UITextField *currentTextField;
    SEL confirmAction;
    CustomerCategory *currentCategory;
    IBOutlet UIButton *btCategory;
    
    NSMutableArray *selectArray;
}
@property (retain, nonatomic) IBOutlet UITextField *city;

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


@property (retain, nonatomic) IBOutlet UITextField *txtCustTag;
@property (assign, nonatomic) id<NewCustomerViewControllerDelegate> delegate;

-(void)initView;


@end
