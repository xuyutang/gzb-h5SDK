//
//  InputViewController.h
//  SalesManager
//
//  Created by ZhangLi on 14-1-17.
//  Copyright (c) 2014年 liu xueyan. All rights reserved.
//

#import "BaseViewController.h"
#import "PlaceTextView.h"

@interface InputViewController : BaseViewController{
    UIImageView *imageView;
    UIView *rightView;
    UITableView *tableView;
}

@property (nonatomic,retain) NSString *defaultText;
@property (nonatomic,retain) NSString *editText;
@property (nonatomic,assign) BOOL bExpand;  //是否采用外部编辑
@property (nonatomic,assign) int validateLength; //外部编辑需要验证的长度
@property (nonatomic,copy) void(^saveButttonClicked) (NSString* content);
@property (nonatomic,retain) UILabel *saveImageView;
@property (retain, nonatomic) IBOutlet PlaceTextView *inputTextField;
@property (retain, nonatomic) NSString* functionName;
@property (nonatomic,assign) id<InputFinishDelegate> delegate;
@property (nonatomic,assign) int tag;
@property (nonatomic,retain) NSString *atUser;
@end
