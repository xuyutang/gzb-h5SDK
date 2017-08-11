//
//  BusinessOpportunityViewController.h
//  SalesManager
//
//  Created by liuxueyan on 4/5/14.
//  Copyright (c) 2014 liu xueyan. All rights reserved.
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
#import "DatePicker.h"

/**
 "business_opportunity_info_label"="商机信息";
 "business_opportunity_bizOppName"="商机名称"; *
 "business_opportunity_bizOppSummary"="商机概述";
 "business_opportunity_bizOppDecision"="商机决策链和关键点";
 "business_opportunity_bizOppPrincipal"="商机负责人"; *
 "business_opportunity_actionPlan"="行动计划";
 "business_opportunity_expectedCost"="预计金额";
 "business_opportunity_expectedSignTime"="预计签约时间";
 "business_opportunity_bizOppRemark"="备注";
 
 */

@interface BusinessOpportunityViewController : BaseViewController<CategoryPickerDelegate,UIPickerViewDelegate,DatePickerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CustomerCategoryDelegate,RequestAgentDelegate,UITextFieldDelegate>{
    UIView *rightView;
    
    CategoryPickerView  *pickerView;
    UITableView *tableView;
    TextViewCell *textViewCell;
    LocationCell* locationCell;
    ExpandCell *expandCell;
    
    SelectCell *customerSelectCell;
    TextFieldCell *otherBizOppSummaryCell;
    TextFieldCell *otherBizOppDecisionCell;
    TextFieldCell *otherActionPlanCell;
    TextFieldCell *otherExpectedCostCell;
    TextFieldCell *selectCell;
    TextFieldCell *otherbizOppRemarkCell;
    
   
    
    DatePicker* datePicker;
    
    
    InputCell *customerNameCell;
    InputCell *contactNameCell;
    InputCell *contactTelCell;
    TextFieldCell *bizOppNameCell;
    TextFieldCell *bizOppPrincipalCell;

    
    CustomerCategory *currentCategory;
    
    NSMutableArray *customerArray;
    Customer *currentCustomer;
    NSMutableArray *customerCategories;
    
    NSString *remarks;
    NSString *customerName;
    NSString *contactName;
    NSString *contactTel;
    NSString *otherBizOppSummary;
    NSString *otherBizOppDecision;
    NSString *otherActionPlan;
    NSString *otherExpectedCost;
    NSString *otherbizOppRemark;
    NSString *signTime;
    NSString *bizOppName;
    NSString *bizOppPrincipal;
    UITextField *currentTextField;
    UITextView *currentTextView;
    
    int distance;
}

@property(nonatomic,retain) UITableView *tableView;

-(id)init;


@end
