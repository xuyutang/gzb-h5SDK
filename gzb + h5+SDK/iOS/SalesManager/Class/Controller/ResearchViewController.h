//
//  ResearchViewController.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-13.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "CustomerSelectViewController.h"
#import "UTTableView.h"
#import "ExpandCell.h"
#import "CategoryPickerView.h"
#import "InputCell.h"
#import "SelectCell.h"
#import "AppDelegate.h"
#import "CommonPhrasesTextViewCell.h"
@interface ResearchViewController : BaseViewController<CategoryPickerDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,CustomerCategoryDelegate,RequestAgentDelegate,UITextFieldDelegate>{
    UIView *rightView;
    
    CategoryPickerView  *pickerView;
    UITableView *tableView;
    UIScrollView *scrollView;
    TextFieldCell *textViewCell;
    LiveImageCell *liveImageCell;
    LocationCell* locationCell;
    ExpandCell *expandCell;
    
    SelectCell *customerSelectCell;
    TextFieldCell *otherScaleCell;
    TextFieldCell *otherCategoryCell;
    TextFieldCell *otherProductCell;
    TextFieldCell *otherTotalCell;
    TextFieldCell *otherAreaCell;
    
    InputCell *customerNameCell;
    InputCell *contactNameCell;
    InputCell *contactTelCell;
    CommonPhrasesTextViewCell *CommonPhrasesCell;
    NSMutableArray *imageFiles;
    
    NSMutableArray *customerArray;
    Customer *currentCustomer;
    NSMutableArray *customerCategories;
    
    NSString *remarks;
    NSString *customerName;
    NSString *contactName;
    NSString *contactTel;
    NSString *otherArea;
    NSString *otherTotal;
    NSString *otherProduct;
    NSString *otherCategory;
    NSString *otherScale;
    UITextField *currentTextField;
    UITextView *currentTextView;
    
}

@property(nonatomic,retain) UITableView *tableView;

-(id)init;

@end
