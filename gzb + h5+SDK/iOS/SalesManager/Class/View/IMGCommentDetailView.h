//
//  IMGCommentDetailView.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-17.
//  Copyright (c) 2015年 liu xueyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldCell.h"
#import "LocationCell.h"
#import "TextViewCell.h"
#import "LiveImageCell.h"
#import "PatrolTypeViewController.h"
#import "CustomerSelectViewController.h"
#import "UTTableView.h"

@interface IMGCommentDetailView : UIView<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,RequestAgentDelegate>{
    
    UITableView *tableView;
    LiveImageCell *liveImageCell;
    TextViewCell *textViewCell;
    NSMutableArray *imageFiles;
}
@property(nonatomic,retain) UIView *parentView;
@property(nonatomic,retain) UIViewController *parentCtrl;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *imageFiles;
@property(nonatomic,retain) NSString *content;

@end
