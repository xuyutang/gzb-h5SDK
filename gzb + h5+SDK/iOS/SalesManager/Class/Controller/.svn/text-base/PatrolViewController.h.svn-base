//
//  PatrolViewController.h
//  SalesManager
//
//  Created by liu xueyan on 8/1/13.
//  Copyright (c) 2013 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "CommonPhrasesTextViewCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "UTTableView.h"
#import "PatrolPostTypeCell.h"
#import "PickerVideoCell.h"

typedef NS_ENUM(NSInteger,PatroPostType) {
    PatrolPostTypeImage = 0,
    PatrolPostTypeVideo = 1,
    PatrolPostTypeImageAndVideo = 2
};

@class SelectCell;
@class AppDelegate;
@interface PatrolViewController : BaseViewController<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,PatrolTypeDelegate,CustomerCategoryDelegate,RequestAgentDelegate>{
    
    UIView *rightView;
    
    UITableView *tableView;
    CommonPhrasesTextViewCell *textViewCell;
    LiveImageCell *liveImageCell;
    LocationCell* locationCell;
    SelectCell      *durationCell;
    PatrolPostTypeCell *patrolPostTypeCell;
    PickerVideoCell    *pickerCell;
    
    NSMutableArray *imageFiles;
    
    NSMutableArray *patrolCategories;
    NSMutableArray *customerArray;
    
    PatrolCategory *currentPatrolCategory;
    Customer *currentCustomer;

    AppDelegate* appDelegate;
}
@property(nonatomic,retain) Customer *taskCustomer;
@property(nonatomic,retain) NSString *taskId;
@property(nonatomic,retain) UITableView *tableView;
@property (nonatomic,assign) BOOL hideListImagViewBool;
-(id)init;

@end
