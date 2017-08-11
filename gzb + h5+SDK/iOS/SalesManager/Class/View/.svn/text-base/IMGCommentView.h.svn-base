//
//  IMGCommentView.h
//  SalesManager
//
//  Created by liuxueyan on 15-3-13.
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

@protocol IMGCommentViewDelegate <NSObject>
-(void)submitComment;
@end

@interface TitleViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *tintLabel;
@end

@interface IMGCommentView : UIView<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,LiveImageCellDelegate,RequestAgentDelegate>{
    
    UITableView *tableView;
    LiveImageCell *liveImageCell;
    TextViewCell *textViewCell;
    TitleViewCell *titleViewCell;
    NSMutableArray *imageFiles;
}
@property(nonatomic,retain) UIViewController *parentCtrl;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) TextViewCell *textViewCell;
@property(nonatomic,retain) NSMutableArray *imageFiles;
@property(nonatomic,retain) LiveImageCell *liveImageCell;
@property(nonatomic,assign) id<IMGCommentViewDelegate> target;
@end
