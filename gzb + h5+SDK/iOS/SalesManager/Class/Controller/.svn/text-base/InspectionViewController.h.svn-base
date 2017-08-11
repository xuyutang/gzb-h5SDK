//
//  InspectionViewController.h
//  SalesManager
//
//  Created by liuxueyan on 14-11-24.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "CategoryPickerView.h"
#import "InspectionTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "UTTableView.h"
#import "InspectionTargetsViewController.h"
#import "CommonPhrasesTextViewCell.h"

@class AppDelegate;
@interface InspectionViewController : BaseViewController<CategoryPickerDelegate,InspectionTargetsDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,InspectionTypeDelegate,CustomerCategoryDelegate,RequestAgentDelegate,UIPickerViewDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    CommonPhrasesTextViewCell *textViewCell;
    LiveImageCell *liveImageCell;
    LocationCell* locationCell;
    
    NSMutableArray *inspectionStatus;
    CategoryPickerView  *pickerView;
    NSMutableArray *currentStatusList;
    int nCurrentCell;
    
    NSMutableArray *imageFiles;
    
    NSMutableArray *inspectionCategories;
    InspectionReportCategory *currentInspectionCategory;
    NSMutableArray *tagetArray;
    NSMutableArray *checkedTargets;//增加了未选的父节点，并且已排序的数据
    NSMutableArray *resultCheckedTargets;//选择后返回的初始数据
    NSMutableArray *unCheckedParents;//未选的父节点，不能被操作的数据，仅显示
    AppDelegate* appDelegate;
    BOOL bHasSync;
    
    //巡检对象选择器
    InspectionTargetsViewController *ctrl;
    UINavigationController *customerNavCtrl;
}

@property(nonatomic,retain) UITableView *tableView;

-(id)init;
-(NSString *) getInspectionStatusName:(InspectionTarget *) target;

@end
